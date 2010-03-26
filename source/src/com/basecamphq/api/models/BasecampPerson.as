package com.basecamphq.api.models{
	import com.adobe.utils.DateUtil;
	
	/**
	 * A registered user in Basecamp 
	 * @author johncblandii
	 * 
	 */	
	public class BasecampPerson{
	//	PROPERTIES
		public var id:int;
		public var clientID:int;
		public var uuid:String;
		public var isAdministrator:Boolean;
		public var isDeleted:Boolean;
		public var hasAccessToNewProjects:Boolean;
		public var name:String;
		public var emailAddress:String;
		public var firstName:String;
		public var lastName:String;
		public var title:String;
		public var userName:String;
		public var identityURL:String;
		public var imHandle:String;
		public var imService:String;
		public var phoneNumberFax:String;
		public var phoneNumberHome:String;
		public var phoneNumberMobile:String;
		public var phoneNumberOffice:String;
		public var phoneNumberOfficeExt:String;
		
	//	PUBLIC METHODS
		/**
		 * Returns a string representation of the object
		 * @return 
		 */		
		public function toString():String{
			return "[Person(id="+id+", first="+firstName+", last="+lastName+")]";
		}
		
	//	STATIC METHODS
		/**
		 * Builds a BasecampPerson object based on the expected format from the API.
		 * Expected Format:
		 * <person>
		    <administrator type="boolean"/>
		    <client-id type="integer"/>
		    <deleted type="boolean"/>
		    <email-address/>
		    <first-name/>
		    <has-access-to-new-projects type="boolean"/>
		    <id type="integer"/>
		    <identity-url/>
		    <im-handle/>
		    <im-service/>
		    <last-name/>
		    <phone-number-fax/>
		    <phone-number-home/>
		    <phone-number-mobile/>
		    <phone-number-office/>
		    <phone-number-office-ext/>
		    <title/>
		    <user-name/>
		    <uuid>/>
		  </person>
		 * @param xml
		 * @return
		 */		
		public static function buildFromXML(xml:XML):BasecampPerson{
			var person:BasecampPerson = new BasecampPerson();
			person.id = xml.id.toString();
			person.uuid = xml.uuid.toString();
			person.clientID = xml.child("client-id").toString();
			person.isAdministrator = xml.administrator.toString() == "true";
			person.isDeleted = xml.deleted.toString() == "true";
			person.hasAccessToNewProjects = xml.child("has-access-to-new-projects").toString() == "true";
			person.name = xml.child("name").toString(); //using child("name") to avoid conflicts with name() method
			person.emailAddress = xml.child("email-address").toString();
			person.firstName = xml.child("first-name").toString();
			person.lastName = xml.child("last-name").toString();
			person.title = xml.title.toString();
			person.userName = xml.child("user-name").toString();
			person.identityURL = xml.child("identity-url").toString();
			person.imHandle = xml.child("im-handle").toString();
			person.imService = xml.child("im-service").toString();
			person.phoneNumberFax = xml.child("phone-number-fax").toString();
			person.phoneNumberHome = xml.child("phone-number-home").toString();
			person.phoneNumberMobile = xml.child("phone-number-mobile").toString();
			person.phoneNumberOffice = xml.child("phone-number-office").toString();
			person.phoneNumberOfficeExt = xml.child("phone-number-office-ext").toString();
			return person;
		}
	}
}