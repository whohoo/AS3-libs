/*utf8*/
//**********************************************************************************//
//	name:	WebservicesEvent 1.0
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
	public class WebServicesEvent extends Event {
		
		
		/** those value are "URL.Not.Found", "Call.Error", "Security.Error", "Call.Security.Error", "Call.Http.Status" */
		public var code:String;
		/** detail infomation */
		public var info:String;
		/** call remote method name */
		public var method:String;
		/** url */
		public var url:String;
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		/**
         * define <code>ioerror</code> event, when call remote method error or can't find the webservices url.
		 * <code>code</code> is "URL.Not.Found" or "Call.Error".
         * @eventType callSecurityError
         */
		static public const IO_ERROR:String				=	"ioerror";
		/**
         * define <code>securityError</code> event, when call remote method security error.
		 * <code>code</code> is "Security.Error" or "Call.Security.Error".
         * @eventType securityError
         */
		static public const SECURITY_ERROR:String		=	"securityError";
		
		/**
         * define <code>httpStatus</code> event, when call remote method http status.
		 * <code>code</code> is "Call.Http.Status".
         * @eventType httpStatus
         */
		static public const HTTP_STATUS:String			=	"httpStatus";
		
		/**
         * define <code>complete</code> event, when call remote method complete.
		 * <code>code</code> is "Call.Complete".
         * @eventType complete
         */
		static public const COMPLETE:String 			= "complete";
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new WebservicesEvent();]
		 * @param	type like IO_ERROR, SECURITY_ERROR ...
		 * @param	url the url of your called.
		 * @param	method method name if not null
		 * @param	code value are  Call.Error or Security.Error or URL.Not.Found or Call.Security.Error.
		 * @param	info the detail infomation
		 */
		public function WebServicesEvent(type:String, url:String, code:String, method:String, info:String = "") { 
			super(type, false, false);
			this.url	=	url;
			this.code	=	code;
			this.method	=	method;
			this.info	=	info;
		}
		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * format output data
		 * @return [Event=WebServicesEvent, type, code, info, method, data]
		 */
		override public function toString():String {
			return formatToString("WebServicesEvent:", "type", "code", "info", "url", "method");
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function clone():Event {
			return new WebServicesEvent(type, url, code, method, info);
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
