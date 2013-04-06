/*utf8*/
//**********************************************************************************//
//	name:	AMFsenderMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Wed Sep 23 2009 23:49:26 GMT+0800
//	description: This file was created by "AMFsender.fla" file.
//				
//**********************************************************************************//


//[.AMFsenderMain]
package  {

	import com.wlash.data.AMFsender;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * AMFsenderMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AMFsenderMain extends MovieClip {
		
		public var out_txt:TextField;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM

		private var amfSender:AMFsender;
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new AMFsenderMain();]
		 */
		public function AMFsenderMain() {
			amfSender	=	new AMFsender("", "http://localhost:8080/Tutorial_Server/service");
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
			
		}
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [.AMFsenderMain]
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
