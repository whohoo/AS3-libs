/*utf8*/
//**********************************************************************************//
//	name:	AMFData 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Sep 28 2009 14:24:10 GMT+0800
//	description: This file was created by "AMFData.fla" file.
//				
//**********************************************************************************//


//[com.wlash.data.AMFData]
package com.wlash.data {

	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	
	
	/**
	 * AMFData.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AMFData extends Object {
		
		
		
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new AMFData();]
		 */
		public function AMFData() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//

		/**
		 * get URLRequest, put all arguments to ByteArray with AMF format,
		 * @param	url the post url
		 * @param	...args
		 * @return	URLRequest
		 */
		static public function getURLRequest(url:String, ...args:*):URLRequest {
			var req:URLRequest	=	new URLRequest(url);
			req.method			=	"post";
			req.contentType		=	"application/x-gzip-compressed";
			
			var byte:ByteArray	=	new ByteArray();
			var len:int	=	args.length;
			byte.writeShort(len);
			for (var i:int = 0; i < len; i++) {
				byte.writeObject(args[i]);
			}
			//byte.compress();
			req.data	=	byte;
			return req;
		}
		
		/**
		 * get response object
		 * @param	byte
		 * @return	Object
		 */
		static public function getResponse(byte:ByteArray):Object {
			byte.uncompress();
			return byte.readObject() as Object;
		}
		
		/**
		 * Show class name.
		 * @return class name
		 */
		public function toString():String {
			return "AMFData 1.0";
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
		}
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.data.AMFData]
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
