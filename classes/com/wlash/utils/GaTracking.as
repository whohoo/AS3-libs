//******************************************************************************
//	name:	GaTracking 1.0
//	author:	whohoo
//	email:	whohoo@qq.com
//	date:	2013/7/30 10:56
//	description: 对新的ga支持
//		
//******************************************************************************

package com.wlash.utils{

	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	/**
	* Ga tracking code
	* @author Wally.ho
	*/
	public class GaTracking {
		
		static private var _prefix:String			=	"";
		
		/**the tracking path prefix.*/
		static public function get prefix():String { return "/"+_prefix; }
		/**@private */
		static public function set prefix(value:String):void {
			if (value == null) value = "";
			
			_prefix	=	_parsePath(value, true);
		}
		
			
		/**
		 * tracking google Analytics 
		 * _gaq.push(['_trackEvent', 'Top', 'link', 'Logo']);
		 * @param	catalog 分类, 类别
		 * @param	action 动作, 一般为 click, link, 视频中的play, pause, stop...
		 * @param	label 按键名称
		 * @param	value [optional] 数值
		 * @usage	TrackCode.tracking("/Homepage");
		 * @return  ExternalInterface.callback
		 */
		static public function trackingEvent(catalog:String, action:String, label:String, value:String=0):* {
			if (catalog == null)	throw new Error("ERROR: catalog is null.");
			if (action == null)	throw new Error("ERROR: action is null.");
			if (label == null)	throw new Error("ERROR: label is null.");
			var ret:*;
			
						
			if(Capabilities.playerType=="External"){//flash IDE
				trace("Tracking Event: _gaq.push(['_trackEvent', '" + catalog + "', '" + action + "', '" + label + "', '" + value + "']);");
			}else if (Capabilities.playerType != "StandAlone") {
				ret	=	ExternalInterface.call("_gaq.push", ['_trackEvent', catalog, action, label, value]);//Google anglytics
			}
			return ret;
		}
		
			
		/**
		 * tracking google Analytics 
		 * 
		 * @param	value it dose not including front and end slash '/'
		 * @usage	TrackCode.tracking("/Homepage");
		 * @return  ExternalInterface.callback
		 */
		static public function trackingPV(value:String):* {
			if (value == null)	throw new Error("ERROR: value is null.");
			var ret:*;
			
			var path = _parsePath(value, false);
			if(prefix!="/"){
				path = prefix + "/" + path;
			}else{
				path = "/" + path;
			}
			if(Capabilities.playerType=="External"){//flash IDE
				trace("Tracking Pageview: _gaq.push(['_trackPageview', '" + path + "']);");
			}else if (Capabilities.playerType != "StandAlone") {
				ret	=	ExternalInterface.call("_gaq.push", ['_trackPageview', path]);//Google anglytics
			}
			return ret;
		}
		
		static private function _parsePath(value:String, parseLast:Boolean):String {
			if (value == null)	return null;
			if(value=="") return "";
			if(value=="/") return parseLast ? "" : "/";
			var arr:Array = value.split("/");
			var arr2:Array = [];
			var len:int = arr.length;
			if (len > 0) {
				var p:String;
				if (!parseLast) {
					p = arr.pop();
					arr2.push(p);
				}
				while (arr.length > 0) {
					p = arr.pop();
					if (p != "") {
						arr2.push(p);
					}
				};
				arr2.reverse();
			}
			return arr2.join("/");
		}
	}
	
}