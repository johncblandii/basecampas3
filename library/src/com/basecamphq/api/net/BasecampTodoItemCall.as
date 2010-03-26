package com.basecamphq.api.net{
	import com.basecamphq.api.core.BasecampSession;
	import com.basecamphq.api.events.BasecampTodoItemEvent;
	import com.basecamphq.api.models.BasecampTodoItem;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	[Event(name="getTodoItemsResult", type="com.basecamphq.api.events.BasecampTodoItemEvent")]
	[Event(name="getTodoItemResult", type="com.basecamphq.api.events.BasecampTodoItemEvent")]
	[Event(name="createTodoItemComplete", type="com.basecamphq.api.events.BasecampTodoItemEvent")]
	[Event(name="updateTodoItemComplete", type="com.basecamphq.api.events.BasecampTodoItemEvent")]
	[Event(name="destroyTodoItemComplete", type="com.basecamphq.api.events.BasecampTodoItemEvent")]
	[Event(name="reorderTodoItemComplete", type="com.basecamphq.api.events.BasecampTodoItemEvent")]
	
	/**
	 * Calls specific to to-do list requests.
	 * Note: Use once and throw away.
	 * @author johncblandii
	 */	
	public class BasecampTodoItemCall extends BasecampCall{
	//	CONSTANTS
		public static const GET_ITEMS:String = "/todo_lists/#{todo_list_id}/todo_items.xml";
		public static const GET_ITEM:String = "/todo_items/#{id}.xml";
		public static const COMPLETE_ITEM:String = "/todo_items/#{id}/complete.xml";
		public static const UNCOMPLETE_ITEM:String = "/todo_items/#{id}/uncomplete.xml";
		public static const CREATE_ITEM:String = "/todo_lists/#{todo_list_id}/todo_items.xml";
		public static const UPDATE_ITEM:String = "/todo_items/#{id}.xml";
		public static const DESTROY_ITEM:String = "/todo_items/#{id}.xml";
	
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param session
		 */		
		public function BasecampTodoItemCall(session:BasecampSession){
			super(session);
		}
		
	//	PUBLIC METHODS
		/**
		 * Returns all todo item records for a single todo list. This is almost the same as the “Get list” action, except it does not return any information about the list itself. The items are returned in priority order, as defined by how they were ordered either in the web UI, or via the “Reorder items” action.
		 * @param id
		 */
		public function getTodoItems(listID:int):void{
			getLoader(onTodoItemsResult).load(getRequest(URLRequestMethod.GET, GET_ITEMS.replace("#{todo_list_id}", listID)));
		}
		
		/**
		 * Returns a single todo item record, given its integer ID.
		 * @param id
		 */
		public function getTodoItem(id:int):void{
			getLoader(onTodoItemResult).load(getRequest(URLRequestMethod.GET, GET_ITEM.replace("#{id}", id)));
		}
		
		/**
		 * Marks the specified todo item as completed.
		 * @param id
		 */		
		public function completeTodoItem(id:int):void{
			getLoader(onCompleteItemResult).load(getRequest(URLRequestMethod.PUT, COMPLETE_ITEM.replace("#{id}", id)));
		}
		
		/**
		 * If the specified todo item was previously marked as completed, this unmarks it, restoring it to an “uncompleted” state. If it was already in the uncompleted state, this call has no effect.
		 * @param id
		 */		
		public function uncompleteTodoItem(id:int):void{
			getLoader(onUncompleteItemResult).load(getRequest(URLRequestMethod.PUT, UNCOMPLETE_ITEM.replace("#{id}", id)));
		}
		
		/**
		 * Creates a new todo item record for the given list. The new record begins its life in the “uncompleted” state. (See the “Complete” and “Uncomplete” actions.) It is added at the bottom of the given list. If a person is responsible for the item, give their id as the party_id value. If a company is responsible, prefix their company id with a ‘c’ and use that as the party_id value. If the item has a person as the responsible party, you can also use the “notify” key to indicate whether an email should be sent to that person to tell them about the assignment.
		 * @param item
		 */		
		public function createTodoItem(item:BasecampTodoItem, notify:Boolean=false):void{
			if(!item.content || item.content.length == 0) throw new ArgumentError("Content is required in the item object.");
			if(item.listID < 1) throw new Error("List ID is required in the item object.");
			
			var data:XML = <todo-item>
							  <content>#{item.content}</content>
							  <notify type="boolean">{notify}</notify>
							</todo-item>;
			if(item.responsiblePartyID > 0) data.appendChild(<responsible-party>#{item.responsiblePartyID}</responsible-party>);
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onCreateResult);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = data;
			
			var request:URLRequest = getRequest(URLRequestMethod.POST, CREATE_ITEM.replace("#{todo_list_id}", item.listID));
			request.data = data;
			
			loader.load(request);
		}
		
		/**
		 * Updates an existing todo item record with the given data. See the “Create item” action for a full discussion of the meaning of the data fields.
		 * @param list
		 */		
		public function updateTodoItem(item:BasecampTodoItem, notify:Boolean=false):void{
			if(!item.content || item.content.length == 0) throw new ArgumentError("Content is required in the item object.");
			if(item.listID < 1) throw new Error("List ID is required in the item object.");
			
			var data:XML = <todo-item>
							  <content>#{item.content}</content>
							  <notify type="boolean">{notify}</notify>
							</todo-item>;
			if(item.responsiblePartyID > 0) data.appendChild(<responsible-party>#{item.responsiblePartyID}</responsible-party>);
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onUpdateResult);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = data;
			
			var request:URLRequest = getRequest(URLRequestMethod.PUT, UPDATE_ITEM.replace("#{id}", item.id));
			request.data = data;
			
			loader.load(request);
		}
		
		/**
		 * Destroys the given todo item record. 
		 * @param id
		 */		
		public function destroyTodoItem(id:int):void{
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onDestroyResult);
			loader.load(getRequest(URLRequestMethod.DELETE, DESTROY_ITEM.replace("#{id}", id)));
		}
		
	//	EVENT LISTENERS
		/**
		 * Handles single message result 
		 * @param event
		 */
		protected function onTodoItemsResult(event:Event):void{
			var data:XML = XML(URLLoader(event.target).data);
			
			var ev:BasecampTodoItemEvent = new BasecampTodoItemEvent(BasecampTodoItemEvent.GET_TODO_ITEMS_RESULT, true);
			ev.todoItems  = new Array();
			for each(var item:XML in data.child("todo-item")){
				ev.todoItems.push(BasecampTodoItem.buildFromXML(item));
			}
			dispatchEvent(ev);
		}
		
		/**
		 * Handles single message result 
		 * @param event
		 */
		protected function onTodoItemResult(event:Event):void{
			var ev:BasecampTodoItemEvent = new BasecampTodoItemEvent(BasecampTodoItemEvent.GET_TODO_ITEM_RESULT, true);
			ev.todoItem = BasecampTodoItem.buildFromXML(XML(URLLoader(event.target).data));
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for create requests 
		 * @param event
		 */
		protected function onCreateResult(event:HTTPStatusEvent):void{
			var ev:BasecampTodoItemEvent;
			switch(event.status){
				case 201:
					ev = new BasecampTodoItemEvent(BasecampTodoItemEvent.CREATE_TODO_ITEM_COMPLETE, true);
				break;
				default:
					ev = new BasecampTodoItemEvent(BasecampTodoItemEvent.TODO_ITEM_CALL_FAILED, true);
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
			var ev:BasecampTodoItemEvent;
			switch(event.status){
				case 200:
					ev = new BasecampTodoItemEvent(BasecampTodoItemEvent.UPDATE_TODO_ITEM_COMPLETE, true);
				break;
				default:
					ev = new BasecampTodoItemEvent(BasecampTodoItemEvent.TODO_ITEM_CALL_FAILED, true);
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
			var ev:BasecampTodoItemEvent;
			switch(event.status){
				case 200:
					ev = new BasecampTodoItemEvent(BasecampTodoItemEvent.DESTROY_TODO_ITEM_COMPLETE, true);
				break;
				default:
					ev = new BasecampTodoItemEvent(BasecampTodoItemEvent.TODO_ITEM_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for complete requests 
		 * @param event
		 */		
		protected function onCompleteItemResult(event:HTTPStatusEvent):void{
			var ev:BasecampTodoItemEvent;
			switch(event.status){
				case 200:
					ev = new BasecampTodoItemEvent(BasecampTodoItemEvent.COMPLETE_TODO_ITEM_COMPLETE, true);
				break;
				default:
					ev = new BasecampTodoItemEvent(BasecampTodoItemEvent.TODO_ITEM_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for uncomplete requests
		 * @param event
		 */		
		protected function onUncompleteItemResult(event:HTTPStatusEvent):void{
			var ev:BasecampTodoItemEvent;
			switch(event.status){
				case 200:
					ev = new BasecampTodoItemEvent(BasecampTodoItemEvent.UNCOMPLETE_TODO_ITEM_COMPLETE, true);
				break;
				default:
					ev = new BasecampTodoItemEvent(BasecampTodoItemEvent.TODO_ITEM_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
	}
}