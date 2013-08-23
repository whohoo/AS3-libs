/*utf8*/
//**********************************************************************************//
//	name:	AbLoader 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Sun Aug 09 2009 20:58:58 GMT+0800
//	description: This file was created by "main.fla" file.
//				v1.0 从原先的 AbContent中分出来
//**********************************************************************************//


//[com.wlash.loader.AbLoader]
package com.wlash.loader {

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.LoaderContext;
	
	import flash.display.LoaderInfo;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * AbLoader.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AbLoader extends Sprite {
		public var curLoader:Loader;
		public var isLoaded:Boolean;
		
		protected var _contentPercent:Number;
		protected var loader0:Loader;
		protected var loader1:Loader;
		protected var _loadUrl:String;
		
		protected var _checkPolicyFile:Boolean;
		
		private var _contentShowFn:Function;
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		/**Annotation*/
		public function get preLoader():Loader { return curLoader == loader0 ? loader1 : loader0; }
		
		/**Annotation*/
		public function get curContent():DisplayObject { return curLoader.content; }
		
		/** current loading percent*/
		public function get percent():Number { return _contentPercent; }
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new Content();]
		 */
		public function AbLoader() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		public function loadContent(url:String, showFn:Function = null):void {
			_loadUrl	=	url;
			var loaderContext:LoaderContext	=	new LoaderContext(_checkPolicyFile);
			preLoader.load(new URLRequest(url), loaderContext);
			_contentShowFn		=	showFn;
			isLoaded			=	false;
			_contentPercent		=	0;
		}
		
		public function unloadCurLoader():void {
			curLoader.unload();
		}
		
		public function showContent(...args:*):void {
			unloadCurLoader();
			curLoader			=	preLoader;
			curLoader.visible	=	true;
		}
		
		public function destroy():void {
			removeListenersDownload(loader0.contentLoaderInfo);
			removeListenersDownload(loader1.contentLoaderInfo);
			unloadCurLoader();
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		
		/*****BEGIN DOWNLOAD EVENTS ******/
		protected function openHandler(e:Event):void  {
			var loaderInfo:LoaderInfo	=	e.currentTarget as LoaderInfo;
			preLoader.visible			=	false;
		}
		
		protected function progressHandler(e:ProgressEvent):void  {
			_contentPercent	=	e.bytesLoaded / e.bytesTotal;
		}
		
		protected function initHandler(e:Event):void  {
			
		}
		
		protected function completeHandler(e:Event):void  {
			_contentPercent	=	1;//因为在etam goodies，因为加载的bytesTotal值会比实际文件大？怪事，因为gzip原因？？
			isLoaded	=	true;
			if (_contentShowFn != null) {
				var loader:LoaderInfo = e.currentTarget as LoaderInfo;
				_contentShowFn(loader.content);
				_contentShowFn = null;
			}
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
		
		protected function unLoadHandler(event:Event):void  {
			//trace("unLoadHandler: " + event);
		}
		/**** END DOWNLOAD EVENTS *****/
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			loader0			=	new Loader();
			loader0.name	=	"loader0";
			addChild(loader0);
			
			loader1			=	new Loader();
			loader1.name	=	"loader1";
			addChild(loader1);
			
			curLoader		=	loader0;
			
			configureListenersDownload(loader0.contentLoaderInfo);
			configureListenersDownload(loader1.contentLoaderInfo);
		}
		
		/////////////////////loader events
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
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.skoda.superb.Content]
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
