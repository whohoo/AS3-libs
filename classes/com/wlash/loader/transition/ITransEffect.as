


package com.wlash.loader.transition {
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	/**
	* ContentLoader当调用切换效果的接口类.
	*/
	public interface ITransEffect extends IEventDispatcher {
		/**
		 * 当加载另一影片完成时,调用此方法来显示切换效果.
		 */
		function trans(obj0:DisplayObject, obj1:DisplayObject):void
		
	}
}