/*utf8*/
//**********************************************************************************//
//	name:	TextMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Thu Apr 21 2011 11:13:48 GMT+0800
//	description: This file was created by "text.fla" file.
//				
//**********************************************************************************//


//[.TextMain]
package  {

	import com.wlash.text.WText;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * TextMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class TextMain extends MovieClip {
		
		private var wText:WText;
		
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new TextMain();]
		 */
		public function TextMain() {
			
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
			wText	=	new WText();
			addChild(wText);
		}
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [.TextMain]
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
