/*utf8*/
//**********************************************************************************//
//	name:	SequencePlayback 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Jun 16 2009 10:54:18 GMT+0800
//	description: This file was created by "scene_change2.fla" file.
//		
//**********************************************************************************//



package com.wlash.video {

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	
	
	/**
	 * SequencePlayback.
	 * <p>加载序列帧组成的swf，swf会被分几段，分别加载，加载越多的swf，精度越高.</p>
	 * 
	 */
	public class SequencePlayback extends Sprite {
		
		[Inspectable(defaultValue="", verbose="0", type="String", category="")]
		public var sequenceName:String;
		[Inspectable(defaultValue="3", verbose="0", type="Number", category="")]
		public var sequenceNum:uint	=	3;
		
		private var _presentMC:MovieClip;
		private var _curLoadingIndex:int;
		private var _sequences:/*MovieClip*/Array;
		private var _totalFrames:int;
		private var _currentFrame:int;
		private var _onFinishPlayFn:Function;
		
		private var _percent:Number;
		
		private var __actframe:Number;
		private var _targetFrame:int;
		private var _currentLabels:Array;
		private var _playDir:int;
		private var _speed:Number;
		private var __state:String;
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set currentFrame(value:int):void {
			var seqLen:int		=	_sequences.length;
			_currentFrame		=	value;
			var seqIndex:int	=	(value-1) % seqLen;
			var mc:MovieClip	=	_sequences[seqIndex];
			if(mc){
				removeChild(_presentMC);
				addChild(mc);
				_presentMC			=	mc;
				var fr:int	=	Math.floor((value-1) / seqLen) + 1;
				mc.gotoAndStop(fr);
			}
					
			//trace("seqName_"+seqIndex, value);
		}
		/**Annotation*/
		public function get currentFrame():int { return _currentFrame; }
		
		protected function set _state(value:String):void {
			if (__state == value)	return;
			__state	=	value;
		}
		//*************************[READ ONLY]**************************************//
		/**total frames*/
		public function get totalFrames():int {
			return _totalFrames;
		}
		/**当前标签,此值来源于加载第一个sequence得到.*/
		public function get currentLabels():Array {
			return _currentLabels;
		}
		
		/**加载的百分值*/
		public function get percent():Number { return _percent; }
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new SequencePlayback();]
		 */
		public function SequencePlayback() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * move in
		 * @param	value [optional] fr or label
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
				throw new Error("moveIn SequencePlayback ["+name+"] current frame: "+_currentFrame+" > target frame: "+_targetFrame);
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
		 * @param	value [optional] fr or label
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
				throw new Error("moveOut SequencePlayback ["+name+"] current frame: "+_currentFrame+" < target frame: "+_targetFrame);
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
		
		/**
		 * start load sequences
		 * @param	seqName sequenceName, not include xx.swf.
		 * @param	seqNum [optinal] the total of sequences, the default value is 3.
		 */
		public function startLoad(seqName:String, seqNum:uint=0):void {
			sequenceName		=	seqName;
			sequenceNum			=	sequenceNum	|| seqNum;
			
			_sequences			=	[];
			_sequences.length	=	sequenceNum;
			
			_loadSequence(0);
		}
		
		/**
		 * get loaded sequences total frames
		 * @return
		 */
		public function getLoadedTotalFrames():int{
			var len:int	=	_sequences.length;
			var mc:MovieClip;
			var tf:int;
			for (var i:int = 0; i < len; i++) {
				mc	=	_sequences[i];
				tf	+=	mc.totalFrames;
			}
			return	tf;
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
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
		
		private function _loopPlay(mc:SequencePlayback):void {
			currentFrame	=	1;
			moveIn(totalFrames, _loopPlay);
		}
		
		private function _loadSequence(value:int):void {
			var loader:Loader	=	new Loader();
			loader.load(new URLRequest(sequenceName + value + ".swf"));
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onSequenceProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSequenceLoaded);
			_curLoadingIndex	=	value;
		}
		
		private function onSequenceProgress(e:ProgressEvent):void {
			//var p:Number	=	e.bytesLoaded / e.bytesTotal;
			_percent		=	 _curLoadingIndex / sequenceNum + e.bytesLoaded / e.bytesTotal;
			dispatchEvent(e);
		}
		
		private function onSequenceLoaded(e:Event):void {
			var lInfo:LoaderInfo	=	LoaderInfo(e.currentTarget);
			lInfo.removeEventListener(Event.COMPLETE, onSequenceLoaded);
			lInfo.removeEventListener(ProgressEvent.PROGRESS, onSequenceLoaded);
			
			_sequences[_curLoadingIndex]	=	(lInfo.content);
			
			lInfo.content['gotoAndStop'](1);
			if (_curLoadingIndex == 0) {
				_presentMC	=	lInfo.content as MovieClip;
				addChild(_presentMC);
				_getFirstSequenceValue();
			}
			//if(_curLoadingIndex==0)	return;
			
			if (_curLoadingIndex < sequenceNum-1) {
				_loadSequence(_curLoadingIndex + 1);
			}
			
			dispatchEvent(e);
		}
		
		///undate total frames
		private function _getFirstSequenceValue():void {
			var mc:MovieClip	=	_sequences[0];
			var arr:Array		=	mc["__seqFrames"];
			var tFrames:int;
			if (arr) {
				var len:int		=	arr.length;
				for (var i:int = 0; i < len; i++) {
					tFrames		+=	arr[i];
				}
			}else {
				tFrames	=	mc.totalFrames * sequenceNum;
			}
			_totalFrames	=	tFrames;
			//currentLabels
			arr	=	mc["__frameLabel"];
			if(arr){
				_currentLabels	=	arr;
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
}//end class
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


*/
