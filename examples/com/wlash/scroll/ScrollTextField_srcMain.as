/*utf8*/
//**********************************************************************************//
//	name:	ScrollTextField_srcMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Jun 22 2009 21:39:08 GMT+0800
//	description: This file was created by "ScrollTextField_src.fla" file.
//		
//**********************************************************************************//



package  {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import com.wlash.scroll.ScrollTextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;
	
	
	/**
	 * ScrollTextField_srcMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class ScrollTextField_srcMain extends MovieClip {
		
		public var scroll_com:ScrollTextField;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM
		public var input_txt:TextField;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM
		public var scroll1_mc:Sprite;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM
		public var click_btn:SimpleButton;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM
		
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ScrollTextField_srcMain();]
		 */
		public function ScrollTextField_srcMain() {
			
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
			click_btn.addEventListener(MouseEvent.CLICK, onClick);
		}
		
				
		private function onClick(e:MouseEvent):void {
			scroll_com.scrollBar	=	scroll1_mc;
			scroll_com.scrollTarget	=	input_txt;
			scroll_com.update();
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
