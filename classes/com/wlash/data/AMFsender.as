//******************************************************************************
//	name:	AMFsender 1.3
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Mon Jun 16 2008 11:04:17 GMT+0800
//	description: This file was created by "main.fla" file.
//		1.1 增加了serverInfo2Array function
//		1.2 serverInfo2Array函数增加了第二个参数,类似Array.forEach();
//		1.3 去掉AMFResponderEvent.as的广播事件
//			去掉Default gateway的定义，必须定义网关
//			int2Date方法改为类的静态方法
//******************************************************************************



package com.wlash.data {
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	/**
	 * dispatch event when async error occur.
	 * @eventType flash.events.AsyncErrorEvent
	 */
	[Event(name = "asyncError", type = "flash.events.AsyncErrorEvent")]
	/**
	 * dispatch event when input and output error occur.
	 * @eventType flash.events.IO_ERROR
	 */
	[Event(name = "ioError ", type = "flash.events.IO_ERROR")]
	/**
	 * dispatch event when net status error occur.
	 * @eventType flash.events.NET_STATUS
	 /*
	[Event(name = "netStauts", type = "flash.events.NET_STATUS")]
	/**
	 * dispatch event when security error occur.
	 * @eventType flash.events.SECURITY_ERROR
	 */
	[Event(name = "securityError", type = "flash.events.SECURITY_ERROR")]

	
	[IconFile("AMFsender.png")]
	/**
	 * AMFsender.
	 * <p>AMF call and respond</p>
	 * 
	 */
	public class AMFsender extends EventDispatcher {
		
		/**remote Class*/
		public var remoteClass:String;
		/**custom responder functions*/
		public var responder:Responder;
		/**gate way url*/
		public var gatewayUrl:String;
		/**netConnection*/
		protected var netConn:NetConnection;
		
		//************************[READ|WRITE]************************************//

		//************************[READ ONLY]*************************************//

		
		
		/**
		 * Construction function.<br></br>
		 * Create a class BY [new AMFsender();]
		 * @param remoteClass remote class
		 * @param gateUrl gate way url,
		 * @param responder [optional] custom responder function, if null, it would trace the result.
		 * @param objectEncoding [optional] default is 3, avaiable value are 0 or 3
		 */
		public function AMFsender(remoteClass:String, gateUrl:String, responder:Responder=null, objectEncoding:uint=3) {
			//NetConnection.defaultObjectEncoding	=	ObjectEncoding.AMF0;
			this.remoteClass	=	remoteClass;
			gatewayUrl			=	gateUrl;
			this.responder		=	responder;
			_init();
			netConn.objectEncoding	=	objectEncoding;
		}
		
		//***********************[PUBLIC METHOD]**********************************//
		/**
		 * 调用远程服务器上的函数,
		 * @param	remoteMethod 远程函数名
		 * @param	respond 返回值[optional] 如果没有指定,则选择responder,如果responder也没定义,则调用默认的responder
		 * @param	...args 传递的参数[optional],因参数经传递后,后台语言变成Array而不是原来定义等原因,所以这里的参数不能超过八个.
		 */
		public function call(remoteMethod:String, respond:Responder = null, ... args):void {
			if (!respond) respond	=	this.responder;
			if (!respond) respond	=	new Responder(onResult, onStatus);	
			switch (args.length) {
				case 0:
					netConn.call(remoteClass + "." + remoteMethod, respond);
				break;
				case 1:
					netConn.call(remoteClass + "." + remoteMethod, respond, args[0]);
				break;
				case 2:
					netConn.call(remoteClass + "." + remoteMethod, respond, args[0], args[1]);
				break;
				case 3:
					netConn.call(remoteClass + "." + remoteMethod, respond, args[0], args[1], args[2]);
				break;
				case 4:
					netConn.call(remoteClass + "." + remoteMethod, respond, args[0], args[1], args[2], args[3]);
				break;
				case 5:
					netConn.call(remoteClass + "." + remoteMethod, respond, args[0], args[1], args[2], args[3], args[4]);
				break;
				case 6:
					netConn.call(remoteClass + "." + remoteMethod, respond, args[0], args[1], args[2], args[3], args[4], args[5]);
				break;
				case 7:
					netConn.call(remoteClass + "." + remoteMethod, respond, args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
				break;
				case 8:
					netConn.call(remoteClass + "." + remoteMethod, respond, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
				break;
				default:
					throw new Error("args length exceed 8, current value is "+args.length);
			}
		}

		/**
		 * 连接服务器,如果没有指定参数,则连接gateway,如果gateway为空值,则连接缺省值"/gateway"
		 * @param	url
		 */
		public function connect(url:String = null):void {
			if (url) {
				gatewayUrl		=	url;
				netConn.connect(gatewayUrl);
			}else {
				netConn.connect(gatewayUrl);
			}
		}
		
		/**
		 * 把PHPAMF返回的RAW数据转为Array格式.
		 * @param	obj
		 * @param	forEachFn [optional] 每条记录调用一次.参数为(dataObj:Object, i:uint, array:Array)
		 * @return	转为Array格式的数组
		 */
		public function serverInfo2Array(obj:Object, forEachFn:Function=null):Array {
			var arr:Array	=	[];
			var servInfo:Object	=	obj.serverInfo;
			var len:Number	=	servInfo.columnNames.length;
			for (var i:int = 0; i < obj.serverInfo.totalCount; i++) {
				var dataObj:Object	=	{ };
				for (var n:int = 0; n < len; n++) {
					dataObj[servInfo.columnNames[n]]	=	servInfo.initialData[i][n];
				}
				if (forEachFn!=null) {
					forEachFn(dataObj, i, arr);
				}
				arr.push(dataObj);
			}
			return arr;
		}
		
		
		/**
		 * 测试远程服务器函数test()
		 * @param	...args
		 */
		public function test(...args):void {
			netConn.call(remoteClass + ".test", new Responder(onResult, onStatus), args);
			trace("Calling method: "+remoteClass + ".test("+args+")");
		}
		
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		/**
		 * 列出网络服务状态,如果连接有问题,可以通过此调用,这函数只在在NetStatusEvent中info属性
		 * @param	info
		 */
		protected function traceNetStatus(info:Object):void {
			trace("[BEGIN NetStatus:]");
			if (info.level == "error") {
				trace("NetStatus | code: "+info.code+", desc: "+info.description+", details: "+info.details);
			}else {
				var traceStr:String		=	"";
				for (var prop:String in info) {
					traceStr	+=	prop + ": " + info[prop]+", ";
				}
				trace("NetStatus | ..."+traceStr);
			}
			trace("[END].");
		}
		
		/**
		 * 列出netConnection的信息, 如:
		 * client, connected, defaultObjectEncoding, objectEncoding, uri, proxyType, connectedProxyType, usingTLS
		 */
		protected function traceNetConnectionInfo():void {
			trace("[BEGIN NetConnectionInfo:]");
			trace("client: "+netConn.client);
			trace("connected: "+netConn.connected);
			trace("defaultObjectEncoding: "+NetConnection.defaultObjectEncoding);
			trace("objectEncoding: "+netConn.objectEncoding);
			trace("uri: "+netConn.uri);
			trace("proxyType: " + netConn.proxyType);
			if(netConn.connected){//必须连接 NetConnection 对象。
				trace("connectedProxyType: "+netConn.connectedProxyType);
				trace("usingTLS: " + netConn.usingTLS);
			}
			trace("[END].");
		}
		
		/**
		 * default onResult
		 * 当没指定responder时会被调用,
		 * @param	obj
		 */
		protected function onResult(obj:*):void {
			trace("return VALUE: "+obj+" | "+remoteClass + ".test()");
			//dispatchEvent(new AMFResponderEvent(AMFResponderEvent.DEFAULT_RESULT, obj));
		}
		
		/**
		 * default onStatus
		 * 当没指定responder时会被调用,
		 * @param	obj
		 */
		protected function onStatus(obj:*):void {
			trace(remoteClass + ".test() | server STATUS:");
			traceObject(obj);
			//dispatchEvent(new AMFResponderEvent(AMFResponderEvent.ERROR_STATUS, obj));
		}
		
		//************************[PRIVATE METHOD]********************************//
		/**
		 * Initializtion this class
		 */
		private function _init():void {
			netConn		=	new NetConnection();
			connect();
			netConn.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			netConn.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			netConn.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			netConn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void {
			dispatchEvent(e);
		}
		
		private function onNetStatus(e:NetStatusEvent):void {
			dispatchEvent(e);
		}
		
		private function onIOError(e:IOErrorEvent):void {
			dispatchEvent(e);
		}
		
		private function onAsyncError(e:AsyncErrorEvent):void {
			dispatchEvent(e);
		}
		
		
		//***********************[STATIC METHOD]**********************************//
		/**
		 * 把对象列出来
		 * @param	obj
		 */
		static public function traceObject(obj:Object):void {
			var i:int	=	0;
			for (var prop:String in obj) {
				trace(i + ") " + prop + " = " + obj[prop]+" : "+typeof(obj[prop]));
				i++;
			}
			if (i == 0) {
				trace(obj+" : "+typeof(obj));
			}
		}
		
		/**
		 * 把PHPAMF返回的秒数转为Date格式.
		 * @param	obj
		 * @return
		 */
		static public function int2Date(obj:int):Date {
			var d:Date	=	new Date();
			d.setTime(obj * 1000);
			return d;
		}
	}
}//end class
//This template is created by whohoo. ver 1.1.0

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]

		[Inspectable(defaultValue="", type="String", verbose="0", name="_targetInstanceName", category="")]
		private var _targetInstanceName:String;

*/
