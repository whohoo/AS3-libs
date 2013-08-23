/*utf8*/
//**********************************************************************************//
//	name:	ComboxSeason 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Wed Feb 24 2010 11:38:16 GMT+0800
//	description: This file was created by "media.fla" file.
//				
//**********************************************************************************//


//[com.wlash.etam.media.AbCombox]
package com.wlash.effects {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	
	
	/**
	 * ComboxSeason.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AbBaseCombox extends MovieClip {
		public var name_txt:TextField;//LAYER NAME: "name_txt", FRAME: [1-7], PATH: 元件 14 副本
		public var down_btn:Sprite;//LAYER NAME: "arrow", FRAME: [1-7], PATH: 元件 14 副本

		protected var _delayCloseSec:Number		=	500;
		protected var _isBack:Boolean;
		private var _interId:int;
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set active(value:Boolean):void {
			mouseChildren	=	
			mouseEnabled	=	value;
		}
		
		//*************************[READ ONLY]**************************************//
		public function get selectedLabel():String { return name_txt.text; }
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ComboxSeason();]
		 */
		public function AbBaseCombox() {
			name_txt.mouseEnabled	=	false;
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		
		//*************************[INTERNAL METHOD]********************************//
		public function open():void {
			_isBack	=	false;
			
		}
		
		public function close():void {
			removeEventListener(MouseEvent.ROLL_OVER, _onOver);
			removeEventListener(MouseEvent.ROLL_OUT, _onOut);
			if (stage) {
				stage.removeEventListener(MouseEvent.CLICK, _onClickStage);
			}
			clearInterval(_interId);
			_isBack	=	true;
			
		}
		
		public function reset():void {
			_isBack	=	false;
		}
		//*************************[PROTECTED METHOD]*******************************//
		protected function onInit():void {
			removeEventListener(MouseEvent.CLICK, _onClick);
			buttonMode	=	false;
		}
		
		protected function onEnd():void {
			stop();
			addEventListener(MouseEvent.ROLL_OVER, _onOver);
			addEventListener(MouseEvent.ROLL_OUT, _onOut);
			if (stage) {
				stage.addEventListener(MouseEvent.CLICK, _onClickStage);
			}
		}
		
		protected function _onClose():void {
			addEventListener(MouseEvent.CLICK, _onClick);
			buttonMode	=	true;
		}
		
		protected function _onSelectItem():void {
			
			dispatchEvent(new Event("choose"));
		}
		
		protected function _onOver(e:MouseEvent):void {
			clearInterval(_interId);
		}
		
		protected function _onOut(e:MouseEvent):void {
			_interId	=	setTimeout(close, _delayCloseSec);
		}
		
		protected function _onClick(e:MouseEvent):void {
			open();
		}
		
		protected function _onClickStage(e:MouseEvent):void {
			if (hitTestPoint(root.mouseX, root.mouseY, true)) {
				
			}else {
				close();
			}
			
		}
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			stop();
			_onClose();
		}
		
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.etam.media.ComboxSeason]
//This template is created by whohoo. ver 1.3.0

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]

		[Inspectable(defaultValue="", type="String", verbose="1", name="_targetInstanceName", category="")]
		private var _targetInstanceName:String;


*/
