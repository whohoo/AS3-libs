//******************************************************************************
//	name:	TrackingCode 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-11-14 11:42
//	description: 
//		
//******************************************************************************

package com.wlash.utils{

	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	/**
	* tracking code
	* @author Wally.ho
	*/
	public class TrackingCode {
		/**old tracking function*/
		static public const GOOGLE_ANALYTICS_TRACKER_0:String	=	"urchinTracker";
		/**new tracking function*/
		static public const GOOGLE_ANALYTICS_TRACKER_1:String	=	"pageTracker._trackPageview";
		/**
		 * current tracking function, default function is new tracking function
		 * @default GOOGLE_ANALYTICS_TRACKER_1
		 * @see GOOGLE_ANALYTICS_TRACKER_0
		 * @see GOOGLE_ANALYTICS_TRACKER_1
		 */
		static public var gAnalyticsFn:String	=	GOOGLE_ANALYTICS_TRACKER_1;
		
		/**the tracking path prefix.*/
		static public function get prefix():String { return _prefix; }
		/**@private */
		static public function set prefix(value:String):void {
			if(value.length>0){
				if (value.indexOf("/") != 0) {
					value	=	"/" + value;
				}
				if (value.lastIndexOf('/') == value.length - 1) {
					value	=	value.substr(0, value.length - 1);
				}
			}
			_prefix	=	value;
		}
		static private var _prefix:String			=	"";
		/**other tracking way URL if tackingUrl start with 'http'*/
		static public function get trackingURL():String { return _trackingURL; }
		/**@private */
		static public function set trackingURL(value:String):void {
			if (value.length > 0) {
				if (value.lastIndexOf('/') == value.length - 1) {
					value	=	value.substr(0, value.length - 1);
				}
			}
			_trackingURL	=	value;
		}
		static private var _trackingURL:String		=	"";
		
		/**
		 * tracking google Analytics and other tracking url if defined TrackingCode.trackingURL.
		 * 
		 * @param	value it dose not including front and end slash '/'
		 * @usage	TrackCode.tracking("Homepage"); or TrackCode.tracking("Gallery Page_create new");
		 * @return  ExternalInterface.callback
		 */
		static public function tracking(value:String):* {
			var ret:*;
			if (value.length > 0) {
				if (value.indexOf("/") == 0) {
					value	=	value.substr(1, value.length - 1);
				}
				if (value.lastIndexOf('/') == value.length - 1) {
					value	=	value.substr(0, value.length - 1);
				}
			}
			if(Capabilities.playerType=="External"){//flash IDE
				trace("javascript:" + gAnalyticsFn + "('" + prefix +"/" + value + "/');");
			}else if (Capabilities.playerType != "StandAlone") {
				ret	=	ExternalInterface.call(gAnalyticsFn, prefix + "/" + value + "/");//Google anglytics
				if(trackingURL.indexOf('http')==0){
					new URLLoader(new URLRequest(trackingURL + prefix + "/" + value + "/"));
				}
			}
			return ret;
		}
	}
	
}