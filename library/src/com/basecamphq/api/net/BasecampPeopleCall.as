package com.basecamphq.api.net{
	import com.basecamphq.api.core.BasecampSession;
	import com.basecamphq.api.events.BasecampPeopleEvent;
	import com.basecamphq.api.events.BasecampProjectEvent;
	import com.basecamphq.api.models.BasecampPerson;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;

	[Event(name="getPersonComplete", type="com.basecamphq.api.events.BasecampProjectEvent")]
	[Event(name="getPeopleComplete", type="com.basecamphq.api.events.BasecampProjectEvent")]
	
	/**
	 * Calls specific to person requests.
	 * Note: Use once and throw away.
	 * @author johncblandii
	 */	
	public class BasecampPeopleCall extends BasecampCall{
	//	CONSTANTS
		protected static const GET_PEOPLE_IN_COMPANY:String = "/contacts/people/#{company_id}";
		protected static const GET_PEOPLE_IN_PROJECT_URL:String = "/projects/#{project_id}/contacts/people/#{company_id}";
		protected static const GET_PERSON_URL:String = "/contacts/person/#{person_id}";		
		
	//	CONSTRUCTOR
		/**
		 * Constructor
		 * @param session
		 */		
		public function BasecampPeopleCall(session:BasecampSession){
			super(session);
		}
		
	//	PUBLIC METHODS
		/**
		 * This will return all of the people in the given company. If a project id is given, it will be used to filter the set of people that are returned to include only those that can access the given project.   
		 * Call: GET /contacts/people/#{company_id}
		 * @param companyID  
		 */		
		public function getPeopleByCompany(companyID:int):void{
			getLoader(onPeopleResult).load(getRequest(URLRequestMethod.POST, GET_PEOPLE_IN_COMPANY.replace("#{company_id}", companyID)));
		}
		
		/**
		 * This will return information about the referenced person.
		 * Call: GET /contacts/person/#{person_id}  
		 * @param personID
		 * 
		 */		
		public function getPerson(personID:int):void{ 
			getLoader(onPersonResult).load(getRequest(URLRequestMethod.GET, GET_PERSON_URL.replace("#{person_id}", personID)));
		}
		
		/**
		 * This will return all of the people in the given company that can access the given project.
		 * Call: GET /projects/#{project_id}/contacts/people/#{company_id} 
		 * @param projectID
		 */		
		public function getPeopleInProject(companyID:int, projectID:int):void{ 
			getLoader(onPeopleResult).load(getRequest(URLRequestMethod.GET, GET_PEOPLE_IN_PROJECT_URL.replace("#{company_id}", companyID).replace("#{project_id}", projectID)));
		}
		
	//	EVENT LISTENERS
		
		/**
		 * Handles getCompanys result 
		 * @param event
		 * @private
		 */		
		private function onPeopleResult(event:Event):void{
			var data:XML = XML(URLLoader(event.target).data);
			var ev:BasecampPeopleEvent = new BasecampPeopleEvent(BasecampPeopleEvent.GET_PEOPLE_COMPLETE, true);
			ev.people = new Array();
			for each(var item:XML in data.person){
				ev.people.push(BasecampPerson.buildFromXML(item));
			}
			dispatchEvent(ev);
		}
		
		/**
		 * Handles getCompany(#) result 
		 * @param event
		 * @private
		 */		
		private function onPersonResult(event:Event):void{
			var ev:BasecampPeopleEvent = new BasecampPeopleEvent(BasecampPeopleEvent.GET_PERSON_COMPLETE, true);
			ev.person = BasecampPerson.buildFromXML(XML(URLLoader(event.target).data));
			dispatchEvent(ev);
		}
	}
}