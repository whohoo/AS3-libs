/*utf8*/
//**********************************************************************************//
//	name:	PlaneDisplayObject 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Sat May 02 2009 10:35:41 GMT+0800
//	description: This file was created by "cube.fla" file.
//		
//**********************************************************************************//



package com.wlash.as3d {

	import flash.events.Event;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Plane;
	
	/**
	 * PlaneDisplayObject.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class PlaneDisplayObject extends DisplayObject3D {
		private var _material:MaterialObject3D;
		private var segmentsW:Number;
		private var segmentsH:Number;
		
		internal var initX:Number;
		internal var initY:Number;
		internal var initZ:Number;
		internal var initPlaneX:Number;
		internal var initPlaneY:Number;
		internal var initPlaneZ:Number;
		
		internal var initRotationX:Number;
		internal var initRotationY:Number;
		internal var initRotationZ:Number;
		internal var initPlaneRotationX:Number;
		internal var initPlaneRotationY:Number;
		internal var initPlaneRotationZ:Number;
		
		public var plane:Plane;
		public var index:int;
		public var planeContainer:DisplayObject3D;
		
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set planeX(value:Number):void {
			plane.x	=	value;
		}
		/**Annotation*/
		public function get planeX():Number { return plane.x; }
		
		/**@private */
		public function set planeY(value:Number):void {
			plane.y	=	value;
		}
		/**Annotation*/
		public function get planeY():Number { return plane.y; }
		
		/**@private */
		public function set planeZ(value:Number):void {
			plane.z	=	value;
		}
		/**Annotation*/
		public function get planeZ():Number { return plane.z; }
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new PlaneDisplayObject();]
		 */
		public function PlaneDisplayObject( material:MaterialObject3D=null, width:Number=0, height:Number=0, segmentsW:Number=0, segmentsH:Number=0 ) {
			super(null, null);
			_material		=	material;
			this.segmentsW 	= segmentsW || 1; // Defaults to 1
			this.segmentsH 	= segmentsH || this.segmentsW;   // Defaults to segmentsW
			
			_init();
			var scale :Number = 1;
	
			if( ! height ){
				if( width ){
					scale = width;
				}
				if( material && material.bitmap ){
					width  = material.bitmap.width  * scale;
					height = material.bitmap.height * scale;
				}else{
					width  = 500 * scale;
					height = 500 * scale;
				}
			}
			plane	=	_buildPlane(width, height);
			addChild(plane);
		}
		//*************************[PUBLIC METHOD]**********************************//
		

		
		//*************************[INTERNAL METHOD]********************************//
		internal function setInitData():void {
			initX			=	x;
			initY			=	y;
			initZ			=	z;
			initPlaneX		=	planeX;
			initPlaneY		=	planeY;
			initPlaneZ		=	planeZ;
			
			initRotationX		=	rotationX;
			initRotationY		=	rotationY;
			initRotationZ		=	rotationZ;
			initPlaneRotationX	=	plane.rotationX;
			initPlaneRotationY	=	plane.rotationY;
			initPlaneRotationZ	=	plane.rotationZ;
		}
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
		}
		
		
		private function _buildPlane(width:Number, height:Number):Plane {
			var plane:Plane	=	new Plane(_material, width, height, segmentsW, segmentsH);
			return plane;
		}
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}


//end class
//This template is created by whohoo. ver 1.2.1

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]



*/
