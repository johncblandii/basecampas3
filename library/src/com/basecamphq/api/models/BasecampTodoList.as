package com.basecamphq.api.models{
	/**
	 * To-do List
	 * @author johncblandii
	 */	
	public class BasecampTodoList{
	//	PROPERTIES
		public var id:int;
		public var name:String;
		public var description:String;
		public var projectID:int;
		public var milestoneID:int;
		public var templateID:int;
		public var position:int;
		/**
		 * if user can see private lists
		 */		
		public var isPrivate:Boolean = false;
		/**
		 * if the account supports time tracking 
		 */		
		public var isTracked:Boolean = false;
		/**
		 * if todo-items are included in the response 
		 */
		[ArrayElementType("com.basecamphq.api.models.BasecampTodoItem")]
		public var todoItems:Array;
		
	//	STATIC METHODS
		/**
		 * Builds a TodoList object from expected format
		 * Expected Format:
		 * <todo-list>
			  <id type="integer">#{id}</id>
			  <name>#{name}</name>
			  <description>#{description}</description>
			  <project-id type="integer">#{project_id}</project-id>
			  <milestone-id type="integer">#{milestone_id}</milestone-id>
			  <position type="integer">#{position}</position>
			  <private type="boolean">#{private}</private>
			  <tracked type="boolean">#{tracked}</tracked>
			  <todo-items type="array">
			    <todo-item>
			      ...
			    </todo-item>
			    ...
			  </todo-items>
			</todo-list>
		 * @return 
		 */		
		public static function buildFromXML(xml:XML):BasecampTodoList{
			var result:BasecampTodoList = new BasecampTodoList();
			result.id = int(xml.id.toString());
			result.name = xml.name.toString();
			result.description = xml.description.toString();
			result.projectID = int(xml.child("project-id").toString());
			result.milestoneID = int(xml.child("milestone-id").toString());
			result.position = int(xml.position.toString());
			result.isPrivate = xml.private.toString() == "true";
			result.isTracked = xml.tracked.toString() == "true";
			result.todoItems = new Array();
			for each(var item:XML in xml.child("todo-items")){
				result.todoItems.push(BasecampTodoItem.buildFromXML(item));
			}
			return result;
		}
	}
}