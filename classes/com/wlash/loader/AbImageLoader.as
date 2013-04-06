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
	import flash.net.URLRequest;
	
	
	
	/**
	 * 只有一图片的加载，如果有两图片加载并要切换的，用AbImageLoader2
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AbImageLoader extends Sprite {
		
		public var mask_mc:Sprite;//LAYER NAME: "mask_mc", FRAME: [1-2], PATH: mc/yuanzi
		public var image_mc:Sprite;//LAYER NAME: "图层 2", FRAME: [1-2], PATH: mc/yuanzi

		protected var _loader:Loader;
		
		protected var _diffWidth:Number;
		protected var _diffHeight:Number;
		protected var _targetImageX:Number;
		protected var _targetImageY:Number;
		
		protected var _centerImageX:Number;
		protected var _centerImageY:Number;
		
		private var _fitToMask:Boolean;
		private var _mouseScroll:Boolean;
		private var _isHoverImage:Boolean;
		//*************************[READ|WRITE]*************************************//
		public function get fitToMask():Boolean { return _fitToMask; }
		
		public function set fitToMask(value:Boolean):void {
			if (value == _fitToMask)	return;
			_fitToMask	=	value;
			if (value) {
				if (_loader.width * mask_mc.width < _loader.height * mask_mc.height) {
					_loader.width	=	mask_mc.width;
					_loader.scaleY	=	_loader.scaleX;
				}else {
					_loader.height	=	mask_mc.height;
					_loader.scaleX	=	_loader.scaleY;
				}
			}else {
				_loader.scaleX	=	1;
				_loader.scaleY	=	1;
			}
		}
		
		public function get mouseScroll():Boolean { return _mouseScroll; }
		
		public function set mouseScroll(value:Boolean):void {
			if (value == _mouseScroll)	return;
			_mouseScroll	=	value;
			if(value){
				if (_loader.width > mask_mc.width || _loader.height > mask_mc.height) {
					_diffWidth	=	_loader.width - mask_mc.width;
					_diffHeight	=	_loader.height - mask_mc.height;
					startImageScroll();
				}
			}else {
				stopImageScroll();
			}
		}
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ThumbImageLoader();]
		 */
		public function AbImageLoader() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		public function loadImage(url:String):void {
			_loadImage(new URLRequest(url));
		}
		
		public function unloadImage():void {
			_loader.unload();
		}
		
		public function startImageScroll():void {
			addEventListener(Event.ENTER_FRAME, _scrollImageByMouse);
			addEventListener(MouseEvent.ROLL_OVER, _onOverImage);
			addEventListener(MouseEvent.ROLL_OUT, _onOutImage);
		}
		
		public function stopImageScroll():void {
			removeEventListener(Event.ENTER_FRAME, _scrollImageByMouse);
			removeEventListener(MouseEvent.ROLL_OVER, _onOverImage);
			removeEventListener(MouseEvent.ROLL_OUT, _onOutImage);
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoving);
		}
		
		public function destory():void {
			removeListenersDownload(_loader.contentLoaderInfo);
			stopImageScroll();
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
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
			if (_diffWidth > 0) {
				var diffX:Number	=	_targetImageX - _loader.x;
				_loader.x	+=	diffX * .5;
			}
			
			if (_diffHeight > 0) {
				var diffY:Number	=	_targetImageY - _loader.y;
				_loader.y	+=	diffY * .5;
			}
		}
		
		protected function _loadImage(req:URLRequest):void {
			_loader.load(req);
		}
		
		/*****BEGIN DOWNLOAD EVENTS ******/
		protected function openHandler(e:Event):void  {
			//trace("openHandler: " + e);
		}
		protected function progressHandler(e:ProgressEvent):void  {
			//var p:Number	=	e.bytesLoaded / e.bytesTotal;
			
		}
		protected function initHandler(e:Event):void  {
			//trace("initHandler: " + e);
		}
		protected function completeHandler(e:Event):void  {
			var loaderInfo:LoaderInfo	=	e.currentTarget as LoaderInfo;
			_loader.x	=	-_loader.width * .5;
			_loader.y	=	-_loader.height * .5;
		}
		protected function securityErrorHandler(e:SecurityErrorEvent):void  {
			trace("securityErrorHandler: " + e);
		}
		protected function httpStatusHandler(e:HTTPStatusEvent):void  {
			//trace("httpStatusHandler: " + e);
		}
		protected function ioErrorHandler(e:IOErrorEvent):void  {
			trace("ioErrorHandler: " + e);
		}
		protected function unLoadHandler(e:Event):void  {
			//trace("unLoadHandler: " + e);
		}
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			_loader	=	new Loader();
			image_mc.addChild(_loader);
			configureListenersDownload(_loader.contentLoaderInfo);
			image_mc.mask	=	mask_mc;
		}
		
		private function configureListenersDownload(dispatcher:LoaderInfo):void  {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(Event.INIT, initHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
		}
		
		private function removeListenersDownload(dispatcher:LoaderInfo):void  {
			dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
			dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.removeEventListener(Event.INIT, initHandler);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.removeEventListener(Event.OPEN, openHandler);
			dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.removeEventListener(Event.UNLOAD, unLoadHandler);
		}
		/**** END DOWNLOAD EVENTS *****/
		
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
