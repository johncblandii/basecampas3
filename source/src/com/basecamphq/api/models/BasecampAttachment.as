package com.basecamphq.api.models{
	public class BasecampAttachment{
		public var name:String;
		public var fileID:int;
		public var contentType:String;
		public var originalFilename:String;
		
		/**
		 * Builds a BasecampCategory object based on the expected format from the API.
		 * Expected format:
		 * 	<attachments>
				<name>#{name}</name> <!-- optional -->
				<file>
				  <file>#{temp_id}</file> <!-- the id of the previously uploaded file -->
				  <content-type>#{content_type}</content-type>
				  <original-filename>#{original_filename}</original-filename>
				</file>
			</attachments> 
		 * @param xml
		 * @return 
		 * 
		 */		
		public static function buildFromXML(xml:XML):BasecampAttachment{
			var result:BasecampAttachment = new BasecampAttachment();
			result.name = xml.child("name").toString();
			result.fileID = int(xml.file.file.toString());
			result.contentType = xml.file.child("content-type").toString();
			result.originalFilename = xml.file.child("original-filename").toString();
			return result;
		}
	}
}