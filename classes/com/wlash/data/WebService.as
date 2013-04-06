/*utf8*/
//**********************************************************************************//
//	name:	Webservice 1.1
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Apr 07 2009 16:47:47 GMT+0800
//	description: optimise the code that from internet.
//				thanks www.SnowManBlog.com www.roading.net
//				add SecurityErrorEvent
//				split event and callMethod class
//				fix some variable spelling error
//				v1.1 call function error.
//**********************************************************************************//

package com.wlash.data{


	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;

	/**
	 * io error. <p>can't find webservice url</p>
	 * 
	 * @eventType com.wlash.data.WebservicesEven
	 */
	[Event(name = "ioerror", type = "com.wlash.data.WebservicesEvent")]
	
	/**
	 * security error.
	 * 
	 * @eventType com.wlash.data.WebservicesEven
	 */
	[Event(name = "securityError", type = "com.wlash.data.WebservicesEvent")]
	
	
	/**
	 * WebService.
	 * <p>Call remote method by web service.</p>
	 * 
	 * @example The following code is how to use this class
	 * <listing version="3.0">
	 * var ws:WebService = new WebService("http://www.xmethods.net/");
	 * 
	 * //send complexType to remote method
	 * var param1:Object = {username:"wally", password:"123456"};
	 * 
	 * ws.call("remoteMethod", onReslut, param1, "param2");
	 * 
	 * //it would be called when remote emthod respond.
	 * function onReslut(obj:*){
	 *    trace(obj);
	 * }
	 * </listing>
	 */
	public class WebService extends EventDispatcher{
		private var wsUrl:String;
		private var xmlns:String;
		//private var headerArray:Array;//SOAP头参数
		private var complexType:Object;//[name]
		private var methods:Object;//webserverices all methods are store here.[methodName]{name, ns, type}
		//方法数组及参数规则,用于在分析完服务之前保存调用方法，待分析完后再执行，避免调用不成功
		private var methodArray:Array;//{methodName, respond, args}
		private var analyseCompleteFlag:Boolean;
		
		/**append header to SOAP*/
		public var header:Object;
		/**there are 3 way what you could call remote method.<br/> 
		 * <li>HTTP		:	0,</li>
		 * <li>SOAP 1.1	:	1, defalut</li>
		 * <li>SOAP 1.2	:	2,</li>
		 * @default 1
		 */
		public var callWay:int	=	1;
		//*************************[READ|WRITE]*************************************//
			
			
		//*************************[READ ONLY]**************************************//
			
			
		//*************************[STATIC]*****************************************//
			
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new WebService();]
		 * @param url
		 * @param header [optinal]
		 */
		public function WebService(url:String, header:Object=null):void{
			wsUrl			= url;
			this.header		= header==null ? {} : header;
			complexType		= {};
			methods			= {};
			methodArray		= [];

			analyseService();//分析服务
		}

		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * call remote method
		 * @param	remoteMethod remote method name
		 * @param   respondFn call back function when remote method respond. must with one argument. like (data:*), 
		 * @param   statueFn call back function when remote method respond. must with one argument. like (data:[WebServicesObj]), 
		 * @param	...args params
		 * @throws	if remote method not found.
		 */
		public function call(remoteMethod:String, respondFn:Function = null, statusFn:Function = null, ...args):void {
			if (!analyseCompleteFlag) { //如果服务还未分析完，将方法及参数暂存入数组对象
				methodArray.push( { methodName:remoteMethod, respond:respondFn, status:statusFn, args:args } );
			}else{
				if(methods[remoteMethod] != null){
					var ws:CallWebServicesMethod	= new CallWebServicesMethod(respondFn, statusFn, callWay);
					ws.addEventListener(WebServicesEvent.IO_ERROR, callErrorHandler);
					ws.addEventListener(WebServicesEvent.SECURITY_ERROR, callSecurityErrorHandler);
					ws.addEventListener(WebServicesEvent.HTTP_STATUS, callHttpStatusrHandler);
					ws.load(wsUrl, xmlns, remoteMethod, methods[remoteMethod], args, complexType);     
				}else{
					throw new Error("METHOD ["+remoteMethod+"()] not found in '"+wsUrl+"'.");
				}
			}
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		private function analyseService():void{
			var urlLoader:URLLoader		= new URLLoader();
			urlLoader.dataFormat		= URLLoaderDataFormat.TEXT;

			var urlRequest:URLRequest	= new URLRequest();
			urlRequest.url				= wsUrl + "?wsdl";
			urlRequest.method			= URLRequestMethod.POST;
			
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			urlLoader.load(urlRequest);
		}

		private function callMethods():void{
			for each(var obj:Object in methodArray) {
				//args数组是作为一个参数传递到load方法的，所以call方法会把数组认为是一个整体的参数
				//var obj:Object	=	methodArray[m];
				//if (obj.args.length==0){
					//call(obj.methodName, obj.respond);
				//}else{
				//}
				call.apply(null, ([obj.methodName, obj.respond, obj.status] as Array).concat(obj.args));
			}
			methodArray		=	null;
		}

		private function completeHandler(e:Event):void{
			var i:uint;

			var tmpXML:XML		=	XML(e.target.data);
			var wsdl:Namespace	=	tmpXML.namespace();//http://schemas.xmlsoap.org/wsdl/

			var s:Namespace		=	tmpXML.namespace("s");//http://www.w3.org/2001/XMLSchema
			
			var elementXML:XMLList		=	tmpXML.wsdl::["types"].s::["schema"].s::["complexType"];//include (@name == "AuthHeader")
			var len:int					=	elementXML.length();
			var elementSequXML:XMLList;
			var itemLen:int;
			//var ii:int;
			for (i = 0; i < len; i++) {
				elementSequXML	=	elementXML[i].s::["sequence"].s::["element"];
				itemLen			=	elementSequXML.length();
				var ctArr:Array	=	[];//complexType array
				for (var ii:int = 0; ii < itemLen; ii++) {
					ctArr.push(elementSequXML[ii].@name);
				}
				complexType[elementXML[i].@name]	=	ctArr;
			}
			
			//parse method
			elementXML	=	tmpXML.wsdl::["types"].s::["schema"].s::["element"].(@name != "AuthHeader");
			
			xmlns		=	elementXML.parent().@targetNamespace;
			itemLen		=	elementXML.length();
			//var item:String;//methods name
			
			for (i = 0; i < itemLen; i += 2) {
				var eXML:XML	=	elementXML[i];
				elementSequXML	=	eXML.s::["complexType"].s::["sequence"].s::["element"];
				methods[eXML.@name]	=	getParamNames(elementSequXML);
			}
			analyseCompleteFlag		=	true;
			callMethods();
			dispatchEvent(new WebServicesEvent(WebServicesEvent.COMPLETE, wsUrl, "Analyse.Web.Service.Complete", null,
							"URL '" + wsUrl + "' security error.  please check 'crossdomain.xml'"));
			_destroy(e);
		}

		private function getParamNames(elementXML:XMLList):Array {
			var retArr:Array	=	[];
			var itemLen:int		=	elementXML.length();
			for (var i:int = 0; i < itemLen; i++) {
				var ns_type:Array	=	elementXML[i].@type.toString().split(":");
				retArr.push({name:elementXML[i].@name.toString(), ns:ns_type[0], type:ns_type[1]});
			}
			return retArr;
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void {
			dispatchEvent(new WebServicesEvent(WebServicesEvent.SECURITY_ERROR, wsUrl, "Security.Error", null,
							"URL '" + wsUrl + "' security error.  please check 'crossdomain.xml'"));
			_destroy(e);
		}

		private function ioErrorHandler(e:IOErrorEvent):void{
			dispatchEvent(new WebServicesEvent(WebServicesEvent.IO_ERROR, wsUrl, "URL.Not.Found", null, "URL " + wsUrl + " not found!"));
			_destroy(e);
		}
		
		private function onHttpStatus(e:HTTPStatusEvent):void{
			dispatchEvent(new WebServicesEvent(WebServicesEvent.HTTP_STATUS, wsUrl, "Http.Status", null, ""+e.status));
		}
		
		//private function callCompleteHandler(e:WebServicesEvent):void{
			//dispatchEvent(e);
		//}

		private function callErrorHandler(e:WebServicesEvent):void {
			dispatchEvent(e);
		}

		private function callSecurityErrorHandler(e:WebServicesEvent):void{
			dispatchEvent(e);
		}
		
		private function callHttpStatusrHandler(e:WebServicesEvent):void{
			dispatchEvent(e);
		}
		
		private function _destroy(e:Event):void {
			var urlLoader:URLLoader	=	e.currentTarget as URLLoader;
			urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
		}
	}
}

