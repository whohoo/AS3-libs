/*utf8*/
//**********************************************************************************//
//	name:	SimpleCube 1.0 
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Dec 22 2009 15:27:19 GMT+0800
//	description: This file was created by "coverFlip2.fla" file.
//					up
//		left       front    	right
//				   down
//**********************************************************************************//


//[com.wlash.as3d.Cube]
package com.wlash.as3d {

	import flash.display.MovieClip;
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
	public class SimpleCube extends Sprite {
		
		public var v3d:Vector3D;
		
		public var viewDist:Number	=	800;

		protected var _actX:Array	=	[ -1, 1, 1, -1, -1, 1, 1, -1];
		protected var _actY:Array	=	[ 1, 1, -1, -1, 1, 1, -1, -1];
		protected var _actZ:Array	=	[ -1, -1, -1, -1, 1, 1, 1, 1];
		
		
		
		private var _width3:Number	=	100;
		private var _height3:Number	=	100;
		private var _depth3:Number	=	100;
		
		protected var p0:Vector3D;//left up front
		protected var p1:Vector3D;//right up front
		protected var p2:Vector3D;//right down front
		protected var p3:Vector3D;//left down front
		protected var p4:Vector3D;//left up back
		protected var p5:Vector3D;//right up back
		protected var p6:Vector3D;//right down back
		protected var p7:Vector3D;//left down back
		
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set angleX(value:Number):void {
			_transAngleXYZ(value, "angleX");
			v3d.angleX	=	value;
		}
		/**Annotation*/
		public function get angleX():Number { return v3d.angleX; }
		
		/**@private */
		public function set angleY(value:Number):void {
			_transAngleXYZ(value, "angleY");
			v3d.angleY	=	value;
		}
		/**Annotation*/
		public function get angleY():Number { return v3d.angleY; }
		
		/**@private */
		public function set angleZ(value:Number):void {
			_transAngleXYZ(value, "angleZ");
			v3d.angleZ	=	value;
		}
		/**Annotation*/
		public function get angleZ():Number { return v3d.angleZ; }
		
		/**@private */
		public function set width3(value:Number):void {
			_transWHD(value, "x", _actX);
			_width3	=	value;
			
			
		}
		
		/**Annotation*/
		public function get width3():Number { return _width3; }
		
		/**@private */
		public function set height3(value:Number):void {
			_transWHD(value, "y", _actY);
			_height3	=	value;
			
		}
		/**Annotation*/
		public function get height3():Number { return _height3; }
		
		/**@private */
		public function set depth3(value:Number):void {
			_transWHD(value, "z", _actZ);
			_depth3	=	value;
			
		}
		/**Annotation*/
		public function get depth3():Number { return _depth3; }
		
		/**@private */
		public function set x3(value:Number):void {
			_transXYZ(value, "x");
			v3d.x	=	value;
			
		}
		/**Annotation*/
		public function get x3():Number { return v3d.x; }
		
		/**@private */
		public function set y3(value:Number):void {
			_transXYZ(value, "y");
			v3d.y	=	value;
			
		}
		/**Annotation*/
		public function get y3():Number { return v3d.y; }
		
		/**@private */
		public function set z3(value:Number):void {
			_transXYZ(value, "z");
			v3d.z	=	value;
			
		}
		/**Annotation*/
		public function get z3():Number { return v3d.z; }
		
		
		//*************************[READ ONLY]**************************************//
		public function get frontSide():Array {
			return [p0, p1, p2, p3];
		}
		
		public function get backSide():Array {
			return [p5, p4, p7, p6];
		}
		
		public function get leftSide():Array {
			return [p4, p0, p3, p7];
		}
		
		public function get rightSide():Array {
			return [p1, p5, p6, p2];
		}
		
		public function get topSide():Array {
			return [p4, p5, p1, p0];
		}
		
		public function get bottomSide():Array {
			return [p3, p2, p6, p7];
		}
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new Cube();]
		 */
		public function SimpleCube() {
			
			v3d		=	new Vector3D();
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		
		public function render():void {
			
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		protected function getPresProjectVector3D(v:Vector3D):Vector3D {
			var pp:Vector3D	=	v.getClone();
			var prep:Number	=	pp.getPerspective(viewDist);
			pp.persProject(prep);
			pp.y	=	-pp.y;
			return pp;
		}
		
		protected function sideTo2D(side:Array):Array {
			var len:int	=	side.length;
			var arr:Array	=	[];
			for (var i:int = 0; i < len; i++) {
				var v:Vector3D	=	side[i];
				arr.push(getPresProjectVector3D(v));
			}
			return arr;
		}
		
		protected function getCenterPoint(v0:Vector3D, v1:Vector3D):Vector3D {
			var v:Vector3D	=	v0.minusNew(v1);
			v.scale(.5);
			v.plus(v1);
			return v;
		}
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			var w2:Number	=	_width3 * .5;
			var h2:Number	=	_height3 * .5;
			var d2:Number	=	_depth3 * .5;
			for (var i:int = 0; i < 8; i++) {
				this["p" + i]	=	new Vector3D(w2 * _actX[i], h2 * _actY[i], d2 * _actZ[i]);
			}
			//p0	=	new Vector3D( -w2, h2, -d2);//left top front
			//p1	=	new Vector3D( w2, h2, -d2);//right top front
			//p2	=	new Vector3D( w2, -h2, -d2);//right bottom front
			//p3	=	new Vector3D( -w2, -h2, -d2);//left bottom front
			//p4	=	new Vector3D( -w2, h2, d2);//left top back
			//p5	=	new Vector3D( w2, h2, d2);//right top back
			//p6	=	new Vector3D( w2, -h2, d2);//right bottom back
			//p7	=	new Vector3D( -w2, -h2, d2);//left bottom back
			
		}
		
		private function _transWHD( value:Number, prop:String, act:Array):void {
			var num2:Number	=	value * .5;
			var v:Vector3D	=	v3d;
			for (var i:int = 0; i < 8; i++) {
				var p:Vector3D	=	this["p" + i];
				p.minus(v);
				p[prop]	=	num2 * act[i];
				p.plus(v);
			}
			
		}
		
		private function _transXYZ( value:Number, prop:String):void {
			var num:Number	=	value - v3d[prop];
			for (var i:int = 0; i < 8; i++) {
				var p:Vector3D	=	this["p" + i];
				p[prop]	+=	num;
			}
		}
		
		private function _transAngleXYZ( value:Number, prop:String):void {
			var num:Number	=	value;
			var v:Vector3D	=	v3d;
			for (var i:int = 0; i < 8; i++) {
				var p:Vector3D	=	this["p" + i];
				p.minus(v);
				p[prop]	=	num;
				p.plus(v);
			}
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
