package com.basecamphq.api.utils{
	public class BasecampUtil{
		public function BasecampUtil(){
			//TODO throw a better error
			throw new Error("Static class. Don't instantitate");
		}
		
		public static function ParseDate(date:String):Date{
			var split:Array = date.split("-");
            return new Date(split[0], split[1]-1, split[2]);
		}
	}
}