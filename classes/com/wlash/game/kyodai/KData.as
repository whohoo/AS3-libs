/*utf8*/
//**********************************************************************************//
//	name:	KData 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Jun 21 2010 11:52:06 GMT+0800
//	description: This file was created by "Kyodai.fla" file.
//				
//**********************************************************************************//


//[com.wlash.game.kyodai.KData]
package com.wlash.game.kyodai {

	import flash.events.Event;
	
	
	
	/**
	 * Kyodai.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class KData extends Object {
		
		public var data:*;
		public var colIndex:int;
		public var rowIndex:int
		public var state:int;//0 means empty
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new KData();]
		 */
		public function KData(row:int, col:int, s:int=0) {
			rowIndex	=	row;
			colIndex	=	col;
			state		=	s;
			
			_init();
		}
		
		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * Show class name.
		 * @return class name
		 */
		public function toString():String {
			return "KData|r: " + rowIndex + ", c: " + colIndex + ", s: " + state;
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
	
}//end class [com.wlash.game.kyodai.KData]
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
