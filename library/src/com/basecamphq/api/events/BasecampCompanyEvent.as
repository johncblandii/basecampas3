package com.basecamphq.api.events{
	import com.basecamphq.api.models.BasecampCompany;
	
	import flash.events.Event;

	public class BasecampCompanyEvent extends Event{
	//	CONSTANTS
		public static const GET_COMPANY_COMPLETE:String = "getCompanyComplete";
		public static const GET_COMPANIES_COMPLETE:String = "getCompaniesComplete";
		
	//	PROPERTIES
		/**
		 * Company returned from get company call 
		 */		
		public var company:BasecampCompany;
		
		/**
		 * Companies returned 
		 */		
		[ArrayElementType(name="com.basecamphq.api.models.BasecampCompany")]
		public var companies:Array;
		
	//	CONSTRUCTOR
		public function BasecampCompanyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}