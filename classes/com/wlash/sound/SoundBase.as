//******************************************************************************
//	name:	BackgroundMusic 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2009-4-18 18:42
//	description: This file was created by "sound_switch.fla" file.
//		
//******************************************************************************



package com.wlash.sound {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	
	
	[IconFile("SoundSwitch.png")]
	/**
	 * SoundSwitch.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class SoundBase extends EventDispatcher {

		public var context:SoundLoaderContext;
		
		protected var s_sound:Sound;
		protected var sound_ch:SoundChannel;
		protected var sound_trans:SoundTransform;
		
		private var _isMusicPlaying:Boolean
		
		private var _position:Number	=	0;
		private var _loop:uint;
		private var _loopTimes:uint;
		private var _isLoaded:Boolean;
		private var _isStream:Boolean;
		private var _state:String;
		//************************[READ|WRITE]************************************//
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		public function set volume(value:Number):void {
			sound_trans.volume		=	value;
			if(sound_ch){
				sound_ch.soundTransform	=	sound_trans;
			}
		}
		
		/**Annotation*/
		public function get volume():Number {
			if(sound_ch){
				sound_trans	=	sound_ch.soundTransform;
			}
			return sound_trans.volume;
		}
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		public function set soundId(value:String):void {
			close();
			var soundClass:Class	=	getDefinitionByName(value) as Class;
			s_sound		=	new soundClass();
			_isLoaded	=	true;
		}
		
		
		//************************[READ ONLY]*************************************//
		/**is sound loaded*/
		public function get isLoaded():Boolean { return _isLoaded; }
		
		/**Returns the currently available number of bytes in this sound object.*/
		public function get bytesLoaded():int { return s_sound.bytesLoaded };
		
		/**Returns the total number of bytes in this sound object.*/
		public function get bytesTotal():int { return s_sound.bytesTotal };
		
		/**the loading percent.*/
		public function get percent():Number { return bytesLoaded / bytesTotal };
		
		/**
		 * Construction function.<br></br>
		 * Create a class BY [new SoundBase();]
		 * @param defaultVol
		 */
		public function SoundBase(defaultVol:Number=1, isStream:Boolean=true) {
			sound_trans	=	new SoundTransform(defaultVol, 0);
			_isStream	=	isStream;
			
			_init();
		}
		
		//*************************[PUBLIC METHOD]**********************************//
		public function setSoundId(swf:Sprite, value:String):void {
			var soundClass:Class	=	swf.loaderInfo.applicationDomain.getDefinition(value) as Class;
			s_sound		=	new soundClass();
			_isLoaded	=	true;
		}
		
		public function load(url:String):void {
			if (sound_ch) {
				sound_ch.stop();
			}
			_isLoaded	=	false;
			_position	=	0;
			createSoundObj();
			s_sound.load(new URLRequest(url), context);
			if (_isStream) {
				play();
			}
		}
		
		public function play(p:Number = -1, loop:uint = 0):void {
			if (_isMusicPlaying) {
				sound_ch.stop();
			}
			if (p == -1)	p	=	_position;
			_loop		=	loop;
			_loopTimes	=	0;
			
			_playSound(p);
			_isMusicPlaying	=	true;
			
		}
		
		public function resume():void {
			play(_position, _loop);
		}
		
		public function pause():void {
			_position	=	sound_ch.position;
			sound_ch.stop();
			_isMusicPlaying	=	false;
		}
		
		public function stop():void {
			_position	=	0;
			sound_ch.stop();
			_isMusicPlaying	=	false;
		}
		
		public function close():void {
			if (sound_ch) {
				sound_ch.stop();
			}
			if (s_sound) {
				s_sound.close();
			}
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initializtion this class
		 * 
		 */
		private function _init():void{
			
			
		}
		
		private function createSoundObj():void{
			s_sound		=	new Sound();
			s_sound.addEventListener(Event.COMPLETE, onSoundLoaded);
			s_sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function _playSound(p:Number):void {
			sound_ch	=	s_sound.play(p, 1, sound_trans);
			sound_ch.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		}
		
		/////////////sound load events
		private function onSoundComplete(e:Event):void {
			if (_loop > 0) {
				_loopTimes++;
				if (_loopTimes >= _loop) {
					//stop music
				}else {
					_playSound(0);
				}
			}else {
				_playSound(0);
			}
		}
			
		private function onSoundLoaded(e:Event):void {
			_isLoaded	=	true;
			dispatchEvent(e);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			dispatchEvent(e);
		}
		
				
		//***********************[STATIC METHOD]**********************************//
		
	}
}//end class
//This template is created by whohoo. ver 1.1.0

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]

		[Inspectable(defaultValue="", type="String", verbose="0", name="_targetInstanceName", category="")]
		private var _targetInstanceName:String;

*/
