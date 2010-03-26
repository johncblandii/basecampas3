package com.basecamphq.api.events{
	import com.basecamphq.api.models.BasecampTodoList;

	/**
	 * To-do List event
	 * @author johncblandii
	 */	
	public class BasecampTodoListEvent extends com.basecamphq.api.events.BasecampAbstractEvent{
	//	CONSTANTS
		public static const GET_TODO_LISTS_RESULT:String = "getTodoListsResult";
		public static const GET_TODO_LIST_RESULT:String = "getTodoListResult";
		public static const CREATE_TODO_LIST_COMPLETE:String = "createTodoListComplete";
		public static const UPDATE_TODO_LIST_COMPLETE:String = "updateTodoListComplete";
		public static const DESTROY_TODO_LIST_COMPLETE:String = "destroyTodoListComplete";
		public static const REORDER_TODO_LIST_COMPLETE:String = "reorderTodoListComplete";
		public static const TODO_LIST_CALL_FAILED:String = "todoListCallFailed";
		
	//	PROPERTIES
		/**
		 * TodoLists received 
		 */		
		[ArrayElementType(name="com.basecamphq.api.models.BasecampTodoList")]
		public var todoLists:Array;
		
		/**
		 * TodoList received
		 */		
		public var todoList:BasecampTodoList;
		
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */
		public function BasecampTodoListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}