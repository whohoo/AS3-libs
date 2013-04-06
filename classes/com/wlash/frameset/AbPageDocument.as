/*utf8*/
//**********************************************************************************//
//	name:	Qa 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Feb 02 2010 19:41:11 GMT+0800
//	description: This file was created by "about.fla" file.
//				
//**********************************************************************************//


//[com.wlash.etam.AbPageDocument]
package com.wlash.frameset {

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * Qa.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AbPageDocument extends MovieClip {
		
		private var _pause:Boolean;
		
		protected var _onShowFn:Function;
		protected var _onHideFn:Function;
		
		protected var _loadPercent:Number;
		
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set active(value:Boolean):void {
			mouseChildren	=	
			mouseEnabled	=	value;
		}
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		public function set pause(value:Boolean):void {
			_pause	=	value;
		}
		
		/**Annotation*/
		public function get pause():Boolean { return _pause; }
		//*************************[READ ONLY]**************************************//
		/**Annotation*/
		public function get loadPercent():Number { return _loadPercent; }
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new Qa();]
		 */
		public function AbPageDocument() {
			_loadPercent	=	1;
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		public function showWithoutPlay():void { 
			visible	=	true;
		}
		
		public function show(fn:Function=null):void { 
			_onShowFn	=	fn;
			visible		=	true;
		}
				
		public function hide(fn:Function=null):void { 
			_onHideFn	=	fn;
		}
		
		public function destroy():void {
			
		}
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		protected function _onShow():void {
			active	=	true;
			if (_onShowFn != null) 	_onShowFn();
		}
		
		protected function _onHide():void {
			visible	=	false;
			active	=	true;
			if (_onHideFn != null) 	_onHideFn();
		}
		
		protected function _singleTest():void {
			if (parent != null) {
				addEventListener(Event.ENTER_FRAME, function(e:Event) {
						removeEventListener(Event.ENTER_FRAME, arguments.callee);
						show();
					} );
			}
		}
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			visible	=	false;
			_singleTest();
		}
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.etam.about.Qa]
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
