//******************************************************************************
//	name:	BackgroundMusic 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2009-4-18 18:42
//	description: This file was created by "sound_switch.fla" file.
//		
//******************************************************************************



package com.wlash.sound {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	import gs.easing.Linear;
	import gs.TweenLite;

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
	public class SoundMax extends SoundBase {

		
		
		//************************[READ|WRITE]************************************//
		
		//************************[READ ONLY]*************************************//
		
		
		
		
		/**
		 * Construction function.<br></br>
		 * Create a class BY [new SoundBase();]
		 * @param defaultVol
		 */
		public function SoundMax(defaultVol:Number=1, isStream:Boolean=true) {
			super(defaultVol, isStream);
			
			_init();
		}
		
		//*************************[PUBLIC METHOD]**********************************//
		public function fadeTo(vol:Number, duration:Number=.5, onCompleteFn:Function=null):void {
			TweenLite.to(this, duration, { volume:vol, ease:Linear.easeNone, onComplete:onCompleteFn } );
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
