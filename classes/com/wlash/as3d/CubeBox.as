/*utf8*/
//**********************************************************************************//
//	name:	CubeBox 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Sat May 02 2009 10:35:41 GMT+0800
//	description: This file was created by "cube.fla" file.
//		
//**********************************************************************************//



package com.wlash.as3d {

	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	//import gs.TweenLite;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Plane;
	
	/**
	 * CubeBox.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class CubeBox extends DisplayObject3D {
		private var _materials:MaterialsList;
		private var _insideFaces:int;
		private var _excludeFaces:int;
		private var segments:Number3D;
		
		private var _interactive:Boolean;
			
		public var planes:PlanesContainer;
		
		//*************************[READ|WRITE]*************************************//
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		public function set interactive(value:Boolean):void {
			var names:Array	=	CUBE_NAMES;
			var len:int	=	6;
			for (var i:int = 0; i < len; i++) {
				_getMaterial(names[i]).interactive	=	value;
				
			}
			_interactive	=	value;
		}
		/**Annotation*/
		public function get interactive():Boolean { return interactive; }
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		static public const CUBE_NAMES:Array	=	['front', 'back', 'right', 'left', 'top', 'bottom' ];
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new CubeBox();]
		 */
		public function CubeBox( materials:MaterialsList, width:Number = 500, depth:Number = 500, height:Number = 500, 
								segmentsS:int=1, segmentsT:int=1, segmentsH:int=1, insideFaces:int=0, excludeFaces:int=0 ) {
			super(null, null);
			_materials	=	materials;
			_insideFaces  = insideFaces;
			_excludeFaces = excludeFaces;
			segments = new Number3D( segmentsS, segmentsT, segmentsH );
			
			planes	=	new PlanesContainer();
			_buildCube(width, height, depth);
			
			_init();	
		}
		//*************************[PUBLIC METHOD]**********************************//
		public function openBox(fn:Function = null):void {
			var tweenLiteClass:Class	=	getDefinitionByName("gs.TweenLite") as Class;
			if(tweenLiteClass){
				tweenLiteClass["to"](planes.front, 1, { rotationX:90 } );
				tweenLiteClass["to"](planes.back, 1, { rotationX:-90 } )
				
				tweenLiteClass["to"](planes.left, 1, { rotationZ:90 } );
				tweenLiteClass["to"](planes.right, 1, { rotationZ:-90 } );
				
				tweenLiteClass["to"](planes.top, 1, { rotationZ:90, onComplete:fn, onCompleteParams:[this]} );
			}else {
				planes.front.rotationX	=	90;
				planes.back.rotationX	=	-90;
				planes.left.rotationX	=	90;
				planes.right.rotationX	=	-90;
				planes.top.rotationX	=	90;
				if (fn != null) {
					fn(this);
				}
			}
			
		}
		
		public function closeBox(fn:Function = null):void {
			var tweenLiteClass:Class	=	getDefinitionByName("gs.TweenLite") as Class;
			if(tweenLiteClass){
				tweenLiteClass["to"](planes.front, 1, { rotationX:0 } );
				tweenLiteClass["to"](planes.back, 1, { rotationX:0 } );
				
				tweenLiteClass["to"](planes.left, 1, { rotationZ:0 } );
				tweenLiteClass["to"](planes.right, 1, { rotationZ:0 } );
				
				tweenLiteClass["to"](planes.top, 1, { rotationZ:0, onComplete:fn, onCompleteParams:[this] } );
			}else {
				planes.front.rotationX	=	0;
				planes.back.rotationX	=	0;
				planes.left.rotationX	=	0;
				planes.right.rotationX	=	0;
				planes.top.rotationX	=	0;
				if (fn != null) {
					fn(this);
				}
			}
		}
		
		public function addListener(type:String = null, listener:Function = null, useCapture:Boolean = false, 
											priority:int = 0, useWeakReference:Boolean = false):void {
			var names:Array	=	CUBE_NAMES;
			var len:int	=	6;
			for (var i:int = 0; i < len; i++) {
				var plane:Plane	=	planes[names[i]].plane;
				plane.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
			
		}
		public function removeListener(type:String = null, listener:Function = null, useCapture:Boolean = false):void {
			var names:Array	=	CUBE_NAMES;
			var len:int	=	6;
			for (var i:int = 0; i < len; i++) {
				var plane:Plane	=	planes[names[i]].plane;
				plane.removeEventListener(type, listener, useCapture);
			}
		}

		
		//*************************[INTERNAL METHOD]********************************//
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
		}
		
		private function _buildCube(width:Number, height:Number, depth:Number):void {
			var width2  :Number = width  /2;
			var height2 :Number = height /2;
			var depth2  :Number = depth  / 2;
			var plane:PlaneDisplayObject;
			var planeName:String;
			////////////////Build planes
			planeName	=	"front";
			plane		=	_buildPlane( planeName, "x", "y", width, height, depth2 );
			planes[planeName]		=	plane;
			addChild(plane, planeName);
			plane.z					=	depth2;
			plane.setInitData();
			
			planeName	=	"back";
			plane	=	_buildPlane( planeName, "x", "y", width, height, -depth2 );
			planes[planeName]		=	plane;
			addChild(plane, planeName);
			plane.z					=	-depth2;
			plane.setInitData();
			
			planeName	=	"right";
			plane		=	_buildPlane( planeName, "z", "y", depth, height, width2 );
			planes[planeName]		=	plane;
			addChild(plane, planeName);
			plane.plane.rotationY	=	-90;
			plane.x					=	width2;
			plane.setInitData();
			
			planeName	=	"left";
			plane		=	_buildPlane( planeName, "z", "y", depth, height, -width2 );
			planes[planeName]	=	plane;
			addChild(plane, planeName);
			plane.plane.rotationY	=	90;
			plane.x					=	-width2;
			plane.setInitData();
			
			planeName	=	"bottom";
			plane		=	_buildPlane( planeName, "x", "z", width, depth, -height2 );
			planes[planeName]	=	plane;
			addChild(plane, planeName);
			plane.plane.rotationX	=	-90;
			plane.planeY			=	0;
			plane.setInitData();
			
			planeName	=	"top";
			plane		=	_buildPlane( planeName, "x", "z", width, depth, height2);
			planes[planeName]		=	plane;
			planes.left.addChild(plane, planeName);
			plane.planeY		=	0;
			plane.y				=	0;
			plane.y				=	height;
			plane.planeX		=	depth2;
			plane.plane.rotationX	=	-90;
			plane.setInitData();
			
		}
		
		private function _buildPlane(mat:String, u:String, v:String, width:Number, height:Number, depth:Number):PlaneDisplayObject {
			var matInstance:MaterialObject3D	=	_getMaterial(mat);
			matInstance.registerObject(this); // needed for the shaders.
			matInstance.doubleSided	=	true;
			//trace( "matInstance.oneSide : " + matInstance.oneSide, matInstance.doubleSided );
			// Find w depth axis
			var w :String;
			if( (u=="x" && v=="y") || (u=="y" && v=="x") ) w = "z";
			else if( (u=="x" && v=="z") || (u=="z" && v=="x") ) w = "y";
			else if ( (u == "z" && v == "y") || (u == "y" && v == "z") ) w = "x";
			var gridU:Number 	= segments[ u ];
			var gridV:Number 	= segments[ v ];
			
			var height2:Number	=	height / 2;
			var plane:PlaneDisplayObject	=	new PlaneDisplayObject(matInstance, width, height, gridU, gridV);
			plane.planeY		=	height2;
			plane.y				=	-height2;
			plane.name			=	mat;
			plane.planeContainer	=	this;
			return plane;
		}
		
		private function _getMaterial(mName:String):MaterialObject3D {
			var mat:MaterialObject3D	=	_materials.getMaterialByName(mName);
			if (!mat) {
				throw new Error("materialObject3D did not find in _materials. [" + mName + "]");
			}
			return mat;
		}

		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}
import com.wlash.as3d.PlaneDisplayObject;

class PlanesContainer extends Object {
	public var front:PlaneDisplayObject;
	public var back:PlaneDisplayObject;
	public var left:PlaneDisplayObject;
	public var right:PlaneDisplayObject;
	public var top:PlaneDisplayObject;
	public var bottom:PlaneDisplayObject;
	
	public function PlanesContainer() {
		
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
