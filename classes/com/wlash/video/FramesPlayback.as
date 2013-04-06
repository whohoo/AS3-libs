/*utf8*/
//**********************************************************************************//
//	name:	FramesPlayback 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Fri May 22 2009 10:37:21 GMT+0800
//	description: This file was created by "scene_change.fla" file.
//		
//**********************************************************************************//



package com.wlash.video {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	//import flash.display.FrameLabel;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.system.System;
	
	
	
	/**
	 * FramesPlayback.
	 * <p>可播放转为bitmap的帧.</p>
	 * 
	 */
	public class FramesPlayback extends FrameToBitmap {
		
		
		
		private var _currentFrame:int;
		private var __actframe:Number;
		private var _targetFrame:int;
		private var _playDir:int;
		private var _speed:Number;
		private var _onFinishPlayFn:Function;
		private var _presentBmp:Bitmap;
		
		//*************************[READ|WRITE]*************************************//
		
		
		/**@private */
		public function set currentFrame(value:int):void {
			if (value < 1) {
				value	=	1;
			}else if (value > totalFrames) {
				value	=	totalFrames;
			}
			_presentBmp.bitmapData	=	framesCache[value-1];
			_currentFrame	=	value;
		}
		override public function get currentFrame():int {
			return _currentFrame;
		}
		
		public function get currentFrame2():int {
			return super.currentFrame;
		}
		
	
		//*************************[READ ONLY]**************************************//
				
		public function get presentBitmap():Bitmap {
			return _presentBmp;
		}
		//*************************[STATIC]*****************************************//
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new FramesPlayback();]
		 */
		public function FramesPlayback() {
			super();
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		override public function rebuildCache(value:Number=0):void {
			super.rebuildCache(value);
			addEventListener(FrameToBitmap.FINISH, _onRebuildCache);
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
				throw new Error("moveIn FramesPlayback ["+name+"] current frame: "+_currentFrame+" > target frame: "+_targetFrame);
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
				throw new Error("moveOut FramesPlayback ["+name+"] current frame: "+_currentFrame+" < target frame: "+_targetFrame);
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
		

		
		/////OVERRIDE METHOD\\\\\\\\\\\\\
		/**
		 * @inheritDoc
		 */
		override public function gotoAndPlay(value:Object, scene:String = null):void {
			gotoAndStop(value, scene);
			moveIn(totalFrames, _loopPlay);
		}
		/**
		 * @inheritDoc
		 */
		override public function gotoAndStop(value:Object, scene:String=null):void {
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
		 * @inheritDoc
		 */
		override public function play():void {
			moveIn(totalFrames, _loopPlay);
		}
		/**
		 * @inheritDoc
		 */
		override public function stop():void {
			removeEventListener(Event.ENTER_FRAME, _onRender);
			_state	=	"stop";
		}
		/**
		 * @inheritDoc
		 */
		override public function nextFrame():void {
			stop();
			currentFrame ++;
		}
		/**
		 * @inheritDoc
		 */
		override public function prevFrame():void {
			stop();
			currentFrame --;
		}

		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//

		
		protected function gotoAndPlay2(value:Object, scene:String = null):void {
			super.gotoAndPlay(value, scene);
		}
		
		protected function gotoAndStop2(value:Object, scene:String = null):void {
			super.gotoAndStop(value, scene);
		}
		
		protected function play2():void {
			super.play();
		}
		
		protected function stop2():void {
			super.stop();
		}
		
		protected function nextFrame2():void {
			super.nextFrame();
		}
		
		protected function prevFrame2():void {
			super.prevFrame();
		}
	
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			_presentBmp		=	new Bitmap();
		}
	
		private function _onRebuildCache(e:Event):void {
			removeEventListener(FrameToBitmap.FINISH, _onRebuildCache);
			_presentBitmapContent();
			currentFrame	=	1;
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

		//
		private function _presentBitmapContent():void {
			
			var len:int	=	numChildren;
			for (var i:int = 0; i < len; i++) {
				var v:Video	=	removeChildAt(0) as Video;
				if (v) {
					v.visible	=	false;
					v.clear();
				}
			}
			addChild(_presentBmp);
		}
		
		private function _loopPlay(mc:FramesPlayback):void {
			currentFrame	=	1;
			moveIn(totalFrames, _loopPlay);
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
