//******************************************************************************
//	name:	LoadProgress 1.1
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 05 16:41:24 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "main.fla" file.
//		1.1增加了以秒为单位的下载百分比数
//******************************************************************************


package com.wlash.loader {
	import com.wlash.loader.LoadingBitRate;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.utils.Timer;

	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	/**
	 * 当前正下载的影片过程广播此事件,不管是模拟下载还是真实下载.
	 *
	 * @eventType flash.events.ProgressEvent
     *
	 */
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	
	/**
	 * 影片被下载完成时广播,不管是模拟下载还是真实下载.
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name = "complete", type = "flash.events.Event")]
	
	[IconFile("LoaderProgress.png")]
	/**
	 * 下载进度条,可以定义下载速度,模拟下载.
	 * 
	 * <p>可监测当前场景对象的下载速度,可模拟下载,也可以按实际网络状况来决定
	 * 下载率.<br/>有两种模拟状态:一是按每秒下载的流量来决定下载率,另一是按每秒
	 * 可以下载多少百分比.模拟下载的使用情况是在网络速度很好,当影片的下载实际速度比
	 * 模拟下载速度快时,才会使用的模拟下载速度,如果设定的模拟下载速度很快,而实际网络
	 * 没达到这么快的下载速度,会按实际的网络速度来决定下载速度.<br/>当要显示下载过程
	 * 页面过场时,模拟下载是挺有用的.</p>
	 * <p>把组件拖到场景中,可在参数面版中设置参数(<b>属性:</b>).</p>
	 * 
	 * <li>loaderTarget 要测量下载的对象,一般设为root</li>
	 * <li>loadBitRate = 0 模拟下载的字节数/s</li>
	 * <li>loadPercent = 0 模拟下载的百分数/s</li>
	 * <li>refreshMilliseond = 10 刷新的毫秒数</li>
	 * <li>simulationMode 可选模拟下载模式</li>
	 * <br/>
	 * simulationRate 下载的速率,单位为bit/s 可以选的值有:
	 * 			<li>com.wlash.loaderLoadingBitRate.NONE   //0 bit/s</li>
	 * 			<li>com.wlash.loaderLoadingBitRate.MODEM_BIT_RATE //4800 bit/s</li>
	 * 			<li>com.wlash.loaderLoadingBitRate.DSL_BIT_RATE //33400 bit/s</li>
	 * 			<li>com.wlash.loaderLoadingBitRate.T1_BIT_RATE //134300 bit/s</li>
	 * <br/>
	 * 
	 * @example sample code:
	 * <listing>
	 * import com.wlash.loader.LoaderProgress;
	 * import com.wlash.loader.LoadingBitRate;
	 * var pro:LoaderProgress	=	getChildAt(0) as LoaderProgress;
	 * 
	 * pro.loadBitRate		=	LoadingBitRate.DSL_BIT_RATE;
	 * pro.addEventListener(ProgressEvent.PROGRESS, onProgress);
	 * pro.addEventListener(Event.COMPLETE, onComplete);
	 * //trace(pro.loaderTarget is String, pro.loaderTarget);
	 * 
	 * function onProgress(evt:ProgressEvent){
	 * 	trace(evt.bytesLoaded, evt.bytesTotal);
	 * 	tf.text	=	(evt.bytesLoaded/evt.bytesTotal*100).toString();
	 * }
	 * function onComplete(evt:Event){
	 * 	trace("FINISH");
	 * }
	 * var tf:TextField	=	new TextField();
	 * addChild(tf);
	 * </listing>
	 */
	public class LoaderProgress extends Sprite {
		
		private var simTimer:Timer;
		private var simBytesLoaded:uint;//模拟下载字节数
		private var bytesTotal:uint;
		private var bytesLoaded:uint;
		//private var _simulationRate:uint	=	LoadingBitRate.NONE;
		//private var isSimulateDownload:Boolean;
		
		private var _loaderTarget:DisplayObject;
		private var loadInfoTarget:LoaderInfo;
		
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
		//************************[READ|WRITE]************************************//
		[Inspectable(defaultValue="", type=String)]
		/**@private */
		public function set source(value:String):void {
			if (loadInfoTarget != null) {
				loadInfoTarget.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				loadInfoTarget.removeEventListener(Event.COMPLETE, completeHandler);
				simTimer.stop();
			}
			_loaderTarget	=	parent[value];
			if (_loaderTarget == null) {
				simTimer.stop();
				throw new Error("NULL DisplayObject. | name:" + value);
			}
			loadInfoTarget	=	_loaderTarget.loaderInfo;
			bytesTotal		=	loadInfoTarget.bytesTotal;
			bytesLoaded		=	loadInfoTarget.bytesLoaded;
			
			if (bytesTotal > 0) {
				switch (simulationMode) {
					case BIT_PER_SECOND:
					case PERCENT_PER_SECOND:
						simTimer.start();
						break;
					default:
						simTimer.stop();
				}
			}else {
				simTimer.stop();
				throw new Error("Empty DisplayObject. | name:" + value + ", disObj: " + _loaderTarget);
			}
			loadInfoTarget.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loadInfoTarget.addEventListener(Event.COMPLETE, completeHandler);
			
		}
		/**
		 * 要检测下载速度的名称,对象为字串,与ProgressBar不一样,这里应为得到parent[source]的对象
		 * 应为DisplayObject才对.如果对象为空或对象大小为0,则会throw Error.
		 */
		public function get source():String {
			return _loaderTarget.name;
		}
		
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
		 * 每一秒内要下载的百分数.
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
		 * Construction function.<br></br>
		 * 直接把组件拖到场景中既可使用,不必用new LoaderProgress()来构建对象.
		 */
		public function LoaderProgress() {
			getChildAt(0).visible	=	false;
			init();
		}
		
		//************************[PRIVATE METHOD]********************************//
		/**
		 * Initializtion this class
		 * 
		 */
		private function init():void{
			simTimer	=	new Timer(10, 0);
			simTimer.addEventListener(TimerEvent.TIMER, onSimulateTimer);
		}
		
		private function onSimulateTimer(evt:TimerEvent):void {
			var simulateBytesLoaded:uint;//假设的下载速度.
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
				dispatchEvent(new Event(Event.COMPLETE, false, false));
			}
			evt.updateAfterEvent();
		}

		private function progressHandler(evt:ProgressEvent):void {
			if (simulationMode==BIT_PER_SECOND || simulationMode==PERCENT_PER_SECOND) {
				//只通过onSimulateTimer函数来广播ProgressEvent事件
				bytesLoaded		=	evt.bytesLoaded;
				return;
			}
			//否则,不模拟下载时,才会广播ProgressEvent事件
			dispatchEvent(evt);
		}
		private function completeHandler(evt:Event):void {
			if (simulationMode==BIT_PER_SECOND || simulationMode==PERCENT_PER_SECOND) {
				//只通过onSimulateTimer函数来广播ProgressEvent事件
				return;
			}
			//否则,不模拟下载时,才会广播Event完成事件
			dispatchEvent(evt);
		}
		//***********************[PUBLIC METHOD]**********************************//
		
		//***********************[STATIC METHOD]**********************************//
		
		
	}//end class
}
//This template is created by whohoo. ver 1.0.0

//below code were remove from above.
/*
 
*/
