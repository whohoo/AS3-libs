/*utf8*/
//**********************************************************************************//
//	name:	Cube 1.0 FAIL!!!!!!!!!
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Dec 22 2009 15:27:19 GMT+0800
//	description: This file was created by "coverFlip2.fla" file.
//				FAIL
//**********************************************************************************//


//[com.wlash.as3d.Cube]
package com.wlash.as3d {

	import flash.display.Sprite;
	import com.wlash.as3d.SimplePaper;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	
	
	
	/**
	 * Cube.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class Cube extends Sprite {
		
		public var v3d:Vector3D;
		
		public var front_mc:SimplePaper;//LAYER NAME: "front", FRAME: [1-2], PATH: flipCover
		public var left_mc:SimplePaper;//LAYER NAME: "left", FRAME: [1-2], PATH: flipCover
		public var right_mc:SimplePaper;//LAYER NAME: "right", FRAME: [1-2], PATH: flipCover
		public var back_mc:SimplePaper;//LAYER NAME: "back", FRAME: [1-2], PATH: flipCover

		private var mcArr/*SimplePaper*/:Array;
		
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set angleY(value:Number):void {
			v3d.angleY	=	value;
			front_mc.angleY	=	value;
			right_mc.angleY =	value + 270;
			back_mc.angleY =	value + 180;
			left_mc.angleY =	value + 90;
		}
		
		/**Annotation*/
		public function get angleY():Number { return v3d.angleY; }
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new Cube();]
		 */
		public function Cube() {
			mcArr	=	[front_mc, right_mc, back_mc, left_mc];
			v3d		=	new Vector3D();
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		public function rotate(value:Number, clockwise:Boolean=true):void {
			TweenLite.to(this, 1, {angleY:value, onUpdate:render } );
		}
		
		public function render():void {
			for (var i:int = 0; i < 4; i++) {
				mcArr[i].render();
			}
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
			front_mc.z3	=	10;
			back_mc.z3	=	-10;
			left_mc.x3	=	-232.5;
			right_mc.x3	=	232.5;
			
			right_mc.angleY	=	90;
			back_mc.angleY	=	180;
			left_mc.angleY	=	270;
			render();
		}
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.as3d.Cube]
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
