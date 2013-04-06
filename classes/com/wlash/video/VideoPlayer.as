/*utf8*/
//**********************************************************************************//
//	name:	VideoPlayer 1.3
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Thu Mar 26 2009 10:07:30 GMT+0800
//	description: This file was created by "main.fla" file.
//		v1.1,修改了当定义loopPlay=false,autoRewind=true;时,没有停止在第一帧上
//		v1.2,增加clear() method, destroy() method
//		v1.3,增加全屏方法，已经bugs，当视频尺寸小于261x177时，视频会左上角对齐而不会
//			居中屏幕正中
//**********************************************************************************//



package com.wlash.video {


	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.AsyncErrorEvent;
	import flash.system.Capabilities;
	
	/**
	 * video start play
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "videoStartPlay", type = "flash.events.Event")]
	
	/**
	 * video buffer empty
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "videoBufferEmpty", type = "flash.events.Event")]
	
	/**
	 * video buffer full
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "videoBufferFull", type = "flash.events.Event")]
	
	/**
	 * video seek notify
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "videoSeekNotify", type = "flash.events.Event")]
	
	/**
	 * video play end
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "videoComplete", type = "flash.events.Event")]
	
	/**
	 * video did not found
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "videoNotFound", type = "flash.events.Event")]
	
	/**
	 * video did not found
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "stateChange", type = "flash.events.Event")]	
	
	/**
	 * VideoPlayer.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class VideoPlayer extends Sprite {
		/**@private */
		public var video_mc:Video;
		[Inspectable(defaultValue = "true", verbose = "0", type = "Boolean", category = "")]
		/**auto play video or not*/
		public var autoPlay:Boolean		=	true;
		
		[Inspectable(defaultValue = "true", verbose = "0", type = "Boolean", category = "")]
		/**auto rewind video or not*/
		public var autoRewind:Boolean	=	true;

		[Inspectable(defaultValue = "false", verbose = "0", type = "Boolean", category = "")]
		/**loop play video when video play end*/
		public var loopPlay:Boolean		=	false;
		
		//be add to stage at top
		//protected var _fullscreenMc:Sprite;
		private var _videoBg:Shape;
		private var _videoContainer:DisplayObjectContainer;
		private var _depthIndex:int;
		
		private var videoURL:String;
        private var connection:NetConnection;
        private var stream:NetStream;

		private var __state:String		=	"";
		private var _duration:Number;
		private var _bufferTime:Number	=	.1;
		private var _source:String;
		private var _metadata:Object;
		private var _fullScreenBackgroundColor:uint	=	0x0;
		private var _skinScaleMaximum:Number		=	4;
		
		private const MIN_WIDTH:Number	=	261;
		private const MIN_HEIGHT:Number	=	177;
		private var _isFullScreen:Boolean;
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set playheadTime(value:Number):void {
			value	=	value < 0 ? 0 : (value>_duration ? _duration : value);
			stream.seek(value);
		}
		/**video playhead time*/
		public function get playheadTime():Number { return stream.time; }
		
		[Inspectable(defaultValue="1", verbose="0", type="Number", category="")]
		/**@private */
		public function set bufferTime(value:Number):void {
			if(stream)
				stream.bufferTime	=	value;
			_bufferTime			=	value;
		}
		/**video buffer time*/
		public function get bufferTime():Number { return stream.bufferTime; }
		
		[Inspectable(defaultValue="", verbose="0", type="String", category="")]
		/**@private */
		public function set source(value:String):void {
			_source	=	value;
			if (autoPlay) {
				play(value);
			}else {
				load(value);
			}
		}
		
		/**Annotation*/
		public function get source():String { return _source; }
		
		[Inspectable(defaultValue="1", verbose="0", type="Number", category="")]
		/**@private */
		public function set volume(value:Number):void {
			var sTrans:SoundTransform	=	netStream.soundTransform;
			sTrans.volume	=	value;
			netStream.soundTransform	=	sTrans;
		}
		
		/**Annotation*/
		public function get volume():Number {return netStream.soundTransform.volume; }
		
		/**@private */
		override public function set soundTransform(value:SoundTransform):void {
			netStream.soundTransform	=	value;
		}
		
		/**Annotation*/
		override public function get soundTransform():SoundTransform { return netStream.soundTransform; }
		
		[Inspectable(defaultValue="0", verbose="1", type="Color", category="")]
		/**@private */
		public function set fullScreenBackgroundColor(value:uint):void {
			_fullScreenBackgroundColor	=	value;
		}
		
		/**the background color when full screen*/
		public function get fullScreenBackgroundColor():uint { return _fullScreenBackgroundColor; }
		
		[Inspectable(defaultValue="4", verbose="1", type="Number", category="")]
		/**@private */
		public function set skinScaleMaximum(value:Number):void {
			_skinScaleMaximum	=	value;
		}
		
		/**
		* This property specifies the largest multiple that VideoPlayer will use to scale up
		* its skin when it enters full screen mode with a Flash Player that supports
		* hardware acceleration. 
		* @default 4.0
		*
		* @see #enterFullScreenDisplayState()
		* @see flash.display.Stage#displayState 
		*
		* @langversion 3.0
		* @internal Flash 9.0.xx.0
		*/
		public function get skinScaleMaximum():Number {
			return _skinScaleMaximum;
		}
		
		/**@private */
		protected function set _state(value:String):void {
			if (__state != value) {
				__state	=	value;
				dispatchEvent(new Event("stateChange"));
			}
		}
		/**Annotation*/
		protected function get _state():String { return __state; }
		
		
		//*************************[READ ONLY]**************************************//
		/**video total time*/
		public function get totalTime():Number { return _duration; }
		/**NetStream object*/
		public function get netStream():NetStream { return stream; }
		/**NetStream object*/
		public function get netConnection():NetConnection { return connection; }
		
		/**video total bytes*/
		public function get bytesTotal():uint { return stream.bytesTotal; }
		/**video loaded bytes*/
		public function get bytesLoaded():uint { return stream.bytesLoaded; }
		/**the state*/
		public function get state():String { return __state; }
		/**is full screen*/
		public function get isFullScreen():Boolean { return _isFullScreen;	}
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new VideoPlayer();]
		 */
		public function VideoPlayer() {
			video_mc.height	=	height;
			video_mc.width	=	width;
			scaleX	=
			scaleY	=	1;
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * load video
		 * @param	url
		 * @param	totalTime
		 */
		public function load(url:String, totalTime:Number = NaN):void {
			//trace( "VideoPlayer.load > url : " + url + ", totalTime : " + totalTime );
			_load(url, totalTime);
			stream.seek(0);
			stream.pause();
			_state	=	"loading";
		}
		
		/**
		 * play video
		 * @param	url
		 * @param	totalTime
		 */
		public function play(url:String = null, totalTime:Number = NaN):void {
			//trace( "play : " + url );
			if(url!=null){
				_load(url, totalTime);
				_state	=	"playing";
			}else if(_state!=""){
				switch(_state) {
					case "loading":
					case "paused":
						stream.resume();
					break;
					case "rewinding":
						stream.seek(0);
						stream.resume();
					break;
					case "stopped":
						//stream.seek(0);
						stream.resume();
					break;
					case ""://not load or play nay flv
						return;
					break;
				}
				_state	=	"playing";
			}
		}
		
		/**
		 * pause video
		 */
		public function pause():void {
			stream.pause();
			_state	=	"paused";
		}
		
		/**
		 * stop video
		 */
		public function stop():void {
			stream.pause();
			if(autoRewind){
				stream.seek(0);
			}
			_state	=	"stopped";
		}
		
		/**
		 * seek video
		 * @param	offset
		 */
		public function seek(offset:Number):void {
			stream.seek(offset);
		}
		
		/**
		 * clear video stream
		 */
		public function clear():void {
			stop();
			video_mc.clear();
		}
		
		/**
		 * close video stream
		 */
		public function close():void {
			stop();
			
			stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			stream.close();
			
			connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.close();
		}
		
		/**
		 * destroy instance.
		 */
		public function destroy():void {
			clear();
			close();
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemved);
			
			videoURL	=	null;
			connection	=	null;
			stream		=	null;
		}
		
		/**
		 * exit full screen.
		 */
		public function exitFullScreen():void {
			//if (_videoContainer) {
				//_videoContainer.addChildAt(this, _depthIndex);
			//}
			try {
				stage.displayState = "normal";
			}catch (err:SecurityError) {
				//trace( "err : " + err );
			};
		}
		
		/**
		 * enter full screen display state
		 */
		public function enterFullScreenDisplayState():void {
			
			setFulScreenSourceRect();
			
			try {
				stage.displayState = "fullScreen";
				_isFullScreen	=	true;
				drawVideoBackground();
				stage.addEventListener(FullScreenEvent.FULL_SCREEN, _fullScreen);
			}catch (err:SecurityError) {
				trace( "err : " + err );
			};
			
			
		}
		
		//////////EVENTS
		/**
		 * @private
		 * @param	info
		 */
		public function onMetaData(info:Object):void {
			if (_metadata != null) return;
			_metadata = info;
			//for( var i:String in info ) trace( "key : " + i + ", value : " + info[ i ] );
			if (isNaN(_duration)) _duration = info.duration;
			//if (_videoWidth < 0) _videoWidth = info.width;
			//if (_videoHeight < 0) _videoHeight = info.height;
			
		}
		/**
		 * @private
		 * @param	obj
		 */
		public function onXMPData(obj:Object):void {
			//for( var i:String in obj ) trace( "key : " + i + ", value : " + obj[ i ] );
			
		}
		/**
		 * @private
		 * @param	obj
		 */
		public function onPlayStatus(obj:Object):void {
			//trace( "onPlayStatus : " + onPlayStatus );
			//for( var i:String in obj ) trace( "key : " + i + ", value : " + obj[ i ] );
		}
		
		/**
		 * @private
		 * @param	info
		 */
		public function onCuePoint(info:Object):void {
			//if ( !_hiddenForResize ||
			     //(!isNaN(_hiddenRewindPlayheadTime) && playheadTime < _hiddenRewindPlayheadTime) ) {
				//dispatchEvent(new MetadataEvent(MetadataEvent.CUE_POINT, false, false, info));
			//}
		}
		
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			initConnection();
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemved);
		}
		
		private function _onRemved(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemved);
			destroy();
		}
		
		private function _load(url:String, totalTime:Number):void {
			_metadata	=	null;
			videoURL	=	url;
			_duration	=	(isNaN(totalTime) || totalTime <= 0) ? NaN : totalTime;
			stream.play(url, 0, (isNaN(totalTime) || totalTime <= 0) ? -1 : totalTime);
		}
		
		private function connectStream():void {
            stream			=	new NetStream(connection);
            stream.client	=	this;
			bufferTime		=	_bufferTime;
            stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            video_mc.attachNetStream(stream);
        }

		private function initConnection():void {
			connection	=	new NetConnection();
            connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            connection.connect(null);
		}

		private function netStatusHandler(e:NetStatusEvent):void { 
			//trace( "VideoPlayer.netStatusHandler > e : " + e.info.code );
            switch (e.info.code) {
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetStream.Play.Start":
					dispatchEvent(new Event("videoStartPlay"));
					break;
                case "NetStream.Buffer.Empty":
					dispatchEvent(new Event("videoBufferEmpty"));
					break;
                case "NetStream.Buffer.Full":
					dispatchEvent(new Event("videoBufferFull"));
					break;
                case "NetStream.Seek.Notify":
					dispatchEvent(new Event("videoSeekNotify"));
					break;
                case "NetStream.Play.Stop":
					if (loopPlay) {
						stream.seek(0);
						stream.resume();
					}else{
						if (autoRewind) {
							stream.seek(0);
							stream.pause();
						}
						_state	=	"rewinding";
					}
					dispatchEvent(new Event("videoComplete"));
					break;
                case "NetStream.Play.StreamNotFound":
                    //trace("Unable to locate video: " + videoURL);
					dispatchEvent(new Event("videoNotFound"));
					
                    break;
            }
        }
		
		private function securityErrorHandler(e:SecurityErrorEvent):void {
            //trace("securityErrorHandler: " + e);
			dispatchEvent(e);
        }
        
        private function asyncErrorHandler(e:AsyncErrorEvent):void {
            // ignore AsyncErrorEvent events.
			dispatchEvent(e);
        }

		
		////////////////full screen method
		private function setFulScreenSourceRect():void{
			var srx:Number	=	Capabilities.screenResolutionX;
			var sry:Number	=	Capabilities.screenResolutionY;
			var sRect:Rectangle	=	this.getRect(stage);
			if (width < MIN_WIDTH || height < MIN_HEIGHT) {
				if ( sRect.height * MIN_WIDTH > sRect.width * MIN_HEIGHT) {
					sRect.height	=	MIN_HEIGHT;
					sRect.width		=	sRect.height * width / height;
				}else {
					sRect.width		=	MIN_WIDTH;
					sRect.height	=	sRect.width * height / width;
				}
			}
			//trace2( "sRect : " + sRect );
			var cRect:Rectangle	=	sRect.clone();
			//_skinScaleMaximum	=	2;
			var cPoint:Point	=	new Point(width * .5, height * .5);
			var cPoint2:Point;
			cPoint	=	localToGlobal(cPoint);
			if (srx * sRect.height < sry * sRect.width) {
				
				var rx:Number	=	srx / _skinScaleMaximum;
				if (rx > cRect.width) {
					cRect.width	=	rx;
					
					width	=	rx;
					scaleY	=	scaleX;
					cPoint2	=	parent.globalToLocal(cPoint);
					x		=	cPoint2.x - width * .5;
					y		=	cPoint2.y - height * .5;
					cRect.x	=	cPoint.x - srx * .5 / _skinScaleMaximum;
					//trace2("scale: "+scaleX);
				}else {
				}
				cRect.height	=	cRect.width * sry / srx;
				cRect.y			+=	(sRect.height - cRect.height) * .5;
				
			}else {
				var ry:Number	=	sry / _skinScaleMaximum;
					//trace2( "ry > cRect.height : " + (ry > cRect.height) );
				if (ry > cRect.height) {
					cRect.height	=	ry;
					
					height	=	ry;
					scaleX	=	scaleY;
					cPoint2	=	parent.globalToLocal(cPoint);
					x		=	cPoint2.x - width * .5;
					y		=	cPoint2.y - height * .5;
					cRect.y	=	cPoint.y - sry * .5 / _skinScaleMaximum;
				}else {
					
				}
				cRect.width		=	cRect.height * srx / sry;
				cRect.x			+=	(sRect.width - cRect.width) * .5;
				
			}
			//trace2( "cRect : " + cRect );
			stage.fullScreenSourceRect	=	cRect;
			
		}
		
		private function drawVideoBackground():void {
			var bg:Shape
			if (!_videoBg) {
				bg	=	new Shape();
				addChildAt(bg, 0);
				//trace2( "rect.width/scaleX : " + bg.width+", "+bg.scaleX+", x: "+bg.x+", | "+width+", "+video_mc.width );
				_videoBg	=	bg;
			}else {
				bg	=	_videoBg;
				bg.graphics.clear();
			}
			var rect:Rectangle	=	stage.fullScreenSourceRect;
			if (!rect) {
				removeChild(_videoBg);
				_videoBg	=	null;
				return;
			}
			//trace2( "cRect3 : " + rect );
			var point:Point		=	globalToLocal(rect.topLeft);
			//trace2(stage.fullScreenSourceRect);
			//trace2(stage.width + ", " + stage.stageWidth + ", " + stage.stageHeight);
			bg.graphics.beginFill(_fullScreenBackgroundColor);

			bg.graphics.drawRect(point.x, point.y, rect.width / scaleX, rect.height / scaleY);
			bg.graphics.endFill();
		}
		
		
		private function _fullScreen(e:FullScreenEvent):void {
			
			if (!e.fullScreen) {
				stage.removeEventListener(FullScreenEvent.FULL_SCREEN, _fullScreen);
				stage.fullScreenSourceRect	=	null;
				var cPoint:Point	=	new Point(video_mc.width * .5, video_mc.height * .5);
				cPoint	=	localToGlobal(cPoint);
				scaleX	=	scaleY	=	1;
				var cPoint2:Point	=	parent.globalToLocal(cPoint);
				x		=	cPoint2.x - video_mc.width * .5;
				y		=	cPoint2.y - video_mc.height * .5;
				if (_videoBg) {
					removeChild(_videoBg);
					_videoBg.graphics.clear();
					_videoBg	=	null;
				}
				
			}
			_isFullScreen	=	e.fullScreen;
			
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


*/
