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
package com.wlash.utils {
	import flash.events.Event;
	
	
	public class ScrollEvt extends Event {
		public var delta:Number;
		public var percent:Number;
		
		public static const SCROLL:String = "scroll";
		
		/**
		 * 在 com.wlash.utils.ScrollDisplayObject广播scroll事件
		 * @param	delta 向上滚动还是向下滚动
		 * @param	percent 当前位置占总位置的百分比
		 */
		public function ScrollEvt(delta:Number, percent:Number) {
			super(SCROLL, false, false);
			this.delta		=	delta;
			this.percent	=	percent;
		}
		
		override public function toString():String {
			return formatToString("ScrollEvt", "type", "delta", "percent");
		}
		
		override public function clone():Event {
			return new ScrollEvt(delta, percent);
		}
	}

}

/*
  ---------------------------------------------
*/
