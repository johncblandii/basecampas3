package com.basecamphq.api.events{
	import com.basecamphq.api.models.BasecampMessage;

	/**
	 * Message event
	 * @author johncblandii
	 */	
	public class BasecampMessageEvent extends com.basecamphq.api.events.BasecampAbstractEvent{
	//	CONSTANTS
		public static const GET_MESSAGES_RESULT:String = "getMessagesResult";
		public static const GET_MESSAGE_RESULT:String = "getMessageResult";
		public static const CREATE_MESSAGE_COMPLETE:String = "createMessageComplete";
		public static const UPDATE_MESSAGE_COMPLETE:String = "updateMessageComplete";
		public static const DESTROY_MESSAGE_COMPLETE:String = "destroyMessageComplete";
		public static const MESSAGE_CALL_FAILED:String = "messageCallFailed";
		
	//	PROPERTIES
		/**
		 * Messages received 
		 */		
		[ArrayElementType(name="com.basecamphq.api.models.BasecampMessage")]
		public var messages:Array;
		
		/**
		 * Message received
		 */		
		public var message:BasecampMessage;
		
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */
		public function BasecampMessageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}