package com.basecamphq.api.events{
	import flash.events.Event;
	
	/**
	 * Abstract event for Basecamp events 
	 * @author johncblandii
	 * 
	 */	
	public class BasecampAbstractEvent extends Event{
	//	PROPERTIES
		/**
		 * HTTP status code returned from a failure call 
		 */		
		public var statusCode:int;
		/**
		 * HTTP response headers, if they exist 
		 */		
		public var responseHeaders:Array;
	
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */		
		public function BasecampAbstractEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}