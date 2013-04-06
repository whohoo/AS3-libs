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
package  {

	import com.wlash.effects.AbMouseStyle;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	
	
	/**
	 * MouseStyle.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class MouseStyle extends AbMouseStyle {
		
		
		
		//*************************[READ|WRITE]*************************************//
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new MouseStyle();]
		 */
		public function MouseStyle(value:Stage) {
			super(value);
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
			_styleFrames.default	=	1;
			_styleFrames.cross		=	1;
			_styleFrames.left_right	=	2;
			_styleFrames.up_down	=	3;
			_styleFrames.close		=	4;
			_styleFrames.zoom_in	=	5;
			_styleFrames.zoom_out	=	6;
			
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
