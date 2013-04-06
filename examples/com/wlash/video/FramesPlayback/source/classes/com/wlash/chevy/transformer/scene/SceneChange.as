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
	import com.wlash.video.FrameToBitmap;
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
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import nl.demonsters.debugger.MonsterDebugger;
	
	
	
	/**
	 * SceneChange.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class SceneChange extends MovieClip {
		
		public var moveIn_btn:SimpleButton;//LAYER NAME: "moveIn_btn", FRAME: [1-2], PATH: DOM
		public var moveOut_btn:SimpleButton;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		public var m0_btn:SimpleButton;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		public var m1_btn:SimpleButton;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		public var m2_btn:SimpleButton;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		public var m3_btn:SimpleButton;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		public var m4_btn:SimpleButton;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		public var msg_txt:TextField;//LAYER NAME: "moveOut_btn", FRAME: [1-2], PATH: DOM
		
		public var scene3:BitmapsPlayback;//LAYER NAME: "scene3", FRAME: [1-2], PATH: DOM
		public var scene2:BitmapsPlayback;//LAYER NAME: "scene3", FRAME: [1-2], PATH: DOM
		public var scene1:BitmapsPlayback;//LAYER NAME: "scene3", FRAME: [1-2], PATH: DOM
		public var scene0:BitmapsPlayback;//LAYER NAME: "scene3", FRAME: [1-2], PATH: DOM

		public var isReady:Boolean;
		
		private var _renderSceneDone:int;
		private var _curStaticImg:Bitmap;
		private var _curSceneIndex:int;
		private var _curScene:BitmapsPlayback;
		private var _moveSpeed:Number;
		private var _moveSequence:Array;
		private var _moveDirFn:String;
		
		private var _totalScene:int;
		private var _staticImgs:Array;
		private var _staticImg:Bitmap;
		private var sequence:Dictionary;
		//private var __startTime:int;
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		public function get curSceneIndex():int { return _curSceneIndex; }
		public function get moveSpeed():Number { return _moveSpeed; }
		public function get sceneReady():Number { return _renderSceneDone; }
		
		//*************************[STATIC]*****************************************//
		static public const MOVE_FINISH:String			=	"moveFinish";
		static public const ON_SWITCH_NEXT_SCENE:String	=	"onSwitchNextScene";
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new SceneChange();]
		 */
		public function SceneChange() {
			sequence	=	new Dictionary();
			//new MonsterDebugger(this);
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
			_staticImg.bitmapData	=	null;
			if (from >= 0) {
				_curSceneIndex	=	from;
			}
			_moveSequence	=	getMovingSceneSequence(value);
			var scene:BitmapsPlayback	=	_moveSequence.shift() as BitmapsPlayback;
			if (!scene)	return;
			_moveSpeed	=	(Math.abs(value-_curSceneIndex)-1)*.25+1;
			if (value > _curSceneIndex) {//forward
				_moveDirFn	=	"moveIn";
			}else if (value < _curSceneIndex) {//backward
				_moveDirFn	=	"moveOut";
			}else {
				
			}
			if (_curStaticImg) {
				removeChild(_curStaticImg);
				_curStaticImg	=	null;
			}
			
			if (!_curScene) {
				scene.gotoAndStop(_moveDirFn=="moveIn" ? 1 : scene.totalFrames);
			}
			_moveScene(scene);
		}
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			_staticImgs			=	[];
			_renderSceneDone	=	0;
			var len:int	=	 _totalScene;
			for (var i:int = 0; i < len; i++) {
				var mc:BitmapsPlayback	=	new BitmapsPlayback();
				addChild(mc);
				mc.visible			=	false;
				sequence[mc]		=	i;
				this['scene' + i]	=	mc;
				//if (i < 2)	loadScene("scene"+i+".swf");
				createStaticImage(i);
			}
			loadScene("scene0.swf");
			_initBtnEvents();
			//__startTime		=	getTimer();
			createStaticImage(i);
			_staticImg	=	new Bitmap();
			addChild(_staticImg);
			attachStaticImage();
		}
		
		private function loadScene(url:String):void{
			var loader:Loader	=	new Loader();
			loader.load(new URLRequest(url));
			//if(url=="scene0.swf")
			loader.contentLoaderInfo.addEventListener(Event.INIT, onSceneInit);
			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSceneLoaded);
		}
		
		private function onSceneInit(e:Event):void {
			e.currentTarget.removeEventListener(Event.INIT, onSceneLoaded);
			var scene:DisplayObject	=	LoaderInfo(e.currentTarget).content;
			scene["rebuildCache"]();
			scene.addEventListener("finish", onSceneRenderFinish);
		}
		
		private function onSceneRenderFinish(e:Event):void {
			_renderSceneDone++;
			//trace( "_renderSceneDone : " + _renderSceneDone );
			var scene:DisplayObject	=	e.currentTarget as DisplayObject;
			scene.removeEventListener("finish", onSceneRenderFinish);
			var url:String	=	scene.loaderInfo.url;
			//trace( "url : " + url );
			var index:int	=	int(url.substr(url.length - 5, 1));
			this["scene" + index].setBitmaps(scene["bitmaps"]);
			msg_txt.text	=	( "_renderSceneDone : " +  index);
			if (_renderSceneDone == 4) {
				isReady			=	true;
				dispatchEvent(e);
			}
			Loader(scene.parent).unload();
			if (index < 3)
				loadScene("scene" + (index + 1) + ".swf");
			else
				msg_txt.text	=	"done.";
		}
		
		private function onSceneLoaded(e:Event):void {
			e.currentTarget.removeEventListener(Event.COMPLETE, onSceneLoaded);
			//LoaderInfo(e.currentTarget).loader.unload();
		}
		
		
		///static images
		private function createStaticImage(i:int):void {
			var bmpClass:Class	=	getDefinitionByName("all_fin_" + i + ".jpg") as Class;
			var bmp:BitmapData	=	new bmpClass(0,0) as BitmapData;
			_staticImgs.push(bmp);
		}
		
		private function _moveScene(scene:BitmapsPlayback):void {
			scene[_moveDirFn](0, onChangeEnd, _moveSpeed);
			scene.visible		=	true;
			_curScene			=	scene;
		}
		
		private function onCacheFinish(e:Event):void {
			trace( "onCacheFinish : "  );
			//trace( "onCacheFinish : " + (getTimer()-__startTime)+"ms" );
			e.currentTarget.removeEventListener("finish", onCacheFinish);
			isReady			=	true;
			
			dispatchEvent(e);
		}
		
		private function onChangeEnd(mc:BitmapsPlayback):void {
			mc.visible		=	false;
			_curSceneIndex	=	_moveDirFn == "moveIn" ? (_curSceneIndex + 1) : (_curSceneIndex - 1);
			
			if (_moveSequence.length > 0) {
				var scene:BitmapsPlayback	=	_moveSequence.shift() as BitmapsPlayback;
				scene.gotoAndStop(_moveDirFn == "moveIn" ? 1 : scene.totalFrames);
				
				_moveScene(scene);
				dispatchEvent(new Event(ON_SWITCH_NEXT_SCENE));
			}else {//end
				attachStaticImage();
				_curScene		=	null;
				dispatchEvent(new Event(MOVE_FINISH));
			}
		}
		
		private function attachStaticImage():void {
			_staticImg.bitmapData	=	_staticImgs[_curSceneIndex];
		}
		
		private function getMovingSceneSequence(value:int):Array {
			var arr:Array	=	[];
			
			var i:int;
			//var scene:BitmapsPlayback;
			if (value > _curSceneIndex) {//forward
				//scene	=	getCurMoveScene( -1);
				//if (!_curScene) {
					//scene.gotoAndStop(scene.totalFrames);
				//}
				i	=	_curSceneIndex;
				while (i < value) {
					arr.push(this["scene" + (i)]);
					i++;
				}
			}else if (value < _curSceneIndex) {//backward
				//scene	=	getCurMoveScene(1);
				//if (!_curScene) {
					//scene.gotoAndStop(1);
				//}
				i	=	_curSceneIndex;
					
				while (i > value) {
					arr.push(this["scene" + (i-1)]);
					i--;
				}
			}
			if (arr.length == 0) {
				if(_curScene){
					arr	=	[_curScene];
				}
			}
			return arr;
		}
		
		private function getCurMoveScene(dir:int):BitmapsPlayback {
			var scene:BitmapsPlayback;
			if (_curScene) {
				return _curScene;
			}else {
				if (dir == 1) {//forward
					if (_curSceneIndex < _totalScene) {
						scene	=	this["scene" + _curSceneIndex];
						scene.gotoAndStop(1);
					}
				}else {//backward
					if (_curSceneIndex > 0) {
						scene	=	this["scene" + (_curSceneIndex - 1)];
						scene.gotoAndStop(scene.totalFrames);
					}
				}
			}
			return scene;
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
			if (!isReady)	return;
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "moveIn_btn" : 
					//trace('eventType: ' + e.type + ', name: ' + moveIn_btn.name);//remove this line with Ctrol+Shift+D
					changeSceneTo(4);
				break;
				case "moveOut_btn" : 
					changeSceneTo(0);
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
