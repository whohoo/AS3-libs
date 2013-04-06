/*utf8*/
//**********************************************************************************//
//	name:	ScrollBar_srcMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Sun Jun 21 2009 12:50:33 GMT+0800
//	description: This file was created by "ScrollBar_src.fla" file.
//		
//**********************************************************************************//



package  {

	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import com.wlash.scroll.SimpleScrollBar;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * ScrollBar_srcMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class ScrollBar_srcMain extends MovieClip {
		
		public var scroll1_mc:Sprite;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM
		public var scroll_com:SimpleScrollBar;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM
		public var click_btn:SimpleButton;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM

		
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ScrollBar_srcMain();]
		 */
		public function ScrollBar_srcMain() {
			
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
			scroll_com.addEventListener(SimpleScrollBar.SCROLL, onScroll);
			scroll_com.addEventListener(SimpleScrollBar.ACTIVE_SCROLL, onActScroll);
			click_btn.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void {
			scroll_com.scrollBar	=	scroll1_mc;
			scroll_com.active		=	true;
		}
		
		private function onActScroll(e:Event):void {
			trace( "onActScroll : scroll is actived"  );
			
		}
		
		private function onScroll(e:Event):void {
			trace(scroll_com.percent, scroll_com.curValue);
		}
		
				
		
		

		
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
