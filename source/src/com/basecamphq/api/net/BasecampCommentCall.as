package com.basecamphq.api.net{
	import com.basecamphq.api.core.BasecampCommentType;
	import com.basecamphq.api.core.BasecampSession;
	import com.basecamphq.api.events.BasecampCommentEvent;
	import com.basecamphq.api.models.BasecampComment;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	[Event(name="getCommentsResult", type="com.basecamphq.api.events.BasecampCommentEvent")]
	[Event(name="getCommentResult", type="com.basecamphq.api.events.BasecampCommentEvent")]
	[Event(name="createCommentComplete", type="com.basecamphq.api.events.BasecampCommentEvent")]
	[Event(name="updateCommentComplete", type="com.basecamphq.api.events.BasecampCommentEvent")]
	[Event(name="destroyCommentComplete", type="com.basecamphq.api.events.BasecampCommentEvent")]
	[Event(name="commentCallFailed", type="com.basecamphq.api.events.BasecampCommentEvent")]
	
	/**
	 * Calls specific to comment requests.
	 * Note: Use once and throw away.
	 * @author johncblandii
	 */	
	public class BasecampCommentCall extends BasecampCall{
	//	CONSTANTS
		public static const GET_COMMENTS:String = "/#{resource}/#{resource_id}/comments.xml";
		public static const GET_COMMENT:String = "/comments/#{comment_id}.xml";
		public static const NEW_COMMENT_FIELDS:String = "/#{resource}/#{resource_id}/comments/new.xml";
		public static const CREATE_COMMENT:String = "/#{resource}/#{resource_id}/comments.xml";
		public static const EDIT_MESSAGE_FIELDS:String = "/comments/#{id}/edit.xml";
		public static const UPDATE_COMMENT:String = "/comments/#{id}.xml";
		public static const DESTROY_COMMENT:String = "/comments/#{id}.xml";
	
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param session
		 */		
		public function BasecampCommentCall(session:BasecampSession){
			super(session);
		}
		
	//	PUBLIC METHODS
		/**
		 * Return the list of comments associated with the specified resource, where the resource named 
		 * in the URL can be one of posts, milestones, or todo_items. 
		 * @param type A valid comment type @see com.basecamphq.api.core.BasecampCommentType
		 * @param resourceID
		 * @throws ArgumentError
		 */		
		public function getComments(type:String, resourceID:int):void{
			if(!BasecampCommentType.validate(type)) throw new ArgumentError("A valid 'type' is required. See com.basecamphq.api.core.BasecampCommentType.");
			getLoader(onCommentsResult).load(getRequest(URLRequestMethod.GET, GET_COMMENTS.replace("#{resource}", type).replace("#{resource_id}", resourceID)));
		}
		
		/**
		 * Retrieve a specific comment by its id. 
		 * @param id
		 */		
		public function getComment(id:int):void{
			getLoader(onCommentResult).load(getRequest(URLRequestMethod.GET, GET_COMMENT.replace("#{id}", id)));
		}
		
		/**
		 * Create a new comment, associating it with a specific resource, where the resource named in the URL can be one of posts, milestones, or todo_items. For example, to create a comment for the milestone with an ID of 1, you would use the path: /milestones/1/comments.xml.
		 * @param comment
		 */		
		public function createComment(comment:BasecampComment):void{
			if(BasecampCommentType.validate(comment.commentableType)) throw new ArgumentError("Commentable Type is not valid. See com.basecamphq.api.core.BasecampCommentType.");
			if(!comment.body || comment.body.length == 0) throw new Error("Comment Body is required in the comment object.");
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onCreateResult);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = comment.toXML();
			
			var request:URLRequest = getRequest(URLRequestMethod.POST, CREATE_COMMENT.replace("#{resource}", comment.commentableType).replace("#{resource_id}", comment.commentableID));
			request.data = comment.toXML();
			
			loader.load(request);
		}
		
		/**
		 * Update a specific comment. This can be used to edit the content of an existing comment.
		 * @param comment
		 */		
		public function updateComment(comment:BasecampComment):void{
			if(comment.id < 1) throw new ArgumentError("ID is required in the comment object.");
			if(!comment.body || comment.body.length == 0) throw new Error("Comment Body is required in the message object.");
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onUpdateResult);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = comment.toXML();
			
			var request:URLRequest = getRequest(URLRequestMethod.PUT, UPDATE_COMMENT.replace("#{id}", comment.id));
			request.data = comment.toXML();
			
			loader.load(request);
		}
		
		/**
		 * Delete the comment with the given ID. 
		 * @param id
		 */		
		public function destroyComment(id:int):void{
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onDestroyResult);
			loader.load(getRequest(URLRequestMethod.DELETE, DESTROY_COMMENT.replace("#{id}", id)));
		}
		
	//	PRIVATE METHODS
		/**
		 * Returns a blank XML “template” for a single comment record, indicating which fields may be submitted to create a new comment. It will also return a custom HTTP header (X-Create-Action) indicating where and how the data may be submitted. 
		 * @param projectID
		 * @private
		 */		
		protected function getNewMessageFields(type:String, resourceID:int):void{
			//not implemented
		}
		
		/**
		 * Returns an XML “template” for a single comment record, prefilled with the existing values for that record, and ready to be resubmitted via the “update comment” action. It will also return a custom HTTP header (X-Update-Action) indicating where and how the data may be submitted. 
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
		protected function onCommentsResult(event:Event):void{
			var data:XML = XML(URLLoader(event.target).data);
			
			var ev:BasecampCommentEvent = new BasecampCommentEvent(BasecampCommentEvent.GET_COMMENTS_RESULT, true);
			ev.comments = new Array();
			for each(var item:XML in data.comment){
				ev.comments.push(BasecampComment.buildFromXML(item));
			}
			
			dispatchEvent(ev);
		}
		
		/**
		 * Handles single message result 
		 * @param event
		 */
		protected function onCommentResult(event:Event):void{
			var ev:BasecampCommentEvent = new BasecampCommentEvent(BasecampCommentEvent.GET_COMMENT_RESULT, true);
			ev.comment = BasecampComment.buildFromXML(XML(URLLoader(event.target).data));
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for create requests 
		 * @param event
		 */
		protected function onCreateResult(event:HTTPStatusEvent):void{
			var ev:BasecampCommentEvent;
			switch(event.status){
				case 201:
					ev = new BasecampCommentEvent(BasecampCommentEvent.UPDATE_COMMENT_COMPLETE, true);
				break;
				default:
					ev = new BasecampCommentEvent(BasecampCommentEvent.COMMENT_CALL_FAILED, true);
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
			var ev:BasecampCommentEvent;
			switch(event.status){
				case 200:
					ev = new BasecampCommentEvent(BasecampCommentEvent.UPDATE_COMMENT_COMPLETE, true);
				break;
				default:
					ev = new BasecampCommentEvent(BasecampCommentEvent.COMMENT_CALL_FAILED, true);
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
			var ev:BasecampCommentEvent;
			switch(event.status){
				case 200:
					ev = new BasecampCommentEvent(BasecampCommentEvent.DESTROY_COMMENT_COMPLETE, true);
				break;
				default:
					ev = new BasecampCommentEvent(BasecampCommentEvent.COMMENT_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
	}
}