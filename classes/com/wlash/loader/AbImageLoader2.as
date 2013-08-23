/*utf8*/
//**********************************************************************************//
//	name:	ThumbImageLoader 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Wed Jun 22 2011 15:51:03 GMT+0800
//	description: This file was created by "vans_legend.fla" file.
//				
//**********************************************************************************//


//[com.wlash.loader.AbImageLoader]
package com.wlash.loader {

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	
	
	/**
	 * ThumbImageLoader.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AbImageLoader2 extends AbLoader {
		
		public var mask_mc:Sprite;//LAYER NAME: "mask_mc", FRAME: [1-2], PATH: mc/yuanzi

		protected var _container:Sprite;
		
		protected var _diffWidth:Number;
		protected var _diffHeight:Number;
		protected var _targetImageX:Number;
		protected var _targetImageY:Number;
		
		protected var _centerImageX:Number;
		protected var _centerImageY:Number;
		
		protected var _fadeStepNum:Number;
		protected var _scrollStepNum:Number;
		
		protected var _fitToMask:Boolean;
		private var _smoothing:Boolean;
		private var _mouseScroll:Boolean;
		private var _isHoverImage:Boolean;
		
		//*************************[READ|WRITE]*************************************//
		/** 图片是否自动缩放到mask的大小。 */
		public function get fitToMask():Boolean { return _fitToMask; }
		/**@private */
		public function set fitToMask(value:Boolean):void {
			if (value == _fitToMask)	return;
			_fitToMask	=	value;
			_setFitToMask(preLoader, value);
		}
		/** 图片因mask被截掉部分，可通过mouse移动来浏览 */
		public function get mouseScroll():Boolean { return _mouseScroll; }
		/**@private */
		public function set mouseScroll(value:Boolean):void {
			if (value == _mouseScroll)	return;
			_mouseScroll	=	value;
			if(value){
				var _loader:Loader		=	curLoader;
				if (_loader.width > mask_mc.width || _loader.height > mask_mc.height) {
					_diffWidth	=	_loader.width - mask_mc.width;
					_diffHeight	=	_loader.height - mask_mc.height;
					startImageScroll();
				}
			}else {
				stopImageScroll();
			}
		}
		
		public function get smoothing():Boolean { return _smoothing; }
		
		public function set smoothing(value:Boolean):void {
			if (value == _smoothing)	return;
			_smoothing	=	value;
			var bmp:Bitmap	=	preLoader.content as Bitmap;
			if (bmp) {
				bmp.smoothing	=	value;
			}
		}
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ThumbImageLoader();]
		 */
		public function AbImageLoader2() {
			//loader0.x =	mask_mc.width >> 1;
			//loader0.y =	mask_mc.height >> 1;
			//
			//loader1.x =	mask_mc.width >> 1;
			//loader1.y =	mask_mc.height >> 1;
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		public function loadImage(url:String):void {
			
			loadContent(url);
		}
		
		
		override public function destroy():void {
			super.destroy();
			stopImageScroll();
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		protected function _createContainer():void {
			_container	=	new Sprite();
			addChildAt(_container, 0);
		}
		
		/**
		 * 使_container在mask的中心
		 */
		protected function _setContainerCenter():void {
			var rect:Rectangle	=	mask_mc.getBounds(this);
			_container.x	=	rect.x + rect.width * .5;
			_container.y	=	rect.y + rect.height * .5;
			
		}
		
		/**
		 * 在调用此方法前，最好图片是居中的，调用_setContainerCenter使图片居中
		 * @param	loader
		 * @param	value
		 */
		protected function _setFitToMask(loader:Loader, value:Boolean):void {
			if (value) {
				if (loader.width * mask_mc.height < loader.height * mask_mc.width) {
					loader.width	=	mask_mc.width;
					loader.scaleY	=	loader.scaleX;
				}else {
					loader.height	=	mask_mc.height;
					loader.scaleX	=	loader.scaleY;
				}
			}else {
				loader.scaleX	=	1;
				loader.scaleY	=	1;
			}
			_setLoaderCenter(loader);
		}
		
		protected function _setLoaderCenter(loader:Loader):void {
			loader.x		=	-loader.width * .5;
			loader.y		=	-loader.height * .5;
			_centerImageX	=	loader.x;
			_centerImageY	=	loader.y;
		}
		
		protected function startImageScroll():void {
			addEventListener(Event.ENTER_FRAME, _scrollImageByMouse);
			addEventListener(MouseEvent.ROLL_OVER, _onOverImage);
			addEventListener(MouseEvent.ROLL_OUT, _onOutImage);
			if (hitTestPoint(root.mouseX, root.mouseY)) {
				_onOverImage(null);
				_onMouseMoving(null);
			}
		}
		
		protected function stopImageScroll():void {
			removeEventListener(Event.ENTER_FRAME, _scrollImageByMouse);
			removeEventListener(MouseEvent.ROLL_OVER, _onOverImage);
			removeEventListener(MouseEvent.ROLL_OUT, _onOutImage);
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoving);
		}
		
		protected function _onOverImage(e:MouseEvent):void {
			_isHoverImage	=	true;
			addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoving);
		}
		
		protected function _onMouseMoving(e:MouseEvent):void {
			var mx:Number	=	mask_mc.mouseX;
			var my:Number	=	mask_mc.mouseY;
			var px:Number	=	mx / mask_mc.width;
			var py:Number	=	my / mask_mc.height;
			_targetImageX	=	_centerImageX - _diffWidth * px;
			_targetImageY	=	_centerImageY - _diffHeight * py;
		}
		
		protected function _onOutImage(e:MouseEvent):void {
			_isHoverImage	=	false;
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoving);
		}
		
		protected function _scrollImageByMouse(e:Event):void {
			if (!_isHoverImage)	return;
			var _loader:Loader	=	curLoader;
			if (_diffWidth > 0) {
				var diffX:Number	=	_targetImageX - _loader.x;
				_loader.x	+=	diffX * _scrollStepNum;
			}
			
			if (_diffHeight > 0) {
				var diffY:Number	=	_targetImageY - _loader.y;
				_loader.y	+=	diffY * _scrollStepNum;
			}
		}
		
		protected function _switchImages():void {
			addEventListener(Event.ENTER_FRAME, _onSwitchImages);
		}
		
		protected function _onSwitchImages(e:Event):void {
			preLoader.alpha	+=	_fadeStepNum;
			curLoader.alpha	=	1 - preLoader.alpha;
			if (preLoader.alpha >= 1) {
				preLoader.alpha		=	1;
				curLoader.alpha		=	0;
				curLoader.visible	=	false;
				removeEventListener(Event.ENTER_FRAME, _onSwitchImages);
				_onSwitchImageDone();
				
			}else {
				
			}
		}
		
		protected function _onSwitchImageDone():void {
			unloadCurLoader();
			curLoader	=	preLoader;
		}
		
		//////////loading events
		override protected function openHandler(e:Event):void {
			super.openHandler(e);
			preLoader.alpha		=	0;
			preLoader.visible	=	true;
		}
		
		override protected function completeHandler(e:Event):void {
			super.completeHandler(e);
			
			_switchImages();
		}
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			_createContainer();
			_setContainerCenter();
			
			_container.mask		=	mask_mc;
			_container.addChild(loader0);
			_container.addChild(loader1);
			
			_fadeStepNum	=	.1;
			_scrollStepNum	=	.2;
		}
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.loader.AbImageLoader]
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
