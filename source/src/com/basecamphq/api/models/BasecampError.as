package com.basecamphq.api.models{
	import mx.messaging.AbstractConsumer;
	
	public class BasecampError{
	//	PROPERTIES
		public var errorID:int;
		public var text:String;
		public var target:Object;
		public var currentTarget:Object;
		public var eventClass:Class;
	}
}