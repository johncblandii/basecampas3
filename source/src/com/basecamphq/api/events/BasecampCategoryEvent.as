package com.basecamphq.api.events{
	import com.basecamphq.api.models.BasecampCategory;

	public class BasecampCategoryEvent extends com.basecamphq.api.events.BasecampAbstractEvent{
	//	CONSTANTS
		public static const GET_CATEGORY_RESULT:String = "getCategoryResult";
		public static const GET_CATEGORIES_RESULT:String = "getCategoriesResult";
		public static const DESTROY_COMPLETE:String = "destroyComplete";
		public static const UPDATE_CATEGORY_COMPLETE:String = "updateCategoryComplete";
		public static const CREATE_CATEGORY_COMPLETE:String = "createCategoryComplete";
		public static const CATEGORY_CALL_FAILED:String = "categoryCallFailed";
		
	//	PROPERTIES
		/**
		 * Categories received 
		 */		
		[ArrayElementType(name="com.basecamphq.api.models.BasecampCategory")]
		public var categories:Array;
		/**
		 * Category received 
		 */		
		public var category:BasecampCategory;
		
	//	CONSTRUCTORS
		public function BasecampCategoryEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}