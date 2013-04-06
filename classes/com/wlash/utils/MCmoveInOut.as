//******************************************************************************
//	name:	MCmoveInOut 3
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2007-12-24 12:02
//	description: 使影片具有moveIn与moveOut方法
//			还在测试的alpha版本.
//			增加了可以播放到指定的标签
//		2.2 增加了停止到播放的事件
//		3.0 把属性放到dictionary里。
//******************************************************************************


package com.wlash.utils {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	[IconFile("MCmoveInOut.png")]
	/**
	 *  使影片(MovieClip)可以正着播放到指定的位置,或倒着播放. 
	 * 
	 *  <p>通过把此类拖到场景舞台(Stage)上,自动把moveIn(),moveOut两方法
	 * 添加到MoveiClip类中,你可以通过target_mc.moveIn(32)来使影片播放到指定的位置.<br/>
	 * 在播放过程中,会忽略影片时间铀上的stop(). </p>
	 * 
	 * @example 例子:
	 * <listing>
	 * //顺着播放到red标签位置.
	 * target_mc.moveIn("red");//如果red标签存在的话,
	 * //倒着播放到green标签位置,当结束时执行Function内定义的代码.
	 * target_mc.moveOut("green", 
	 * 				function(mc:MovieClip):void{
	 * 					//播放到指定的位置时,执行以下代码.
	 * 					trace(mc==target_mc);// true
	 * 				});
	 * ....
	 * target_mc.stopMoveInOut();//停止播放
	 * </listing>
	 * 如果moveIn()或moveOut()第一个参数既是字符串,就查找标签,如果找不到标签,
	 * 则throw TypeError错误.<br/>
	 * 如果是数值形,播放到指定的帧位置.<br/>
	 * 如果是其它类型,则播放到头或尾.<br/>
	 * <br/>
	 * <Strong>注意:</Strong>
	 * <br/>
	 * 对于继承于MovieClip的子类,其必须为<code>dynamic</code>(动态类),<br/>
	 * 或须添加两个属性变量_targetFrame与_targetFunc.<br/>
	 * <listing>
	 * 	public class  SimpleMC extends MovieClip{//dynamic
	 * 	  
	 *	  public var _targetFrame:Number;
	 *	  public var _targetFunc:Function;
	 *    .....
	 *   public function SimpleMC(){
	 * </listing>
	 */
	final public class MCmoveInOut extends Object {
		
		static public var mcDict:Dictionary
		
		/**
		 * 表示是否已经初始化此类.
		 */
		static public var isInit:Boolean;
		/**
		 * initiallize target(movieclip), make target had tow methods(moveIn,moveOut)<br></br>
		 * if not point out which movieclip you wannna, it would make all movieclips<br></br>
		 * had those methods
		 * 
		 * @param   target if not movieclip or not undefined, it would regist <br></br>
		 * 		MovieClip.prototype, that means all movieclip would had those <br></br>
		 * 		methods.
		 * @throws Error 如果moveOut 或moveIn已经被其它程序定义了.
		 * @return 
		 */
		static public function initialize():Boolean {
			if (isInit)	return true;
			var o:Object	=	Object(MovieClip.prototype);
			if(o.moveOut!=null || o.moveIn!=null){
				throw new Error("MovieClip.moveOut or MoveiClip.moveIn was defined. [com.wlash.utils.MCmoveInOut]");
				return false;
			}
			var m:Object	=	MCmoveInOut.prototype;
			
			o.stopMoveInOut	=	m.stopMoveInOut;
			o.moveIn		=	m.moveIn;
			o.moveOut		=	m.moveOut;
			o.__goFrame		=	m.__goFrame;
			o.__onRemoved	=	m.__onRemoved;
			/*public static var isInit:Boolean	=	initialize();
			 如果这样调用,则MCmoveInOut的值为null,可能是因为太早初始化而没有MCmoveInOut类.
			 如果非要在库中就自动初始化好MCmoveInOut类,则必须把所有的function写在initialize()中
			 如:
			 o.moveIn=function(){
				//action
			 }
			 所以,现只能按把此类直接拖到场景中来初始化.
			 或直接调用MCmoveInOut.initialize()来初始化
			*/
			mcDict			=	new Dictionary(true);
			return (isInit	=	true);
		}
		
		/**
		 * a empty private CONSTRUCT FUNCTION, 
		 * you can't create instance by this.
		 */
		function MCmoveInOut(){
			
		}
		
		/**
		 * make a MovieClip playing untile end if not point param frame.<br></br>
		 * if you point a frame, and frame large then currentFrame,<br></br>
		 * this movieclip would not play, or it would stop.<br></br>
		 * 
		 * <pre>
		 * 	<b>eg:</b>
		 * 		car_mc is a movieclip.
		 * 		car_mc.moveIn();// it would play end
		 * 		car_mc.moveIn(4);// it would play to frame 4.
		 * 		car_mc.moveIn(null,doFunc);// it would play end and trigger function
		 * 		    //doFunc(target_mc);
		 * </pre>
		 * 
		 * @param   frame [optional parameters]<br></br>
		 * 		the default frame is last frame(_totalFramess), if not point.
		 * @param   func  [optional parameters]<br></br>
		 *		a function, when this movieclip gotopaly the frame,<br></br>
		 * 		the func would be trigger, and pass this movieclip to the parameter.
		 * @param	speed, [optional parameters]<br/>
		 * 		scale the playback speed.
		 */
		prototype.moveIn = function(frame:* = 0, func:Function = null, speed:Number=1):void {
			var mc:MovieClip	=	this;
			mc.removeEventListener(Event.ENTER_FRAME, mc["__goFrame"]);
			
			
			if (frame is String) {
				var frameLabel:String	=	frame;
				var labels:Array	=	mc.currentLabels;
				var retArr:Boolean	=	labels.some(
					function(item:*, index:uint, array:Array):Boolean {
						if (item.name == frameLabel) {
							frame	=	item.frame;
							return	true;
						}else {
							return false;
						}
					}, null);
				if(!retArr){
					throw new TypeError("at " + mc.name + ".moveIn(" + frameLabel + 
							"), frameLabel["+frameLabel+"] did not found!");
				}
			}else if (!(frame is uint)) {
				frame	=	mc.totalFrames;
			}else{
				frame	=	frame || mc.totalFrames;
			}
			
			if (frame > mc.currentFrame) { 
				var mcObj:Object	=	MCmoveInOut.mcDict[mc];
				if (!mcObj) {
					mcObj	=	new Object();
					MCmoveInOut.mcDict[mc]	=	mcObj;
				}
				mc.addEventListener(Event.REMOVED_FROM_STAGE, mc['__onRemoved']);
				mcObj.targetFrame	=	frame;
				mcObj.func			=	func;
				mcObj.speed			=	speed <= 0 ? 1 : speed;
				mcObj.actframe		=	mc.currentFrame;
				mcObj.playDir		=	1;
				mc.addEventListener(Event.ENTER_FRAME, mc['__goFrame'], false, 0, true);
				}else if (frame == mc.currentFrame) {
					if(func!=null)	func(mc);
				}
		}
		
		/**
		 * make a MovieClip playing untile first if not point param frame.<br></br>
		 * if you point a frame, and frame less then currentFrame,<br></br>
		 * this movieclip would not play, or it would stop.<br></br>
		 * 
		 * <pre>
		 * <b>eg:</b>
		 * 		car_mc is a movieclip.
		 * 		car_mc.moveOut();// it would play end
		 * 		car_mc.moveOut(4);// it would play to frame 4.
		 * 		car_mc.moveOut(null,doFunc);// it would play end and trigger function
		 * 		   //doFunc(target_mc);
		 * </pre>
		 * 
		 * @param   frame [optional parameters]<br></br>
		 * 		the default frame is first frame(1), if not point.
		 * @param   func  [optional parameters]<br></br>
		 *		a function, when this movieclip gotopaly the frame,<br></br>
		 * 		the func would be trigger, and pass this movieclip to the parameter.
		 * @param	speed, [optional parameters]<br/>
		 * 		scale the playback speed.
		 */
		prototype.moveOut = function(frame:* = 0, func:Function = null, speed:Number=1):void {
			var mc:MovieClip	=	this;
			mc.removeEventListener(Event.ENTER_FRAME, mc["__goFrame"]);
			
			if (frame is String) {
				var frameLabel:String	=	frame;
				var labels:Array	=	mc.currentLabels;
				var retArr:Boolean	=	labels.some(
					function(item:*, index:uint, array:Array):Boolean {
						if (item.name == frame) {
							frame	=	item.frame;
							return	true;
						}else {
							return false;
						}
					}, null);
				if(!retArr){
					throw new TypeError("at " + mc.name + ".moveIn(" + frameLabel + 
							"), frameLabel["+frameLabel+"] did not found!");
				}
			}else if (!(frame is uint)) {
				frame	=	1;
			}else{
				frame	=	frame || 1;
			}
			
			if (frame < mc.currentFrame) {
				var mcObj:Object	=	MCmoveInOut.mcDict[mc];
				if (!mcObj) {
					mcObj	=	new Object();
					MCmoveInOut.mcDict[mc]	=	mcObj;
				}
				mc.addEventListener(Event.REMOVED_FROM_STAGE, mc['__onRemoved']);
				mcObj.targetFrame	=	frame;
				mcObj.func			=	func;
				mcObj.speed			=	speed <= 0 ? 1 : speed;
				mcObj.actframe		=	mc.currentFrame;
				mcObj.playDir		=	-1;
				mc.addEventListener(Event.ENTER_FRAME, mc['__goFrame'], false, 0, true);
			}else if (frame == mc.currentFrame) {
				if(func!=null)	func(mc);
			}
		}
		
		prototype.__goFrame = function(e:Event):void {
			var mc:MovieClip	=	e.currentTarget as MovieClip;
			var mcObj:Object	=	MCmoveInOut.mcDict[mc];
			var speed:Number	=	mcObj.speed;
			var playDir:int		=	mcObj.playDir;
			var targetFrame:int	=	mcObj.targetFrame;
			var func:Function	=	mcObj.func;
			
			//trace( "mc.currentFrame * playDir >= targetFrame * playDir : " +mc, mc.currentFrame , playDir , targetFrame * playDir );
			if (mc.currentFrame * playDir >= targetFrame * playDir) {
				if (mc.currentFrame != targetFrame) { 
					mcObj.actframe	=	targetFrame;
					mc.gotoAndStop(targetFrame);
				}
				mc.removeEventListener(Event.ENTER_FRAME, mc["__goFrame"]);
				if (func != null)	func(mc);
				delete MCmoveInOut.mcDict[mc];
			}else {
				mcObj.actframe	+=	speed * playDir;
				mc.gotoAndStop(Math.round(mcObj.actframe));
			}
		}
		/**
		 * 把事件删除
		 */
		prototype.__onRemoved=function(e:Event):void{
			var mc:MovieClip	=	e.currentTarget as MovieClip;
			mc['stopMoveInOut']();
		}
		
		/**
		 * stop moveIn or moveOut
		 */
		prototype.stopMoveInOut = function():void {
			var mc:MovieClip	=	this;
			mc.removeEventListener(Event.ENTER_FRAME, mc['__goFrame']);
			mc.removeEventListener(Event.REMOVED_FROM_STAGE, mc['__onRemoved']);
			delete MCmoveInOut.mcDict[mc];
		}
		
	}
}
