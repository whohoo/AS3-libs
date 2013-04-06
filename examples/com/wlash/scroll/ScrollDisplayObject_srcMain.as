/*utf8*/
//**********************************************************************************//
//	name:	ScrollDisplayObject_srcMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Jun 23 2009 00:43:56 GMT+0800
//	description: This file was created by "ScrollDisplayObject_src.fla" file.
//		
//**********************************************************************************//



package  {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import com.wlash.scroll.ScrollDisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * ScrollDisplayObject_srcMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class ScrollDisplayObject_srcMain extends MovieClip {
		
		public var scroll1_mc:Sprite;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM
		public var click_btn:SimpleButton;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM
		public var scroll_com:ScrollDisplayObject;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM
		public var image_mc:Sprite;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM

		
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ScrollDisplayObject_srcMain();]
		 */
		public function ScrollDisplayObject_srcMain() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			_initBtnEvents();
		}
		
		/**
		 * initialize SimpleButton events.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _initBtnEvents():void {
			click_btn.addEventListener(MouseEvent.CLICK, _onClickBtn, false, 0, false);
			click_btn.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtn, false, 0, false);
			click_btn.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtn, false, 0, false);
			
		};
		
		/**
		 * SimpleButton click event.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _onClickBtn(e:MouseEvent):void {
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "click_btn" : 
					//trace('eventType: ' + e.type + ', name: ' + click_btn.name);//remove this line with Ctrol+Shift+D
					scroll_com.maskHeight	=	100;
					scroll_com.scrollTarget	=	image_mc;
					scroll_com.update();
				break;
			};
		};
		
		/**
		 * SimpleButton rollover event.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _onRollOverBtn(e:MouseEvent):void {
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "click_btn" : 
					//trace('eventType: ' + e.type + ', name: ' + click_btn.name);//remove this line with Ctrol+Shift+D
					
				break;
			};
		};
		
		/**
		 * SimpleButton rollout event.
		 * @internal AUTO created by JSFL.
		 */
		private function _onRollOutBtn(e:MouseEvent):void {
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "click_btn" : 
					//trace('eventType: ' + e.type + ', name: ' + click_btn.name);//remove this line with Ctrol+Shift+D
					
				break;
			};
		};

		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class
//This template is created by whohoo. ver 1.2.1

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
