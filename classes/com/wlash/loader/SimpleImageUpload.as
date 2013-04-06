/*utf8*/
//**********************************************************************************//
//	name:	SimpleImageUpload 1.2
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Apr 20 2009 21:37:12 GMT+0800
//	description: This file was created by "diy_card.fla" file.
//		v1.1增加了imageUrl属性,当图片上传完成时,返回图片路径.
//		v1.2增加了maxFileSize,
//**********************************************************************************//



package com.wlash.loader {

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.LoaderContext;

	
	import flash.net.FileReference;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.DataEvent;
	import flash.net.FileFilter;
	import flash.display.LoaderInfo;
	import flash.utils.getTimer;
	
	/**
	 * SimpleImageUpload.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class SimpleImageUpload extends Sprite {
		
		[Inspectable(defaultValue = "0", verbose = "0", type = "Number", category = "")]
		/**upload max file size, default 0 means no limit*/
		public var maxFileSize:int			=	0;
		
		[Inspectable(defaultValue = "", verbose = "0", type = "String", category = "")]
		/**server upload url, must start with HTTP or HTTPS*/
		public var uploadUrl:String			=	"";
		[Inspectable(defaultValue = "", verbose = "0", type = "String", category = "")]
		/**download image path, not include the image file*/
		public var downloadPath:String		=	"";
		[Inspectable(defaultValue = "true", verbose = "0", type = "Boolean", category = "")]
		/**if true, when image is uploaded, it would download right now.*/
		public var autoDownload:Boolean		=	true;
		[Inspectable(defaultValue = "true", verbose = "0", type = "Boolean", category = "")]
		/**if true, the image would be set smoothing.*/
		public var smoothing:Boolean		=	true;
		[Inspectable(defaultValue = "", verbose = "1", type = "String", category = "")]
		/**if true, the image would be set smoothing.*/
		public var uploadParamName:String		=	"";
		/*default upload request content type "application/octet-stream"*/
		//public var contentType:String		=	"application/octet-stream";
		
		protected var _file:FileReference;
		protected var _state:String;
		protected var _contentImg:Bitmap;
		protected var _loader:Loader;
		
		private var _content:Sprite;
		
		private var _percent:Number;
		private var _downloadFileName:String	=	'';
		private var _fileFilterArr:Array;
		private var _onlyUpload:Boolean;
		private var _autoUpload:Boolean;
		private var _imageUrl:String;
		private var _badSizeFn:Function;
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set fileFilterArr(value:Array):void {
			_fileFilterArr	=	value;
		}
		/**default is (*.jpg, *.jpeg, *.gif, *.png)*/
		public function get fileFilterArr() { return _fileFilterArr; }
		//*************************[READ ONLY]**************************************//
		/**upload file name*/
		public function get fileName():String { return _file.name; }
		/**upload file type*/
		public function get fileType():String { return _file.type; }
		/**upload file modification date*/
		public function get fileModificationDate():Date { return _file.modificationDate; }
		/**upload file creation date*/
		public function get fileCreationDate():Date { return _file.creationDate; }
		/**upload file size*/
		public function get fileSize():Number { return _file.size; }
		/**image container*/
		public function get content():Sprite { return _content; }
		/**upload or download or none*/
		public function get state():String { return _state; }
		/**upload or download or none*/
		public function get percent():Number { return _percent; }
		
		/**get image url*/
		public function get imageUrl():String {	return _imageUrl == null ? downloadPath + _downloadFileName : _imageUrl; }
		/**get image*/
		public function get image():Bitmap { return _contentImg; }
		
		
		//*************************[STATIC]*****************************************//
		static public const UPLOAD:String	=	"upload";
		static public const DOWNLOAD:String	=	"download";
		static public const NONE:String		=	"none";
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new SimpleImageUpload();]
		 */
		public function SimpleImageUpload() {
			_state			=	NONE;
			_content		=	addChild(new Sprite()) as Sprite;
			_loader			=	_content.addChild(new Loader()) as Loader;
			_init();
		}
		
		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * download image
		 * @param	url
		 */
		public function download(url:String = null, context:LoaderContext = null):void {
			var req:URLRequest;
			if (url == null) {
				_imageUrl	=	null;
				req	=	new URLRequest(imageUrl);
			}else {
				_imageUrl	=	url;
				req	=	new URLRequest(url);
			}
			_loader.load(req, context);
		}
		
		/**
		 * upload image file
		 * @param	url
		 * @param	uploadDataFieldName
		 * @param	testUpload
		 */
		public function upload(url:String = null, uploadDataFieldName:String = "Filedata", testUpload:Boolean = false):void {
			url		=	(url == null ? uploadUrl : url);
			if (uploadParamName.length > 0) {
				if (url.indexOf("?") == -1) {
					url	+=	"?" + uploadParamName;
				}else {
					if (url.indexOf("?"+uploadParamName) == -1 && url.indexOf("&"+uploadParamName) == -1 ) {
						url	+=	"&" + uploadParamName;
					}
				}
				_downloadFileName	=	getUnique() + fileType;
				url	+=	"=" + _downloadFileName;
			}
			var req:URLRequest	=	new URLRequest(url);
			
			req.contentType		=	"multipart/form-data";
			req.method			=	URLRequestMethod.POST;
			_file.upload(req, uploadDataFieldName, testUpload);
		}
		
		/**
		 * browse files, when autoUpload is true, it would upload file after select one file
		 * @param autoUpload	auto upload when select one image
		 * @param maxSize		max file size, default value 0
		 * @param fn			if bad file size, call this fn
		 */
		public function browse(autoUpload:Boolean = true, maxSize:int=0, fn:Function=null):void {
			_autoUpload		=	autoUpload;
			maxFileSize		=	maxSize || maxFileSize;
			_badSizeFn		=	fn;
			_file.browse(fileFilterArr);
		}
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		protected function onImageLoaded():void {
			//empty, it would be override by ImageUpload
		}
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
			_fileFilterArr	=	[new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png")];
			_file			=	new FileReference();
			
			configureListenersUpload(_file);
			configureListenersDownload(_loader.contentLoaderInfo);
		}
		
		private function configureListenersDownload(dispatcher:LoaderInfo):void  {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(Event.INIT, initHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
		}
		
		private function configureListenersUpload(dispatcher:FileReference):void  {
			dispatcher.addEventListener(Event.CANCEL, cancelHandler);
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(Event.SELECT, selectHandler);
            dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
		}
		/*****BEGIN DOWNLOAD EVENTS ******/
		private function initHandler(event:Event):void  {
			dispatchEvent(event);
		}
		
		private function unLoadHandler(event:Event):void  {
			dispatchEvent(event);
		}
		
		/**** END DOWNLOAD EVENTS *****/
		
		/*****BEGIN UPLOAD EVENTS ******/
		private function uploadCompleteDataHandler(event:DataEvent):void {
			if(uploadParamName.length==0){
				_downloadFileName	=	event.data;
			}
			dispatchEvent(event);
			if (autoDownload) {
				download();
			}
		}
		private function selectHandler(event:Event):void {
			if (maxFileSize > 0 && fileSize > maxFileSize) {
				if (_badSizeFn != null) {
					_badSizeFn();
				}
				dispatchEvent(event);
			}else{
				_downloadFileName	=	fileName;
				dispatchEvent(event);
				if (_autoUpload) {
					upload();
				}
			}
			
			
		}
		private function cancelHandler(event:Event):void {
			//trace("cancelHandler: " + event);
			dispatchEvent(event);
		}
		/*****BEGIN DOWNLOAD EVENTS ******/
		
		//////////////UPLOAD DOWNLOAD EVENTS
		private function openHandler(event:Event):void  {
			if (event.currentTarget == _file) {
				_state	=	UPLOAD;
			}else {
				_state	=	DOWNLOAD;
			}
			dispatchEvent(event);
			
		}
		private function progressHandler(event:ProgressEvent):void  {
			var p:Number	=	event.bytesLoaded / event.bytesTotal;
			//trace( "progressHandler : " + p,event.currentTarget, autoDownload );
			if (event.currentTarget == _file) {//uploading
				if (autoDownload) {
					_percent	=	p * .5;
				}else {
					_percent	=	p;
				}
			}else {//download
				if (autoDownload) {
					_percent	=	.5 + p * .5;
				}else {
					_percent	=	p;
				}
			}
			dispatchEvent(event);
		}
		private function completeHandler(event:Event):void  {
			if (event.currentTarget != _file) {
				_contentImg				=	_loader.content as Bitmap;
				_contentImg.smoothing	=	smoothing;
				onImageLoaded();
			}
			dispatchEvent(event);
			_state	=	NONE;
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void  {
			dispatchEvent(event);
		}
		private function httpStatusHandler(event:HTTPStatusEvent):void  {
			dispatchEvent(event);
		}
		private function ioErrorHandler(event:IOErrorEvent):void  {
			dispatchEvent(event);
		}

		
		//*************************[STATIC METHOD]**********************************//
		static public function getUnique(value:int=0):String {
			var d:Date		=	new Date();
			var n0:String	=	numToStr(d.getFullYear()) + numToStr(d.getMonth()) + numToStr(d.getDay()) + numToStr(d.getHours()) + 
								numToStr(d.getMinutes()) +numToStr(d.getSeconds()) + numToStr(d.getMilliseconds());
			var n1:int	=	getTimer();
			n1				=	n1 > 0xfffffff ? Math.round(Math.random() * 0xfffffff) : n1;
			var n2:int	=	Math.round(Math.random() * 0xfffffff);
			var str:String	=	numToStr(n2) + n0 + numToStr(n1);
			return str.substr(0, value || str.length);
		}
		
		static private function numToStr(value:int):String {
			return value.toString(36);
		}
		
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
