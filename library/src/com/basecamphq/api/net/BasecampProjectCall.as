package com.basecamphq.api.net{
	import com.basecamphq.api.core.BasecampSession;
	import com.basecamphq.api.events.BasecampEvent;
	import com.basecamphq.api.events.BasecampProjectEvent;
	import com.basecamphq.api.models.BasecampProject;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;

	[Event(name="getProjectsComplete", type="com.basecamphq.api.events.BasecampProjectEvent")]
	[Event(name="getProjectComplete", type="com.basecamphq.api.events.BasecampProjectEvent")]
	
	/**
	 * Calls specific to project requests.
	 * Note: Use once and throw away.
	 * @author johncblandii
	 */	
	public class BasecampProjectCall extends BasecampCall{
	//	CONSTANTS
		protected static const PROJECT_BASE_URL:String = "/projects/#{project_id}.xml";
		protected static const GET_PROJECTS_BASE_URL:String = "/projects.xml";
	
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param session
		 */		
		public function BasecampProjectCall(session:BasecampSession){
			super(session);
		}
		
	//	PUBLIC METHODS
		/**
		 * Returns all accessible projects. This includes active, inactive, and archived projects.
		 * Call: GET /projects.xml  
		 */		
		public function getProjects():void{
			getLoader(onProjectsResult).load(getRequest(URLRequestMethod.GET, GET_PROJECTS_BASE_URL));
		}
		
		/**
		 * Returns a single project identified by its integer ID
		 * Call: GET /projects/#{project_id}.xml  
		 * @param projectID
		 * 
		 */		
		public function getProject(projectID:int):void{ 
			getLoader(onProjectResult).load(getRequest(URLRequestMethod.GET, PROJECT_BASE_URL.replace("#{project_id}", projectID)));
		}
		
	//	EVENT LISTENERS
		/**
		 * Handles getProjects result 
		 * @param event
		 * @private
		 */		
		private function onProjectsResult(event:Event):void{
			var data:XML = XML(URLLoader(event.target).data);
			var ev:BasecampProjectEvent = new BasecampProjectEvent(BasecampProjectEvent.GET_PROJECTS_COMPLETE, true);
			ev.projects = new Array();
			for each(var item:XML in data.project){
				ev.projects.push(BasecampProject.buildFromXML(item));
			}
			dispatchEvent(ev);
		}
		
		/**
		 * Handles getProject(#) result 
		 * @param event
		 * @private
		 */		
		private function onProjectResult(event:Event):void{
			var ev:BasecampProjectEvent = new BasecampProjectEvent(BasecampProjectEvent.GET_PROJECT_COMPLETE, true);
			ev.project = BasecampProject.buildFromXML(XML(URLLoader(event.target).data));
			dispatchEvent(ev);
		}
	}
}