package com.basecamphq.api.models{
	public class BasecampCategory{
	//	PROPERTIES
		public var id:int;
		public var projectID:int;
		public var name:String;
		public var elementsCount:int;
		public var type:String;
		
	//	PUBLIC METHODS
		public function toString():String{
			return "[Category(id="+id+", name="+name+", elements="+elementsCount+", type="+type+")]";
		}
		
		/**
		 * Converts the current properties to xml 
		 * @return 
		 */		
		public function toXML():XML{
			var result:XML = <category>
							  <name/>
							  <type/>
							</category>;
			result.type = type;
			result.name = name;
			return result;
		}
		
	//	STATIC METHODS
		/**
		 * Builds a BasecampCategory object based on the expected format from the API.
		 * Expected format:
		 * <category>
			  <id type="integer">#{id}</id>
			  <name>#{name}</name>
			  <project-id type="integer">#{project_id}</project-id>
			  <elements-count type="integer">#{elements_count}</elements-count>
			  <type>#{type}</type>
			</category>
		 * @param xml
		 * @return
		 */		
		public static function buildFromXML(xml:XML):BasecampCategory{
			var result:BasecampCategory = new BasecampCategory();
			result.id = int(xml.id.toString());
			result.projectID = int(xml.child("project-id").toString());
			result.name = xml.child("name").toString(); //using child("name") to avoid conflicts with name() method
			result.elementsCount = int(xml.child("elements-count").toString());
			result.type = xml.type.toString();
			return result;
		}
	}
}