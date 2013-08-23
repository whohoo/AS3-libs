/*utf8*/
//**********************************************************************************//
//	name:	ImageShot 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Jun 27 2011 19:45:59 GMT+0800
//	description: This file was created by "imageShot.fla" file.
//				
//**********************************************************************************//


//[com.wlash.tools.ImageShot]
package com.wlash.tools {

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	
	
	/**
	 * ImageShot.
	 * <p>架在图片上可调整(移动,放大,缩小框)的框,可对框内的图片进行截取</p>
	 * 
	 */
	public class ImageShot extends Sprite {
		
		public var leftUpPoint_mc:Sprite;//LAYER NAME: "points", FRAME: [1-2], PATH: 调整框
		public var rightUp_mc:Sprite;//LAYER NAME: "points", FRAME: [1-2], PATH: 调整框
		public var leftDown_mc:Sprite;//LAYER NAME: "points", FRAME: [1-2], PATH: 调整框
		public var scaleBar_btn:MovieClip;//LAYER NAME: "scale bar", FRAME: [1-2], PATH: 调整框
		public var frame_mc:Sprite;//LAYER NAME: "frame", FRAME: [1-2], PATH: 调整框
		public var bg_mc:Sprite;//LAYER NAME: "bg", FRAME: [1-2], PATH: 调整框

		private var _bounds:Rectangle;
		private var _onMouseMovingFn:Function;
		private var _pressPoint:Point;
		
		private var _fixedRatio:Number;
		private var _framePostionBounds:Rectangle;
		private var _pressObj:Sprite;
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set active(value:Boolean):void {
			mouseChildren	=	
			mouseEnabled	=	value;
		}
		
		/**Annotation*/
		public function get bounds():Rectangle { return _bounds.clone(); }
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		public function set bounds(value:Rectangle):void {
			_bounds	=	value.clone();
			_framePostionBounds	=	value.clone();
			_framePostionBounds.right	-=	frame_mc.width;
			_framePostionBounds.bottom	-=	frame_mc.height;
		}
		
		/** width / height, default 0 mean free scale*/
		public function get fixedRatio():Number { return _fixedRatio; }
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		public function set fixedRatio(value:Number):void {
			_fixedRatio	=	value;
			if (value > 0) {
				setFrameSize(frame_mc.width, frame_mc.height / value);
			}
		}
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ImageShot();]
		 */
		public function ImageShot() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		public function getFrameBounds(value:DisplayObject):Rectangle {
			return frame_mc.getBounds(value);
		}
		
		public function getImageBitmapData(image:DisplayObject, smoothing:Boolean = false):BitmapData {
			//trace(image.transform.concatenatedMatrix, image.transform.matrix);
			var bmp:BitmapData	=	new BitmapData(frame_mc.width, frame_mc.height, true);
			var matrix:Matrix	=	new Matrix();
			var rect:Rectangle	=	getFrameBounds(image);
			matrix.tx	=	-rect.x;
			matrix.ty	=	-rect.y;
			var trans:Transform	=	image.transform;
			matrix.scale(trans.concatenatedMatrix.a, trans.concatenatedMatrix.d)
			//rect		=	null;
			bmp.draw(image, matrix, null, null, null, smoothing);
			return bmp;
		}
		
		public function setFrameSize(width:Number, height:Number):void {
			_onMouseMoveScaleBar(frame_mc.x + width, frame_mc.y + height);
		}
		
		public function destroy():void {
			scaleBar_btn.removeEventListener(MouseEvent.MOUSE_DOWN, _onPressBtn, false);
			scaleBar_btn.removeEventListener(MouseEvent.ROLL_OVER, _onRollOverBtn, false);
			scaleBar_btn.removeEventListener(MouseEvent.ROLL_OUT, _onRollOutBtn, false);
			
			frame_mc.removeEventListener(MouseEvent.MOUSE_DOWN, _onPressBtn, false);
			frame_mc.removeEventListener(MouseEvent.ROLL_OVER, _onRollOverFrame, false);
			frame_mc.removeEventListener(MouseEvent.ROLL_OUT, _onRollOutFrame, false);
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onReleaseBtn);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			bounds	=	new Rectangle( -0xFFFF >> 1, -0xFFFF >> 1, 0xFFFF, 0xFFFF);
			fixedRatio	=	1;
			//_bounds : (x=-65535, y=-65535, w=65535, h=65535)
			//_bounds : (x=4.9406564584124654e-324, y=4.9406564584124654e-324, w=1.79769313486231e+308, h=1.79769313486231e+308)
			_initBtnEvents();
			scaleBar_btn.cacheAsBitmap	=	true;
			_pressPoint	=	new Point();
		}
		
		private function _onMouseMoveScaleBar(mx:Number, my:Number):void {
			var leftPoint:Number	=	frame_mc.x + scaleBar_btn.width;
			var upPoint:Number		=	frame_mc.y + scaleBar_btn.height;
			
			var posX:Number	=	mx < leftPoint ? leftPoint : (mx>_bounds.right ? _bounds.right : mx);
			var posY:Number	=	my < upPoint ? upPoint : (my>_bounds.bottom ? _bounds.bottom : my);
			
			if (_fixedRatio>0) {
				if (posX / posY > _fixedRatio) {
					posX	=	(posY - frame_mc.y) * _fixedRatio + frame_mc.x;
					if (posX > _bounds.right) {
						return;
					}
				}else {
					posY	=	(posX - frame_mc.x) / _fixedRatio + frame_mc.y;
					if (posY > _bounds.bottom) {
						return;
					}
				}
			}
			scaleBar_btn.x	=	posX;
			scaleBar_btn.y	=	posY;
			
			frame_mc.width	=	scaleBar_btn.x-frame_mc.x;
			frame_mc.height	=	scaleBar_btn.y-frame_mc.y;
			
			bg_mc.scaleX	=	frame_mc.scaleX;
			bg_mc.scaleY	=	frame_mc.scaleY;
			
			rightUp_mc.x	=	scaleBar_btn.x;
			leftDown_mc.y	=	scaleBar_btn.y;
			
			_framePostionBounds.right	=	_bounds.width - frame_mc.width;
			_framePostionBounds.bottom	=	_bounds.height - frame_mc.height;
		}
		
		private function _onMouseMoveFrame(mx:Number, my:Number):void {
			
			//frame_mc.x	=	mx < _framePostionBounds.left ? _framePostionBounds.left : (mx > _framePostionBounds.right ? _framePostionBounds.right : mx);
			//frame_mc.y	=	my < _framePostionBounds.top ? _framePostionBounds.top : (my > _framePostionBounds.bottom ? _framePostionBounds.bottom : my);
			var isOutBounds:Boolean;
			var outBoundsDir:String	=	"";
			var posX:Number;
			if (mx < _framePostionBounds.left) {
				posX	=	_framePostionBounds.left;
				isOutBounds	=	true;
				outBoundsDir	+=	"left,";
			}else if(mx>_framePostionBounds.right){
				posX	=	_framePostionBounds.right;
				isOutBounds	=	true;
				outBoundsDir	+=	"right,";
			}else {
				posX	=	mx;
			}
			
			var posY:Number;
			if (my < _framePostionBounds.top) {
				posY	=	_framePostionBounds.top;
				isOutBounds	=	true;
				outBoundsDir	+=	"top,";
			}else if(my>_framePostionBounds.bottom){
				posY	=	_framePostionBounds.bottom;
				isOutBounds	=	true;
				outBoundsDir	+=	"bottom,";
			}else {
				posY	=	my;
			}
			
			if (isOutBounds) {
				dispatchEvent(new StatusEvent("out_bounds", false, false, outBoundsDir.substring(0, outBoundsDir.length-1)));
			}
			
			frame_mc.x	=	posX;
			frame_mc.y	=	posY;
			
			leftUpPoint_mc.x	=	frame_mc.x;
			leftUpPoint_mc.y	=	frame_mc.y;
			
			rightUp_mc.x		=	frame_mc.x+frame_mc.width;
			rightUp_mc.y		=	frame_mc.y;
			
			leftDown_mc.x		=	frame_mc.x;
			leftDown_mc.y		=	frame_mc.y + frame_mc.height;
			
			scaleBar_btn.x		=	rightUp_mc.x;
			scaleBar_btn.y		=	leftDown_mc.y;
			
			bg_mc.x				=	frame_mc.x;
			bg_mc.y				=	frame_mc.y;
		}
		
		///////////////////////////////Begin Initialize Buttons/////////////////////////////////////////
		/**
		 * initialize SimpleButton events.
		 * @internal AUTO created by JSFL.
		 */
		private function _initBtnEvents():void {
			scaleBar_btn.addEventListener(MouseEvent.MOUSE_DOWN, _onPressBtn, false);
			scaleBar_btn.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtn, false);
			scaleBar_btn.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtn, false);
			//scaleBar_btn.buttonMode	=	true;
			scaleBar_btn.stop();
			
			frame_mc.addEventListener(MouseEvent.MOUSE_DOWN, _onPressBtn, false);
			frame_mc.addEventListener(MouseEvent.ROLL_OVER, _onRollOverFrame, false);
			frame_mc.addEventListener(MouseEvent.ROLL_OUT, _onRollOutFrame, false);
		};
		
		private function _onPressBtn(e:MouseEvent):void {
			var mc:Sprite	=	e.currentTarget as Sprite;
			_pressObj		=	mc;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, _onReleaseBtn);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_pressPoint.x	=	mouseX - mc.x;
			_pressPoint.y	=	mouseY - mc.y;
			if (mc == scaleBar_btn) {
				_onMouseMovingFn	=	_onMouseMoveScaleBar;
			}else {
				_onMouseMovingFn	=	_onMouseMoveFrame;
			}
		};
		
		private function _onMouseMove(e:MouseEvent):void {
			var mx:Number	=	mouseX - _pressPoint.x;
			var my:Number	=	mouseY - _pressPoint.y;
			_onMouseMovingFn(mx, my);
		}
		
		private function _onReleaseBtn(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onReleaseBtn);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			
		}
		
		private function _onRollOverBtn(e:MouseEvent):void {
			if (_pressObj != scaleBar_btn)	return;
			scaleBar_btn.gotoAndStop(2);
		};
		
		private function _onRollOutBtn(e:MouseEvent):void {
			scaleBar_btn.gotoAndStop(1);
		};
		
		private function _onRollOverFrame(e:MouseEvent):void {
			if (_pressObj != frame_mc)	return;
			Mouse.cursor	=	MouseCursor.HAND;
		};
		
		private function _onRollOutFrame(e:MouseEvent):void {
			Mouse.cursor	=	MouseCursor.AUTO;
		};
		///////////////////////////////End Initialize Buttons/////////////////////////////////////////

		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.tools.ImageShot]
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
