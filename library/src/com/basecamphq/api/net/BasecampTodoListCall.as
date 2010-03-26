package com.basecamphq.api.net{
	import com.basecamphq.api.core.BasecampSession;
	import com.basecamphq.api.events.BasecampTodoListEvent;
	import com.basecamphq.api.models.BasecampTodoItem;
	import com.basecamphq.api.models.BasecampTodoList;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	[Event(name="getTodoListsResult", type="com.basecamphq.api.events.BasecampTodoListEvent")]
	[Event(name="getTodoListResult", type="com.basecamphq.api.events.BasecampTodoListEvent")]
	[Event(name="createTodoListComplete", type="com.basecamphq.api.events.BasecampTodoListEvent")]
	[Event(name="updateTodoListComplete", type="com.basecamphq.api.events.BasecampTodoListEvent")]
	[Event(name="destroyTodoListComplete", type="com.basecamphq.api.events.BasecampTodoListEvent")]
	[Event(name="reorderTodoListComplete", type="com.basecamphq.api.events.BasecampTodoListEvent")]
	
	/**
	 * Calls specific to to-do list requests.
	 * Note: Use once and throw away.
	 * @author johncblandii
	 */	
	public class BasecampTodoListCall extends BasecampCall{
	//	CONSTANTS
		public static const GET_LISTS_BY_PARTY:String = "/todo_lists.xml?responsible_party=#{id}";
		public static const GET_LISTS_BY_PROJECT:String = "/projects/#{project_id}/todo_lists.xml?filter=#{filter}";
		public static const GET_LIST:String = "/todo_lists/#{id}.xml";
		public static const CREATE_LIST:String = "/projects/#{project_id}/todo_lists.xml";
		public static const UPDATE_LIST:String = "/todo_lists/#{id}.xml";
		public static const DESTROY_LIST:String = "/todo_lists/#{id}.xml";
		public static const REORDER_LIST:String = "/projects/#{project_id}/todo_lists/reorder.xml";
	
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param session
		 */		
		public function BasecampTodoListCall(session:BasecampSession){
			super(session);
		}
		
	//	PUBLIC METHODS
		/**
		 * Returns a list of todo-list records, with todo-item records that are assigned to the given company 
		 * @param companyID
		 */		
		public function getTodoListsByCompany(companyID:int):void{
			getLoader(onTodoListsResult).load(getRequest(URLRequestMethod.GET, GET_LISTS_BY_PARTY.replace("#{id}", companyID)));
		}
		
		/**
		 * Returns a list of todo-list records, with todo-item records that are assigned to the given person 
		 * @param personID
		 */		
		public function getTodoListsByPerson(personID:int):void{
			getLoader(onTodoListsResult).load(getRequest(URLRequestMethod.GET, GET_LISTS_BY_PARTY.replace("#{id}", personID)));
		}
		
		/**
		 * Returns a list of todo-list records, with todo-item records that are assigned to the logged in person 
		 */		
		public function getTodoListsForLoggedinUser():void{
			getLoader(onTodoListsResult).load(getRequest(URLRequestMethod.GET, GET_LISTS_BY_PARTY.replace("#{id}", "")));
		}
		
		/**
		 * Returns a list of todo-list records by project 
		 * @param projectID
		 */		
		public function getTodoListsByProject(projectID:int):void{
			getLoader(onTodoListsResult).load(getRequest(URLRequestMethod.GET, GET_LISTS_BY_PROJECT.replace("#{project_id}", projectID)));
		}
		
		/**
		 * Returns a single to-do list record identified by its integer ID. 
		 * @param id
		 */		
		public function getTodoList(id:int):void{
			getLoader(onTodoListResult).load(getRequest(URLRequestMethod.GET, GET_LIST.replace("#{id}", id)));
		}
		
		/**
		 * Creates a new todo-list based on the submitted XML data. If you wish to base the new list on a todo-list template that you’ve created previously, you can specify the “todo-list-template-id” field in the data, and the new list will default to the name, description, and todo-items indicated by that template.
		 * @param list
		 */		
		public function createTodoList(list:BasecampTodoList):void{
			if(list.projectID < 1) throw new ArgumentError("Project ID is required in the list object.");
			if(!list.name || list.name.length == 0) throw new Error("Message Name is required in the list object.");
			
			var data:XML = <todo-list>
							  <name>{list.name}</name>
							  <description>{list.description}</description>
							  <private type="boolean">{list.isPrivate}</private>
							  <tracked type="boolean">{list.isTracked}</tracked>
							</todo-list>;
			if(list.milestoneID > 0) data.appendChild(<milestone-id>{list.milestoneID.toString()}</milestone-id>);
			if(list.templateID > 0) data.appendChild(<todo-list-template-id>{list.templateID}</todo-list-template-id>);
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onCreateResult);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = data;
			
			var request:URLRequest = getRequest(URLRequestMethod.POST, CREATE_LIST.replace("#{project_id}", list.projectID));
			request.data = data;
			
			loader.load(request);
		}
		
		/**
		 * Updates the specified todo-list record with the changes indicated by the submitted XML data.
		 * @param list
		 */		
		public function updateTodoList(list:BasecampTodoList):void{
			if(list.id < 1) throw new ArgumentError("ID is required in the message object.");
			
			var data:XML = <todo-list>
							  <name>{list.name}</name>
							  <description>{list.description}</description>
							  <milestone-id>{list.milestoneID}</milestone-id>
							  <private type="boolean">{list.isPrivate}</private>
							  <tracked type="boolean">{list.isTracked}</tracked>
							</todo-list>;
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onUpdateResult);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = data;
			
			var request:URLRequest = getRequest(URLRequestMethod.PUT, UPDATE_LIST.replace("#{id}", list.id));
			request.data = data;
			
			loader.load(request);
		}
		
		/**
		 * Destroys the given todo-list and all of its associated todo items. 
		 * @param id
		 */		
		public function destroyTodoList(id:int):void{
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onDestroyResult);
			loader.load(getRequest(URLRequestMethod.DELETE, DESTROY_LIST.replace("#{id}", id)));
		}
		
		/**
		 * Reorders the lists in the project according to the ordering given. Any lists that are not explicitly specified will be positioned after the lists that are specified. 
		 * @param id
		 */		
		public function reorderTodoList(list:BasecampTodoList):void{
			var data:XML = 	<todo-lists type="array"/>;
			
			for each(var item:BasecampTodoItem in list.todoItems){
				data.appendChild(<todo-list><id>{item.id}</id></todo-list>);
			}
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onReorderResult);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = data;
			
			var request:URLRequest = getRequest(URLRequestMethod.POST, REORDER_LIST.replace("#{project_id}", list.projectID));
			request.data = data;
			loader.load(request);
		}
		
	//	PRIVATE METHODS
		/**
		 * Returns a blank XML “template” for a single message record, indicating which fields may be submitted to create a new message. It will also return a custom HTTP header (X-Create-Action) indicating where and how the data may be submitted. 
		 * @param projectID
		 * @private
		 */		
		protected function getNewMessageFields(projectID:int):void{
			//not implemented
		}
		
		/**
		 * Returns an XML “template” for a single message record, prefilled with the existing values for that record, and ready to be resubmitted via the “update message” action. It will also return a custom HTTP header (X-Update-Action) indicating where and how the data may be submitted. 
		 * @param id
		 * @private
		 */		
		protected function getEditMessageFields(id:int):void{
			//not implemented
		}
		
	//	EVENT LISTENERS
		/**
		 * Handles message list result 
		 * @param event
		 */
		protected function onTodoListsResult(event:Event):void{
			var data:XML = XML(URLLoader(event.target).data);
			
			var ev:BasecampTodoListEvent = new BasecampTodoListEvent(BasecampTodoListEvent.GET_TODO_LISTS_RESULT, true);
			ev.todoLists = new Array();
			for each(var item:XML in data.child("todo-list")){
				ev.todoLists.push(BasecampTodoList.buildFromXML(item));
			}
			
			dispatchEvent(ev);
		}
		
		/**
		 * Handles single message result 
		 * @param event
		 */
		protected function onTodoListResult(event:Event):void{
			var ev:BasecampTodoListEvent = new BasecampTodoListEvent(BasecampTodoListEvent.GET_TODO_LIST_RESULT, true);
			ev.todoList = BasecampTodoList.buildFromXML(XML(URLLoader(event.target).data));
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for create requests
		 * @param event
		 */
		protected function onCreateResult(event:HTTPStatusEvent):void{
			var ev:BasecampTodoListEvent;
			switch(event.status){
				case 201:
					ev = new BasecampTodoListEvent(BasecampTodoListEvent.CREATE_TODO_LIST_COMPLETE, true);
				break;
				default:
					ev = new BasecampTodoListEvent(BasecampTodoListEvent.TODO_LIST_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for update requests 
		 * @param event
		 */	
		protected function onUpdateResult(event:HTTPStatusEvent):void{
			var ev:BasecampTodoListEvent;
			switch(event.status){
				case 200:
					ev = new BasecampTodoListEvent(BasecampTodoListEvent.UPDATE_TODO_LIST_COMPLETE, true);
				break;
				default:
					ev = new BasecampTodoListEvent(BasecampTodoListEvent.TODO_LIST_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for destroy requests 
		 * @param event
		 */	
		protected function onDestroyResult(event:HTTPStatusEvent):void{
			var ev:BasecampTodoListEvent;
			switch(event.status){
				case 200:
					ev = new BasecampTodoListEvent(BasecampTodoListEvent.DESTROY_TODO_LIST_COMPLETE, true);
				break;
				default:
					ev = new BasecampTodoListEvent(BasecampTodoListEvent.TODO_LIST_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for reorder requests 
		 * @param event
		 * @private
		 */		
		protected function onReorderResult(event:HTTPStatusEvent):void{
			var ev:BasecampTodoListEvent;
			switch(event.status){
				case 200:
					ev = new BasecampTodoListEvent(BasecampTodoListEvent.REORDER_TODO_LIST_COMPLETE, true);
				break;
				default:
					ev = new BasecampTodoListEvent(BasecampTodoListEvent.TODO_LIST_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
	}
}