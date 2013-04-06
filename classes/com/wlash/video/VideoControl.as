/*utf8*/
//**********************************************************************************//
//	name:	VideoControl 1.1
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Wed Jul 15 2009 15:06:35 GMT+0800
//	description: This file was created by "videoplayer.fla" file.
//		1.1修改了一些bug，并支持多层影片路径,不再需要TweenLite类
//**********************************************************************************//



package com.wlash.video {

	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import com.wlash.frameset.Component;
	
	
	/**
	 * VideoControl.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class VideoControl extends Component {
		private var _controlBar:DisplayObjectContainer;
		
		[Inspectable(defaultValue = ".3", type = "Number", verbose="1", name = "fadeVolume", category="")]
		/**the second of fade in or fade out volume */
		public var fadeVolume:Number	=	.3;
		
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
		
		private var _playBtn:InteractiveObject;
		private var _pauseBtn:InteractiveObject;
		private var _stopBtn:InteractiveObject;
		private var _muteBtn:InteractiveObject;
		private var _fullScreenBtn:InteractiveObject;
		private var _seekBar:DisplayObjectContainer;
		private var _seekBarContainer:SeekBarContainer;
		
		private var _lastVolume:Number;
		private var _volumeTo:Number;
		private var _videoPlayer:VideoPlayer;
		private var _active:Boolean;
		//*************************[READ|WRITE]*************************************//
		[Inspectable(defaultValue="", type="String", verbose="0", name="videoPlayer", category="target")]
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
				fullScreenBtn		=	value.getChildByName(__fullScreenBtn) as InteractiveObject;
				
				seekBar		=	value.getChildByName(__seekBar) as DisplayObjectContainer;

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
		public function set videoPlayer(value:VideoPlayer):void {
			_videoPlayer	=	null;
			if (value) {
				//var vName:String	=	getQualifiedClassName(value);
				//switch(vName) {
					//case "fl.video::FLVPlayback":
					//case "com.wlash.video::VideoPlayer":
					//case "fl.video::VideoPlayer":
						_videoPlayer	=	value;
						value.addEventListener("stateChange", onStateChange);
						onStateChange();
						if(_seekBarContainer){
							_seekBarContainer.initiazlie();
						}
					//break;
				//}
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
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemoved);
			removeEventListener(Event.ENTER_FRAME, _onVolumeFadeFn);
			if(_playBtn) _playBtn.removeEventListener(MouseEvent.CLICK, onClickPlay);	
			if(_pauseBtn) _pauseBtn.removeEventListener(MouseEvent.CLICK, onClickPause);
			if(_stopBtn) _stopBtn.removeEventListener(MouseEvent.CLICK, onClickStop);
			if(_muteBtn) _muteBtn.removeEventListener(MouseEvent.CLICK, onClickSpeaker);
			if(_fullScreenBtn) _fullScreenBtn.removeEventListener(MouseEvent.CLICK, onClickFullScreen);
			_videoPlayer.removeEventListener("stateChange", onStateChange);
			
			if(_seekBar) _seekBarContainer.destory();
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
				break;
				case "stopped":
					if(_pauseBtn)
						_pauseBtn.visible	=	false;
					if(_playBtn)
						_playBtn.visible	=	true;
				break;
				case "paused":
					if(_pauseBtn)
						_pauseBtn.visible	=	false;
					if(_playBtn)
						_playBtn.visible	=	true;
				case "rewinding":
					if(_pauseBtn)
						_pauseBtn.visible	=	false;
					if(_playBtn)
						_playBtn.visible	=	true;
				break;
			}
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
