//******************************************************************************
//	name:	ContentLoader 1.2
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 05 16:41:24 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "main.fla" file.
//		1.1 增加了模拟字节下载数
//		1.2 增加了模拟百分比下载数
//******************************************************************************


package com.wlash.loader {
	
	import com.wlash.loader.LoadingBitRate;
	//import fl.transitions.easing.Strong;
	//import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	//import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	import com.wlash.loader.transition.ITransEffect;
	import flash.utils.Timer;
	
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	
	/**
	 * 当过度效果完成时,也就是两影片切换效果完成时广播.
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "transFinish", type = "flash.events.Event")]
	
	/**
	 * 当加载错误,达到最大次数时广播此事件.
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "retryLoadMax", type = "flash.events.Event")]
	
	/**
	 * 开始加载时广播此事件.
	 *
	 * @eventType flash.events.HTTPStatusEvent
     *
	 */
	[Event(name = "httpStatus", type = "flash.events.HTTPStatusEvent")]
	
	/**
	 * 影片被下载完成时广播,不管是模拟下载还是真实下载.
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	/**
	 * 影片被加载完成,并开初始化时广播此事件.
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "init", type = "flash.events.Event")]
	
	/**
	 * 下载发生错误时触发此广播事件.
	 *
	 * @eventType flash.events.IOErrorEvent
     *
	 */
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	
	/**
	 * 影片开始下载时触发些广播事件.
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "open", type = "flash.events.Event")]
	
	/**
	 * 当前正下载的影片过程广播此事件,不管是模拟下载还是真实下载.
	 *
	 * @eventType flash.events.ProgressEvent
     *
	 */
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	
	/**
	 * 影片被unload时触发此广播事件.
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "unload", type = "flash.events.Event")]
	
	
	[IconFile("ContentLoader.png")]
	/**
	 * 通常大型网站中需要的加载栏目内容.
	 * 
	 * <p>拖到场景中,内容会被加载到此对象,通过调用方法来加载不同的内容,当加载另一内容时
	 * 原来的内容会被替换掉,还可定义切换效果.<br/>可定义是否启用模拟下载方式来下载,
	 * 如果启用模拟下载,可以以按每秒下载字节数,或按每秒下载整个影片的下载百分数.
	 * 模拟下载的使用情况是在网络速度很好,当影片的下载实际速度比
	 * 模拟下载速度快时,才会使用的模拟下载速度,如果设定的模拟下载速度很快,而实际网络
	 * 没达到这么快的下载速度,会按实际的网络速度来决定下载速度.<br/>当要显示下载过程
	 * 页面过场时,模拟下载是挺有用的.</p>
	 * <b>参数面版:</b>
	 * <li>maxRetry = 3 重试的次数.</li>
	 * <li>loadBitRate = 0 模拟下载的字节数/s</li>
	 * <li>loadPercent = 0 模拟下载的百分数/s</li>
	 * <li>simulationMode 可选模拟下载模式</li>
	 * load(url:String)  加载方法
	 * unload() 把加载的内容全部去除.
	 * 
	 * 常量:下载的速度
	 * <li>LoadingBitRate.MODEM_BIT_RATE	4800;//bit/s </li>
	 * <li>LoadingBitRate.DSL_BIT_RATE	33400;//bit/s </li>
	 * <li>LoadingBitRate.T1_BIT_RATE	134300;//bit/s </li>
	 * 
	 * @example sample code:
	 * <listing>
	 * import com.wlash.loader.ContentLoader;
	 * import com.wlash.loader.LoadingBitRate;
	 * import com.wlash.loader.transition.TransBrighten;
	 * //import com.wlash.loader.transition.TransParticle;
	 * var content_mc:ContentLoader	=	getChildAt(0) as ContentLoader;
	 * //trace(getChildAt(0));
	 * import flash.events.ProgressEvent;
	 * content_mc.trans	=	new TransBrighten(3);
	 * //content_mc.trans	=	new TransParticle(3);
	 * content_mc.loadBitRate	=	LoadingBitRate.T1_BIT_RATE;
	 * content_mc.load("wuyang5.jpg");
	 * //trace(content_mc is oo);
	 * switch_btn.addEventListener(MouseEvent.CLICK, onClick);
	 * content_mc.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	 * content_mc.addEventListener(ContentLoader.RETRY_LOAD_MAX, retryTimes);
	 * content_mc.addEventListener(ContentLoader.TRANS_FINISH, onTransFinish);
	 * content_mc.addEventListener(Event.OPEN, onTransFinish);
	 * var iCount:uint	=	0;
	 * function onClick(evt:MouseEvent){
	 * 	trace("load: "+"wuyang"+(((++iCount)%2)*5+5)+".jpg");
	 * 	content_mc.load("wuyang"+(((iCount)%2)*5+5)+".jpg");
	 * 	//var obj:*	=	content_mc.preLoader.transform.colorTransform=
	 * 				//	new ColorTransform(1,1,1,1,0,0,0,-50);
	 * 	//trace(obj);
	 * }
	 * 
	 * function progressHandler(event:ProgressEvent){
	 * 	//trace(event.target, event.currentTarget);
	 * 	trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
	 * }
	 * function retryTimes(evt:Event){
	 * 	trace(evt);
	 * }
	 * function onTransFinish(evt:Event){
	 * 	trace(evt.type);
	 * }
	 * </listing>
	 */
	public class ContentLoader extends Sprite{
		private var curLoaderMC:Loader;
		private var preLoaderMC:Loader;

		private var _trans:ITransEffect;
		private var retryTimes:uint;
		private var contentUrl:String;
		
		private var simTimer:Timer;
		private var simBytesLoaded:uint;//模拟下载字节数
		private var bytesLoaded:uint;//真实的下载字节数
		private var bytesTotal:uint;//真实的总大小
		//private var isSimulateDownload:Boolean;//
		//private var _simulationRate:uint	=	LoadingBitRate.NONE;
		
		//private var isTransing:Boolean;
		private var loadNewPreLoader:Boolean;//如果preLoader内容还在,此时再加载新内容时,此值为true
		
		[Inspectable(defaultValue=3, type=uint)]
		/**如果发生错误,重试的次数*/
		public var maxRetry:uint	=	3;
		
		/**
		 * 当过渡效果结束后,广播的事件,这名称与trans:ITransEffect中的定义一样
		 */
		public static const TRANS_FINISH:String		=	"transFinish";
		/**重试次数达到最大值时.*/
		public static const RETRY_LOAD_MAX:String	=	"retryLoadMax";
		
		//************************[READ|WRITE]************************************//
		/**@private */
		public function set trans(value:ITransEffect):void {
			if (value ==null) {//新定义的值是空值,且
				if(_trans!=null){//原来已经定义过了,所以直接删除掉事件,
					_trans.removeEventListener(TRANS_FINISH, onTransFinish);
				}
			}else{//新值不为空,
				if(_trans!=null){//原来定义的删除
					_trans.removeEventListener(TRANS_FINISH, onTransFinish);
				}
				//重新再定义新值.
				value.addEventListener(TRANS_FINISH, onTransFinish);
			}
			_trans	=	value;
		}
		/**
		 * 如果没有指定,就直接显示,如果有,必须继承ITransEffect接口,
		 * 这是两张不同图片或swf过渡的效果.
		 */
		public function get trans():ITransEffect {
			return _trans;
		}
		
		
		[Inspectable(defaultValue="none", type=String, enumeration="none,bit/s,percent/s", name="simulationMode")]
		/**
		 * 可选的模拟下载模式.可选的值有none, bit/s, percent/s
		 */
		public var simulationMode:String				=	"none";
		/**不用模拟下载,按实际加载情况广播下载事件*/
		public static const NONE:String					=	"none";
		/**按下载的字节数来模拟下载速度*/
		public static const BIT_PER_SECOND:String		=	"bit/s";
		/**按一秒内可下载的百分比数来模拟下载速度*/
		public static const PERCENT_PER_SECOND:String	=	"percent/s";
		
		private var _refreshMilliseond:Number	=	100;
		[Inspectable(defaultValue=10, type=uint, name=" refreshMilliseond")]
		/**@private */
		public function set refreshMilliseond(value:uint):void {
			if (value <= 0) {
				value	=	1;
			}
			//为了在刷新时不再计算值,所以_refreshMilliseond保存的是1000分之一的倒数.
			_refreshMilliseond	=	1000/value;
			simTimer.delay	=	value;
		}
		/**
		 * 刷新的速度,是毫秒为单位的.
		 */
		public function get refreshMilliseond():uint {
			return 1000/_refreshMilliseond;
		}
		
		private var _loadPercent:Number			=	0.01;
		[Inspectable(defaultValue = 100, type = uint)]
		/**@private */
		public function set loadPercent(value:uint):void {
			if (value <= 0) {
				value	=	1;
			}
			//为了在刷新时不再计算值,所以这里以刷新毫秒为单位先计算出来.
			_loadPercent	=	value / 100 / _refreshMilliseond;
			
		}
		/**
		 * 一秒内要下载的百分数.
		 */
		public function get loadPercent():uint {
			return _loadPercent*100*_refreshMilliseond;
		}
		
		private var _loadBitRate:Number			=	LoadingBitRate.DSL_BIT_RATE/_refreshMilliseond;
		[Inspectable(defaultValue=33400, type=uint)]
		/**@private */
		public function set loadBitRate(value:uint):void {
			if (value <= 0) {
				value	=	1;
			}
			//为了在刷新时不再计算值,所以这里以刷新毫秒为单位先计算出来.
			_loadBitRate	=	value / _refreshMilliseond;
		}
		/**
		 * 假设要下载的字节数.
		 */
		public function get loadBitRate():uint {
			return _loadBitRate*_refreshMilliseond;
		}
		//************************[READ ONLY]*************************************//
		/**
		 * 当前加载的影片
		 */
		public function get curLoader():Loader {
			return curLoaderMC;
		}
		/**
		 * 在后台加载的影片,当过渡完成后,就指向curLoader
		 */
		public function get preLoader():Loader {
			return preLoaderMC;
		}
		
		/**
		 * Construction function.<br></br>
		 * drop this MovieClip to stage form Library.
		 */
		public function ContentLoader() {
			getChildAt(0).visible	=	false;
			//removeChildAt(0);
			init();
		}
		
		//************************[PRIVATE METHOD]********************************//
		/**
		 * Initializtion this class
		 * 
		 */
		private function init():void{
			preLoaderMC	=	new Loader();
			preLoaderMC.name	=	"loader0_mc";
			addChild(preLoaderMC);
			
			curLoaderMC	=	new Loader();
			curLoaderMC.name	=	"loader1_mc";
			addChild(curLoaderMC);
			
			configureListeners(preLoaderMC.contentLoaderInfo);//如果使用loaderInfo属性,则当加载完成后,
			configureListeners(curLoaderMC.contentLoaderInfo);//可能是因为loaderInfo丢失,不能再监听事件
			
			simTimer	=	new Timer(10, 0);
			simTimer.addEventListener(TimerEvent.TIMER, onSimulateTimer);
		}
		
		private function onSimulateTimer(evt:TimerEvent):void {
			if (bytesTotal > 0) {
				var simulateBytesLoaded:uint;
				switch (simulationMode) {
					case BIT_PER_SECOND:
						simBytesLoaded		+=	_loadBitRate;
						simulateBytesLoaded	=	Math.min(simBytesLoaded, bytesLoaded);
						break;
					case PERCENT_PER_SECOND:
						simBytesLoaded		+=	_loadPercent * bytesTotal;
						simulateBytesLoaded	=	Math.min(simBytesLoaded, bytesLoaded);
						break;
					default:
						simTimer.stop();
						simulationMode	=	NONE;
				}
				var event:ProgressEvent	=	new ProgressEvent(ProgressEvent.PROGRESS, false, false,
											simulateBytesLoaded, bytesTotal);
				dispatchEvent(event);
				if (simulateBytesLoaded >= bytesTotal) {
					simTimer.stop();
					startTrans();//开始过渡
				}
			}
			
		}
		//////loading events
		private function configureListeners(dispatcher:LoaderInfo):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(Event.INIT, initHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
        }
		
		private function openHandler(event:Event):void {
			if (simulationMode==BIT_PER_SECOND || simulationMode==PERCENT_PER_SECOND) {
				simBytesLoaded	=	
				bytesLoaded		=	
				bytesTotal		=	0;
				
				simTimer.start();
			}else {
				
			}
			dispatchEvent(event);
        }
		
		private function progressHandler(event:ProgressEvent):void {
			if (simulationMode==BIT_PER_SECOND || simulationMode==PERCENT_PER_SECOND) {
				//只通过onSimulateTimer函数来广播ProgressEvent事件
				if (bytesTotal == 0) {
					bytesTotal	=	event.bytesTotal;
				}
				bytesLoaded		=	event.bytesLoaded;
				return;
			}
			//否则,不模拟下载时,才会广播ProgressEvent事件
			dispatchEvent(event);
		}
		
        private function completeHandler(event:Event):void {
			dispatchEvent(event);
        }
	
        private function initHandler(event:Event):void {
            preLoaderMC.visible	=	false;
			if (simulationMode == BIT_PER_SECOND || simulationMode == PERCENT_PER_SECOND) {
				return;//模拟下载,不要广播此事件
			}
			startTrans();
			dispatchEvent(event);
			//trace(this, event.currentTarget.content.parent==curLoader);
        }

        private function unLoadHandler(event:Event):void {
			dispatchEvent(event);
        }
		
        private function httpStatusHandler(event:HTTPStatusEvent):void {
			//loadContent(contentUrl);
			dispatchEvent(event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            loadContent(contentUrl);
			dispatchEvent(event);
        }
		////////end loading event
		
		/**
		 * 加载完成后开始的过渡效果
		 */
		private function startTrans():void {
			preLoaderMC.visible	=	true;
			if(trans is ITransEffect){
				trans.trans(preLoaderMC, curLoaderMC);
			}else {
				onTransFinish(new Event(TRANS_FINISH));
			}
			
			var tempMC:Loader	=	curLoaderMC;
			curLoaderMC	=	preLoaderMC;
			preLoaderMC	=	tempMC;
			swapChildren(preLoaderMC, curLoaderMC);//换到上层来
			//isTransing	=	true;
		}
		
		private function onTransFinish(evt:Event):void {
			if(loadNewPreLoader){
				preLoaderMC.unload();
			}
			//isTransing	=	false;
			dispatchEvent(new Event(TRANS_FINISH));
		}
		
		private function loadContent(url:String):void {
			//trace(retryTimes);
			if (retryTimes++ > maxRetry) {
				dispatchEvent(new Event(RETRY_LOAD_MAX));
				return;
			}
			var request:URLRequest	=	new URLRequest(url);
			try{
				preLoaderMC.load(request);
			}catch (e:SecurityError) {
				trace(e);
			}
			preLoaderMC.visible	=	false; 
		}
		
		//***********************[PUBLIC METHOD]**********************************//
		/**
		 * 加载对象,如jpg,swf,png等可显示的内容.
		 * @param	url 被加载对象的路径地址
		 */
		public function load(url:String):void{
			retryTimes	=	0;
			if (preLoader.content != null) {//表明preLoaderMC内容不为空
				loadNewPreLoader	=	true;
			}else {
				loadNewPreLoader	=	false;
			}
			loadContent(url);
			contentUrl	=	url;
			
		}
		/**
		 * 删除已经加载的对象.
		 */
		public function unload():void {
			curLoaderMC.unload();
			preLoaderMC.unload();
		}
		//***********************[STATIC METHOD]**********************************//
		
		
	}//end class
}
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*
 private function getRefMaskPos():Object{
			var pos:Object	=	{x:refMaskMC._x, y:refMaskMC._y};
			refMaskMC._parent.localToGlobal(pos);
			globalToLocal(pos);
			return pos;
		}
		
		private function onChangeSceneMove():void{
			mask_mc._width	=	getRefMaskPos().x;
			
		}
		private function onChangeSceneEnd():void{
			loader_mcl.unloadClip(preLoaderMC);//过渡场景结束,删除原来加载的内容 
			curLoaderMC.setMask(null)
			mask_mc._visible	=	false;
		}
//***MovieClipLoader Events***\\
		private function onLoadStart(mc:MovieClip):void{
			mc._visible	=	false;
			curLoaderMC.stopAll();
		}
		private function onLoadProgress(mc:MovieClip, loadedBytes:Number, totalBytes:Number):void{
			var percent:Number	=	Math.round(loadedBytes/totalBytes*100);
			
		}
		private function onLoadComplete(mc:MovieClip):void{
			//_parent.preLoader_mc.startPreLoad();
			
		}
		private function onLoadInit(mc:MovieClip):void{
			if(!isIntro){
				//trace(curLoaderMC.getBytesTotal())
				if(curLoaderMC.getBytesTotal()>20){
					//bricks_mc.build(15, 10, 655, 340);
					//curLoaderMC.setMask(bricks_mc);
					fadeInOut();
				}else{//第一次加载
					onFinishFadeOut();
				}
				
				
			}
			mc._visible	=	true;
			if(_global.isSkip2LuckyDraw){
				_global.isSkip2LuckyDraw	=	false;
				mc.gotoAndPlay("form");
			}else if(_global.isSkip2Network){
				_global.isSkip2Network	=	false;
				mc.gotoAndPlay("network");
			}else{
				mc.gotoAndPlay(2);
			}
		}
		private function onLoadError(mc:MovieClip, errorCode:String):void{
			switch(errorCode){
				case "URLNotFound":
					
					break;
				case "LoadNeverCompleted":
					
					break;
				
			}
			trace("MovieClipLoader errorCode: "+errorCode);
			 
		 }
		 
		//***MovieClipLoader Events END***\\
*/
