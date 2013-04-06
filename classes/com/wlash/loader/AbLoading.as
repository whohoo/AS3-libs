//******************************************************************************
//	name:	Loading 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Sat Aug 23 2008 14:38:21 GMT+0800
//	description: This file was created by "magazine.fla" file.
//		
//******************************************************************************



package com.wlash.loader {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	
	[IconFile("Loading.png")]
	/**
	 * Loading.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AbLoading extends MovieClip {
		
		protected var _percent:Number;
		protected var _onHideFn:Function;
		protected var _onShowFn:Function;
		//************************[READ|WRITE]************************************//
		/**@private */
		public function set percent(value:Number):void {
			//var p:int	=	Math.round(value * 100);
			_percent	=	value;
		}
		
		/**Annotation*/
		public function get percent():Number { return _percent; }
		//************************[READ ONLY]*************************************//
		
		
		//************************[STATIC]****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br></br>
		 * Create a class BY [new Loading();]
		 */
		public function AbLoading() {
			
			_init();
		}
		
		//************************[PRIVATE METHOD]*********************************//
		/**
		 * Initializtion this class
		 * 
		 */
		private function _init():void {
			visible	=	false;
			percent	=	0;
			stop();
		}
		
		
		//***********************[INTERNAL METHOD]**********************************//
		
		//***********************[PROTECTED METHOD]*********************************//
		protected function _onShow():void {
			if (_onShowFn != null) {
				_onShowFn();
			}
		}
		
		protected function _onHide():void {
			visible	=	false;
			if (_onHideFn != null) {
				_onHideFn();
			}
		}
		
		//***********************[PUBLIC METHOD]***********************************//
		public function show(fn:Function=null):void {
			if (visible)	return;
			visible	=	true;
			_onShowFn	=	fn;
		}
		
		public function hide(fn:Function=null):void {
			if (!visible)	return;
			_onHideFn	=	fn;
			
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

		[Inspectable(defaultValue="", type="String", verbose="0", name="_targetInstanceName", category="")]
		private var _targetInstanceName:String;

*/
