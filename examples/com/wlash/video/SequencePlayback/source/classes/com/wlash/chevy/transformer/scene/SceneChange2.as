/*utf8*/
//**********************************************************************************//
//	name:	SceneChange 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Wed May 27 2009 18:25:09 GMT+0800
//	description: This file was created by "scene_change.fla" file.
//		
//**********************************************************************************//



package com.wlash.chevy.transformer.scene {

	import com.wlash.video.BitmapsPlayback;
	import com.wlash.video.BitmapsPlayback;
	import com.wlash.video.FrameToBitmap;
	import com.wlash.video.SequencePlayback;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import nl.demonsters.debugger.MonsterDebugger;
	
	
	
	/**
	 * SceneChange.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class SceneChange2 extends MovieClip {
		
		public var moveIn_btn:SimpleButton;//LAYER NAME: "moveIn_btn", FRAME: [1-2], PATH: DOM
		public var moveOut_btn:SimpleButton;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		public var m0_btn:SimpleButton;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		public var m1_btn:SimpleButton;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		public var m2_btn:SimpleButton;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		public var m3_btn:SimpleButton;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		public var m4_btn:SimpleButton;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		
		public var sequence_pb:SequencePlayback;//LAYER NAME: "scene3", FRAME: [1-2], PATH: DOM

		public var isReady:Boolean;
		
		private var _renderSceneDone:int;
		private var _curStaticImg:Bitmap;
		private var _curSceneIndex:int;
		//private var _curScene:BitmapsPlayback;
		private var _moveSpeed:Number;
		private var _moveSequence:Array;
		private var _moveDirFn:String;
		
		private var _totalScene:int;
		private var _staticImgs:Array;
		private var sequence:Dictionary;
		//private var __startTime:int;
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		public function get curSceneIndex():int { return _curSceneIndex; }
		public function get moveSpeed():Number { return _moveSpeed; }
		
		//*************************[STATIC]*****************************************//
		static public const MOVE_FINISH:String			=	"moveFinish";
		static public const ON_SWITCH_NEXT_SCENE:String	=	"onSwitchNextScene";
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new SceneChange();]
		 */
		public function SceneChange2 () {
			sequence	=	new Dictionary();
			new MonsterDebugger(this);
			_moveSpeed	=	1;
			_totalScene	=	4;
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * 开始播放场景，
		 * @param	value 到某个场景
		 * @param	from 强制从某个地方开始播放。
		 */
		public function changeSceneTo(value:int, from:int = -1):void {
			//sequence_pb.currentFrame	=	value + 2;
			sequence_pb.gotoAndPlay("scene"+value);
		}
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			sequence_pb.startLoad("jpg-sequence_", 3);
			
			_initBtnEvents();
			//__startTime		=	getTimer();
		}
		
		
		
		private function getNextScene(mc:BitmapsPlayback):BitmapsPlayback {
			var i:int	=	sequence[mc];
			return this["scene" + (i + 1) % _totalScene];
		}
		
		private function getPrevScene(mc:BitmapsPlayback):BitmapsPlayback {
			var i:int	=	sequence[mc];
			return this["scene" + (i - 1 + _totalScene) % 4];
		}
		
		/**
		 * initialize SimpleButton events.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _initBtnEvents():void {
			moveIn_btn.addEventListener(MouseEvent.CLICK, _onClickBtn, false, 0, false);
			moveIn_btn.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtn, false, 0, false);
			moveIn_btn.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtn, false, 0, false);
			
			moveOut_btn.addEventListener(MouseEvent.CLICK, _onClickBtn, false, 0, false);
			moveOut_btn.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtn, false, 0, false);
			moveOut_btn.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtn, false, 0, false);
			
			for (var i:int = 0; i < 5; i++) {
				var btn:SimpleButton	=	this['m' + i + "_btn"];
				btn.addEventListener(MouseEvent.CLICK, _onClickBtn, false, 0, false);
			}
		};
		
		/**
		 * SimpleButton click event.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _onClickBtn(e:MouseEvent):void {
			//if (!isReady)	return;
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "moveIn_btn" : 
					//trace('eventType: ' + e.type + ', name: ' + moveIn_btn.name);//remove this line with Ctrol+Shift+D
					sequence_pb.moveIn();
				break;
				case "moveOut_btn" : 
					sequence_pb.moveOut();
				break;
				case "m0_btn" : 
					changeSceneTo(0);
				break;
				case "m1_btn" : 
					changeSceneTo(1);
				break;
				case "m2_btn" : 
					changeSceneTo(2);
				break;
				case "m3_btn" : 
					changeSceneTo(3);
				break;
				case "m4_btn" : 
					changeSceneTo(4);
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
				case "moveIn_btn" : 
					//trace('eventType: ' + e.type + ', name: ' + moveIn_btn.name);//remove this line with Ctrol+Shift+D
					
				break;
				case "moveOut_btn" : 
					//trace('eventType: ' + e.type + ', name: ' + moveOut_btn.name);//remove this line with Ctrol+Shift+D
					
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
				case "moveIn_btn" : 
					//trace('eventType: ' + e.type + ', name: ' + moveIn_btn.name);//remove this line with Ctrol+Shift+D
					
				break;
				case "moveOut_btn" : 
					//trace('eventType: ' + e.type + ', name: ' + moveOut_btn.name);//remove this line with Ctrol+Shift+D
					
				break;
			};
		};
		
		
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
