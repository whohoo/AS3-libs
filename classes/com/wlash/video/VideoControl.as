/*utf8*/
//**********************************************************************************//
//	name:	VideoControl 1.2
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Wed Jul 15 2009 15:06:35 GMT+0800
//	description: This file was created by "videoplayer.fla" file.
//		1.1修改了一些bug，并支持多层影片路径,不再需要TweenLite类
//		1.2增加OverVideo控制, 时间显示, 背影条,
//			可隐藏控制条
//**********************************************************************************//



package com.wlash.video {

	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import com.wlash.frameset.Component;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	
	
	/**
	 * VideoControl.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class VideoControl extends Component {
		private var _controlBar:DisplayObjectContainer;
		
		
		
		[Inspectable(defaultValue = "play_btn", type = "String", verbose="1", name = "playBtn", category="btns")]
		/**@private */
		public var __playBtn:String;
		
		[Inspectable(defaultValue = "pause_btn", type = "String", verbose="1", name = "pauseBtn", category="btns")]
		/**@private */
		public var __pauseBtn:String;
		
		[Inspectable(defaultValue = "stop_btn", type = "String", verbose="1", name = "stopBtn", category="btns")]
		/**@private */
		public var __stopBtn:String;
		
		[Inspectable(defaultValue = "mute_btn", type = "String", verbose="1", name = "muteBtn", category="btns")]
		/**@private */
		public var __muteBtn:String;
		
		[Inspectable(defaultValue = "fullScreen_btn", type = "String", verbose="1", name = "fullScreenBtn", category="btns")]
		/**@private */
		public var __fullScreenBtn:String;
		
		[Inspectable(defaultValue = "seekBar_mc", type = "String", verbose="1", name = "seekBar", category="btns")]
		/**@private */
		public var __seekBar:String;

		//[Inspectable(defaultValue = "bg_mc", type = "String", verbose="1", name = "background", category="btns")]
		/**@private */
		//public var __backgroundMc:String;

		[Inspectable(defaultValue = "overVideo_mc", type = "String", verbose="1", name = "overVideo", category="ov")]
		/**@private */
		public var __overVideoMc:String;

		[Inspectable(defaultValue = "timer_txt", type = "String", verbose="1", name = "timer", category="btns")]
		/**@private */
		public var __timerTxt:String;
		
		private var _playBtn:InteractiveObject;
		private var _pauseBtn:InteractiveObject;
		private var _stopBtn:InteractiveObject;
		private var _muteBtn:InteractiveObject;
		private var _fullScreenBtn:InteractiveObject;
		private var _seekBar:DisplayObjectContainer;
		private var _seekBarContainer:SeekBarContainer;
		//private var _backgroundMc:DisplayObject;
		private var _overVideoMc:MovieClip;
		private var _timerTxt:TextField;
		
		private var _lastVolume:Number;
		private var _volumeTo:Number;
		private var _videoPlayer:VideoPlayer;
		private var _active:Boolean;
		private var _autoHide:Number;
		private var _fadeVolume:Number;
		private var _timer:Timer;
		private var _isCountdownTimer:Boolean;//是否为倒计时
		private var _delayHideOverVideoInterId:int;
		//*************************[READ|WRITE]*************************************//
		[Inspectable(defaultValue = ".3", type = "Number", verbose="1", name = "fadeVolume", category="")]
		/**@private */
		public function set fadeVolume(value:Number):void {
			if(value>=1){
				_fadeVolume	=	1;
			}else if(value>0){
				_fadeVolume 	=	value;
			}else{
				_fadeVolume	=	0.00001;
			}
		}

		/**the time of fade in or fade out volume. */
		public function get fadeVolume():Number { return _fadeVolume; }

		[Inspectable(defaultValue = "0", type = "Number", verbose="1", name = "autoHide", category="")]
		/**@private */
		public function set autoHide(value:Number):void {
			if(value>=1){
				_autoHide	=	1;
			}else if(value>0){
				_autoHide 	=	value;
			}else{
				_autoHide	=	0;
			}
		}

		/**auto hide control bar when mouse out, number must between 0 in 1, 0 means not auto hide, 1 means auto hide immediately.<br/> 0.05 is perfect for auto hide.*/
		public function get autoHide():Number { return _autoHide; }

		[Inspectable(defaultValue="videoPlayer_mc", type="String", verbose="0", name="videoPlayer", category="target")]
		/**@private */
		public function set videoPlayerName(value:String):void {
			if (value.length == 0)	return;
			var sTraget:VideoPlayer	=	eval(value) as VideoPlayer;
			if (sTraget) {
				videoPlayer	=	sTraget;
			}else {
				throw new Error("ERROR: can NOT find ["+value+"] in ["+parent+"]. pls redefine videoPlayer in parameters panel.");
			}
		}	
		
		/**Annotation*/
		public function get videoPlayerName():String { return _videoPlayer==null ? "" : _videoPlayer.name; }
		
		[Inspectable(defaultValue="", type="String", verbose="0", name="controlBar", category="target")]
		/**@private */
		public function set _targetInstanceName(value:String):void {
			if (value.length > 0) {
				var mc:DisplayObjectContainer	=	eval(value) as DisplayObjectContainer;
				if (mc) {
					controlBar	=	mc;
				}else {
					throw new TypeError("controlBar is not flash.display.DisplayObjectContainer. type: " + 
								typeof(eval(value)) + ", target: " + value);
				}
			}
		}
		/**
		 * @private
		 * 定义controlBar属性,此属性只在参数面版中修改
		 */		
		public function get _targetInstanceName():String {//scrollTargetName
			return _controlBar==null ? "" : _controlBar.name;
		}
		
		/**@private */
		public function set controlBar(value:DisplayObjectContainer):void {
			if(value){
				playBtn		=	value.getChildByName(__playBtn) as InteractiveObject;
				pauseBtn	=	value.getChildByName(__pauseBtn) as InteractiveObject;
				stopBtn		=	value.getChildByName(__stopBtn) as InteractiveObject;
				muteBtn		=	value.getChildByName(__muteBtn) as InteractiveObject;
				fullScreenBtn	=	value.getChildByName(__fullScreenBtn) as InteractiveObject;
				
				seekBar		=	value.getChildByName(__seekBar) as DisplayObjectContainer;

				//backgroundMc =	value.getChildByName(__backgroundMc) as DisplayObject;
				overVideoMc	=	value.parent.getChildByName(__overVideoMc) as MovieClip;//此对象在控制条之外
				timerTxt	=	value.getChildByName(__timerTxt) as TextField;

				_controlBar	=	value;
			}
			//if (isActive)	active	=	true;
		}
		/**
		 * 定义滚动条对象，必须为DisplayObjectContainer<br/>
		 * track为最底层，且顶点对齐原点<br/>
		 * thumb不能超过trakc的高度.
		 * @throws Error, 当scrollBar不符合所要求的时候。
		 */	
		public function get controlBar():DisplayObjectContainer {
			return _controlBar;
		}
		
		/**@private */
		public function set playBtn(value:InteractiveObject):void {
			if (_playBtn) {
				_playBtn.removeEventListener(MouseEvent.CLICK, onClickPlay);
			}
			_playBtn	=	value;
			if (!value) 	return;
			_playBtn.addEventListener(MouseEvent.CLICK, onClickPlay);	
			
			
		}
		/**Annotation*/
		public function get playBtn():InteractiveObject { return _playBtn; }
		
		/**@private */
		public function set pauseBtn(value:InteractiveObject):void {
			if (_pauseBtn) {
				_pauseBtn.removeEventListener(MouseEvent.CLICK, onClickPause);
			}
			_pauseBtn	=	value;
			if (!value) 	return;
			_pauseBtn.visible	=	false;
			_pauseBtn.addEventListener(MouseEvent.CLICK, onClickPause);	
		}
		/**Annotation*/
		public function get pauseBtn():InteractiveObject { return _pauseBtn; }
		
		/**@private */
		public function set stopBtn(value:InteractiveObject):void {
			if (_stopBtn) {
				_stopBtn.removeEventListener(MouseEvent.CLICK, onClickStop);
			}
			_stopBtn	=	value;
			if (!value) 	return;
			_stopBtn.addEventListener(MouseEvent.CLICK, onClickStop);
		}
		/**Annotation*/
		public function get stopBtn():InteractiveObject { return _stopBtn; }
		
		/**@private */
		public function set muteBtn(value:InteractiveObject):void {
			if (_muteBtn) {
				_muteBtn.removeEventListener(MouseEvent.CLICK, onClickSpeaker);
			}
			_muteBtn	=	value;
			if (!value) 	return;
			_muteBtn.addEventListener(MouseEvent.CLICK, onClickSpeaker);
			if (value is MovieClip) {
				value["gotoAndStop"](1);
			}
		}
		/**Annotation*/
		public function get muteBtn():InteractiveObject { return _muteBtn; }
		
		/**@private */
		public function set fullScreenBtn(value:InteractiveObject):void {
			if (_fullScreenBtn) {
				_fullScreenBtn.removeEventListener(MouseEvent.CLICK, onClickFullScreen);
			}
			_fullScreenBtn	=	value;
			if (!value) 	return;
			_fullScreenBtn.addEventListener(MouseEvent.CLICK, onClickFullScreen);
			if (value is MovieClip) {
				value["gotoAndStop"](1);
			}
		}
		/**Annotation*/
		public function get fullScreenBtn():InteractiveObject { return _fullScreenBtn; }
		
		/**@private */
		public function set seekBar(value:DisplayObjectContainer):void {
			if (_seekBar) {
				if(_seekBarContainer){
					_seekBarContainer.destory();
					_seekBarContainer	=	null;
				}
			}
			_seekBar	=	value;
			if (!value) {
				if (_seekBarContainer) {
					_seekBarContainer = null;
				}
			}else{
				_seekBarContainer	=	new SeekBarContainer(value, this);
			}
		}
		/**Annotation*/
		public function get seekBar():DisplayObjectContainer { return _seekBar; }
		

		/**@private */
		/*public function set backgroundMc(value:DisplayObject):void {
			if (_backgroundMc) {
				
			}
			_backgroundMc	=	value;
			if (!value) 	return;
			
		}*/
		/**Annotation*/
		//public function get backgroundMc():DisplayObject { return _backgroundMc; }
		
		/**@private */
		public function set overVideoMc(value:MovieClip):void {
			if (_overVideoMc)  _overVideoMc.removeEventListener(MouseEvent.CLICK, onClickOverVideo);
			
			_overVideoMc	=	value;
			if (!value) 	return;
			_overVideoMc.addEventListener(MouseEvent.CLICK, onClickOverVideo);
			if (value is MovieClip) {
				value["gotoAndStop"](1);
			}
		}
		/**Annotation*/
		public function get overVideoMc():MovieClip { return _overVideoMc; }
		
		/**@private */
		public function set timerTxt(value:TextField):void {
			if (_timerTxt) _timerTxt.removeEventListener(MouseEvent.CLICK, onClickTimer);
			if(_timer){
				_timer.stop();
			}
			_timerTxt	=	value;
			if (!value) 	return;
			_timerTxt.addEventListener(MouseEvent.CLICK, onClickTimer);
			if(!_timer){
				_timer = new Timer(500);
			}
			_timer.addEventListener(TimerEvent.TIMER, _onTimer);

		}
		/**Annotation*/
		public function get timerTxt():TextField { return _timerTxt; }

		/**@private */
		public function set videoPlayer(value:VideoPlayer):void {
			_videoPlayer	=	null;
			if (value && _seekBarContainer) {
				//var vName:String	=	getQualifiedClassName(value);
				//switch(vName) {
					//case "fl.video::FLVPlayback":
					//case "com.wlash.video::VideoPlayer":
					//case "fl.video::VideoPlayer":
						_videoPlayer	=	value;
						value.addEventListener("stateChange", onStateChange);
						onStateChange();
						
						_seekBarContainer.initiazlie();
						
					//break;
				//}
				_listenVideoOverEvent();
			}
		}
		
		/**Annotation*/
		public function get videoPlayer():VideoPlayer { return _videoPlayer; }
		
		/**@private */
		public function set active(value:Boolean):void {
			if (value) {
				mouseChildren	=	value;
			}
			_active	=	value;
		}
		/**Annotation*/
		public function get active():Boolean { return _active; }
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new VideoControl();]
		 */
		public function VideoControl() {
			mouseChildren	=	false;
			removeChildAt(0);
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//

		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
		}
		
		private function _onRemoved(e:Event):void {
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, _fullScreen);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveInFullScr);
			clearTimeout(_delayHideOverVideoInterId);
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
			removeEventListener(Event.ENTER_FRAME, _onVolumeFadeFn);
			removeEventListener(Event.ENTER_FRAME, _onHidingBar);
			if(_playBtn) _playBtn.removeEventListener(MouseEvent.CLICK, onClickPlay);	
			if(_pauseBtn) _pauseBtn.removeEventListener(MouseEvent.CLICK, onClickPause);
			if(_stopBtn) _stopBtn.removeEventListener(MouseEvent.CLICK, onClickStop);
			if(_muteBtn) _muteBtn.removeEventListener(MouseEvent.CLICK, onClickSpeaker);
			if(_fullScreenBtn) _fullScreenBtn.removeEventListener(MouseEvent.CLICK, onClickFullScreen);
			if (_timerTxt) _timerTxt.removeEventListener(MouseEvent.CLICK, onClickTimer);
			if(_timer){
				_timer.stop();
				_timer.addEventListener(TimerEvent.TIMER, _onTimer);
			}

			if (_overVideoMc)  _overVideoMc.removeEventListener(MouseEvent.CLICK, onClickOverVideo);
			if(_videoPlayer){
				_videoPlayer.removeEventListener("stateChange", onStateChange);
				_videoPlayer.removeEventListener("hoverVideoPlayer", _onVideoPlayerHoverChange);
				_videoPlayer.removeEventListener("outVideoPlayer", _onVideoPlayerHoverChange);
			}

			if(_seekBar) _seekBarContainer.destory();
		}

		private function _listenVideoOverEvent():void{
			_videoPlayer.addEventListener("hoverVideoPlayer", _onVideoPlayerHoverChange);
			_videoPlayer.addEventListener("outVideoPlayer", _onVideoPlayerHoverChange);
			_onVideoPlayerHoverChange(null);
		}

		private function _onVideoPlayerHoverChange(e:Event):void{
			//_out("isHoverVideo: "+_videoPlayer.isHoverVideo+", isFullScreen: "+ _videoPlayer.isFullScreen);
			if(_videoPlayer.isFullScreen && _videoPlayer.isHoverVideo){//全屏状态
				if(_videoPlayer.state=="playing"){
					_overVideoMc.gotoAndStop(2);
				}else{
					_overVideoMc.gotoAndStop(1);
				}
				_overVideoMc.visible = true;
				stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveInFullScr);
			}else{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveInFullScr);
				clearTimeout(_delayHideOverVideoInterId);
				if(_videoPlayer.isHoverVideo){
					_overVideoMc.visible = true;
					if(_videoPlayer.state=="playing"){
						_overVideoMc.gotoAndStop(2);
					}else{
						_overVideoMc.gotoAndStop(1);
					}
					_showBar();
				}else{
					if(_videoPlayer.state=="playing"){
						_overVideoMc.visible = false;
					}else{
						_overVideoMc.visible = true;
						_overVideoMc.gotoAndStop(1);
					}
					_hideBar();
				}
			}
			
		}

		private function _onMouseMoveInFullScr(e:MouseEvent):void{
			clearTimeout(_delayHideOverVideoInterId);
			if(_videoPlayer.state=="playing"){
				_overVideoMc.gotoAndStop(2);
			}else{
				_overVideoMc.gotoAndStop(1);
			}
			_overVideoMc.visible = true;
			_showBar();
			_delayHideOverVideoInterId = setTimeout(function():void{
					if(_videoPlayer.state=="playing") _overVideoMc.visible = false;
					_hideBar();
				}, 800);
		}

		private function _showBar():void{
			removeEventListener(Event.ENTER_FRAME, _onHidingBar);
			_controlBar.alpha = 1;
			_controlBar.visible = true;
		}

		private function _hideBar():void{
			removeEventListener(Event.ENTER_FRAME, _onHidingBar);
			if(_autoHide>=1){
				_controlBar.visible = false;
			}else if(_autoHide>0){
				addEventListener(Event.ENTER_FRAME, _onHidingBar);
			}
		}

		private function _onHidingBar(e:Event):void{
			_controlBar.alpha -= _autoHide;
			if(_controlBar.alpha<=0){
				_controlBar.visible = false;
				removeEventListener(Event.ENTER_FRAME, _onHidingBar);
			}
		}
		
		private function onClickPlay(e:MouseEvent):void {
			if (_videoPlayer) {
				_videoPlayer['play']();
			}
		}
		private function onClickPause(e:MouseEvent):void {
			if (_videoPlayer) {
				_videoPlayer['pause']();
			}
		}
		private function onClickStop(e:MouseEvent):void {
			if (_videoPlayer) {
				_videoPlayer['stop']();
			}
		}
		private function onClickSpeaker(e:MouseEvent):void {
			if (_videoPlayer) {
				
				if (_videoPlayer["volume"] != 0) {
					_lastVolume	=	_videoPlayer.volume;
					_fadeVolumeTo(0);
					if (_muteBtn is MovieClip) {
						_muteBtn["gotoAndStop"](2);
					}
				}else {
					_fadeVolumeTo(_lastVolume);
					if (_muteBtn is MovieClip) {
						_muteBtn["gotoAndStop"](1);
					}
				}
			}
		}

		private function onClickOverVideo(e:MouseEvent):void{
			if(_overVideoMc){
				if(_overVideoMc.currentFrame==1){
					onClickPlay(null);
				}else{
					onClickPause(null);
				}
			}
		}

		private function onClickTimer(e:MouseEvent):void{
			_isCountdownTimer = !_isCountdownTimer;
			_onTimer(null);
		}

		private function _onTimer(e:TimerEvent):void{
			var t:int;
			if(!_isCountdownTimer){
				t = this._videoPlayer.playheadTime
			}else{
				t = this._videoPlayer.totalTime - this._videoPlayer.playheadTime;
			}
			
			_timerTxt.text = _formatTimer(t);
		}

		private function _formatTimer(value:int):String{
			var min:int = value / 60;
			var sec:int = value % 60;
			return (min>9 ? min : "0"+min)+":"+(sec>9 ? sec : "0"+sec);
		}

		private function onClickFullScreen(e:MouseEvent):void {
			if (_videoPlayer) {
				
				if (_fullScreenBtn is MovieClip) {
					if (MovieClip(_fullScreenBtn).currentFrame == 1) {
						_videoPlayer.enterFullScreenDisplayState();
						if(_videoPlayer.isFullScreen){
							_fullScreenBtn["gotoAndStop"](2);
							stage.addEventListener(FullScreenEvent.FULL_SCREEN, _fullScreen);
						}else {
							_fullScreenBtn["gotoAndStop"](1);
							stage.removeEventListener(FullScreenEvent.FULL_SCREEN, _fullScreen);
						}
					}else {
						_fullScreenBtn["gotoAndStop"](1);
						_videoPlayer.exitFullScreen();
					}
				}else {
					_videoPlayer.enterFullScreenDisplayState();
				}
			}
		}
		
		private function _fullScreen(e:FullScreenEvent):void {
			if (!e.fullScreen) {
				stage.removeEventListener(FullScreenEvent.FULL_SCREEN, _fullScreen);
				if (MovieClip(_fullScreenBtn).currentFrame == 2) {
					_fullScreenBtn["gotoAndStop"](1);
				}
			}
		}
		
		private function _fadeVolumeTo(value:Number):void {
			_volumeTo	=	value;
			addEventListener(Event.ENTER_FRAME, _onVolumeFadeFn);
		}
		
		private function _onVolumeFadeFn(e:Event):void {
			var diff:Number	=	_volumeTo - _videoPlayer.volume;
			_videoPlayer.volume		+=	diff * fadeVolume;
			if (Math.abs(diff) <= .5) {
				_videoPlayer.volume	=	_volumeTo;
				removeEventListener(Event.ENTER_FRAME, _onVolumeFadeFn);
				_onVolumeChanged();
			}
		}
		
		private function _onVolumeChanged():void {
			dispatchEvent(new Event("volumeChanged"));
		}
		
		private function onStateChange(e:Event=null):void {
			//_out("state: "+_videoPlayer["state"]);

			switch(_videoPlayer["state"]) {
				case "loading":
					if(_pauseBtn)
						_pauseBtn.visible	=	false;
					if(_playBtn)
						_playBtn.visible	=	true;
				break;
				case "playing":
					if(_pauseBtn)
						_pauseBtn.visible	=	true;
					if(_playBtn)
						_playBtn.visible	=	false;
					if(_overVideoMc){
						if(!_videoPlayer.isHoverVideo)
							_overVideoMc.visible	=	false;
						else {
							_overVideoMc.visible	=	true;
							_overVideoMc.gotoAndStop(2);
						}
					}
					if(_timer) _timer.start();
				break;
				case "stopped":
					if(_pauseBtn)
						_pauseBtn.visible	=	false;
					if(_playBtn)
						_playBtn.visible	=	true;
					if(_overVideoMc){
						_overVideoMc.visible	=	true;
						_overVideoMc.gotoAndStop(1);
					}
					if(_timer) _timer.stop();
				break;
				case "paused":
					if(_pauseBtn)
						_pauseBtn.visible	=	false;
					if(_playBtn)
						_playBtn.visible	=	true;
					if(_overVideoMc){
						_overVideoMc.visible	=	true;
						_overVideoMc.gotoAndStop(1);
					}
					if(_timer) _timer.stop();
				case "videoEnd":
					if(_pauseBtn)
						_pauseBtn.visible	=	false;
					if(_playBtn)
						_playBtn.visible	=	true;
					if(_overVideoMc){
						_overVideoMc.visible	=	true;
						_overVideoMc.gotoAndStop(1);
					}
					if(_timer) _timer.stop();
				break;
			}
		}

		private function _out(value:Object):void{
			ExternalInterface.call("console.log", value);
			trace(value);
		}
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import com.wlash.video.VideoControl;
import flash.events.MouseEvent;

