/*utf8*/
//**********************************************************************************//
//	name:	FlipNumber 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Dec 28 2009 17:51:38 GMT+0800
//	description: This file was created by "sucai.fla" file.
//				
//**********************************************************************************//


//[com.wlash.effects.FlipNumber]
package com.wlash.effects {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * FlipNumber.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class FlipNumber extends MovieClip {
		
		public var up_num:MovieClip;//LAYER NAME: "up_num", FRAME: [1-6], PATH: FlipNumber
		public var up_num2:MovieClip;//LAYER NAME: "up_num2", FRAME: [1-11], PATH: FlipNumber
		public var down_num:MovieClip;//LAYER NAME: "down_num", FRAME: [6-11], PATH: FlipNumber
		public var down_num2:MovieClip;//LAYER NAME: "down_num2", FRAME: [1-10], PATH: FlipNumber

		protected var _changeMaxFr:uint;
		
		protected var _currentNum:uint;
		protected var _nextNum:uint;
		//*************************[READ|WRITE]*************************************//
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		public function set num(value:uint):void {
			change(value);
		}
		
		/**Annotation*/
		public function get num():uint { return _currentNum; }
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new FlipNumber();]
		 */
		public function FlipNumber() {
			_changeMaxFr	=	2;
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		public function setNumber(value:uint):Boolean {
			if (value == _currentNum)	return false;
			if (value > 9)	value	=	0;
			if (currentFrame == 1) {
				_nextNum	=	
				_currentNum	=	value;
				value++;
				up_num.gotoAndStop(value);
				down_num2.gotoAndStop(value);
				return true;
			}else {
				return false;
			}
		}
		
		public function change(value:uint):Boolean {
			if (value == _currentNum)	return false;
			if (currentFrame > _changeMaxFr) {
				return false;
			}else {
				if (value > 9)	value	=	0;
				_nextNum	=	value;
				value++;
				if (currentFrame > 1 && up_num2!=null) {
					up_num2.gotoAndStop(value);
				}
				play();
				return true;
			}
		}
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		protected function init():void {
			_currentNum	=	_nextNum;
			up_num.gotoAndStop(_currentNum+1);
			down_num2.gotoAndStop(_currentNum+1);
			stop();
		}
		
		protected function _changeUpNum2():void {
			up_num2.gotoAndStop(_nextNum + 1);
		}
		
		protected function _changeDownNum():void {
			down_num.gotoAndStop(_nextNum + 1);
		}
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
			
		}
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.effects.FlipNumber]
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
