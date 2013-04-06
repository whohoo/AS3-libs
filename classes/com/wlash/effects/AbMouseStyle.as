/*utf8*/
//**********************************************************************************//
//	name:	MouseStyle 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Jan 04 2010 17:58:30 GMT+0800
//	description: This file was created by "collection.fla" file.
//				
//**********************************************************************************//


//[com.wlash.puma.damouth.MouseStyle]
package com.wlash.effects {

	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	
	
	/**
	 * MouseStyle.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AbMouseStyle extends MovieClip {
		
		protected var _style:Object	=	"default";
		
		protected var _prevStyle:Object	=	"default";
		protected var _styleFrames:Object;
		protected var _stage:Stage;
		
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set style(value:Object):void {
			changeStyle(value);
			
		}
		/**mouse style */
		public function get style():Object { return _style };
		
		
		//*************************[READ ONLY]**************************************//
		/**prevous mouse style*/
		public function get prevStyle():Object { return _prevStyle; }
		
		//*************************[STATIC]*****************************************//
		//protected var _instance:AbMouseStyle;
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new MouseStyle();]
		 * @param value
		 */
		public function AbMouseStyle() {
			stop();
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		public function setStage(value:Stage):void {
			_stage	=	value;
		}
		
		public function show(value:Object):void {
			removeMouseStyle();
			if(_stage){
				_stage.addChild(this);
			}
			setVisible(true);
			
			changeStyle(value);
			
			//addEventListener(Event.ENTER_FRAME, _onRender, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onRender, false, 0, true);
			_onRender(null);
		}
		
		public function hide():void {
			removeMouseStyle();
			setVisible(false);
		}
		
		public function destroy():void {
			//removeEventListener(Event.ENTER_FRAME, _onRender);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onRender);
		}
		
		public function changeStyle(value:Object):void {
			if (value == _style)	return;
			
			var fr:Object;
			if (value is Number) {
				fr	=	value;
				if (fr<1 || fr>totalFrames)	
					throw new Error("ERROR: AbMouseStyle | ChangeSytle out of frames: value = " + value+", totalFrames: "+totalFrames);
			}else if (value) {
				fr	=	_styleFrames[value.toString()];
				if(!fr){
					switch(value) {
						case "default":
						case "normal":
							defautStyleFn();
							_style	=	value;
							return;
						break;
						default:
							throw new Error("ERROR: AbMouseStyle | ChangeSytle NULL: value = " + value);
					}
				}
			}else {
				throw new Error("ERROR: AbMouseStyle | ChangeSytle NULL: value = " + value);
			}
			
			setVisible(true);
			gotoAndStop(fr);
			_prevStyle	=	_style;
			_style	=	value;
		}
		
		public function onFrameEnd(mc:DisplayObject):void {
			
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		protected function defautStyleFn():void {
			setVisible(false);
		}
		
		protected function removeMouseStyle():void {
			destroy();
			if(_stage){
				_stage.removeChild(this);
			}
		}
		
		protected function setVisible(value:Boolean):void {
			if (value) {
				visible	=	true;
				Mouse.hide();
			}else {
				visible	=	false;
				Mouse.show();
			}
		}
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			//name	=	"__mouseStyle__";
			_styleFrames	=	{ };
			mouseChildren	=	
			mouseEnabled	=	false;
			var obj:Array	=	currentLabels;
			for each(var o:FrameLabel in obj) {
				_styleFrames[o.name]	=	o.frame;
			}
		}
		
		private function _onRender(e:MouseEvent):void {
			if(e!=null)		e.updateAfterEvent();
			x	=	root.mouseX;
			y	=	root.mouseY;
		}
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.puma.damouth.MouseStyle]
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
