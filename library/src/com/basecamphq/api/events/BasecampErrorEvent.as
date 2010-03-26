package com.basecamphq.api.events{
	import com.basecamphq.api.models.BasecampError;
	
	import flash.events.Event;

	public class BasecampErrorEvent extends Event{
		/**
		 * An error occurred loading the content 
		 */		
		public static const API_ERROR:String = "apiError";
		
		public var error:BasecampError;
		
		public function BasecampErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}