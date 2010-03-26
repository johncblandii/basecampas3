package com.basecamphq.api.models{
	/**
	 * A company created in Basecamp 
	 * @author johncblandii
	 */	
	public class BasecampCompany{
	//	PROPERTIES
		public var id:int;
		public var name:String;
		public var address1:String;
		public var address2:String;
		public var city:String;
		public var state:String;
		public var zipcode:String;
		public var country:String;
		public var phoneFax:String;
		public var phoneOffice:String;
		public var timezoneID:String;
		public var urlName:String;
		public var uuid:String;
		public var webAddress:String;
		
	//	PUBLIC METHODS
		/**
		 * Returns a string representation of the object 
		 * @return 
		 */
		public function toString():String{
			return "[Company(id="+id+", name="+name+")]";
		}
	
	//	STATIC METHODS
		/**
		 * Builds a BasecampCompany object based on the expected format from the API.
		 * Expected format:
		 *   <company>
			    <address-one/>
			    <address-two/>
			    <city/>
			    <country/>
			    <id type="integer"/>
			    <name/>
			    <phone-number-fax/>
			    <phone-number-office/>
			    <state/>
			    <time-zone-id/>
			    <url-name/>
			    <uuid/>
			    <web-address/>
			    <zip/>
			  </company> 
		 * @param xml
		 * @return 
		 */		
		public static function buildFromXML(xml:XML):BasecampCompany{
			var company:BasecampCompany = new BasecampCompany();
			company.id = int(xml.id.toString());
			company.name = xml.child("name").toString(); //using child("name") to avoid conflicts with name() method
			company.address1 = xml.child("address-one").toString();
			company.address2 = xml.child("address-two").toString();
			company.city = xml.city.toString();
			company.state = xml.state.toString();
			company.zipcode = xml.zipcode.toString();
			company.country = xml.country.toString();
			company.phoneFax = xml.child("phone-number-fax").toString();
			company.phoneOffice = xml.child("phone-number-office").toString();
			company.timezoneID = xml.child("time-zone-id").toString();
			company.urlName = xml.child("url-name").toString();
			company.uuid = xml.uuid.toString();
			company.webAddress = xml.child("web-address").toString();
			company.zipcode = xml.zip.toString();
			return company;
		}
	}
}