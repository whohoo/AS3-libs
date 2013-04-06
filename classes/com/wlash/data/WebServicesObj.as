/*utf8*/
//**********************************************************************************//
//	name:	WebServicesObj 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Apr 07 2009 17:43:14 GMT+0800
//	description: This file was created by "webservices_Sample.fla" file.
//			v1.1 add property url. and http status events.
//**********************************************************************************//



package com.wlash.data {

	import flash.events.Event;
	
	
	/**
	 * WebservicesEvent.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class WebServicesObj extends Object {
		
		/** those value are "URL.Not.Found", "Call.Error", "Security.Error", "Call.Security.Error", "Call.Http.Status" */
		public var code:String;
		/** detail infomation */
		public var info:String;
		/** call remote method name */
		public var method:String;
		/** url */
		public var url:String;
		/** http status code */
		public var httpStatus:int;
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new WebServicesObj();]
		 * @param	url the url of your called.
		 * @param	code value are  Call.Error or Security.Error or URL.Not.Found or Call.Security.Error.
		 * @param	method method name if not null
		 * @param	info the detail infomation
		 * @param	httpStatus http status code
		 */
		public function WebServicesObj( url:String, code:String, method:String, httpStatus:int=0, info:String = "") { 
			this.url		=	url;
			this.code		=	code;
			this.method		=	method;
			this.httpStatus	=	httpStatus;
			this.info		=	info;
		}
		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * format output data
		 * @return [Event=WebServicesEvent, type, code, info, method, data]
		 */
		public function toString():String {
			return "WebServicesObj 1.0 " + "[code: " + code + ", info: " + info +", url: " + url + 
					", method: " + method + ", httpStatus: " + httpStatus + "]";
		}
		
	
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		
		
		
		

		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class
//This template is created by whohoo. ver 1.2.1

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]



*/
