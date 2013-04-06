/*utf8*/
//**********************************************************************************//
//	name:	LocalConn 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Aug 24 2009 14:51:00 GMT+0800
//	description: This file was created by "as3.fla" file.
//				
//**********************************************************************************//


//[com.wlash.data.LocalConn]
package com.wlash.data {

	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	
	/**
	 * LocalConn.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class LocalConn extends LocalConnection {
		
		
		private var _connName:String;
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new LocalConn();]
		 * @private connName 
		 * @private listenerName
		 */
		public function LocalConn(connName:String, listenerName:String = null) {
			_connName	=	connName;
			if (listenerName) {
				connect(listenerName);
			}
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		public function call(methodName:String, respond:Object = null, ... args:*):void {
			//note, function无法传递过去
			var fnName:String;
			if (respond is String) {
				fnName	=	String(respond);
				if(typeof (client[fnName])=="function"){
					args.push(respond);
				}else {
					throw new Error("function : " + fnName + "can't found in " + client);
				}
			}else if(respond is Object){
				if (typeof(respond['result']) == "function") {
					args.push(respond['result']);
				}
				if (typeof(respond['status']) == "function") {
					args.push(respond['status']);
				}
			}
			
		
			switch (args.length) {
				case 0:
					send(_connName, methodName);
				break;
				case 1:
					send(_connName, methodName, args[0]);
				break;
				case 2:
					send(_connName, methodName, args[0], args[1]);
				break;
				case 3:
					send(_connName, methodName, args[0], args[1], args[2]);
				break;
				case 4:
					send(_connName, methodName, args[0], args[1], args[2], args[3]);
				break;
				case 5:
					send(_connName, methodName, args[0], args[1], args[2], args[3], args[4]);
				break;
				case 6:
					send(_connName, methodName, args[0], args[1], args[2], args[3], args[4], args[5]);
				break;
				case 7:
					send(_connName, methodName, args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
				break;
				case 8:
					send(_connName, methodName, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
				break;
				case 9:
					send(_connName, methodName, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
				break;
				case 10:
					send(_connName, methodName, args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]);
				break;
				default:
					throw new Error("args length exceed 8, current value is "+args.length);
			}
		}
		
		/**
		 * Show class name.
		 * @return class name
		 */
		override public function toString():String {
			return super.toString();
		}

		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			//addEventListener(StatusEvent.STATUS, _onStatus);
		}
		
		//private function _onStatus(e:StatusEvent):void {
			//switch(e.level) {
				//case "status":
					//
				//break;
				//case "warning":
					//
				//break;
				//case "error":
					//
				//break;
				//
			//}
		//}
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.data.LocalConn]
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
