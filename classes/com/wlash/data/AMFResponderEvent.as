//******************************************************************************
//	name:	AMFResponderEvent 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Jun 17 2008 14:14:53 GMT+0800
//	description: This file was created by "score_board_sender.fla" file.
//		
//******************************************************************************



package com.wlash.data {
	
	import flash.events.Event;
	import flash.events.TextEvent;
	
	
	
	/**
	 * AMFResponderEvent.
	 * <p>call respond</p>
	 * 
	 */
	public class AMFResponderEvent extends Event {

		public var respondObj:*; 
		
		//************************[READ|WRITE]************************************//
		
		
		//************************[READ ONLY]*************************************//
		
		static public const DEFAULT_RESULT:String		=	"defaultResult";
		static public const ERROR_STATUS:String			=	"errorStatus";
		
		
		/**
		 * Construction function.<br></br>
		 * Create a class BY [new AMFResponderEvent();]
		 */
		public function AMFResponderEvent(type:String, respondObj:*) {
			super(type, false, false);
			this.respondObj	=	respondObj;
			init();
		}
		
		//************************[PRIVATE METHOD]********************************//
		/**
		 * Initializtion this class
		 * 
		 */
		private function init():void{
			
		}
		
		
		//***********************[PUBLIC METHOD]**********************************//
		
		
		/**
		 * 重定义输出的格式。
		 * @return [Event=AMFResponderEvent, type=, respondObj=]
		 */
		override public function toString():String {
			return formatToString("AMFResponderEvent", "type", "respondObj");
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function clone():Event {
			return new AMFResponderEvent(type, respondObj);
		}
		
		
		//***********************[STATIC METHOD]**********************************//
		
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


*/
