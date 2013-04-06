//******************************************************************************
//	name:	FlipPagesEvent 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Tue Jun 17 2008 14:14:53 GMT+0800
//	description: This file was created by "score_board_sender.fla" file.
//		
//******************************************************************************



package com.wlash.effects {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	
	
	/**
	 * FlipPagesEvent.
	 * <p>FlipPagesBox广播事件</p>
	 * 
	 */
	public class FlipPagesEvent extends Event {

		public var flipPage:FlipPage;
		public var page:Sprite; 
		public var range:Object;
		/**if state is true, mean rear page is created or removed.*/
		public var isRearPage:Boolean; 
		public var width:Number;
		public var height:Number;
		public var x:Number;
		public var y:Number;
		public var flipToFace:Boolean;
		public var dragButton:String;
		//************************[READ|WRITE]************************************//
		
		
		//************************[READ ONLY]*************************************//
		
		static public const REMOVE_PAGE:String			=	"onRemovePage";
		static public const CREATE_PAGE:String			=	"onCreatePage";
		static public const ADJUST_PAGE:String			=	"onAdjustPage";
		static public const SET_FLIP_AREA:String		=	"onSetFlipArea";
		static public const RESIZE_PAGE:String			=	"onResizePage";
		static public const START_FLIP:String			=	"onStartFlip";
		static public const STOP_FLIP:String			=	"onStopFlip";
		static public const PRESS_FLIP:String			=	"onPressFlip";
		static public const ROLL_OVER_FLIP:String		=	"onRollOverFlip";
		static public const ROLL_OUT_FLIP:String		=	"onRollOutFlip";
		static public const RELEASE_FLIP:String			=	"onReleaseFlip";
		static public const FINISH_FLIP:String			=	"onFinishFlip";
		static public const MOVE_PAGE:String			=	"onMovePage";
		static public const DRAG_PAGE:String			=	"onDragPage";
		
		
		/**
		 * Construction function.<br></br>
		 * Create a class BY [new AMFResponderEvent();]
		 * @param type
		 * @param page
		 */
		public function FlipPagesEvent(type:String, page:FlipPage) {
			super(type, false, false);
			flipPage	=	page;

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
		 * @return [Event=scrollEvent, type=activeScroll, delta=xx]
		 */
		override public function toString():String {
			return formatToString("FlipPagesEvent", "type", "flipPage", "page");
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
