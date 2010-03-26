package com.basecamphq.api.net{
	import com.basecamphq.api.core.BasecampSession;
	import com.basecamphq.api.events.BasecampMessageEvent;
	import com.basecamphq.api.models.BasecampMessage;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	[Event(name="getMessagesResult", type="com.basecamphq.api.events.BasecampMessageEvent")]
	[Event(name="getMessageResult", type="com.basecamphq.api.events.BasecampMessageEvent")]
	[Event(name="createMessageComplete", type="com.basecamphq.api.events.BasecampMessageEvent")]
	[Event(name="updateMessageComplete", type="com.basecamphq.api.events.BasecampMessageEvent")]
	[Event(name="destroyMessageComplete", type="com.basecamphq.api.events.BasecampMessageEvent")]
	
	/**
	 * Calls specific to message requests.
	 * Note: Use once and throw away.
	 * @author johncblandii
	 */	
	public class BasecampMessageCall extends BasecampCall{
	//	CONSTANTS
		public static const GET_MESSAGES:String = "/projects/#{project_id}/posts.xml";
		public static const GET_MESSAGE:String = "/posts/#{id}.xml";
		public static const GET_MESSAGES_BY_CATEGORY:String = "/projects/#{project_id}/cat/#{category_id}/posts.xml";
		public static const GET_ARCHIVED_MESSAGES:String = "/projects/#{project_id}/posts/archive.xml";
		public static const GET_ARCHIVED_MESSAGES_BY_CATEGORY:String = "/projects/#{project_id}/cat/#{category_id}/posts/archive.xml";
		public static const NEW_MESSAGE_FIELDS:String = "/projects/#{project_id}/posts/new.xml";
		public static const CREATE_MESSAGE:String = "/projects/#{project_id}/posts.xml";
		public static const EDIT_MESSAGE_FIELDS:String = "/posts/#{id}/edit.xml";
		public static const UPDATE_MESSAGE:String = "/posts/#{id}.xml";
		public static const DESTROY_MESSAGE:String = "/posts/#{id}.xml";
	
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param session
		 */		
		public function BasecampMessageCall(session:BasecampSession){
			super(session);
		}
		
	//	PUBLIC METHODS
		/**
		 * Returns the 25 most recent messages in the given project. 
		 * @param projectID
		 */		
		public function getMessages(projectID:int):void{
			getLoader(onMessagesResult).load(getRequest(URLRequestMethod.GET, GET_MESSAGES.replace("#{project_id}", projectID)));
		}
		
		/**
		 * Returns a single message record identified by its integer ID. 
		 * @param id
		 */		
		public function getMessage(id:int):void{
			getLoader(onMessageResult).load(getRequest(URLRequestMethod.GET, GET_MESSAGE.replace("#{id}", id)));
		}
		
		/**
		 * Returns the most 25 most recent messages in the given project for the given category.
		 * @param projectID
		 * @param categoryID
		 */		
		public function getMessagesByCategory(projectID:int, categoryID:int):void{
			getLoader(onMessagesResult).load(getRequest(URLRequestMethod.GET, GET_MESSAGES_BY_CATEGORY.replace("#{category_id}", categoryID).replace("#{project_id}", projectID)));
		}
		
		/**
		 * Returns a summary record for each message in the given project. (Note that a summary record includes only a few bits of information about a message, not the complete record.)
		 * @param projectID
		 */		
		public function getArchivedMessages(projectID:int):void{
			getLoader(onMessagesResult).load(getRequest(URLRequestMethod.GET, GET_ARCHIVED_MESSAGES.replace("#{project_id}", projectID)));
		}
		
		/**
		 * Returns a summary record for each message in the given project for the given category. (Note that a summary record includes only a few bits of information about a post, not the complete record.)
		 * @param projectID
		 * @param categoryID
		 */		
		public function getArchivedMessagesByCategory(projectID:int, categoryID:int):void{
			getLoader(onMessagesResult).load(getRequest(URLRequestMethod.GET, GET_ARCHIVED_MESSAGES_BY_CATEGORY.replace("#{category_id}", categoryID).replace("#{project_id}", projectID)));
		}
		
		/**
		 * Creates a new message, optionally sending notifications to a selected list of people. Note that you can also upload files using this function, but you need to upload the files first and then attach them.
		 * @param message
		 */		
		public function createMessage(message:BasecampMessage):void{
			if(message.projectID < 1) throw new ArgumentError("Project ID is required in the message object.");
			if(!message.title || message.title.length == 0) throw new Error("Message Title is required in the message object.");
			if(!message.body || message.body.length == 0) throw new Error("Message Body is required in the message object.");
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onCreateResult);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = message.toXML();
			
			var request:URLRequest = getRequest(URLRequestMethod.POST, CREATE_MESSAGE.replace("#{project_id}", message.projectID));
			request.data = message.toXML();
			
			loader.load(request);
		}
		
		/**
		 * Updates an existing message, optionally sending notifications to a selected list of people. Note that you can also upload files using this function, but you need to upload the files first and then attach them.
		 * @param message
		 */		
		public function updateMessage(message:BasecampMessage):void{
			if(message.id < 1) throw new ArgumentError("ID is required in the message object.");
			if(!message.title || message.title.length == 0) throw new Error("Message Title is required in the message object.");
			if(!message.body || message.body.length == 0) throw new Error("Message Body is required in the message object.");
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onUpdateResult);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = message.toXML();
			
			var request:URLRequest = getRequest(URLRequestMethod.PUT, UPDATE_MESSAGE.replace("#{project_id}", message.projectID));
			request.data = message.toXML();
			
			loader.load(request);
		}
		
		/**
		 * Destroys the given message and all of its associated comments. 
		 * @param id
		 */		
		public function destroyMessage(id:int):void{
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onDestroyResult);
			loader.load(getRequest(URLRequestMethod.DELETE, DESTROY_MESSAGE.replace("#{id}", id)));
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
		protected function onMessagesResult(event:Event):void{
			var data:XML = XML(URLLoader(event.target).data);
			
			var ev:BasecampMessageEvent = new BasecampMessageEvent(BasecampMessageEvent.GET_MESSAGES_RESULT, true);
			ev.messages = new Array();
			for each(var item:XML in data.post){
				ev.messages.push(BasecampMessage.buildFromXML(item));
			}
			
			dispatchEvent(ev);
		}
		
		/**
		 * Handles single message result 
		 * @param event
		 */
		protected function onMessageResult(event:Event):void{
			var ev:BasecampMessageEvent = new BasecampMessageEvent(BasecampMessageEvent.GET_MESSAGE_RESULT, true);
			ev.message = BasecampMessage.buildFromXML(XML(URLLoader(event.target).data));
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for create requests 
		 * @param event
		 */
		protected function onCreateResult(event:HTTPStatusEvent):void{
			var ev:BasecampMessageEvent;
			switch(event.status){
				case 201:
					ev = new BasecampMessageEvent(BasecampMessageEvent.UPDATE_MESSAGE_COMPLETE, true);
				break;
				default:
					ev = new BasecampMessageEvent(BasecampMessageEvent.MESSAGE_CALL_FAILED, true);
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
			var ev:BasecampMessageEvent;
			switch(event.status){
				case 200:
					ev = new BasecampMessageEvent(BasecampMessageEvent.UPDATE_MESSAGE_COMPLETE, true);
				break;
				default:
					ev = new BasecampMessageEvent(BasecampMessageEvent.MESSAGE_CALL_FAILED, true);
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
			var ev:BasecampMessageEvent;
			switch(event.status){
				case 200:
					ev = new BasecampMessageEvent(BasecampMessageEvent.DESTROY_MESSAGE_COMPLETE, true);
				break;
				default:
					ev = new BasecampMessageEvent(BasecampMessageEvent.MESSAGE_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
	}
}