/*utf8*/
//**********************************************************************************//
//	name:	AbstractSWF 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Feb 02 2010 15:27:13 GMT+0800
//	description: This file was created by "legal_terms.fla" file.
//				
//**********************************************************************************//


//[com.wlash.loader.AbstractSWF]
package com.wlash.loader {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * AbstractSWF.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AbstractSWF extends MovieClip {
		public var _isTest:Boolean;
		
		
		
		
		
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set active(value:Boolean):void {
			mouseChildren	=	
			mouseEnabled	=	value;
		}
		
		//*************************[READ ONLY]**************************************//
		/**Annotation*/
		public function get loadPercent():Number { return 1; }
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new LegaTermsMain();]
		 */
		public function AbstractSWF() {
			visible		=	false;
			
			_init();
			
			if (parent != null) {
				_isTest	=	true;
				_test();
			}
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		public function destroy():void {
			
		}
		
		public function show(fn:Function = null, ...args:*):void { 
			visible	=	true;
			_onShowFn(fn);
		}
				
		public function hide(fn:Function = null, ...args:*):void { 
			_onHideFn(fn);
		}
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		protected function _onShowFn(fn:Function):void {
			active	=	true;
			if (fn != null) 	fn();
		}
		
		protected function _onHideFn(fn:Function):void {
			visible	=	false;
			active	=	true;
			if (fn != null) 	fn();
		}
		
		
		//*************************[PROTECTED METHOD]*******************************//
		protected function _test():void {
			
			show();
		}
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
		}
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.loader.AbstractSWF]
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
