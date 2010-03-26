package com.basecamphq.api.core{
	import flash.errors.IllegalOperationError;
	
	/**
	 * [static] Valid category types 
	 * @author johncblandii
	 */	
	public class BasecampCategoryType{
	//	CONSTANTS
		public static const ATTACHMENT:String = "attachment";
		public static const POST:String = "post";
	
	//	CONSTRUCTOR
		/**
		 * [static] Do not instantiate.
		 * @throws flash.errors.IllegalOperationError
		 */
		public function BasecampCategoryType(){
			throw new IllegalOperationError("BasecampCategoryType is a static class. Instantiation is unnecessary.");
		}
		
	//	STATIC METHODS
		/**
		 * Validates the type as a valid category type
		 * @param type
		 * @return
		 */
		public static function validate(type:String):Boolean{
			return type == ATTACHMENT || type == POST;
		}
	}
}