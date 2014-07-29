/*utf8*/
//**********************************************************************************//
//	name:	AbRequestData 1.3
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	2010/11/26 10:09
//	description: 
//				1.1 增加defaultMethod， 默认为post方式
//					增加createXMLLoader方法，当调用的接口返回是xml格式时，建议使用此
//					方法。
//					data:*数据做为传参，数据保存作用，或其它
//				1.2 增加了createDataLoader方法,当调用的接口返回是String格式时
//				1.3 如果参数是XML类型,则直接给到data
//**********************************************************************************//


//[com.wlash.data.AbRequestData]
package com.wlash.data {
	import flash.external.ExternalInterface;
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
		public var defaultMethod:String		=	"post";
		
		protected var _fnRefDict:Dictionary;
		protected var _domain:String		=	"";
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

		/////////////SAMPLE METHOD 1\\\\\\\\\\\\\\\\\\\\\\\\\\
		/*public function sampleMethod1(cbFn:Function, errFn:Function, data:* = null):void {
			var urlLoader:URLLoader	=	createXMLLoader.apply(this, ["sample.do", {paramId:0}].concat(_onSampleMethod_1, errFn));
			var fnRef:ReqFnRef		=	_fnRefDict[urlLoader];
			
			fnRef.callBackFn	=	cbFn;
		}
		//也可以不指定_onSampleMethod_1此方法，这样....concat(cbFn, errFn)); 且不用指定fnRef.callBackFn	=	cbFn;
		private function _onSampleMethod_1(xml:XML, fnRef:ReqFnRef):void {
			fnRef.callBackFn(String(xml.result[0])=="1");//sample
		}*/
		
		/////////////SAMPLE METHOD 2\\\\\\\\\\\\\\\\\\\\\\\\\\
		/*public function sampleMethod2(cbFn:Function, errFn:Function, data:* = null):void {
			
			var urlLoader:URLLoader	=	getUrlLoader.apply(this, ["sample.php" + forceRefresh, null].concat(arguments));
			urlLoader.addEventListener(Event.COMPLETE, _onSampleMethod_2);//Event.COMPLETE
		}

		private function _onSampleMethod_2(e:Event):void {
			var urlLoader:URLLoader	=	e.currentTarget as URLLoader;
			var data:Object			=	urlLoader.data;
			var fnRef:ReqFnRef		=	_fnRefDict[urlLoader];
			
			fnRef.cbFn(data);

			releaseEvents(urlLoader, arguments.callee);
		}*/

		public function releaseEvents(urlLoader:URLLoader, completeFn:Function=null):void {
			var fnRef:ReqFnRef	=	_fnRefDict[urlLoader];
			if(completeFn!=null)	urlLoader.removeEventListener("complete", completeFn);//Event.COMPLETE
			urlLoader.removeEventListener("complete", fnRef.xmlComplete);//Event.COMPLETE
			urlLoader.removeEventListener("securityError", fnRef.securityError);//SecurityErrorEvent.SECURITY_ERROR
			urlLoader.removeEventListener("httpStatus", fnRef.httpStatus);//HTTPStatusEvent.HTTP_STATUS
			urlLoader.removeEventListener("ioError", fnRef.ioError);//IOErrorEvent.IO_ERROR
			fnRef.destroy();
			delete _fnRefDict[urlLoader];
		}


		//*************************[INTERNAL METHOD]********************************//

		


		//*************************[PROTECTED METHOD]*******************************//


		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			_fnRefDict	=	new Dictionary();
		}

		protected function createXMLLoader(urlPath:String, paramObj:Object, cbFn:Function, errFn:Function = null, data:* = null):URLLoader {
			var urlLoader:URLLoader =	getUrlLoader(urlPath, paramObj, null, errFn, data);
			var fnRef:ReqFnRef		=	_fnRefDict[urlLoader];
			fnRef._completeFn		=	cbFn;//指定当加载完成时调用的函数，可以是做为解析xml, 函数的定义为function onXXXX(xml:XML, fnRef:ReqFnRef):void{...}
			urlLoader.addEventListener("complete", fnRef.xmlComplete);//Event.COMPLETE
			return urlLoader;
		}

		protected function createDataLoader(urlPath:String, paramObj:Object, cbFn:Function, errFn:Function = null, data:* = null):URLLoader {
			var urlLoader:URLLoader =	getUrlLoader(urlPath, paramObj, null, errFn, data);
			var fnRef:ReqFnRef		=	_fnRefDict[urlLoader];
			fnRef._completeFn		=	cbFn;//指定当加载完成时调用的函数，可以是做为解析xml, 函数的定义为function onXXXX(xml:XML, fnRef:ReqFnRef):void{...}
			urlLoader.addEventListener("complete", fnRef.dataComplete);//Event.COMPLETE
			return urlLoader;
		}
		
		protected function getUrlLoader(urlPath:String, paramObj:Object, cbFn:Function, errFn:Function = null, data:* = null):URLLoader {
			var urlObj:Object			=	getUrlLoaderAndRequest(urlPath, paramObj, cbFn, errFn, data);
			var urlLoader:URLLoader		=	urlObj.urlLoader;
			var urlRequest:URLRequest 	=	urlObj.urlRequest;
			urlLoader.load(urlRequest);
			return urlLoader;
		}
		
		protected function getUrlLoaderAndRequest(urlPath:String, paramObj:Object, cbFn:Function, errFn:Function = null, data:* = null):Object {
			var url:String			=	(urlPath.indexOf("http://")!=-1 || urlPath.indexOf("https://")!=-1) ? urlPath : (appPath + urlPath);
			var urlLoader:URLLoader =	new URLLoader();
			var fnRef:ReqFnRef		=	new ReqFnRef(this, cbFn, errFn, url, paramObj, data);
			addListeners(urlLoader, fnRef);
			fnRef.paramObj			=	paramObj;
			_fnRefDict[urlLoader]	=	fnRef;
			var urlRequest:URLRequest	=	getUrlReq(url, paramObj);
			return {urlLoader:urlLoader, urlRequest:urlRequest};
		}
		
		protected function addListeners(urlLoader:URLLoader, fnRef:ReqFnRef):void {
			
			urlLoader.addEventListener("securityError", fnRef.securityError);//SecurityErrorEvent.SECURITY_ERROR
			urlLoader.addEventListener("httpStatus", fnRef.httpStatus);//HTTPStatusEvent.HTTP_STATUS
			urlLoader.addEventListener("ioError", fnRef.ioError);//IOErrorEvent.IO_ERROR
		}

		protected function getUrlReq(url:String, paramObj:Object = null):URLRequest {
			var req:URLRequest	=	new URLRequest(url);
			req.method		=	defaultMethod;
			if (paramObj is XML) {
				req.data	=	getXMLParams(paramObj);
			}else{
				req.data	=	getUrlVars(paramObj);
	
				if (url.indexOf("?")!=-1) {
					var urlArr:Array	=	url.split("?");
					req.url	=	urlArr[0];//把原来url ?后的参数统一放到URLVariables中去
					URLVariables(req.data).decode(urlArr[1]);
				}
	
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

		protected function getXMLParams(obj:Object):XML {
			
			return XML(obj);
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

		static public function consoleCmd(cmd:String, ...args:*):void {
			if (ExternalInterface.available) {
				ExternalInterface.call.apply(null, ["console."+cmd].concat(args));
			}
		}
		
		static public function log(...args:*):void {
			consoleCmd.apply(null, ["log"].concat(args));
		}
		
		static public function debug(...args:*):void {
			consoleCmd.apply(null, ["debug"].concat(args));
		}
		
		static public function info(...args:*):void {
			consoleCmd.apply(null, ["info"].concat(args));
		}
		
		static public function warn(...args:*):void {
			consoleCmd.apply(null, ["warn"].concat(args));
		}
		
		static public function error(...args:*):void {
			consoleCmd.apply(null, ["error"].concat(args));
		}
		
		static public function assert(...args:*):void {
			consoleCmd.apply(null, ["assert"].concat(args));
		}
		
		static public function dir(obj:Object):void {
			consoleCmd.apply(null, ["dir"].concat(obj));
		}
		
		static public function dirxml(node:Object):void {
			consoleCmd.apply(null, ["dirxml"].concat(node));
		}
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
console.debug(object[, object, ...])
向控制台输出一条信息，它包括一个指向该行代码位置的超链接。

console.info(object[, object, ...])


向控制台输出一条信息，该信息包含一个表示“信息”的图标，和指向该行代码位置的超链接。

console.warn(object[, object, ...])
同 info。区别是图标与样式不同。

console.error(object[, object, ...])
同 info。区别是图标与样式不同。error 实际上和 throw new Error() 产生的效果相同，使用该语句时会向浏览器抛出一个 js 异常。

console.assert(expression[, object, ...])
断言，测试一条表达式是否为真，不为真时将抛出异常（断言失败）。

console.dir(object)
输出一个对象的全部属性（输出结果类似于 DOM 面板中的样式）。

console.dirxml(node)
输出一个 HTML 或者 XML 元素的结构树，点击结构树上面的节点进入到 HTML 面板。

console.trace()
输出 Javascript 执行时的堆栈追踪。

console.group(object[, object, ...])
输出消息的同时打开一个嵌套块，用以缩进输出的内容。调用 console.groupEnd() 用以结束这个块的输出。

console.groupCollapsed()
同 console.group(); 区别在于嵌套块默认是收起的。

console.time(name)
计时器，当调用 console.timeEnd(name);并传递相同的 name 为参数时，计时停止，并输出执行两条语句之间代码所消耗的时间（毫秒）。

console.profile([title])
与 profileEnd() 结合使用，用来做性能测试，与 console 面板上 profile 按钮的功能完全相同。

console.count([title])
输出该行代码被执行的次数，参数 title 将在输出时作为输出结果的前缀使用。

console.clear()
清空控制台


 */
