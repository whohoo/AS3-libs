/*utf8*/
//**********************************************************************************//
//	name:	ClipsPlayback 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Fri Aug 28 2009 16:16:59 GMT+0800
//	description: This file was created by "home360_2.fla" file.
//				两段视频,正放与倒放,
//**********************************************************************************//


//[com.wlash.video.ClipsPlayback]
package com.wlash.video {

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * ClipsPlayback.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class ClipsPlayback extends Sprite {
		public var click0:SimpleButton;
		public var click1:SimpleButton;
		
		protected var _video1:MovieClip;//LAYER NAME: "video1", FRAME: [1-2], PATH: DOM
		protected var _video0:MovieClip;//LAYER NAME: "video0", FRAME: [1-2], PATH: DOM

		protected var _curVideo:MovieClip;
		
		private var _totalFrames:int;
		private var __actframe:Number;
		private var _targetFrame:int;
		private var _playDir:int;
		private var _speed:Number;
		private var _onFinishPlayFn:Function;
		private var __state:String;
		
		private var _loop360Fn:Function;
		private var _tFrame360:int;
		private var _speed360:Number;
		
		public var currentLabels:Array;
		
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set currentFrame(value:int):void {
			//if (_curVideo == _video0) {//正
				//_video0.gotoAndStop(value);
			//}else {//倒
				var fr:int	=	_totalFrames - value + 1;
				_video1.gotoAndStop(fr);
				_video0.gotoAndStop(value);
			//}
			
		}
		public function get currentFrame():int {
			var fr:int;
			if (_curVideo == _video0) {
				fr	=	_video0.currentFrame;
			}else {
				fr	=	_totalFrames - _video1.currentFrame + 1;
			}
			return fr;
		}
		
		private function set _state(value:String):void {
			if (__state == value)	return;
			__state	=	value;
		}
		//*************************[READ ONLY]**************************************//
		/**total frames*/
		public function get totalFrames():int { return _totalFrames; }
		
		/**the state*/
		public function get state():String { return __state; }
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ClipsPlayback();]
		 */
		public function ClipsPlayback() {
			_video1		=	getChildAt(1) as MovieClip;//倒
			_video0		=	getChildAt(0) as MovieClip;//正
			_curVideo	=	_video0;
			//click0.addEventListener(MouseEvent.CLICK, onClick);	click1.addEventListener(MouseEvent.CLICK, onClick);
			_init();
		}
		
		private function onClick(e:MouseEvent):void {
			if (e.currentTarget == click0) {
				moveTo360(300);
			}else {
				moveIn();
			}
		}
		//*************************[PUBLIC METHOD]**********************************//
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
			
			var diffFr:int	=	currentFrame-fr;
			
			//trace( "moveTo360 | fn: " + value, "diffFr: " + diffFr, "halfFr: " + halfFr, " is long: "+ (Math.abs(diffFr) > halfFr));
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
			//trace( "moveIn : " + value, currentFrame );
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
			
			setCurVideo(_video0);
			
			if (currentFrame > _targetFrame) {
				throw new Error("moveIn ClipsPlayback ["+name+"] current frame: "+currentFrame+" > target frame: "+_targetFrame);
			}else if (currentFrame == _targetFrame) {
				if (fn != null) {
					fn(this);
				}
			}else {
				_onFinishPlayFn	=	fn;
				addEventListener(Event.ENTER_FRAME, _onRender);
				
				_video0.play();
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
			//trace( "moveOut : " + value, currentFrame );
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
			
			setCurVideo(_video1);
			
			if (currentFrame < _targetFrame) {
				throw new Error("moveOut ClipsPlayback ["+name+"] current frame: "+currentFrame+" < target frame: "+_targetFrame);
			}else if (currentFrame == _targetFrame) {
				if (fn != null) {
					fn(this);
				}
			}else {
				_onFinishPlayFn	=	fn;
				addEventListener(Event.ENTER_FRAME, _onRender);
				
				_video1.play();
				_state	=	"backward";
			}
		}
		
		/**
		 * goto value(frame label or frame number) and play
		 * @param value
		 */
		public function gotoAndPlay(value:Object):void {
			var fr:int;
			if (isNaN(Number(value))) {
				fr	=	getFrameByLabel(String(value));
				if (fr==-1) {
					throw new ArgumentError("ArgumentError: Error #2109: frame lable "+value+" cannot found in current scene .");
				}
			}else {
				fr	=	int(value);
				if (fr > _totalFrames) {
					fr	=	_totalFrames;
				}else if (fr < 1) {
					fr	=	1;
				}
			}
			
			_video1.stop();
			_video1.visible	=	false;
			
			setCurVideo(_video0);
			_video0.gotoAndPlay(fr);
			_state	=	"play";
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
			
			_video1.stop();
			_video1.visible	=	false;
			
			setCurVideo(_video0);
			_video0.gotoAndStop(fr);
			_state	=	"stop";
		}
		
		/**
		 * play current frame
		 */
		public function play():void {
			_video1.stop();
			_video1.visible	=	false;
			
			setCurVideo(_video0);
			_video0.play();
			_state	=	"play";
		}
		
		/**
		 * stop playing
		 */
		public function stop():void {
			_video1.stop();
			_video1.visible	=	false;
			
			setCurVideo(_video0);
			_state	=	"stop";
		}
		/**
		 * goto next frame and stop
		 */
		public function nextFrame():void {
			_video1.stop();
			_video1.visible	=	false;
			
			setCurVideo(_video0);
			_video0.nextFrame();
			_state	=	"stop";
		}
		
		/**
		 * goto prevouse frame and stop
		 */
		public function prevFrame():void {
			_video1.stop();
			_video1.visible	=	false;
			
			setCurVideo(_video0);
			_video0.prevFrame();
			_state	=	"stop";
		}

		public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, _onRender);
		}
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			if (_video0.totalFrames == _video1.totalFrames) {
				_totalFrames	=	_video0.totalFrames;
			}else {
				throw new Error("Error length | _video0 toalFrames : " + _video0.totalFrames + 
						", " + "_video1 toalFrames : " + _video1.totalFrames);
			}
			
			_video0.stop();
			_video1.stop();
			_video1.visible	=	false;
		}
		
		private function _onRender(e:Event):void {
			var curFr:int;
			//if (__state == "backward") {
				//curFr	=	_totalFrames - _video1.currentFrame + 1;
			//}else {
				//curFr	=	_video0.currentFrame;
			//}
			curFr	=	currentFrame;
			//trace( "_onRender : " + (curFr * _playDir >= _targetFrame * _playDir), "curFr: "+curFr, "_playDir: "+_playDir, "_targetFr: "+_targetFrame );
			if (curFr * _playDir >= _targetFrame * _playDir) {
				_curVideo.stop();
				removeEventListener(Event.ENTER_FRAME, _onRender);
				_state	=	"stop";
				if (_onFinishPlayFn != null) {
					_onFinishPlayFn(this);
					//_onFinishPlayFn	=	null;
				}
			}else {
				//playing...
			}
		}
		
		private function _loopPlay360(mc:ClipsPlayback):void {
			if (currentFrame == 1) {
				currentFrame	=	_totalFrames;
				moveOut(_tFrame360, _loop360Fn, _speed360);
			}else {
				currentFrame	=	1;
				moveIn(_tFrame360, _loop360Fn, _speed360);
			}
		}
		
		private function setCurVideo(v:MovieClip):void {
			if (v != _curVideo) {
				var fr:int	=	_curVideo.currentFrame;
				fr			=	_totalFrames - fr + 1;
				v.gotoAndStop(fr);
				
				_curVideo.visible	=	false;
				v.visible			=	true;
				_curVideo			=	v;
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
}//end class [com.wlash.video.ClipsPlayback]
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
