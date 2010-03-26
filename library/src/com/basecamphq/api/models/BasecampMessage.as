package com.basecamphq.api.models{
	import com.basecamphq.api.utils.BasecampUtil;

	public class BasecampMessage{
	//	PROPERTIES
		public var id:int;
		public var categoryID:int;
		public var projectID:int;
		public var authorID:int;
		public var milestoneID:int;
		public var postedOn:Date;
		public var title:String;
		public var body:String;
		public var extendedBody:String;
		public var displayBody:String;
		public var displayExtendedBody:String;
		public var categoryName:String;
		public var authorName:String;
		public var readByPerson:String;
		public var readByPersonID:int;
		public var commentsCount:int;
		public var attachmentsCount:int;
		public var useTextile:Boolean;
		public var isPrivate:Boolean = false;
		public var fromClient:Boolean = false;
		[ArrayElementType(name="int")]
		public var notifications:Array;
		[ArrayElementType(name="com.basecamphq.api.models.BasecampAttachment")]
		public var attachments:Array;
	
	//	PUBLIC METHODS
		/**
		 * Converts the BasecampMessage to the expected XML format
		 * Expected Result:
		 * 	<post>
			  <id type="integer">#{id}</id>
			  <title>#{title}</title>
			  <body>#{body}</body>
			  <posted-on type="datetime">#{posted_on}</posted-on>
			  <project-id type="integer">#{project_id}</project-id>
			  <category-id type="integer">#{category_id}</category-id>
			  <author-id type="integer">#{author_id}</author-id>
			  <milestone-id type="integer">#{milestone_id}</milestone-id>
			  <comments-count type="integer">#{comments_count}</comments-count>
			  <attachments-count type="integer">#{attachments_count}</attachments-count>
			  <use-textile type="boolean">#{use_textile}</use-textile>
			  <extended-body>#{extended_body}</extended-body>
			  <display-body>#{display_body}</display-body>
			  <display-extended-body>#{display_extended_body}</display-extended-body>
			
			  <!-- if user can see private posts -->
			  <private type="boolean">#{private}</private>
			</post>
		 * @return
		 */		
		public function toXML():XML{
			var result:XML = <post>
								<attachments-count type="integer"/>
								<author-id type="integer"/>
								<author-name/>
								<body/>
								<category-id type="integer" nil="true"/>
								<category-name nil="true"/>
								<comments-count type="integer"/>
								<display-body/>
								<display-extended-body nil="true"/>
								<extended-body/>
								<from-client/>
								<id type="integer"/>
								<milestone-id type="integer"/>
								<posted-on type="datetime"/>
								<private type="boolean"/>
								<project-id type="integer"/>
								<read-by-person/>
								<read-by-person-id/>
								<title/>
								<use-textile type="boolean"/>
							</post>;
			//TODO set vars
			return result;
		}
		
	//	STATIC METHODS
		/**
		 * 
		 * Expected format:
		 * 	<post>
				<attachments-count type="integer"/>
				<author-id type="integer"/>
				<author-name/>
				<body/>
				<category-id type="integer" nil="true"/>
				<category-name nil="true"/>
				<comments-count type="integer"/>
				<display-body/>
				<display-extended-body nil="true"/>
				<extended-body/>
				<from-client/>
				<id type="integer"/>
				<milestone-id type="integer"/>
				<posted-on type="datetime"/>
				<private type="boolean"/>
				<project-id type="integer"/>
				<read-by-person/> <!-- not returned on all calls -->
				<read-by-person-id/> <!-- not returned on all calls -->
				<title/>
				<use-textile type="boolean"/>
			</post>
	 	 * @param xml
	 	 * @return
		 */
		
		public static function buildFromXML(xml:XML):BasecampMessage{
			var result:BasecampMessage = new BasecampMessage();
			result.id = int(xml.id.toString());
			result.authorID = int(xml.child("author-id").toString());
			result.authorName = xml.child("author-name").toString();
			result.body = xml.body.toString();
			result.categoryID = int(xml.child("category-id").toString());
			result.categoryName = xml.child("category-name").toString();
			result.commentsCount = int(xml.child("comments-count").toString());
			result.displayBody = xml.child("display-body").toString();
			result.displayExtendedBody = xml.child("display-extended-body").toString();
			result.extendedBody = xml.child("extended-body").toString();
			result.fromClient = xml.child("from-client").toString() == "1";
			result.milestoneID = int(xml.child("milestone-id").toString());
			result.postedOn = BasecampUtil.ParseDate(xml.child("posted-on").toString());
			result.isPrivate = xml.private.toString() == true;
			result.projectID = int(xml.child("project-id").toString());
			result.readByPerson = xml.child("read-by-person").toString();
			result.readByPersonID = int(xml.child("read-by-person-id").toString());
			result.useTextile = xml.child("use-textile").toString() == "true";
			result
			return result;
		}
	}
}