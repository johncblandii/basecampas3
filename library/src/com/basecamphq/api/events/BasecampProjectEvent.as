package com.basecamphq.api.events{
	import com.basecamphq.api.models.BasecampProject;
	
	import flash.events.Event;

	public class BasecampProjectEvent extends Event{
	//	CONSTANTS
		public static const GET_PROJECT_COMPLETE:String = "getProjectComplete";
		public static const GET_PROJECTS_COMPLETE:String = "getProjectsComplete";
	
	//	PROPERTES
		public var project:BasecampProject;
		
		[ArrayElementType(name="com.basecamphq.api.models.BasecampProject")]
		public var projects:Array;
		
	//	CONSTANTS
		public function BasecampProjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}