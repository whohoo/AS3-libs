/*utf8*/
//**********************************************************************************//
//	name:	WText 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Thu Apr 21 2011 11:08:11 GMT+0800
//	description: This file was created by "text.fla" file.
//				
//**********************************************************************************//


//[com.wlash.text.WText]
package com.wlash.text {

	import flash.display.Sprite;
	import flash.events.Event;
	
	
	
	/**
	 * WText.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class WText extends Sprite {
		
		
		
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new WText();]
		 */
		public function WText() {
			
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
			var char:Character	=	new Character(20062);
			addChild(char);
		}
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.text.WText]
//This template is created by whohoo. ver 1.3.0

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]



*/
