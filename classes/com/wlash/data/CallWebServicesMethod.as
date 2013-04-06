/*utf8*/
//**********************************************************************************//
//	name:	Webservices 1.1
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Apr 07 2009 16:47:47 GMT+0800
//	description: optimise the code that from internet.
//				thanks www.SnowManBlog.com www.roading.net
//				add SecurityErrorEvent
//				v.1.1 add listene http status events.
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
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	
	/**
	 * security error.
	 * 
	 * @eventType com.wlash.data.WebservicesEven
	 */
	[Event(name = "securityError", type = "com.wlash.data.WebservicesEvent")]
	
	/**
	 * io error. 
	 * 
	 * @eventType com.wlash.data.WebservicesEven
	 */
	[Event(name = "ioerror", type = "com.wlash.data.WebservicesEvent")]
	
	/**
	 * CallWebServicesMethod，
	 * <p>normally, this class would be call by WebService.call().</p>
	 * @example The following code is how to use this class
	 * <listing version="3.0">
	 * var ws:CallWebServicesMethod = new CallWebServicesMethod(onReslut);
	 * 
	 * var paramsName:Array	=	["name", "email", "gender"]
	 * 
	 * ws.call("http://www.xmethods.net/", "remoteMethod", paramsName, "wally", "whohoo@21cn.com", "male");
	 * 
	 * //it would be called when remote emthod respond.
	 * function onReslut(obj:*){
	 *    trace(obj);
	 * }
	 * </listing>
	 */
	public class CallWebServicesMethod extends EventDispatcher{
		private var _xmlns:Namespace;
		private var soap:Namespace;
		private var soapXML:XML;
		private var urlLoader:URLLoader;
		private var urlRequest:URLRequest;
		private var targetMethodName:String;

		private var _resultFn:Function;
		private var _statusFn:Function;
		private var _callWay:int;
		private var _httpStatusCode:int;
		
		private const SOAP1:String			=	"http://schemas.xmlsoap.org/soap/envelope/";
		private const SOAP2:String			=	"http://www.w3.org/2003/05/soap-envelope";
		//*************************[READ|WRITE]*************************************//
			
			
		//*************************[READ ONLY]**************************************//
			
			
		//*************************[STATIC]*****************************************//
		/**call method with HTTP*/
		static public const HTTP:int	=	0;
		/**call method with SOAP 1.1, default*/
		static public const SOAP_11:int	=	1;
		/**call method with SOAP 1.2*/
		static public const SOAP_12:int	=	2;
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new CallWebServicesMethod();]
		 * @param resultFn [optional] if respond, would call this function
		 * @param statusFn [optional] if error, call this function
		 * @param callWay  [optional] the value maybe is 0, 1, 2. the default is 1, means SOAP 1.1
		 */
		public function CallWebServicesMethod(resultFn:Function = null, statusFn:Function = null, callWay:int = 1):void {
			_resultFn	=	resultFn;
			_statusFn	=	statusFn;
			_callWay	=	callWay;
			_init();
		}

		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * the sample call remote method without anaylize the web serviece, no header.
		 * @param	wsUrl web service address
		 * @param	xmlns XML namepace
		 * @param	methodName remote method name
		 * @param	labels method params name
		 * @param	...args params
		 */
		public function call(wsUrl:String, xmlns:String, methodName:String, labels:Array, ...args):void {
			load(wsUrl, xmlns, methodName, labels, args, {});
		}
		
		//*************************[INTERNAL METHOD]********************************//
		/**
		 * call remote method, this method would be call by WebService.
		 * @param	wsUrl webservices url
		 * @param	xmlns xmlns targetNamespace value
		 * @param	methodName webservices method name
		 * @param	labels webservices method params name {name,ns,type}
		 * @param	args webservices method params
		 * @param	headerObj  header value
		 * @param	complexType [optinal] include header
		 * @throws	throw ArgumentError if args is incorrect.
		 */
		internal function load(wsUrl:String, xmlns:String, methodName:String, labels:Array, args:Array, headerObj:Object, complexType:Object = null):void {
			if (labels.length != args.length) {
				throw new ArgumentError("Incorrect number of arguments. Expected " + labels.length+", current arguements is "+args.length);
			}
			targetMethodName	=	methodName;
			_xmlns				=	new Namespace(xmlns);
			switch(_callWay) {
				case 0://http
					setHttpRequest(wsUrl, methodName, labels, args, headerObj, complexType);
				break;
				case 1://soap 1.1
					urlRequest.requestHeaders.push(new URLRequestHeader("SOAPAction", xmlns + "/" + methodName));
				case 2://soap 1.2
					setSoapRequest(wsUrl, xmlns, methodName, labels, args, headerObj, complexType);
				break;
			}
			_httpStatusCode	=	-1;
			urlLoader.load(urlRequest);
		}
		
		//*************************[PROTECTED METHOD]*******************************//
		/**
		 * anaylize the respond result, and return to resultFn.
		 * <p>this function would be auto call when remote method respond.</p>
		 * @param	data
		 * @return
		 */
		protected function parseRespond(data:XML):* {
			switch(_callWay) {
				case 0://http
					return data.toString();
				break;
				case 1://soap 1.1
				case 2://sopa 1.2
					var soap_ns:Namespace	=	data.namespace();//http://schemas.xmlsoap.org/soap/envelope/ or http://www.w3.org/2003/05/soap-envelope
					var d:*	=	data.soap_ns::["Body"]._xmlns::[targetMethodName + "Response"];
					if (d.toString() == "")	return void;//not return value
					return String(d._xmlns::[targetMethodName + "Result"]);
				break;
			}
			
		}
		
		//*************************[PRIVATE METHOD]*********************************//
		private function setHttpRequest(wsUrl:String, methodName:String, labels:Array, args:Array, headerObj:Object, complexType:Object):void {
			var data:URLVariables	=	new URLVariables();
			var len:int				=	args.length;
			for (var i:int = 0; i < len; i++) {
				var methodParamObj:Object	=	labels[i];
				var elementLabel:String		=	methodParamObj.name;
				data[elementLabel]			=	args[i];
			}
			urlRequest.data	=	data;
			urlRequest.url	=	wsUrl + "/" + methodName;
		}
		
		private function setSoapRequest(wsUrl:String, xmlns:String, methodName:String, labels:Array, args:Array, headerObj:Object, complexType:Object):void {
			var tempXML:XML			=	soapXML;
			
			complexType				=	complexType == null ? { } : complexType;
			
			var headerArray:Array	=	complexType["AuthHeader"];//header
			var elementLabel:String;
			var len:int;
			if(headerArray!=null){
				len		=	headerArray.length;
				if(len>0){//add Header
					var headerXML:XML	=	XML("<AuthHeader xmlns=\"" + xmlns + "\"/>");
					for (var i:int = 0; i < len; i++) {
						elementLabel	=	headerArray[i];
						headerXML.appendChild( new XML("<" + elementLabel +">" + headerObj[elementLabel] + "</" + elementLabel + ">") );
					}
					tempXML.soap::["Header"].appendChild(headerXML);
				}
			}
			
			var methodXML:XML	=	XML("<" + methodName + " xmlns=\"" + xmlns + "\"/>");
			len	=	args.length;
			for (i = 0; i < len; i++) {
				var methodParamObj:Object	=	labels[i];
				elementLabel				=	methodParamObj.name;
				var argsValue:*				=	args[i];
				
				var paramXML:XML			=	new XML("<" + elementLabel +"/>");
				if (methodParamObj.ns == "s") {
					paramXML.appendChild(argsValue);
				}else if (methodParamObj.ns == "tns") {//TODO 可能有更多的嵌套
					var complexTypeNames:Array	=	complexType[methodParamObj.type];
					var len2:int	=	complexTypeNames.length;
					for (var ii:int = 0; ii < len2; ii++) {
						var complexTypeName:String	=	complexTypeNames[ii];
						var complexTypeValue:*		=	argsValue[complexTypeName];
						if (complexTypeValue === undefined) {
							throw new ArgumentError("Incorrect Arguments. Expect complexType [" + complexTypeName + "] at " + i + ".");
						}
						paramXML.appendChild(new XML("<" + complexTypeName + ">" + complexTypeValue + "</" + complexTypeName + ">"));
					}
				}
				methodXML.appendChild( paramXML );
			}
		  
			tempXML.soap::["Body"].appendChild(methodXML);
			if (xmlns.lastIndexOf("/") == xmlns.length - 1)	xmlns = xmlns.substr(0, xmlns.length - 1);//remove "/"
			
			urlRequest.url		=	wsUrl + "?op=" + methodName;
			urlRequest.data		=	tempXML;
		}
		
		///////////EVENTS///////////////////
		private function completeHandler(e:Event):void {
			if (_resultFn != null) {
				_resultFn(parseRespond(XML(e.target.data)));
			} 
			
			dispatchEvent(new WebServicesEvent(WebServicesEvent.COMPLETE, urlRequest.url, "Call.Complete", targetMethodName,
							"call method [" + targetMethodName + "] success!"));
			_destroy();
		}

		private function ioHttpStatusHandler(e:HTTPStatusEvent):void {
			_httpStatusCode		=	e.status;
			if (_statusFn != null) {
				if (_httpStatusCode != 200 && //success
					_httpStatusCode != 0 &&//for local file
					_httpStatusCode < 400) {
						_statusFn( new WebServicesObj(urlRequest.url, "Call.Http.Status", targetMethodName, _httpStatusCode, 
							"bad http status code" ) );
				}
			}
			
			dispatchEvent(new WebServicesEvent(WebServicesEvent.HTTP_STATUS, urlRequest.url, "Call.Http.Status", targetMethodName,
							"" + e.status));
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void {
			if (_statusFn != null) {
				_statusFn(new WebServicesObj(urlRequest.url, "Call.Security.Error", targetMethodName, _httpStatusCode));
			}
			
			dispatchEvent(new WebServicesEvent(WebServicesEvent.SECURITY_ERROR, urlRequest.url, "Call.Security.Error", targetMethodName,
							"call method [" + targetMethodName + "] security error by URL '" + urlRequest.url +
							"'. please check 'crossdomain.xml'."));
			_destroy();
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			if (_statusFn != null) {
				_statusFn(new WebServicesObj(urlRequest.url, "Call.Error", targetMethodName, _httpStatusCode));
			}
			
			dispatchEvent(new WebServicesEvent(WebServicesEvent.IO_ERROR, urlRequest.url, "Call.Error", targetMethodName,
							"call method [" + targetMethodName + "] error by URL '" + urlRequest.url + "'"));
			_destroy();
		}
		
		///////////////INIT/////////////////
		private function _init():void{
			urlLoader			= 	new URLLoader();
			urlRequest			= 	new URLRequest();
			urlRequest.method	=	URLRequestMethod.POST;
			 
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, ioHttpStatusHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			initSoap();
		}
		
		private function initSoap():void {
			switch(_callWay) {
				case 0://http
					
				break;
				case 1://soap 1.1
					soap	=	new Namespace(SOAP1);
					soapXML	=	XML('<?xml version="1.0" encoding="utf-8" ?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" '+
							'xmlns:soap="' + SOAP1 + '" ><soap:Header/><soap:Body/></soap:Envelope>');
					urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "text/xml;charset=utf-8")); 
				break;
				case 2://soap 1.2
					soap	=	new Namespace(SOAP2);
					soapXML	=	XML('<?xml version="1.0" encoding="utf-8" ?><soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" '+
							'xmlns:soap12="' + SOAP2 + '" ><soap12:Header/><soap12:Body/></soap12:Envelope>');
					urlRequest.requestHeaders.push(new URLRequestHeader("Content-Type", "application/soap+xml;charset=utf-8")); 
				break;
			}
			
		}
		
		private function _destroy():void {
			urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, ioHttpStatusHandler);
			urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
	}
}