class SeekBarContainer extends Object {
	
	private var _seekBar:DisplayObjectContainer;
	private var _progressMc:DisplayObject;
	private var _seekMc:DisplayObject;
	private var _owner:VideoControl;
	
	public function SeekBarContainer(seekBar:DisplayObjectContainer, vc:VideoControl) {
		_seekBar	=	seekBar;
		_owner		=	vc;
		
		_init();
	}
	
	function destory():void {
		_seekBar.removeEventListener(Event.ENTER_FRAME, _checkLoading);
		_seekBar.removeEventListener(Event.ENTER_FRAME, _checkProgress);
		_seekBar.removeEventListener(MouseEvent.MOUSE_DOWN, _onDownSeekBar);
		
	}
	
	function initiazlie():void {
		_seekBar.addEventListener(Event.ENTER_FRAME, _checkLoading);
		_seekBar.addEventListener(Event.ENTER_FRAME, _checkProgress);
		_checkLoading();
	}
	
	private function _init():void {
		if (_seekBar.numChildren != 3) {
			throw new Error("seekBar must contain 3 bar, current depth number is "+_seekBar.numChildren);
		}
		
		_progressMc	=	_seekBar.getChildAt(1);
		_seekMc		=	_seekBar.getChildAt(2);
		_progressMc.scaleX	=	
		_seekMc.scaleX		=	0;
		_seekBar.addEventListener(MouseEvent.MOUSE_DOWN, _onDownSeekBar);
	}
	
