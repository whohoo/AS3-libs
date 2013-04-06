/*utf8*/
//**********************************************************************************//
//	name:	FrameToBitmap 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Fri May 22 2009 10:37:21 GMT+0800
//	description: This file was created by "scene_change.fla" file.
//		
//**********************************************************************************//


//[com.wlash.video.FrameToBitmap]
package com.wlash.video {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	
	
	/**
	 * FrameToBitmap.
	 * <p>把此MC中的每一帧转为bitmapdata,保存在数组当中.</p>
	 * 
	 */
	public class FrameToBitmap extends MovieClip {
		/**
		 * transparent the background
		 * @default false
		 */
		public var transparent:Boolean;
		/**
		 * smoothing
		 * @default false
		 */
		public var smoothing:Boolean;
		/**
		 * the jpg quality
		 * @default 90
		 */
		public var jpgQuality:int		=	90;
		
		private var _encodeClass:Class;
		private var _jpgEncode:Object;
		private var _bmpMode:String		=	"bmp";
		
		private var _renderWidth:Number;
		private var _renderHeight:Number;
		
		private var _matrix:Matrix		=	new Matrix();
		private var _colorTransform:ColorTransform;
		private var _blendMode:String;
		private var _clipRect:Rectangle	=	new Rectangle();
		
		private var __state:String;
		
		private var _framesCache:Array;
		private var _targetFrame:int;
		private var _scale:Number		=	1;
		
		//*************************[READ|WRITE]*************************************//
		/**@private */
		protected function set framesCache(value:Array):void {
			_framesCache	=	value;	
		}
		protected function get framesCache():Array {return _framesCache;}
		
		protected function set _state(value:String):void {
			if (__state == value)	return;
			__state	=	value;
		}
		
		/**@private */
		public function set clipRect(value:Rectangle):void {
			_clipRect		=	value.clone();
			_renderWidth	=	_clipRect.width;
			_renderHeight	=	_clipRect.height;
		}
		/**Annotation*/
		public function get clipRect():Rectangle { return _clipRect.clone(); }
		
		/**@private */
		public function set matrix(value:Matrix):void {
			_matrix		=	value.clone();
		}
		/**Annotation*/
		public function get matrix():Matrix { return _matrix; }
		
		public function set scale(value:Number):void {
			_scale			=	value;
			_matrix.scale(value, value);
			_renderWidth	*=	value;
			_renderHeight	*=	value;
			_clipRect.width	 =	_renderWidth;
			_clipRect.height =	_renderHeight;
		}
		
		/**Annotation*/
		public function get scale():Number { return _scale; }
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/** @private */
		public function set bmpMode(value:String):void {
			_bmpMode	=	value;
		}
		/**parse bitmapdata to jpg or png, default is bmp*/
		public function get bmpMode():String { return _bmpMode; }
		//*************************[READ ONLY]**************************************//
		/**the state*/
		public function get state():String { return __state; }
		
		/**parse frame percent*/
		public function get cachePercnet():Number { return _framesCache.length / totalFrames; }
		
		public function get bitmaps():Array { return _framesCache.concat(); };
		//*************************[STATIC]*****************************************//
		static public const FINISH:String		=	"finish";
		static public const BMP:String			=	"bmp";
		static public const PNG:String			=	"png";
		static public const JPG:String			=	"jpg";
		static public const BYTE:String			=	"byte";
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new FrameToBitmap();]
		 */
		public function FrameToBitmap() {
			super.stop();
			_framesCache	=	[];
			_init();
			
			//rebuildCache();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		/**
		 * build frames cache
		 */
		public function rebuildCache(value:Number=0):void {
			clear();
			scale	=	value || _scale;
			_encodeClass	=	null;
			_jpgEncode		=	null;
			switch(_bmpMode) {
				case "jpg":
					try{
						_encodeClass	=	getDefinitionByName("com.adobe.images.JPGEncoder") as Class;
						_jpgEncode		=	new _encodeClass(jpgQuality);
					}catch (err:Error) {
						throw new Error("ERROR: com.adobe.images.JPGEncoder is not exist.");
					}
				break;
				case "png":
					try{
						_encodeClass	=	getDefinitionByName("com.adobe.images.PNGEncoder") as Class;
					}catch (err:Error) {
						throw new Error("ERROR: com.adobe.images.PNGEncoder is not exist.");
					}
				break;
				case "byte":
					//empty
				break;
				default:
					_bmpMode	=	"bmp";
			}
			
			addEventListener(Event.ENTER_FRAME, _onCache, false, 0, true);
			_state			=	"cache";
		}
		
		/**
		 * set ClipRect
		 * @param	x    
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		public function setClipRect(x:Number, y:Number, width:Number, height:Number):void {
			_clipRect	=	new Rectangle(x, y, width, height);
		}
		
		/**
		 * stop cache
		 */
		public function stopCache():void {
			removeEventListener(Event.ENTER_FRAME, _onCache);
		}
		
		public function clear():void {
			stopCache();
			_framesCache	=	[];
		}
		
		public function setBlendMode(value:String):void {
			_blendMode	=	value;
		}
		
		public function getBlendMode():String {
			return _blendMode;
		}
		
		public function destroy():void {
			
			var len:int	=	_framesCache.length;
			for (var i:int = 0; i < len; i++) {
				var bmp:*	=	_framesCache.shift();
				if (bmp is BitmapData) {
					bmp.dispose();
				}else if (bmp is ByteArray) {
					bmp.clear();
				}
			}
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		protected function getBmpCache():BitmapData {
			//trace( "getBmpCache : " + this.name, super.currentFrame, System.totalMemory/1024/1024);
			try{
				var bmp:BitmapData	=	new BitmapData(_renderWidth, _renderHeight, transparent, 0x0);
			}catch (err:Error) {
				//trace( "getBmpCache : " + err );
				trace( "getBmpCache : " + this.name, super.currentFrame, super.totalFrames, System.totalMemory / 1024 / 1024);
				stopCache();
			}
			bmp.draw(this, _matrix, _colorTransform, _blendMode, _clipRect, smoothing);

			return bmp;
		}
		
		
		protected function _onCache(e:Event):void {
			if (_framesCache.length == super.currentFrame-1) {
				var img:ByteArray;
				var bmp:BitmapData	=	getBmpCache();
				switch(_bmpMode) {
					case "bmp":
						_framesCache[super.currentFrame-1]	=	bmp;
					break;
					case "jpg":
						img		=	_jpgEncode.encode(bmp);
						_framesCache[super.currentFrame-1]	=	img;
						bmp.dispose();
					break;
					case "png":
						img		=	_encodeClass["encode"](bmp);
						_framesCache[super.currentFrame-1]	=	img;
						bmp.dispose();
					break;
					case "byte":
						img		=	bmp.getPixels(_clipRect);
						//img.compress();
						_framesCache[super.currentFrame-1]	=	img;
						bmp.dispose();
					break;
				}
			}
			
			if (super.currentFrame == super.totalFrames) {
				_state	=	"done";
				stopCache();
				dispatchEvent(new Event(FINISH));
				super.stop();
			}else if (framesLoaded > super.currentFrame ) {
				super.gotoAndStop(super.currentFrame + 1);
			}
		}
	
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			clipRect		=	getBounds(this);
			_matrix			=	new Matrix();
		}
		
		private function _onRenderFinish():void {
			_state	=	"done";
			dispatchEvent(new Event(FINISH));
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

		[Inspectable(defaultValue="", type="String", verbose="1", name="_targetInstanceName", category="")]
		private var _targetInstanceName:String;

		
		public function rebuildCache(value:uint=0):void {
			_framesCache	=	[];
			value	=	value || autoRenderFrames;
			value	=	value || totalFrames;
			doubleBuildCache(value, _onRenderFinish);
		}

*/
