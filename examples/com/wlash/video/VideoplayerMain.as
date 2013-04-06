/*utf8*/
//**********************************************************************************//
//	name:	VideoplayerMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Thu Mar 26 2009 10:24:16 GMT+0800
//	description: This file was created by "videoplayer.fla" file.
//		
//**********************************************************************************//



package  {

	import flash.display.MovieClip;
	import com.wlash.video.VideoPlayer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import gs.TweenLite;
	import fl.video.FLVPlayback;
	
	
	
	/**
	 * VideoplayerMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class VideoplayerMain extends MovieClip {
		public var video2_mc:FLVPlayback;
		public var video_mc:VideoPlayer;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM
		public var play_btn:Sprite;
		public var stop_btn:Sprite;
		public var pause_btn:Sprite;
		public var close_btn:Sprite;
		public var controlBar:Sprite;
		
		private var tw:TweenLite;
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new VideoplayerMain();]
		 */
		public function VideoplayerMain() {
			
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
			//video_mc.play("test.flv");
			//video_mc.load("test.flv");
			stage.addEventListener(MouseEvent.CLICK, onClickStage);
			video_mc.addEventListener("videoComplete", onPlayFinish);
			
			/*play_btn.addEventListener(MouseEvent.CLICK, onClick);
			stop_btn.addEventListener(MouseEvent.CLICK, onClick);
			pause_btn.addEventListener(MouseEvent.CLICK, onClick);
			close_btn.addEventListener(MouseEvent.CLICK, onClick);*/
		}
		
		private function onClick(e:MouseEvent):void {
			if (e.currentTarget == pause_btn) {
				video_mc.pause();
			}else if(e.currentTarget==play_btn){
				video_mc.play();
			}else if(e.currentTarget==stop_btn){
				video_mc.stop();
			}else if (e.currentTarget == close_btn) {
				video_mc.close();
			}
		}
		
		private function onPlayFinish(e:Event):void {
			trace( "onPlayFinish : " + onPlayFinish );
			video_mc.play();
		}
		
		private function onClickStage(e:MouseEvent):void {
			//video_mc.pause();
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
