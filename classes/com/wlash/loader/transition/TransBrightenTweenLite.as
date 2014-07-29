
package com.wlash.loader.transition{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.utils.getDefinitionByName;
	import gs.TweenLite;
	
	[IconFile("TransBrighten.png")]
	/**
	* 变亮变消失.
	* 
	* <p>在ContentLoader类中,当加载另一对象时,两对象的切换效果.
	* </p>
	*/
	public class TransBrightenTweenLite extends EventDispatcher implements ITransEffect{
		private var _second:Number;
		
		private var TweenLiteClass:Class;
		/**@private */
		public var colorNum:Number;
		
		/**
		 * 当切换效果方法结束时的广播名称.
		 */
		public static const TRANS_FINISH:String	=	"transFinish";
		
		/**
		 * 构建一个切换效果对象.
		 * @param	second 多少秒后完成切换效果.默认为1秒.
		 */
		public function TransBrightenTweenLite(second:Number=1) {
			TweenLiteClass	=	getDefinitionByName("gs.TweenLite") as Class;
			if (!TweenLiteClass) {
				throw new Error("must import gs.TweenLite Class");
			}
			_second		=	second;
		}
		
		/**
		 * @private 
		 * 此方法会在ContentLoader类当中自动调用.
		 * @param	obj0
		 * @param	obj1
		 */
		public function trans(obj0:DisplayObject, obj1:DisplayObject):void {
			colorNum	=	0;
			onTweenChange(obj0, obj1);
			TweenLiteClass['to'](this, _second, { colorNum:255, onUpdate:onTweenChange, onUpdateParams:[obj0, obj1] ,onComplete:onTweenFinish } );
		}
		
		private function onTweenChange(obj0:DisplayObject, obj1:DisplayObject):void{
			onChanging(obj0, 255 - colorNum);
			onChanging(obj1, colorNum);
		}
		
		private function onChanging(mc:DisplayObject, b:Number):void {
			b	=	Math.round(b);
			mc.transform.colorTransform	=	new ColorTransform(1, 1, 1, 1, b, b, b, -b);
		}
		
		private function onTweenFinish():void {
			dispatchEvent(new Event(TRANS_FINISH));
		}
	}
}