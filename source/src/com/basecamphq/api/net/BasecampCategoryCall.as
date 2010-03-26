package com.basecamphq.api.net{
	import com.basecamphq.api.core.BasecampCategoryType;
	import com.basecamphq.api.events.BasecampCategoryEvent;
	import com.basecamphq.api.events.BasecampEvent;
	import com.basecamphq.api.models.BasecampCategory;
	import com.basecamphq.api.core.BasecampSession;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	[Event(name="getCategoryResult", type="com.basecamphq.api.events.BasecampCategoryEvent")]
	[Event(name="getCategoriesComplete", type="com.basecamphq.api.events.BasecampCategoryEvent")]
	[Event(name="destroyComplete", type="com.basecamphq.api.events.BasecampCategoryEvent")]
	[Event(name="updateCategoryComplete", type="com.basecamphq.api.events.BasecampCategoryEvent")]
	[Event(name="createCategoryComplete", type="com.basecamphq.api.events.BasecampCategoryEvent")]
	[Event(name="categoryCallFailed", type="com.basecamphq.api.events.BasecampCategoryEvent")]
	
	/**
	 * Calls specific to category requests.
	 * Note: Use once and throw away.
	 * @author johncblandii
	 */	
	public class BasecampCategoryCall extends BasecampCall{
	//	CONSTANTS
		protected static const GET_CATEGORIES_URL:String = "/projects/#{project_id}/categories.xml";
		protected static const GET_CATEGORY:String = "/categories/#{category_id}.xml";
		protected static const DESTROY_CATEGORY:String = "/categories/#{category_id}.xml";
		protected static const UPDATE_CATEGORY:String = "/categories/#{category_id}.xml";
		protected static const CREATE_CATEGORY:String = "/projects/#{project_id}/categories.xml";
		
	//	CONSTRUCTOR
		/**
		 * Constructor 
		 * @param session
		 */		
		public function BasecampCategoryCall(session:BasecampSession){
			super(session);
		}
		
	//	PUBLIC METHODS
		/**
		 * Returns all categories for the given project. To filter by type, pass the type parameter, where type can be one of 'post' or 'attachment'. 
		 * GET /projects/#{project_id}/categories.xml(?type=[post|attachment])  
		 * @see com.basecamphq.api.core.BasecampCategoryType
		 */		
		public function getCategories(projectID:Number, type:String=""):void{
			var url:String = GET_CATEGORIES_URL.replace("#{project_id}", projectID);
			if(type && type.length > 0 && BasecampCategoryType.validate(type)) url += "?type=" + type;
			getLoader(onCategoriesResult).load(getRequest(URLRequestMethod.GET, url));
		}
		
		/**
		 * Returns a single category identified by its integer ID.  
		 * GET /categories/#{id}.xml  
		 * @param categoryID
		 * 
		 */		
		public function getCategory(categoryID:int):void{
			getLoader(onCategoryResult).load(getRequest(URLRequestMethod.GET, GET_CATEGORY.replace("#{category_id}", categoryID)));
		}
		
		/**
		 * Deletes the category identified by its integer ID. Note that only categories without elements can be deleted.  
		 * @param categoryID
		 */		
		public function destroyCategory(categoryID:int):void{ 
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onDestroyHTTPStatus);
			loader.load(getRequest(URLRequestMethod.DELETE, DESTROY_CATEGORY.replace("#{category_id}", categoryID)));
		}
		
		/**
		 * Updates an existing category identified by its integer ID.
		 * @param category
		 */		
		public function updateCategory(category:BasecampCategory):void{
			if(category.id < 1) throw new ArgumentError("Category ID is required in the category object.");
			if(!category.name || category.name.length == 0) throw new ArgumentError("Category name is required in the category object.");
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onUpdateHTTPStatus);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = category.toXML();
			
			var request:URLRequest = getRequest(URLRequestMethod.PUT, UPDATE_CATEGORY.replace("#{category_id}", category.id));
			request.data = category.toXML();
			
			loader.load(request);
		}
		
		/**
		 * Creates a new category of the given type for the given project. The type attribute is required and must be one of 'post' or 'attachment'.
		 * <p>Note: Creating duplicate categories (where name is the same) fails silently, or so it seems.</p>
		 * @param category
		 */		
		public function createCategory(category:BasecampCategory):void{
			if(category.projectID < 1) throw new ArgumentError("Project ID is required in the category object.");
			
			var loader:URLLoader = getLoader();
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onCreateHTTPStatus);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.data = category.toXML();
			
			var request:URLRequest = getRequest(URLRequestMethod.POST, CREATE_CATEGORY.replace("#{project_id}", category.projectID));
			request.data = category.toXML();
			
			loader.load(request);
		}
		
	//	EVENT LISTENERS
		/**
		 * Handles category list result 
		 * @param event
		 * @private
		 */		
		private function onCategoriesResult(event:Event):void{
			var data:XML = XML(URLLoader(event.target).data);
			
			var ev:BasecampCategoryEvent = new BasecampCategoryEvent(BasecampCategoryEvent.GET_CATEGORIES_RESULT, true);
			ev.categories = new Array();
			for each(var item:XML in data.category){
				ev.categories.push(BasecampCategory.buildFromXML(item));
			}
			
			dispatchEvent(ev);
		}
		
		/**
		 * Handles single category result 
		 * @param event
		 * @private
		 */		
		private function onCategoryResult(event:Event):void{
			var ev:BasecampCategoryEvent = new BasecampCategoryEvent(BasecampCategoryEvent.GET_CATEGORY_RESULT, true);
			ev.category = BasecampCategory.buildFromXML(XML(URLLoader(event.target).data));
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for create requests
		 * @param event
		 */		
		private function onCreateHTTPStatus(event:HTTPStatusEvent):void{
			var ev:BasecampCategoryEvent;
			switch(event.status){
				case 201:
					ev = new BasecampCategoryEvent(BasecampCategoryEvent.CREATE_CATEGORY_COMPLETE, true);
				break;
				default:
					ev = new BasecampCategoryEvent(BasecampCategoryEvent.CATEGORY_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for update requests 
		 * @param event
		 */		
		private function onUpdateHTTPStatus(event:HTTPStatusEvent):void{
			var ev:BasecampCategoryEvent;
			switch(event.status){
				case 200:
					ev = new BasecampCategoryEvent(BasecampCategoryEvent.UPDATE_CATEGORY_COMPLETE, true);
				break;
				default:
					ev = new BasecampCategoryEvent(BasecampCategoryEvent.CATEGORY_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			dispatchEvent(ev);
		}
		
		/**
		 * Handles the http status event for destroy requests 
		 * @param event
		 */		
		private function onDestroyHTTPStatus(event:HTTPStatusEvent):void{
			var ev:BasecampCategoryEvent;
			switch(event.status){
				case 200:
					ev = new BasecampCategoryEvent(BasecampCategoryEvent.DESTROY_COMPLETE, true);
				break;
				default:
					ev = new BasecampCategoryEvent(BasecampCategoryEvent.CATEGORY_CALL_FAILED, true);
				break;
			}
			ev.responseHeaders = event.responseHeaders;
			ev.statusCode = event.status;
			
			dispatchEvent(ev);
		}
	}
}