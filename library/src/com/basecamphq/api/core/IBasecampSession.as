package com.basecamphq.api.core{
	public interface IBasecampSession{
		function get password():String;
		function set password(value:String):void;
		
		function get username():String;
		function set username(value:String):void;
		
		function authenticate():void;
	}
}