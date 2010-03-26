package com.basecamphq.api.net{
	import com.basecamphq.api.events.BasecampErrorEvent;
	import com.basecamphq.api.models.BasecampError;
	import com.basecamphq.api.core.BasecampSession;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import mx.utils.Base64Encoder;
		
	/**
	 * Basecamp core call api
	 * @author johncblandii
	 */
	public class BasecampCall extends EventDispatcher{
	//	STATIC CONSTANTS/VARIABLES
		public static var DEFAULT_USER_AGENT:String;
		
	//	PROPERTIES
		/**
		 * Authenticated Basecamp session. 
		 */		
		protected var _session:BasecampSession;
		
	//	CONSTRUCTOR
		public function BasecampCall(session:BasecampSession){
			super();
			_session = session;
		}
		
	//	PRIVATE METHODS
		protected function getLoader(result:Function=null):URLLoader{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			if(result != null) loader.addEventListener(Event.COMPLETE, result);
			return loader;
		}
		
		/**
		 * 
		 * @param method A valid URLRequestMethod
		 * @param url End part of the url (not the full basecamp url)
		 * @return
		 */
		protected function getRequest(method:String, url:String):URLRequest{
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encode(_session.username+":"+_session.password);
			var credentials:String = encoder.drain();
			
			var request:URLRequest = new URLRequest(_session.basecampURL + url);
			request.method = method;
			request.contentType = "application/xml";
			request.authenticate = true;
			if(DEFAULT_USER_AGENT) request.userAgent = DEFAULT_USER_AGENT;
			request.followRedirects = false;
			request.requestHeaders = [new URLRequestHeader("Authorization", "Basic " + credentials),
									  new URLRequestHeader("Accept", "application/xml")];
			return request;
		}
		
	//	EVENT LISTENERS
		
		/**
		 * Handles IOErrorEvent.IO_ERROR events 
		 * @param event
		 */		
		protected function onIOError(event:IOErrorEvent):void{
			var ev:BasecampErrorEvent = new BasecampErrorEvent(BasecampErrorEvent.API_ERROR);
			ev.error = new BasecampError();
			ev.error.currentTarget = event.currentTarget;
			ev.error.target = event.target;
			ev.error.errorID = event.errorID;
			ev.error.text = event.text;
			ev.error.eventClass = IOErrorEvent;
			dispatchEvent(ev);
		}
		
		/**
		 * Handles SecurityErrorEvent.SECURITY_ERROR events 
		 * @param event
		 * 
		 */		
		protected function onSecurityError(event:SecurityErrorEvent):void{
			var ev:BasecampErrorEvent = new BasecampErrorEvent(BasecampErrorEvent.API_ERROR);
			ev.error = new BasecampError();
			ev.error.currentTarget = event.currentTarget;
			ev.error.target = event.target;
			ev.error.errorID = event.errorID;
			ev.error.text = event.text;
			ev.error.eventClass = SecurityErrorEvent;
			dispatchEvent(ev);
		}
	}
}