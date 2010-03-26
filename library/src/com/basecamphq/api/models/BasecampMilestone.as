package com.basecamphq.api.models{
	import com.basecamphq.api.utils.BasecampUtil;
	
	[Bindable]
	/**
	 * Milestone
	 * @author johncblandii 
	 */
	public class BasecampMilestone{
	//	PROPERTIES
		public var id:int;
		public var title:String;
		public var deadline:Date;
		public var isComplete:Boolean = false;
		public var projectID:int;
		public var createdOn:Date;
		public var creatorID:int;
		public var responsiblePartyID:int;
		public var responsiblePartyType:String;
		public var commentsCount:int;
		public var completedOn:Date;
		public var completerID:int;
		
	//	STATIC METHODS
		/**
		 * Builds a milestone item
		 * Expected Format:
		 * <milestone>
			  <id type="integer">#{id}</id>
			  <title>#{title}</title>
			  <deadline type="date">#{deadline}</deadline>
			  <completed type="boolean">#{true|false}</completed>
			  <project-id type="integer">#{project_id}</project-id>
			  <created-on type="datetime">#{created_on}</created-on>
			  <creator-id type="integer">#{creator_id}</creator-id>
			  <responsible-party-id type="integer">#{responsible_party_id}</responsible-party-id>
			  <responsible-party-type>#{responsible_party_type}</responsible-party-type>
			  <comments-count type="integer">#{comments_count}</comments-count>
			
			  <!-- if the milestone has been completed -->
			  <completed-on type="datetime">#{completed_on}</completed-on>
			  <completer-id type="integer">#{completer_id}</completer-id>
			</milestone>
		 * @param xml
		 * @return
		 */
		public static function buildFromXML(xml:XML):BasecampMilestone{
			var result:BasecampMilestone = new BasecampMilestone();
			result.id = int(xml.id.toString());
			result.title = xml.title.toString();
			result.deadline = BasecampUtil.ParseDate(xml.deadline.toString());
			result.isComplete = xml.completed.toString() == "true";
			result.projectID = int(xml.child("project-id").toString());
			result.createdOn = BasecampUtil.ParseDate(xml.child("created-on").toString());
			result.creatorID = int(xml.child("creator-id").toString());
			result.responsiblePartyID = int(xml.child("responsible-party-id").toString());
			result.responsiblePartyType = xml.child("responsible-party-type").toString();
			result.commentsCount = int(xml.child("comments-count").toString());
			result.completedOn = BasecampUtil.ParseDate(xml.child("completed-on").toString());
			result.completerID = int(xml.child("completer-id").toString());
			return result;
		}
	}
}