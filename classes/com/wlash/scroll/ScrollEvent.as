//******************************************************************************
//	name:	ScrollEvt 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-1-21 17:19
//	description: http://www.17play.org/forum/viewthread.php?tid=75
//			http://topic.csdn.net/t/20030921/15/2284126.html
// 
//******************************************************************************

/**
* 在 com.wlash.utils.ScrollDisplayObject广播scroll事件<p>
* </p>
*/
package com.wlash.scroll {
	import flash.events.Event;
	
	/**
	 * com.wlash.scroll.ScrollBar类的滚动事件.
	 * <p>
	 * 此类有以下事件：
	 * <ul>
     *     <li><code>ScrollEvent.PRESS_THUMB</code>: 广播当按下thumb时.</li>
     *     <li><code>ScrollEvent.RELEASE_THUMB</code>: 广播当放开thumb时.</li>
	 * 	   <li><code>ScrollEvent.SCROLL</code>: 广播当滑动thumb时.</li>
     *     <li><code>ScrollEvent.ACTIVE_SCROLL</code>: 当滚动条被激活时或不被激活时.</li>
     * </ul></p>
	 */
	public class ScrollEvent extends Event {
		private var delta:Number;
		
		 /**
         * 定义<code>pressThumb</code>按下thumb事件的<code>type</code>
         * 
         * 属性与flash.events.MouseEvent.MOUSE_DOWN一样。
         *
         * @eventType pressThumb
         *
         * @see flash.events.MouseEvent
         */
		public static const PRESS_THUMB:String		=	"pressThumb";
		/**
         * 定义<code>releaseThumb</code>放开thumb事件的<code>type</code>
         * 
         * 属性与flash.events.MouseEvent.MOUSE_UP一样。
         *
         * @eventType releaseThumb
         *
         * @see flash.events.MouseEvent
         */
		public static const RELEASE_THUMB:String	=	"releaseThumb";
		/**
         * 定义<code>scroll</code>滑动thumb时产生的<code>type</code>事件.
         * 
		 * 此事件有如下属性：<br/>
         *  <table class="innertable" width="100%">
         *     <tr><th>Property</th><th>Value</th></tr>
         *	   <tr><td><code>bubbles</code></td><td><code>false</code></td></tr>
         *     <tr><td><code>cancelable</code></td><td><code>false</code>; there is no default
         *         behavior to cancel.</td></tr>
		 * 	   <tr><td><code>delta</code></td><td>Contains the change
		 *         in scroll position, expressed in pixels. A positive value indicates the 
		 * 		   scroll was down or to the right. A negative value indicates the scroll 
		 * 		   was up or to the left.</td></tr>
         *     <tr><td><code>currentTarget</code></td><td>The object that is actively processing 
         *         the event object with an event listener.</td></tr>
         *     <tr><td><code>target</code></td><td>The object that dispatched the event. The target is 
         *         not always the object listening for the event. Use the <code>currentTarget</code>
         * 	       property to access the object that is listening for the event.</td></tr>
         *  </table>
         *
         * @eventType scroll
         *
         * 
         */
		public static const SCROLL:String			=	"scroll";
		/**
         * 定义<code>activeScroll</code>激活滚动条时产生的<code>type</code>事件。
         * 
         * 
         *
         * @eventType activeScroll
         *
         */
		public static const ACTIVE_SCROLL:String	=	"activeScroll";
		
		/**
		 * 在 com.wlash.utils.ScrollBar广播scroll事件
		 * @param	delta 向上滚动还是向下滚动
		 */
		public function ScrollEvent(delta:Number) {
			super("scroll", false, false);
			this.delta		=	delta;
		}
		
		/**
		 * 重定义输出的格式。
		 * @return [Event=scrollEvent, type=activeScroll, delta=xx]
		 */
		override public function toString():String {
			return formatToString("ScrollEvent", "type", "delta");
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function clone():Event {
			return new ScrollEvent(delta);
		}
	}

}

/*
  ---------------------------------------------
*/
