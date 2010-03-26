package com.basecamphq.api.core{
	import flash.errors.IllegalOperationError;
	
	/**
	 * [static] Valid comment types 
	 * @author johncblandii
	 */	
	public class BasecampCommentType{
	//	CONSTANTS
		public static const MILESTONE:String = "milestone";
		public static const POST:String = "post";
		public static const TODO:String = "todo"
		
	//	CONSTRUCTOR
		/**
		 * Constructor. Do not instantiate. 
		 */
		public function BasecampCommentType(){
			throw new IllegalOperationError("BasecampCategoryType is a static class. Instantiation is unnecessary.");
		}
		
	//	STATIC METHODS
		/**
		 * Validates the type as a valid comment type
		 * @param type
		 * @return
		 */		
		public static function validate(type:String):Boolean{
			return type == MILESTONE || type == POST || type == TODO;
		}
	}
}