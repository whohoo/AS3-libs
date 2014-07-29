
package com.wlash.loader.transition{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import fl.transitions.easing.Strong;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	
	[IconFile("TransBrighten.png")]
	/**
	* 变亮变消失.
	* 
	* <p>在ContentLoader类中,当加载另一对象时,两对象的切换效果.
	* </p>
	*/
	public class TransBrighten extends EventDispatcher implements ITransEffect{
		private var _tw:Tween;
		private var obj0:DisplayObject;
		private var obj1:DisplayObject;
		
		/**
		 * @private
		 * Tween类使用的计数器
		 */
		public var iCount:Number;
		/**
		 * 当切换效果方法结束时的广播名称.
		 */
		public static const TRANS_FINISH:String	=	"transFinish";
		
		/**
		 * 构建一个切换效果对象.
		 * @param	second 多少秒后完成切换效果.默认为1秒.
		 */
		public function TransBrighten(second:uint=1) {
			_tw	=	new Tween(this, "iCount",
							Strong.easeOut,
							0, 255, second, true);
			_tw.stop();
			_tw.addEventListener(TweenEvent.MOTION_CHANGE, onTweenChange);
			_tw.addEventListener(TweenEvent.MOTION_FINISH, onTweenFinish);
		}
		
		/**
		 * @private 
		 * 此方法会在ContentLoader类当中自动调用.
		 * @param	obj0
		 * @param	obj1
		 */
		public function trans(obj0:DisplayObject, obj1:DisplayObject):void {
			this.obj0	=	obj0;
			this.obj1	=	obj1;
			onChanging(obj0, 255);//先变为全透明
			onChanging(obj1, 0);
			_tw.start();
		}
		
		private function onTweenChange(evt:TweenEvent):void{
			onChanging(obj0, 255-evt.position);
			onChanging(obj1, evt.position);
		}
		
		private function onChanging(mc:DisplayObject, b:Number):void{
			mc.transform.colorTransform	=	new ColorTransform(1, 1, 1, 1, b, b, b, -b);
			//trace(preLoader.name, mc.transform.colorTransform);
		}
		private function onTweenFinish(evt:TweenEvent):void {
			dispatchEvent(new Event(TRANS_FINISH));
		}
	}
}