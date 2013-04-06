/*utf8*/
//**********************************************************************************//
//	name:	RectangleDefined 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Thu May 07 2009 11:32:39 GMT+0800
//	description: This file was created by "game.fla" file.
//		
//**********************************************************************************//



package com.wlash.game {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	
	
	/**
	 * RectangleDefined.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AbstractDefined extends Sprite {
		
		
		[Inspectable(defaultValue="false", verbose="0", type="Boolean", category="")]
		public var fixed:Boolean		=	false;
		
		[Inspectable(defaultValue="1", verbose="0", type="Number", category="")]
		public var mass:Number			=	1;
		
		[Inspectable(defaultValue="0.3", verbose="0", type="Number", category="")]
		public var elasticity:Number	=	0.3;
		
		[Inspectable(defaultValue="0", verbose="0", type="Number", category="")]
		public var friction:Number		=	0;
		
		[Inspectable(defaultValue="", verbose="0", type="String", category="")]
		public var groupName:String		=	"";
		
		[Inspectable(defaultValue="", verbose="0", type="String", category="")]
		public var 	springConstraintTo:String		=	"";
		
		public var particle:*;
		
		public var connected:Array;
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		/**Annotation*/
		public function get position2():Point {
			var p:Point	=	new Point(x, y);
			p	=	parent.localToGlobal(p);
			p	=	parent.parent.globalToLocal(p);
			return p;
		}
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new AbstractDefined();]
		 */
		public function AbstractDefined() {
			visible		=	false;
			connected	=	[];
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
