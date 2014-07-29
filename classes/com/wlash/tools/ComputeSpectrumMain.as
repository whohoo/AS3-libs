/**
 * 声普测试。
 * 原打算把声音输出成字串的数组，但因不同的帧率，得出的数据肯定不一样，所以
 * 这个是不可能实践的。
 * 分析声音。
 * 按下mouse左右上下移动可以控制左右声道的大小与平衡。
 */

package com.wlash.tools{
	import flash.display.Graphics;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundChannel;
	import flash.system.System;
	import flash.display.MovieClip;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.ID3Info;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.media.Video;
	import flash.text.TextField;
	
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.events.ActivityEvent;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	
	/**
	* ...
	* @author Default
	*/
	public class  ComputeSpectrumMain extends Sprite{
		public var play_btn:SimpleButton;
		public var stop_btn:SimpleButton;
		public var load_btn:SimpleButton;
		public var out_txt:TextField;
		public var mp3Url_txt:TextField;
		public var radioF:MovieClip;
		public var radioT:MovieClip;
		
		private var _sound:Sound;
		private var sound_ch:SoundChannel;
		private var _timer:Timer;
		private var leftLevel:Sprite;
		private var rightLevel:Sprite;
		private var volmueMC:Sprite;
		
		private var right2Left:Sprite;
		private var right2Right:Sprite;
		private var left2Left:Sprite;
		private var left2Right:Sprite;
		
		
		private var bytes:ByteArray = new ByteArray();
		private const PLOT_HEIGHT:int	 = stage.stageHeight / 2;
		private const CHANNEL_LENGTH:int = 256;
		private var MP3Url:String	=	"music/music01.mp3";
		private var _isPress:Boolean;
		private var _isPlaying:Boolean;
		private var _FFTMode:Boolean;
		private var _leftArr:Array;//把数据保存在这里。不太实际。
		private var _rightArr:Array;
		private var _buttomHeight:Number	=	-20;
		private var _topHeight:Number		=	10;
		
		public function ComputeSpectrumMain() {
			//System.useCodePage	=	false;
			var sprite:Sprite	=	
			leftLevel	=	new Sprite();
			sprite.x	=	10;
			sprite.y	=	stage.stageHeight - 10;
			addChild(sprite);
			sprite	=	
			rightLevel	=	new Sprite();
			sprite.x	=	stage.stageWidth-10;
			sprite.y	=	stage.stageHeight - 10;
			addChild(sprite);
			sprite	=	
			volmueMC	=	new Sprite();
			sprite.x	=	stage.stageWidth/2;
			sprite.y	=	stage.stageHeight - 10;
			addChild(sprite);
			
			sprite	=	
			right2Left	=	new Sprite();
			sprite.x	=	30;
			sprite.y	=	stage.stageHeight - 10;
			addChild(sprite);
			sprite	=	
			right2Right	=	new Sprite();
			sprite.x	=	stage.stageWidth-20;
			sprite.y	=	stage.stageHeight - 10;
			addChild(sprite);
			sprite	=	
			left2Left	=	new Sprite();
			sprite.x	=	20;
			sprite.y	=	stage.stageHeight - 10;
			addChild(sprite);
			sprite	=	
			left2Right	=	new Sprite();
			sprite.x	=	stage.stageWidth-30;
			sprite.y	=	stage.stageHeight - 10;
			addChild(sprite);
			
			
			
			init();
		}
		
		private function init():void {
			//out_txt.mouseEnabled	=	false;

			mp3Url_txt.text	=	MP3Url;
			loadSound(MP3Url);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			play_btn.addEventListener(MouseEvent.CLICK, onClickPlay);
			stop_btn.addEventListener(MouseEvent.CLICK, onClickStop);
			load_btn.addEventListener(MouseEvent.CLICK, onClickLoad);
			radioT.addEventListener(MouseEvent.CLICK, onClickRadio);
			radioF.addEventListener(MouseEvent.CLICK, onClickRadio);
			radioF.buttonMode	=	
			radioT.buttonMode	=	true;
			radioF.gotoAndStop(2);
			radioT.gotoAndStop(1);
			
			startRenderSound();
		}
		
		private function startRenderSound():void {
			if (_isPlaying)	return;
			_leftArr	=	[];
			_rightArr	=	[];
			sound_ch	=	_sound.play(0);
			addEventListener(Event.ENTER_FRAME, _onRenderSound);
			sound_ch.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			showMsg("START SOUND!");
			_isPlaying	=	true;
		}
		
		private function stopRenderSound():void {
			if (!_isPlaying)	return;
			sound_ch.stop();
			removeEventListener(Event.ENTER_FRAME, _onRenderSound);
			showMsg("STOP SOUND!");
			_isPlaying	=	false;
			//trace(arrayToString(_leftArr));
		}
		
		private function onSoundComplete(e:Event):void {
			stopRenderSound();
			
		}
		
		private function _onRenderSound(e:Event):void {
			//trace(sound_ch.position, _sound.length/1000/60);
			drawLeftSoundLevel(sound_ch.leftPeak);
			drawRightSoundLevel(sound_ch.rightPeak);
			drawSoundTransform(sound_ch.soundTransform);
			
			drawSpectrum();
		}
		
		private function drawSoundTransform(st:SoundTransform):void {
			drawVolmueSoundLevel(st.volume);
			
			drawRight2LeftSoundLevel(st.rightToLeft);
			drawRight2RightSoundLevel(st.rightToRight);
			drawLeft2LeftSoundLevel(st.leftToLeft);
			drawLeft2RightSoundLevel(st.leftToRight);
		}
		
		private function loadSound(u:String):void {
			if (sound_ch) {
				sound_ch.stop();
			}
			try {
				_sound.close();
			}catch (err:Error) {
				trace(err);
			}
			MP3Url	=	u;
            //_sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			var url:URLRequest	=	new URLRequest(MP3Url);
			_sound		=	new Sound();
			_sound.addEventListener(Event.COMPLETE, completeHandler);
            _sound.addEventListener(Event.ID3, id3Handler);
            _sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_sound.load(url);
			
		}
		
		private function completeHandler(event:Event):void {
			
        }

        private function id3Handler(event:Event):void {

			showMsg(showID3());
        }

        private function ioErrorHandler(event:Event):void {
			showMsg("load "+MP3Url+" error!");
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler: " + Math.round(event.bytesLoaded/event.bytesTotal*100));
        }
		
		
		private function setPan(pan:Number):void {
            //trace("setPan: " + pan.toFixed(2));
            var transform:SoundTransform = sound_ch.soundTransform;
            transform.pan = pan;
            sound_ch.soundTransform = transform;
        }

        private function setVolume(volume:Number):void {
            //trace("setVolume: " + volume.toFixed(2));
            var transform:SoundTransform = sound_ch.soundTransform;
            transform.volume = volume;
            sound_ch.soundTransform = transform;
        }
		
		/////mouse events
        private function onClickRadio(event:MouseEvent):void {
			if (event.currentTarget == radioF) {
				if (_FFTMode) {
					_FFTMode	=	false;
					radioF.gotoAndStop(2);
					radioT.gotoAndStop(1);
				}
			}else {
				if (!_FFTMode) {
					_FFTMode	=	true;
					radioT.gotoAndStop(2);
					radioF.gotoAndStop(1);
				}
			}
		}
        private function onClickLoad(event:MouseEvent):void {
			var _isPlaying:Boolean	=	this._isPlaying;
			stopRenderSound();
			loadSound(mp3Url_txt.text);
			if (_isPlaying) {
				startRenderSound();
			}
		}
        private function onClickPlay(event:MouseEvent):void {
			startRenderSound();
		}
        private function onClickStop(event:MouseEvent):void {
			stopRenderSound();
		}
        private function mouseDownHandler(event:MouseEvent):void {
			_isPress	=	true;
		}
        private function mouseUpHandler(event:MouseEvent):void {
			_isPress	=	false;
		}
        private function mouseMoveHandler(event:MouseEvent):void {
			if (!_isPress)	return;
            var halfStage:uint = Math.floor(stage.stageWidth / 2);
            var xPos:uint = event.stageX;
            var yPos:uint = event.stageY;
            var value:Number;
            var pan:Number;

            if (xPos > halfStage) {
                value = xPos / halfStage;
                pan = value - 1;
            } else if (xPos < halfStage) {
                value = (xPos - halfStage) / halfStage;
                pan = value;
            } else {
                pan = 0;
            }

            var volume:Number = 1 - (yPos / stage.stageHeight);

            setVolume(volume);
            setPan(pan);
            
        }

		//draw
		private function drawLeftSoundLevel(num:Number):void {
			var gr:Graphics	=	leftLevel.graphics;
			gr.clear();
			gr.moveTo(0, _buttomHeight);
			gr.lineStyle(10, 0x6600CC);
			gr.lineTo(0, -num * (stage.stageHeight - _topHeight)+_buttomHeight);
		}
		
		private function drawRightSoundLevel(num:Number):void {
			var gr:Graphics	=	rightLevel.graphics;
			gr.clear();
			gr.moveTo(0, _buttomHeight);
			gr.lineStyle(10, 0xCC0066);
			gr.lineTo(0, -num*(stage.stageHeight-_topHeight)+_buttomHeight);
		}
		
		private function drawVolmueSoundLevel(num:Number):void {
			var gr:Graphics	=	volmueMC.graphics;
			gr.clear();
			gr.moveTo(0, _buttomHeight);
			gr.lineStyle(20, 0xffff00);
			gr.lineTo(0, -num*(stage.stageHeight-_topHeight)+_buttomHeight);
		}
		
		private function drawRight2LeftSoundLevel(num:Number):void {
			var gr:Graphics	=	right2Left.graphics;
			gr.clear();
			gr.moveTo(0, _buttomHeight);
			gr.lineStyle(5, 0x990000);
			gr.lineTo(0, -num*(stage.stageHeight-_topHeight)+_buttomHeight);
		}
		
		private function drawRight2RightSoundLevel(num:Number):void {
			var gr:Graphics	=	right2Right.graphics;
			gr.clear();
			gr.moveTo(0, _buttomHeight);
			gr.lineStyle(5, 0xDD0000);
			gr.lineTo(0, -num*(stage.stageHeight-_topHeight)+_buttomHeight);
		}
		
		private function drawLeft2LeftSoundLevel(num:Number):void {
			var gr:Graphics	=	left2Left.graphics;
			gr.clear();
			gr.moveTo(0, _buttomHeight);
			gr.lineStyle(5, 0xDD0000);
			gr.lineTo(0, -num*(stage.stageHeight-_topHeight)+_buttomHeight);
		}
		
		private function drawLeft2RightSoundLevel(num:Number):void {
			var gr:Graphics	=	left2Right.graphics;
			gr.clear(); 
			gr.moveTo(0, _buttomHeight);
			gr.lineStyle(5, 0x990000);
			gr.lineTo(0, -num*(stage.stageHeight-_topHeight)+_buttomHeight);
		}
		
		private function drawSpectrum():void{
			SoundMixer.computeSpectrum(bytes, _FFTMode, 0);
			
			var g:Graphics = this.graphics;
			
			g.clear();
			g.lineStyle(0, 0x6600CC);
			g.beginFill(0x6600CC);
			g.moveTo(0, PLOT_HEIGHT);
			
			var n:Number = 0;
			var f:Number;
			var arr:Array	=	[];
			// left channel
			for (var i:int = 0; i < CHANNEL_LENGTH; i++) {
				f	=	bytes.readFloat();
				n	=	( f* PLOT_HEIGHT);
				g.lineTo(i * 2, PLOT_HEIGHT - n);
				//if (i != 25)	continue;//只输出第25位的数值。
				arr.push(f);
			}
			g.lineTo(CHANNEL_LENGTH * 2, PLOT_HEIGHT);
			g.endFill();
			_leftArr.push(arr);
			
			// right channel
			g.lineStyle(0, 0xCC0066);
			g.beginFill(0xCC0066, 0.5);
			g.moveTo(CHANNEL_LENGTH * 2, PLOT_HEIGHT);
			arr	=	[];
			for (i = CHANNEL_LENGTH; i > 0; i--) {
				f	=	bytes.readFloat();
				n	=	(f * PLOT_HEIGHT);
				g.lineTo(i * 2, PLOT_HEIGHT - n);
				arr.push(f);
			}
			g.lineTo(0, PLOT_HEIGHT);
			g.endFill();
			_rightArr.push(arr);
		}

		//////show message
		private function showMsg(msg:String):void {
			out_txt.appendText(msg + "\r\n");
			out_txt.scrollH	=	out_txt.maxScrollH;
		}

		private function showID3():String{
			var id3:ID3Info	=	_sound.id3;
			var out:String	=	("ID3[album: " + id3.album + ", songName: " + id3.songName + ", artist: " + id3.artist +
					", year: "+id3.year+", track: "+id3.track+", genre: "+id3.genre+", comment: "+id3.comment+"]\r");
			out+=("ID3 MORE[文件类型: " + id3.TFLT + ", 时间: " + id3.TIME + ", 内容组说明: " + id3.TIT1 +
			", 标题/歌曲名称/内容说明: " + id3.TIT2 + ", 副标题/说明精选: " + id3.TIT3 + ", 初始密钥: " + id3.TKEY + ", 语言: " + id3.TLAN +
			", 长度: " + id3.TLEN + ", 媒体类型: " + id3.TMED + ", 原始唱片/影片/演出标题: " + id3.TOAL + ", 原始文件名: " + id3.TOFN +
			", 原词作者/乐谱作者: " + id3.TOLY + ", 原始艺术家/表演者: " + id3.TOPE + ", 原始发行年份: " + id3.TORY + ", 文件所有者/获得授权者: " + id3.TOWN +
			", 主要表演者/独奏（独唱）: " + id3.TPE1 + ", 乐队/管弦乐队/伴奏: " + id3.TPE2 + ", 指挥/主要演奏者: " + id3.TPE3 +
			", 翻译、混录员或以其它方式进行修改的人员: " + id3.TPE4 +", 歌曲集部分: " + id3.TPOS +", 发行者: " + id3.TPUB +
			", 歌曲集中的曲目编号/位置: " + id3.TRCK +", 录制日期: " + id3.TRDA +", ISRC（国际标准音像制品编码）: " + id3.TSRC +
			", Internet 无线电台所有者: " + id3.TRSO +", 大小: " + id3.TSIZ +", Internet 无线电台名称: " + id3.TRSN +
			", 用于编码的软件/硬件和设置: " + id3.TSSE +", 年份: " + id3.TYER +", URL 链接帧: " + id3.WXXX +"]");
			return out;
		}
		
		private function arrayToString(arr:Array):String {
			var str:String	=	"";
			var len:int	=	arr.length;
			var len2:int;
			var a:Array;
			for (var i:int = 0; i < len; i++) {
				str	+=	"[";
				a	=	arr[i];
				len2	=	a.length;
				for (var ii:int = 0; ii < len2; ii++) {
					str	+=	"\"" + a[ii] + "\", ";
				}
				str	=	str.substr(0, str.length - 2)+"], \r";
			}
			return "[ "+str.substr(0, str.length-3)+" ]";
		}
	}
	
}