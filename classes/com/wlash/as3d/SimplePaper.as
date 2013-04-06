/*utf8*/
//**********************************************************************************//
//	name:	SimplePaper 1.1
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Dec 22 2009 15:25:25 GMT+0800
//	description: This file was created by "coverFlip2.fla" file.
//				v1.1 增加smoothing与isRenderNow两属性
//**********************************************************************************//


//[com.wlash.as3d.SimplePaper]
package com.wlash.as3d {

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import com.wlash.as3d.Vector3D;
	import flash.geom.Rectangle;
	import sandy.util.DistortImage;
	
	/**
	 * Paper.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class SimplePaper extends Sprite {
		
		
		public var v3d:Vector3D;
		public var setpX:int	=	2;
		public var setpY:int	=	2;
		
		public var viewDist:Number	=	800;
		
		protected var p0:Vector3D;//left up
		protected var p1:Vector3D;//right up
		protected var p2:Vector3D;//right down
		protected var p3:Vector3D;//left down
		
		protected var bmp:BitmapData;
		protected var disImage:DistortImage;
		protected var container:Sprite;
		
		protected var _imageMc:DisplayObject;
		private var _isRenderNow:Boolean;
		
		//*************************[READ|WRITE]*************************************//
		
		/**@private */
		public function set isRenderNow(value:Boolean):void {
			_isRenderNow	=	value;
			render();
		}
		
		/**Annotation*/
		public function get isRenderNow():Boolean { return _isRenderNow; }
		
		/**@private */
		public function set smoothing(value:Boolean):void {
			disImage.smooth	=	value;
		}
		
		/**Annotation*/
		public function get smoothing():Boolean { return disImage.smooth; }
	
		/**@private */
		public function set angleX(value:Number):void {
			v3d.angleX	=	value;
			for (var i:int = 0; i < 4; i++) {
				var p:Vector3D	=	this["p" + i];
				p.angleX	=	value;
			}
			render();
		}
		
		/**Annotation*/
		public function get angleX():Number { return v3d.angleX; }
		
		/**@private */
		public function set angleY(value:Number):void {
			v3d.angleY	=	value;
			for (var i:int = 0; i < 4; i++) {
				var p:Vector3D	=	this["p" + i];
				p.angleY	=	value;
			}
			render();
		}
		
		/**Annotation*/
		public function get angleY():Number { return v3d.angleY; }
		
		/**@private */
		public function set angleZ(value:Number):void {
			v3d.angleZ	=	value;
			for (var i:int = 0; i < 4; i++) {
				var p:Vector3D	=	this["p" + i];
				p.angleZ	=	value;
			}
			render();
		}
		
		/**Annotation*/
		public function get angleZ():Number { return v3d.angleZ; }
		
		/**@private */
		public function set x3(value:Number):void {
			var v:Vector3D	=	new Vector3D(value-v3d.x, 0, 0);
			v3d.x	=	value;
			for (var i:int = 0; i < 4; i++) {
				var p:Vector3D	=	this["p" + i];
				p.plus(v);
			}
			render();
		}
		
		/**Annotation*/
		public function get x3():Number { return v3d.x; }
		
		/**@private */
		public function set y3(value:Number):void {
			var v:Vector3D	=	new Vector3D(0, value-v3d.y, 0);
			v3d.y	=	value;
			for (var i:int = 0; i < 4; i++) {
				var p:Vector3D	=	this["p" + i];
				p.plus(v);
			}
			render();
		}
		
		/**Annotation*/
		public function get y3():Number { return v3d.y; }
		
		/**@private */
		public function set z3(value:Number):void {
			var v:Vector3D	=	new Vector3D(0, 0, value-v3d.z);
			v3d.z	=	value;
			for (var i:int = 0; i < 4; i++) {
				var p:Vector3D	=	this["p" + i];
				p.plus(v);
			}
			render();
		}
		
		/**Annotation*/
		public function get z3():Number { return v3d.z; }
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new Paper();]
		 */
		public function SimplePaper() {
			_imageMc			=	getChildAt(0);
			_imageMc.visible	=	false;
			_isRenderNow		=	true;
			_init();
		}
		
		
		//*************************[PUBLIC METHOD]**********************************//
		public function updateBitmap():void {
			if (disImage.texture) {
				disImage.texture.dispose();
			}
			bmp	=	new BitmapData(_imageMc.width, _imageMc.height, true, 0xffffff);
			bmp.draw(_imageMc);
			disImage.target	=	bmp;
			disImage.initialize(setpX, setpY);
		}
		
		public function render():void {
			if (!_isRenderNow)	return;
			var pp0:Vector3D	=	getPresProjectVector3D(p0);
			var pp1:Vector3D	=	getPresProjectVector3D(p1);
			var pp2:Vector3D	=	getPresProjectVector3D(p2);
			var pp3:Vector3D	=	getPresProjectVector3D(p3);

			disImage.setTransform(pp0.x, pp0.y, 
								pp1.x, pp1.y, 
								pp2.x, pp2.y, 
								pp3.x, pp3.y);
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		protected function getPresProjectVector3D(v:Vector3D):Vector3D {
			var pp:Vector3D	=	v.getClone();
			var prep:Number	=	pp.getPerspective(viewDist);
			pp.persProject(prep);
			return pp;
		}
		
		protected function initVector3D():void {
			var w2:Number	=	_imageMc.width * .5;
			var h2:Number	=	_imageMc.height * .5;
			p0	=	new Vector3D(-w2, -h2, 0);
			p1	=	new Vector3D(w2, -h2, 0);
			p2	=	new Vector3D(w2, h2, 0);
			p3	=	new Vector3D(-w2, h2, 0);
			//trace(p0, p1, p2, p3);
		}
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			v3d	=	new Vector3D();
			initVector3D();
			
			container	=	addChild(new Sprite()) as Sprite;
			container.x	=	_imageMc.width * .5;
			container.y	=	_imageMc.height * .5;
			
			disImage	=	new DistortImage();
			disImage.container	=	container;
			
			updateBitmap();
			
			render();
		}
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.as3d.Paper]
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