	private function _onDownSeekBar(e:MouseEvent):void {
		_seekBar.stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMoveSeekBar);
		_seekBar.stage.addEventListener(MouseEvent.MOUSE_UP, _onUpSeekBar);
		_onMoveSeekBar(e);
	}
	
	private function _onMoveSeekBar(e:MouseEvent):void {
		var p:Number	=	_seekBar.mouseX / _seekBar.width;
		p	=	p > _progressMc.scaleX ? _progressMc.scaleX : p;
		var sec:Number	=	p * _owner.videoPlayer["totalTime"];
		
		_owner.videoPlayer["seek"](sec);
	}
	
	private function _onUpSeekBar(e:MouseEvent):void {
		_seekBar.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMoveSeekBar);
		_seekBar.stage.removeEventListener(MouseEvent.MOUSE_UP, _onUpSeekBar);
	}
	
	private function _checkProgress(e:Event=null):void {
		var p:Number	=	_owner.videoPlayer["bytesLoaded"] / _owner.videoPlayer["bytesTotal"];
		if (!isNaN(p)) {
			_progressMc.scaleX	=	p;
			if (p == 1) {
				_seekBar.removeEventListener(Event.ENTER_FRAME, _checkProgress);
			}
		}
	}
	
	private function _checkLoading(e:Event=null):void {
		var p:Number	=	_owner.videoPlayer["playheadTime"] / _owner.videoPlayer["totalTime"];
		if (!isNaN(p)) {
			_seekMc.scaleX	=	p;
		}
	}
}

