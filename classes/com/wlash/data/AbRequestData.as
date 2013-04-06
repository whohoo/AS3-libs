/*utf8*/
//**********************************************************************************//
//	name:	AbRequestData 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	2010/11/26 10:09
//	description: 
//				
//**********************************************************************************//


//[com.wlash.data.AbRequestData]
package com.wlash.data {

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;



	/**
	 * RequestData.
	 * <p>annotate here for this class.</p>
	 *
	 */
	public class AbRequestData extends Object {
		public var path:String				=	"";

		protected var _fnRefDict:Dictionary;
		protected var _domain:String		=	"http://www.sample.com/";
		protected var _isTest:Boolean		=	true;
		//*************************[READ|WRITE]*************************************//


		//*************************[READ ONLY]**************************************//
		/**check is live*/
		public function get isLive():Boolean { return Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn";}
		
		/**get domain relative or absolute path*/
		public function get domain():String { //import flash.system.Capabilities;
			if(isLive){
				return ""; //RELATIVE PATH
			} else { //work for flash IDE test.
				return _domain; //ABSOLUTE PATH
			}
		}
		
		/** path */
		public function get appPath():String {
			return domain + path;
		}
		
		/**force refresh*/
		protected function get forceRefresh():String { return isLive ? "?r=" + Math.random() : ""; }
		
		//*************************[STATIC]*****************************************//

		

		/**
		 * CONSTRUCTION FUNCTION.<br />
		 */
		public function AbRequestData(){

			_init();
		}

		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * Show class name.
		 * @return class name
		 */
		public function toString():String {
			return "AbRequestData 1.0";
		}

		/////////////SAMPLE METHOD\\\\\\\\\\\\\\\\\\\\\\\\\\
		/*public function sampleMethod(cbFn:Function, errFn:Function, thisObject:Object = null):void {
			
			var urlLoader:URLLoader	=	getUrlLoader.apply(this, ["sample.php" + forceRefresh, null].concat(arguments));
			urlLoader.addEventListener(Event.COMPLETE, _onSampleMethod);//Event.COMPLETE
		}

		private function _onSampleMethod(e:Event):void {
			var urlLoader:URLLoader	=	e.currentTarget as URLLoader;
			var data:Object			=	urlLoader.data;
			var xml:XML				=	new XML(data);
			var fnRef:ReqFnRef		=	_fnRefDict[urlLoader];
			
			fnRef.cbFn.call(fnRef.obj, xml);

			releaseEvents(urlLoader, arguments.callee);
		}*/

		


		//*************************[INTERNAL METHOD]********************************//


		//*************************[PROTECTED METHOD]*******************************//


		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			_fnRefDict	=	new Dictionary();
		}

		protected function getUrlLoader(urlPath:String, paramObj:Object, cbFn:Function, errFn:Function = null, thisObject:Object = null):URLLoader {
			var url:String			=	appPath + urlPath;
			var urlLoader:URLLoader =	new URLLoader();
			var fnRef:ReqFnRef		=	new ReqFnRef(cbFn, errFn, url, paramObj, thisObject);
			urlLoader.addEventListener("securityError", fnRef.httpStatus);//SecurityErrorEvent.SECURITY_ERROR
			urlLoader.addEventListener("httpStatus", fnRef.httpStatus);//HTTPStatusEvent.HTTP_STATUS
			urlLoader.addEventListener("ioError", fnRef.ioError);//IOErrorEvent.IO_ERROR
			fnRef.paramObj			=	paramObj;
			_fnRefDict[urlLoader]	=	fnRef;
			
			urlLoader.load(getUrlReq(url, paramObj));
			return urlLoader;
		}

		protected function getUrlReq(url:String, paramObj:Object = null):URLRequest {
			var req:URLRequest	=	new URLRequest(url);
			if (paramObj){
				req.data		=	getUrlVars(paramObj);
				req.method		=	"post";
			}
			return req;
		}

		protected function getUrlVars(obj:Object):URLVariables {
			var urlVars:URLVariables	=	new URLVariables();
			for (var prop:String in obj){
				urlVars[prop]	=	obj[prop];
			}
			return urlVars;
		}

		protected function releaseEvents(urlLoader:URLLoader, completeFn:Function):void {
			var fnRef:ReqFnRef	=	_fnRefDict[urlLoader];
			urlLoader.removeEventListener(Event.COMPLETE, completeFn);//Event.COMPLETE
			urlLoader.removeEventListener("securityError", fnRef.httpStatus);//SecurityErrorEvent.SECURITY_ERROR
			urlLoader.removeEventListener("httpStatus", fnRef.httpStatus);//HTTPStatusEvent.HTTP_STATUS
			urlLoader.removeEventListener("ioError", fnRef.ioError);//IOErrorEvent.IO_ERROR
			fnRef.destroy();
			delete _fnRefDict[urlLoader];
		}

		protected function outParams(obj:Object):String {
			var str:String	=	"";
			for (var prop:String in obj) {
				str	+=	prop + ": " + obj[prop]+"\n";
			}
			return str;
		}
		
		
		//*************************[STATIC METHOD]**********************************//
		//static public function getInstance():AbRequestData {
			//if (!_instance){
				//_instance = new AbRequestData();
			//}
			//return _instance
		//}

		
	}


}


//end class [com.wlash.puma.wp2010.RequestData]
//This template is created by whohoo. ver 1.3.0

/*below code were removed from above.

 * dispatch event when targeted.
 *
 * @eventType flash.events.Event
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0

   [Event(name = "sampleEvent", type = "flash.events.Event")]



 */
