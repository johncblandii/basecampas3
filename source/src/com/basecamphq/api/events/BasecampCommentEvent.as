package com.basecamphq.api.events{
	import com.basecamphq.api.models.BasecampComment;

	public class BasecampCommentEvent extends BasecampAbstractEvent{
	//	CONSTANTS
		public static const GET_COMMENTS_RESULT:String = "getCommentsResult";
		public static const GET_COMMENT_RESULT:String = "getCommentResult";
		public static const CREATE_COMMENT_COMPLETE:String = "createCommentComplete";
		public static const UPDATE_COMMENT_COMPLETE:String = "updateCommentComplete";
		public static const DESTROY_COMMENT_COMPLETE:String = "destroyCommentComplete";
		public static const COMMENT_CALL_FAILED:String = "commentCallFailed";
		
	//	PROPERTIES
		/**
		 * Comments received 
		 */		
		[ArrayElementType(name="com.basecamphq.api.models.BasecampComment")]
		public var comments:Array;
		
		/**
		 * Comment received
		 */
		public var comment:BasecampComment;
		
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */
		public function BasecampCommentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}