//class VolumeBarContainer extends Object {
	//
	//private var _volBar:DisplayObjectContainer;
	//private var _progressMc:DisplayObject;
	//private var _seekMc:DisplayObject;
	//private var _owner:VideoControl;
	//
	//public function VolumeBarContainer(volBar:DisplayObjectContainer, vc:VideoControl) {
		//_volBar		=	volBar;
		//_owner		=	vc;
		//
		//_init();
	//}
	//
	//function destory():void {
		//
		//_volBar.removeEventListener(MouseEvent.MOUSE_DOWN, _onDownSeekBar);
	//}
	//
	//function initiazlie():void {
		//
	//}
	//
	//private function _init():void {
		//if (_volBar.numChildren != 3) {
			//throw new Error("volumeBar must contain 3 bar, current depth number is "+_volBar.numChildren);
		//}
		//
		//_progressMc	=	_volBar.getChildAt(1);
		//_seekMc		=	_volBar.getChildAt(2);
		//_progressMc.scaleX	=	
		//_seekMc.scaleX		=	0;
		//_seekBar.addEventListener(MouseEvent.MOUSE_DOWN, _onDownSeekBar);
	//}
	//
	//private function _onDownSeekBar(e:MouseEvent):void {
		//_seekBar.stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMoveSeekBar);
		//_seekBar.stage.addEventListener(MouseEvent.MOUSE_UP, _onUpSeekBar);
		//_onMoveSeekBar(e);
	//}
	//
	//private function _onMoveSeekBar(e:MouseEvent):void {
		//var p:Number	=	_seekBar.mouseX / _seekBar.width;
		//p	=	p > _progressMc.scaleX ? _progressMc.scaleX : p;
		//var sec:Number	=	p * _owner.videoPlayer["totalTime"];
		//
		//_owner.videoPlayer["seek"](sec);
	//}
	//
	//private function _onUpSeekBar(e:MouseEvent):void {
		//_seekBar.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMoveSeekBar);
		//_seekBar.stage.removeEventListener(MouseEvent.MOUSE_UP, _onUpSeekBar);
	//}
	//
	//
//}
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


*/
