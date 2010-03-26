package com.basecamphq.api.core{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * Stores user credentials for a Basecamp session. For openid user must login to retrieve a special username/password.
	 * @author johncblandii
	 * 
	 */	
	public class BasecampSession extends EventDispatcher implements IEventDispatcher, IBasecampSession{
		/**
		 * Users username 
		 */		
		protected var _username:String;
		public function get username():String{ return _username; }
		public function set username(value:String):void{ _username = value; }
		
		/**
		 * Users password 
		 */		
		protected var _password:String;
		public function get password():String{ return _password; }
		public function set password(value:String):void{ _password = value; }
		
		/**
		 * URL to basecamp project 
		 */		
		protected var _basecampURL:String;
		public function get basecampURL():String{ return _basecampURL; }
		public function set basecampURL(value:String):void{ _basecampURL = value; }
		
		/**
		 * Application state 
		 */		
		protected var _state:String = BasecampSessionState.DISCONNECTED;
		public function get state():String{ return _state; }
		
		/**
		 * Constructor 
		 * @param username Users username
		 * @param password Users password
		 */		
		public function BasecampSession(basecampURL:String="", username:String="", password:String=""){
			super();
			
			_basecampURL = basecampURL;
			_username = username;
			_password = password;
		}
		
		/**
		 * Authenticates the user in the Basecamp
		 */		
		public function authenticate():void{
			//send request
		}
	}
}