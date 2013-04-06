/*utf8*/
//**********************************************************************************//
//	name:	Loading2 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Thu May 27 2010 14:06:42 GMT+0800
//	description: This file was created by "loading2.fla" file.
//				
//**********************************************************************************//


//[.Loading1]
package  com.wlash.loader{

	import com.wlash.loader.AbLoading;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
	
	/**
	 * Loading2.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class Loading1 extends AbLoading {
		
		public var percent_txt:TextField;//LAYER NAME: "text", FRAME: [2-3], PATH: loading folder/loading

		
		
		//*************************[READ|WRITE]*************************************//
		//override public function get percent():Number { return super.percent; }
		
		override public function set percent(value:Number):void {
			super.percent = value;
			var p:int	=	Math.round(value * 100);
			percent_txt.text	=	(p > 9 ? "" + p : "0" + p) + "%";
		}
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new Loading2();]
		 */
		public function Loading1() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		override public function show(fn:Function=null):void {
			super.show(fn);
			gotoAndStop(2);
		}
		
		override public function hide(fn:Function = null):void {
			super.hide(fn);
			gotoAndStop(1);
			_onHide();
		}
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
		}
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [.Loading2]
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
