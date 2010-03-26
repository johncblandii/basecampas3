package com.basecamphq.api.models{
	import com.basecamphq.api.utils.BasecampUtil;
	
	/**
	 * To-do Item
	 * @author johncblandii 
	 */	
	public class BasecampTodoItem{
	//	PROPERTIES
		public var id:int;
		public var listID:int;
		public var content:String;
		public var position:int;
		public var createdOn:Date;
		public var creatorID:int;
		public var isCompleted:Boolean = false;
		public var commentsCount:int;
		/**
		 * if the item has a responsible party 
		 */
		public var responsiblePartyType:String;
		public var responsiblePartyID:int;
		/**
		 * if the item has been completed 
		 */		
		public var completedOn:Date;
		public var completerID:int;
		
	//	STATIC METHODS
		
		/**
		 * Builds a todo item
		 * Expected Format:
		 * <todo-item>
			  <id type="integer">#{id}</id>
			  <content>#{content}</content>
			  <position type="integer">#{position}</position>
			  <created-on type="datetime">#{created_on}</created-on>
			  <creator-id type="integer">#{creator_id}</creator-id>
			  <completed type="boolean">#{completed}</completed>
			  <comments-count type="integer">#{comments_count}</comments-count>
			  <responsible-party-type>#{responsible_party_type}</responsible-party-type>
			  <responsible-party-id type="integer">#{responsible_party_id}</responsible-party-id>
			  <completed-on type="datetime">#{completed_on}</completed-on>
			  <completer-id type="integer">#{completer_id}</completer-id>
			</todo-item> 
		 * @param xml
		 * @return 
		 * 
		 */		
		public static function buildFromXML(xml:XML):BasecampTodoItem{
			var result:BasecampTodoItem = new BasecampTodoItem();
			result.id = int(xml.id.toString());
			result.content = xml.content.toString();
			result.position = int(xml.position.toString());
			result.createdOn = BasecampUtil.ParseDate(xml.child("created-on").toString());
			result.creatorID = int(xml.child("creator-id").toString());
			result.isCompleted = xml.completed.toString() == "true";
			result.commentsCount = int(xml.child("comments-count").toString());
			result.responsiblePartyType = xml.child("responsible-party-type").toString();
			result.responsiblePartyID = xml.child("responsible-party-id").toString();
			result.completedOn = BasecampUtil.ParseDate(xml.child("completed-on").toString());
			result.completerID = int(xml.child("completer-id").toString());
			return result;
		}
	}
}