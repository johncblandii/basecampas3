package com.basecamphq.api.models{
	import com.adobe.utils.DateUtil;
	import com.basecamphq.api.utils.BasecampUtil;

	/**
	 * A Basecamp project 
	 * @author johncblandii
	 */	
	public class BasecampProject{
	//	PROPERTIES
		public var id:int;
		public var createdOn:Date;
		public var lastChangedOn:Date;
		public var name:String;
		public var announcement:String;
		public var showWriteboards:Boolean;
		public var showAnnouncement:Boolean;
		/**
		 * Expected values are available tabs from basecamp 
		 */		
		public var startPage:String;
		public var status:String;
		/**
		 * Associated company 
		 */		
		public var company:BasecampCompany;
		
	//	PUBLIC METHODS
		/**
		 * Returns a string representation of the object 
		 * @return 
		 */
		public function toString():String{
			return "[Project(id=\"" + id + "\" name=\"" + name + "\")";
		}
		
	//	STATIC METHODS
		/**
		 * Builds a BasecampProject object based on the expected format from the API.
		 * Expected xml:
		 * <project>
				<announcement/>
				<created-on type="date"/>
				<id type="integer"/>
				<last-changed-on type="datetime"/>
				<name/>
				<show-announcement type="boolean"/>
				<show-writeboards type="boolean"/>
				<start-page/>
				<status/>
				<company>
					<id type="integer"/>
					<name/>
				</company>
			</project>
		 * @param xml
		 * @return 
		 * 
		 */		
		public static function buildFromXML(xml:XML):BasecampProject{
			var project:BasecampProject = new BasecampProject();
			project.id = xml.id.toString();
			project.createdOn = BasecampUtil.ParseDate(xml.child("created-on").toString());
			project.lastChangedOn = BasecampUtil.ParseDate(xml.child("last-changed-on").toString());
			project.name = xml.child("name").toString(); //using child("name") to avoid conflicts with name() method
			project.announcement = xml.announcement.toString();
			project.showWriteboards = xml.child("show-writeboards").toString() == true;
			project.showAnnouncement = xml.child("show-announcement").toString() == true;
			project.status = xml.status.toString();
			project.startPage = xml.child("start-page").toString();
			project.company = BasecampCompany.buildFromXML(xml.company[0]);
			return project;
		}
	}
}