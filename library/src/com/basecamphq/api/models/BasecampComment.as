package com.basecamphq.api.models{
	import com.basecamphq.api.utils.BasecampUtil;
	
	/**
	 * Basecamp comment object 
	 * @author johncblandii
	 */	
	public class BasecampComment{
	//	PROPERTIES
		public var id:int;
		public var authorID:int;
		public var commentableID:int;
		public var commentableType:String;
		public var body:String;
		public var emailedFrom:String;
		public var attachmentsCount:int;
		public var createdAt:Date;
		
	//	PUBLIC METHODS
		/**
		 * Returns a string representation of the object 
		 * @return 
		 */
		public function toString():String{
			return "[Comment(id="+id+", authorID="+authorID+")]";
		}
		
		/**
		 * Converts comment object to the expected xml format 
		 * @return
		 */		
		public function toXML():XML{
			var result:XML = <comment>
							  <body/>
							</comment>;
			result.body = body;
			return result;
		}
		
	//	STATIC METHODS
		/**
		 * Builds a Comment object from xml
		 * Expected format:
		 * <comment>
			  <id type="integer">#{id}</id>
			  <author-id type="integer">#{author_id}</author-id>
			  <commentable-id type="integer">#{commentable_id}</commentable-id>
			  <commentable-type>#{commentable_type}</commentable-type>
			  <body>#{body}</body>
			  <emailed-from nil="true">#{emailed_from}</emailed-from>
			  <attachments-count type="integer">#{attachments_count}</attachments-count>
			  <created-at type="datetime">#{created_at}</created-at>
			</comment> 
		 * @param xml
		 * @return 
		 * 
		 */		
		public static function buildFromXML(xml:XML):BasecampComment{
			var result:BasecampComment = new BasecampComment;
			result.id = int(xml.id.toString());
			result.authorID = int(xml.child("author-id").toString());
			result.commentableID = int(xml.child("commentable-id").toString());
			result.commentableType = xml.child("commentable-type").toString();
			result.body = xml.body.toString();
			result.emailedFrom = xml.child("emailed-from").toString();
			result.attachmentsCount = int(xml.child("attachments-count").toString());
			result.createdAt = BasecampUtil.ParseDate(xml.child("created-at"));
			return result;
		}
	}
}