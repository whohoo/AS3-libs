/*utf8*/
//**********************************************************************************//
//	name:	BitmapsPlayback 1.1
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Fri May 22 2009 10:37:21 GMT+0800
//	description: This file was created by "scene_change.fla" file.
//		v1.1 增加了move360, moveTO两方法
//**********************************************************************************//


//[com.wlash.video.BitmapsPlayback]
package com.wlash.video {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	
	
	/**
	 * BitmapsPlayback.
	 * <p>对于bitmaps数组的播放.</p>
	 * 
	 */
	public class BitmapsPlayback extends Sprite {
		
		public var pixelSnapping:String		=	"auto";
		
		private var _smoothing:Boolean;
		private var _currentFrame:int;
		private var __actframe:Number;
		private var _targetFrame:int;
		private var _playDir:int;
		private var _speed:Number;
		private var _onFinishPlayFn:Function;
		private var _presentBmp:Bitmap;
		private var __state:String;
		private var _bmpMode:String;//bmp, jpg, png, byte
		private var _rectangle:Rectangle;
		
		private var _loop360Fn:Function;
		private var _tFrame360:int;
		private var _speed360:Number;
		
		public var currentLabels:Array;
		
		protected var framesCache:Array;
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set smoothing(value:Boolean):void {
			_smoothing	=	value;
		}
		/**Annotation*/
		public function get smoothing():Boolean { return _smoothing; }
		
		/**@private */
		public function set currentFrame(value:int):void {
			if (value < 1) {
				value	=	1;
			}else if (value > totalFrames) {
				value	=	totalFrames;
			}
			var img:ByteArray;
			switch(_bmpMode) {
				case "jpg":
				case "png":
					img	=	framesCache[value-1];
					
				break;
				case "byte":
					img	=	framesCache[value-1];
					var bmp:BitmapData	=	new BitmapData(_rectangle.width, _rectangle.height, false, 0x0);
					img.position	=	0;
					bmp.setPixels(_rectangle, img);
					_presentBmp.bitmapData	=	bmp;
					_presentBmp.smoothing	=	_smoothing;
				break;
				default:
					_presentBmp.bitmapData	=	framesCache[value-1];
					_presentBmp.smoothing	=	_smoothing;
			}
			
			_currentFrame			=	value;
		}
		
		public function get currentFrame():int {
			return _currentFrame;
		}

		private function set _state(value:String):void {
			if (__state == value)	return;
			__state	=	value;
		}
	
		//*************************[READ ONLY]**************************************//
		/**total frames*/
		public function get totalFrames():int { return framesCache.length; }
		/**当前显示的图片*/
		public function get presentBitmap():Bitmap {
			return _presentBmp;
		}
		/**the state*/
		public function get state():String { return __state; }
		//*************************[STATIC]*****************************************//
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new BitmapsPlayback();]
		 */
		public function BitmapsPlayback() {
			super();
			currentLabels	=	[];
			framesCache		=	[];
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		/**
		 * set bitmaps frames to this sprite
		 * @param	value a Array of BitmapData.
		 */
		public function setBitmaps(value:Array, bmpMode:String="bmp", rect:Rectangle=null):void {
			framesCache		=	value;
			_bmpMode		=	bmpMode;
			_rectangle		=	rect;
			currentFrame	=	1;
		}
		
		/**
		 * set rectangle
		 * @param	w
		 * @param	h
		 */
		public function setRectange(w:int, h:int):void {
			_rectangle	=	new Rectangle(0, 0, w, h);
		}
		
		/**
		 * move to 360
		 * @param	value 
		 * @param	fn [optional]
		 * @param	speed [optional]
		 */
		public function moveTo360(value:Object, fn:Function = null, speed:Number = 1):void {
			var fr:int;
			if (isNaN(Number(value))) {
				fr	=	getFrameByLabel(String(value));
				if (fr == -1) {
					throw new ArgumentError("ArgumentError: Error #2109: frame lable "+value+" cannot found in current scene .");
				}
			}else {
				var tFr:int	=	totalFrames - 1;
				fr	=	((int(value) + tFr - 1) % tFr) + 1;
			}
			var halfFr:int	=	int(totalFrames * .5);
			var diffFr:int	=	currentFrame - fr;
			if (Math.abs(diffFr) > halfFr) {//long
				_loop360Fn	=	fn;
				_speed360	=	speed;
				_tFrame360	=	fr;
				if (diffFr > 0) {
					moveIn(totalFrames, _loopPlay360, speed);
				}else {
					moveOut(1, _loopPlay360, speed);
				}
			}else {//short
				if (diffFr > 0) {
					moveOut(fr, fn, speed);
				}else {
					moveIn(fr, fn, speed);
				}
			}
			
		}
		
		/**
		 * move to
		 * @param	value 
		 * @param	fn [optional]
		 * @param	speed [optional]
		 */
		public function moveTo(value:Object, fn:Function = null, speed:Number = 1):void {
			var fr:int;
			if (isNaN(Number(value))) {
				fr	=	getFrameByLabel(String(value));
				if (fr == -1) {
					throw new ArgumentError("ArgumentError: Error #2109: frame lable "+value+" cannot found in current scene .");
				}
			}else{
				fr	=	int(value);
			}
			
			if (fr > currentFrame) {
				moveIn(fr, fn, speed);
			}else{
				moveOut(fr, fn, speed);
			}
		}
		
		/**
		 * move in
		 * @param	value [optional]
		 * @param	fn [optional]
		 * @param	speed [optional]
		 */
		public function moveIn(value:Object = null, fn:Function = null, speed:Number = 1):void {
			removeEventListener(Event.ENTER_FRAME, _onRender);
			_playDir		=	1;
			var fr:int;
			if (isNaN(Number(value))) {
				fr	=	getFrameByLabel(String(value));
				if (fr == -1) {
					throw new ArgumentError("ArgumentError: Error #2109: frame lable "+value+" cannot found in current scene .");
				}else {
					_targetFrame	=	fr;
				}
			}else{
				_targetFrame	=	int(value) || totalFrames;
			}
			
			_speed			=	speed;
			if (_currentFrame > _targetFrame) {
				throw new Error("moveIn BitmapsPlayback ["+name+"] current frame: "+_currentFrame+" > target frame: "+_targetFrame);
			}else if (_currentFrame == _targetFrame) {
				__actframe	=	_currentFrame;
				if (fn != null) {
					fn(this);
				}
			}else {
				_onFinishPlayFn	=	fn;
				__actframe		=	_currentFrame;
				addEventListener(Event.ENTER_FRAME, _onRender);
				_state	=	"forward";
			}
		}
		
		/**
		 * move out
		 * @param	value [optional]
		 * @param	fn [optional]
		 * @param	speed [optional]
		 */
		public function moveOut(value:Object = null, fn:Function = null, speed:Number = 1):void {
			removeEventListener(Event.ENTER_FRAME, _onRender);
			_playDir		=	-1;
			var fr:int;
			if (isNaN(Number(value))) {
				fr	=	getFrameByLabel(String(value));
				if (fr == -1) {
					throw new ArgumentError("ArgumentError: Error #2109: frame lable "+value+" cannot found in current scene .");
				}else {
					_targetFrame	=	fr;
				}
			}else{
				_targetFrame	=	int(value) || 1;
			}
			
			_speed			=	speed;
			if (_currentFrame < _targetFrame) {
				throw new Error("moveOut BitmapsPlayback ["+name+"] current frame: "+_currentFrame+" < target frame: "+_targetFrame);
			}else if (_currentFrame == _targetFrame) {
				__actframe	=	_currentFrame;
				if (fn != null) {
					fn(this);
				}
			}else {
				_onFinishPlayFn	=	fn;
				__actframe		=	_currentFrame;
				addEventListener(Event.ENTER_FRAME, _onRender);
				_state	=	"backward";
			}
		}
		

		
		/**
		 * goto value(frame label or frame number) and play
		 * @param value
		 */
		public function gotoAndPlay(value:Object):void {
			gotoAndStop(value);
			moveIn(totalFrames, _loopPlay);
		}
		
		/**
		 * goto value(frame label or frame number) and stop
		 * @param value
		 */
		public function gotoAndStop(value:Object):void {
			var fr:int;
			if (isNaN(Number(value))) {
				fr	=	getFrameByLabel(String(value));
				if (fr==-1) {
					throw new ArgumentError("ArgumentError: Error #2109: frame lable "+value+" cannot found in current scene .");
				}
			}else {
				fr	=	int(value);
				if (fr > totalFrames) {
					fr	=	totalFrames;
				}else if (fr < 1) {
					fr	=	1;
				}
			}
			stop();
			currentFrame	=	fr;
		}
		/**
		 * play current frame
		 */
		public function play():void {
			moveIn(totalFrames, _loopPlay);
		}
		/**
		 * stop playing
		 */
		public function stop():void {
			removeEventListener(Event.ENTER_FRAME, _onRender);
			_state	=	"stop";
		}
		/**
		 * goto next frame and stop
		 */
		public function nextFrame():void {
			stop();
			currentFrame ++;
		}
		
		/**
		 * goto prevouse frame and stop
		 */
		public function prevFrame():void {
			stop();
			currentFrame --;
		}

		public function destroy():void {
			currentLabels	=	[];
			var len:int	=	totalFrames;
			for (var i:int = 0; i < len; i++) {
				var bmp:BitmapData	=	framesCache.shift() as BitmapData;
				if (bmp) {
					bmp.dispose();
				}
			}
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//

		
	
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			_presentBmp		=	new Bitmap(null, pixelSnapping, false);
			
			addChild(_presentBmp);
		}

		
		private function _onRender(e:Event):void {
			if (_currentFrame * _playDir >= _targetFrame * _playDir) {
				if(_currentFrame!=_targetFrame){
					__actframe		=	_targetFrame;
					currentFrame	=	_targetFrame;
				}
				removeEventListener(Event.ENTER_FRAME, _onRender);
				_state	=	"stop";
				if (_onFinishPlayFn != null) {
					_onFinishPlayFn(this);
					//_onFinishPlayFn	=	null;
				}
			}else {
				__actframe	+=	_speed * _playDir;
				var fr:int	=	Math.round(__actframe);
				if (fr != _currentFrame) {
					currentFrame	=	fr;
				}
			}
		}

		
		
		
		private function _loopPlay(mc:BitmapsPlayback):void {
			currentFrame	=	1;
			moveIn(totalFrames, _loopPlay);
		}
		
		private function _loopPlay360(mc:BitmapsPlayback):void {
			if(currentFrame==1){
				currentFrame	=	totalFrames;
				moveOut(_tFrame360, _loop360Fn, _speed360);
			}else {
				currentFrame	=	1;
				moveIn(_tFrame360, _loop360Fn, _speed360);
			}
		}
		
		
		private function getFrameByLabel(value:String):int {
			var arr:Array	=	currentLabels;
			var len:int		=	arr.length;
			for (var i:int = 0; i < len; i++) {
				var frLable:Object	=	arr[i];
				if (frLable.name == value) {
					return frLable.frame;
				}
			}
			return -1;
		}
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}
//[com.wlash.video.BitmapsPlayback]

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
