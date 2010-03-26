package com.basecamphq.api.events{
	import flash.events.Event;

	public class BasecampEvent extends Event{
		public static const SESSION_STATE_CHANGE:String = "sessionStateChange";
		
		/**
		 * Content has loaded, parsed, and is ready for use 
		 */		
		public static const CONTENT_LOADED:String = "contentLoaded";
		
		/**
		 * An http status error has occurred 
		 */		
		public static const HTTP_ERROR:String = "httpError";
		
		/**
		 * An error occurred loading the content 
		 */		
		public static const CONTENT_ERROR:String = "contentError";
		
		/**
		 * Call completed 
		 */		
		public static const COMPLETE:String = "callComplete";
		
		/**
		 * A call failed 
		 */		
		public static const FAILED:String = "callFailed";
		
		public function BasecampEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}