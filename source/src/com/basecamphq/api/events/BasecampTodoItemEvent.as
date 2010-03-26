package com.basecamphq.api.events{
	import com.basecamphq.api.models.BasecampTodoItem;
	

	/**
	 * To-do Item event
	 * @author johncblandii
	 */	
	public class BasecampTodoItemEvent extends com.basecamphq.api.events.BasecampAbstractEvent{
	//	CONSTANTS
		public static const GET_TODO_ITEMS_RESULT:String = "getTodoItemsResult";
		public static const GET_TODO_ITEM_RESULT:String = "getTodoItemResult";
		public static const COMPLETE_TODO_ITEM_COMPLETE:String = "completeTodoItemComplete";
		public static const UNCOMPLETE_TODO_ITEM_COMPLETE:String = "uncompleteTodoItemComplete";
		public static const CREATE_TODO_ITEM_COMPLETE:String = "createTodoItemComplete";
		public static const UPDATE_TODO_ITEM_COMPLETE:String = "updateTodoItemComplete";
		public static const DESTROY_TODO_ITEM_COMPLETE:String = "destroyTodoItemComplete";
		public static const REORDER_TODO_ITEM_COMPLETE:String = "reorderTodoItemComplete";
		public static const TODO_ITEM_CALL_FAILED:String = "todoItemCallFailed";
		
	//	PROPERTIES
		/**
		 * TodoItems received 
		 */		
		[ArrayElementType(name="com.basecamphq.api.models.BasecampTodoItem")]
		public var todoItems:Array;
		
		/**
		 * TodoItem received
		 */		
		public var todoItem:BasecampTodoItem;
		
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 */
		public function BasecampTodoItemEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}