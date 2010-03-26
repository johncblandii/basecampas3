package com.basecamphq.api.events{
	import com.basecamphq.api.models.BasecampMilestone;

	public class BasecampMilestoneEvent extends BasecampAbstractEvent{
	//	CONSTANTS
		public static const GET_MILESTONES_COMPLETE:String = "getMilestonesComplete";
		//public static const GET_MILESTONE_COMPLETE:String = "getMilestoneComplete";
		public static const COMPLETE_MILESTONE_COMPLETE:String = "completeMilestoneComplete";
		public static const UNCOMPLETE_MILESTONE_COMPLETE:String = "uncompleteMilestoneComplete";
		public static const CREATE_MILESTONE_COMPLETE:String = "createMilestoneComplete";
		public static const UPDATE_MILESTONE_COMPLETE:String = "updateMilestoneComplete";
		public static const DESTROY_MILESTONE_COMPLETE:String = "destroyMilestoneComplete";
		public static const MILESTONE_CALL_FAILED:String = "milestoneCallFailed";
		
	//	PROPERTIES
		/**
		 * Milestones received 
		 */		
		[ArrayElementType(name="com.basecamphq.api.models.BasecampMilestone")]
		public var milestones:Array;
		
		/**
		 * Milestone received
		 */		
		public var milestone:BasecampMilestone;
		
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */		
		public function BasecampMilestoneEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}