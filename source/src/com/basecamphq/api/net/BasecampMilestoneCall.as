package com.basecamphq.api.net{
	import com.basecamphq.api.core.BasecampSession;
	import com.basecamphq.api.events.BasecampMilestoneEvent;
	import com.basecamphq.api.models.BasecampMilestone;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	[Event(name="getMilestonesResult", type="com.basecamphq.api.events.BasecampMilestoneEvent")]
	[Event(name="createMilestoneComplete", type="com.basecamphq.api.events.BasecampMilestoneEvent")]
	[Event(name="updateMilestoneComplete", type="com.basecamphq.api.events.BasecampMilestoneEvent")]
	[Event(name="destroyMilestoneComplete", type="com.basecamphq.api.events.BasecampMilestoneEvent")]
	
	/**
	 * Calls specific to to-do list requests.
	 * Note: Use once and throw away.
	 * @author johncblandii
	 */	
	public class BasecampMilestoneCall extends BasecampCall{
	//	CONSTANTS
		protected static const GET_MILESTONES:String = "/projects/#{project_id}/milestones/list";
		protected static const COMPLETE_MILESTONE:String = "/milestones/complete/#{id}";
		protected static const UNCOMPLETE_MILESTONE:String = "/milestones/uncomplete/#{id}";
		protected static const CREATE_MILESTONE:String = "/projects/#{project_id}/milestones/create";
		protected static const CREATE_MILESTONES:String = "/projects/#{project_id}/milestones/create";
		protected static const UPDATE_MILESTONE:String = "/milestones/update/#{id}";
		protected static const DESTROY_MILESTONE:String = "/milestones/delete/#{id}";
	
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param session
		 */		
		public function BasecampMilestoneCall(session:BasecampSession){
			super(session);
		}
		
	//	PUBLIC METHODS
		/**
		 * This lets you query the list of milestones for a project. You can either return all milestones, or only those that are late, completed, or upcoming. 
		 * @param companyID
		 */		
		public function getMilestonesByProject(projectID:int):void{
			getLoader(onMilestonesResult).load(getRequest(URLRequestMethod.GET, GET_MILESTONES.replace("#{project_id}", projectID)));
		}
		
		/**
		 * Marks the specified milestone as complete.
		 * @param id
		 */		
		public function completeTodoItem(id:int):void{
			getLoader(onCompleteMilestoneResult).load(getRequest(URLRequestMethod.PUT, COMPLETE_MILESTONE.replace("#{id}", id)));
		}
		
		/**
		 * Marks the specified milestone as uncomplete.
		 * @param id
		 */		
		public function uncompleteTodoItem(id:int):void{
			getLoader(onUncompleteMilestoneResult).load(getRequest(URLRequestMethod.PUT, UNCOMPLETE_MILESTONE.replace("#{id}", id)));
		}
		
		/**
		 * Creates a single milestone. To create multiple milestones in a single call, see the “create (batch)” function. To make a company responsible for the milestone, prefix the company id with a “c”.
		 * @param list
		 */		
		public function createMilestone(milestone:BasecampMilestone, notify:Boolean=false):void{
			if(milestone.projectID < 1) throw new ArgumentError("Project ID is required in the milestone object.");
			if(!milestone.title || milestone.title.length == 0) throw new Error("Message Title is required in the list object.");
			
			var data:XML = <request>
							  <milestone>
							    <title>{milestone.title}</title>
							    <deadline type="date">{milestone.deadline}</deadline>
							    <notify>{notify}</notify>
							  </milestone>
							</request>;
			if(milestone.responsiblePartyID > 0) data.appendChild(<responsible-party>{milestone.responsiblePartyID}</responsible-party>);
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onCreateResult);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = data;
			
			var request:URLRequest = getRequest(URLRequestMethod.POST, CREATE_MILESTONE.replace("#{project_id}", milestone.projectID));
			request.data = data;
			
			loader.load(request);
		}
		
		/**
		 * Creates a single milestone. To create multiple milestones in a single call, see the “create (batch)” function. To make a company responsible for the milestone, prefix the company id with a “c”. 
		 * @param projectID
		 * @param milestoneList
		 * @param notify 
		 */		
		public function batchCreateMilestone(projectID:int, milestoneList:Array, notify:Boolean=false):void{
			var data:XML = <request/>;
			var item:XML;
			for each(var milestone:BasecampMilestone in milestoneList){
				item = <milestone>
						    <title>{milestone.title}</title>
						    <deadline type="date">{milestone.deadline}</deadline>
						    <notify>{notify}</notify>
						  </milestone>;
				if(milestone.responsiblePartyID > 0) item.appendChild(<responsible-party>{milestone.responsiblePartyID}</responsible-party>);
				data.appendChild(item);
			}
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onCreateResult);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = data;
			
			var request:URLRequest = getRequest(URLRequestMethod.POST, CREATE_MILESTONES.replace("#{project_id}", projectID));
			request.data = data;
			
			loader.load(request);
		}
		
		/**
		 * Modifies a single milestone. You can use this to shift the deadline of a single milestone, and optionally shift the deadlines of subsequent milestones as well.
		 * @param list
		 */		
		public function updateMilestone(milestone:BasecampMilestone, notify:Boolean=false, moveUpcoming:Boolean=false, moveUpcomingOffWeekends:Boolean=false):void{
			if(milestone.id < 1) throw new ArgumentError("ID is required in the message object.");
			
			var data:XML = <request>
							  <milestone>
							    <title>{milestone.title}</title>
							    <deadline>{milestone.deadline}</deadline>
							    <responsible-party>{milestone.responsiblePartyID}</responsible-party>
							    <notify>{notify}</notify>
							  </milestone>
							  <move-upcoming-milestones>{moveUpcoming}</move-upcoming-milestones>
							  <move-upcoming-milestones-off-weekends>{moveUpcomingOffWeekends}</move-upcoming-milestones-off-weekends>
							</request>;
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onUpdateResult);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = data;
			
			var request:URLRequest = getRequest(URLRequestMethod.PUT, UPDATE_MILESTONE.replace("#{id}", milestone.id));
			request.data = data;
			
			loader.load(request);
		}
		
		/**
		 * Deletes the given milestone from the project. 
		 * @param id
		 */		
		public function destroyMilestone(id:int):void{
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onDestroyResult);
			loader.load(getRequest(URLRequestMethod.DELETE, DESTROY_MILESTONE.replace("#{id}", id)));
		}
		
	//	EVENT LISTENERS
		/**
		 * Handles message list result 
		 * @param event
		 */
		protected function onMilestonesResult(event:Event):void{
			var data:XML = XML(URLLoader(event.target).data);
			
			var ev:BasecampMilestoneEvent = new BasecampMilestoneEvent(BasecampMilestoneEvent.GET_MILESTONES_COMPLETE, true);
			ev.milestones = new Array();
			for each(var item:XML in data.milestone){
				ev.milestones.push(BasecampMilestone.buildFromXML(item));
			}
			
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for create requests
		 * @param event
		 */
		protected function onCreateResult(event:HTTPStatusEvent):void{
			var ev:BasecampMilestoneEvent;
			switch(event.status){
				case 201:
					ev = new BasecampMilestoneEvent(BasecampMilestoneEvent.CREATE_MILESTONE_COMPLETE, true);
				break;
				default:
					ev = new BasecampMilestoneEvent(BasecampMilestoneEvent.MILESTONE_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for update requests 
		 * @param event
		 */	
		protected function onUpdateResult(event:HTTPStatusEvent):void{
			var ev:BasecampMilestoneEvent;
			switch(event.status){
				case 200:
					ev = new BasecampMilestoneEvent(BasecampMilestoneEvent.UPDATE_MILESTONE_COMPLETE, true);
				break;
				default:
					ev = new BasecampMilestoneEvent(BasecampMilestoneEvent.MILESTONE_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for destroy requests 
		 * @param event
		 */	
		protected function onDestroyResult(event:HTTPStatusEvent):void{
			var ev:BasecampMilestoneEvent;
			switch(event.status){
				case 200:
					ev = new BasecampMilestoneEvent(BasecampMilestoneEvent.DESTROY_MILESTONE_COMPLETE, true);
				break;
				default:
					ev = new BasecampMilestoneEvent(BasecampMilestoneEvent.MILESTONE_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for complete requests 
		 * @param event
		 */		
		protected function onCompleteMilestoneResult(event:HTTPStatusEvent):void{
			var ev:BasecampMilestoneEvent;
			switch(event.status){
				case 200:
					ev = new BasecampMilestoneEvent(BasecampMilestoneEvent.COMPLETE_MILESTONE_COMPLETE, true);
				break;
				default:
					ev = new BasecampMilestoneEvent(BasecampMilestoneEvent.MILESTONE_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for uncomplete requests
		 * @param event
		 */		
		protected function onUncompleteMilestoneResult(event:HTTPStatusEvent):void{
			var ev:BasecampMilestoneEvent;
			switch(event.status){
				case 200:
					ev = new BasecampMilestoneEvent(BasecampMilestoneEvent.UNCOMPLETE_MILESTONE_COMPLETE, true);
				break;
				default:
					ev = new BasecampMilestoneEvent(BasecampMilestoneEvent.MILESTONE_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
	}
}