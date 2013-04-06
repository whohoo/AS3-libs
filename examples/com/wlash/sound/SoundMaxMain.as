/*utf8*/
//**********************************************************************************//
//	name:	SoundMaxMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Fri Sep 18 2009 17:25:44 GMT+0800
//	description: This file was created by "SoundMax.fla" file.
//				
//**********************************************************************************//


//[.SoundMaxMain]
package  {

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.wlash.sound.SoundMax;
	
	
	/**
	 * SoundMaxMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class SoundMaxMain extends MovieClip {
		
		public var btn_mc:SimpleButton;//LAYER NAME: "btn", FRAME: [1-2], PATH: DOM

		
		private var sound:SoundMax;
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new SoundMaxMain();]
		 */
		public function SoundMaxMain() {
			sound	=	new SoundMax(1);
			sound.soundId	=	"bgsound";
			sound.play();
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
			
		}
		
		/**
		 * initialize SimpleButton events.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _initBtnEvents():void {
			btn_mc.addEventListener(MouseEvent.CLICK, _onClickBtn, false, 0, false);
			btn_mc.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtn, false, 0, false);
			btn_mc.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtn, false, 0, false);
			
		};
		
		/**
		 * SimpleButton click event.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _onClickBtn(e:MouseEvent):void {
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "btn_mc" : 
					//trace('eventType: ' + e.type + ', name: ' + btn_mc.name);//remove this line with Ctrol+Shift+D
					
				break;
			};
		};
		
		/**
		 * SimpleButton rollover event.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _onRollOverBtn(e:MouseEvent):void {
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "btn_mc" : 
					//trace('eventType: ' + e.type + ', name: ' + btn_mc.name);//remove this line with Ctrol+Shift+D
					
				break;
			};
		};
		
		/**
		 * SimpleButton rollout event.
		 * @internal AUTO created by JSFL.
		 */
		private function _onRollOutBtn(e:MouseEvent):void {
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "btn_mc" : 
					//trace('eventType: ' + e.type + ', name: ' + btn_mc.name);//remove this line with Ctrol+Shift+D
					
				break;
			};
		};

		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [.SoundMaxMain]
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
