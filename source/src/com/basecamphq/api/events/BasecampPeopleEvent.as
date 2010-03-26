package com.basecamphq.api.events{
	import com.basecamphq.api.models.BasecampPerson;
	
	import flash.events.Event;

	public class BasecampPeopleEvent extends Event{
	//	CONSTANTS
		public static const GET_PERSON_COMPLETE:String = "getPersonComplete";
		public static const GET_PEOPLE_COMPLETE:String = "getPeopleComplete";
	
	//	PROPERTIES
		public var person:BasecampPerson;
		
		[ArrayElementType(name="com.basecamphq.api.models.BasecampPerson")]
		public var people:Array;
	
	//	CONSTRUCTOR
		public function BasecampPeopleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}