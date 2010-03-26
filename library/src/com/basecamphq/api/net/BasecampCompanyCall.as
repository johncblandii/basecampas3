package com.basecamphq.api.net{
	import com.basecamphq.api.core.BasecampSession;
	import com.basecamphq.api.events.BasecampCompanyEvent;
	import com.basecamphq.api.models.BasecampCompany;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;

	[Event(name="getCompanyComplete", type="com.basecamphq.api.events.BasecampCompanyEvent")]
	[Event(name="getCompaniesComplete", type="com.basecamphq.api.events.BasecampCompanyEvent")]

	/**
	 * Calls specific to company requests.
	 * Note: Use once and throw away.
	 * @author johncblandii
	 */	
	public class BasecampCompanyCall extends BasecampCall{
	//	CONSTANTS
		protected static const GET_COMPANIES_URL:String = "/companies.xml";
		protected static const GET_COMPANIES_ON_PROJECT_URL:String = "/projects/#{project_id}/companies.xml";
		protected static const GET_COMPANY:String = "/companies/#{company_id}.xml";
		
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param session
		 */		
		public function BasecampCompanyCall(session:BasecampSession){
			super(session);
		}
		
	//	PUBLIC METHODS
		/**
		 * Returns a list of all companies visible to the requesting user. 
		 * Call: GET /companies.xml  
		 */		
		public function getCompanies():void{
			getLoader(onCompaniesResult).load(getRequest(URLRequestMethod.GET, GET_COMPANIES_URL));
		}
		
		/**
		 * Returns a single company identified by its integer ID. 
		 * Call: GET /companies/#{company_id}.xml  
		 * @param companyID
		 * 
		 */		
		public function getCompany(companyID:int):void{ 
			getLoader(onCompanyResult).load(getRequest(URLRequestMethod.GET, GET_COMPANY.replace("#{company_id}", companyID)));
		}
		
		/**
		 * Returns a list of all companies associated with given project.
		 * @param projectID
		 * 
		 */		
		public function getCompaniesByProject(projectID:int):void{ 
			getLoader(onCompaniesResult).load(getRequest(URLRequestMethod.GET, GET_COMPANIES_ON_PROJECT_URL.replace("#{project_id}", projectID)));
		}
		
	//	EVENT LISTENERS
		/**
		 * Handles getCompanys result 
		 * @param event
		 * @private
		 */		
		private function onCompaniesResult(event:Event):void{
			var data:XML = XML(URLLoader(event.target).data);
			var ev:BasecampCompanyEvent = new BasecampCompanyEvent(BasecampCompanyEvent.GET_COMPANIES_COMPLETE, true);
			ev.companies = new Array();
			for each(var item:XML in data.company){
				ev.companies.push(BasecampCompany.buildFromXML(item));
			}
			dispatchEvent(ev);
		}
		
		/**
		 * Handles getCompany(#) result 
		 * @param event
		 * @private
		 */		
		private function onCompanyResult(event:Event):void{
			var ev:BasecampCompanyEvent = new BasecampCompanyEvent(BasecampCompanyEvent.GET_COMPANY_COMPLETE, true);
			ev.company = BasecampCompany.buildFromXML(XML(URLLoader(event.target).data));
			dispatchEvent(ev);
		}
	}
}