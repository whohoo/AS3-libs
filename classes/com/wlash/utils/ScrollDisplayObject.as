//******************************************************************************
//	name:	ScrollBar 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-1-21 17:52
//	description: http://www.17play.org/forum/viewthread.php?tid=75
//			http://topic.csdn.net/t/20030921/15/2284126.html
// 
//******************************************************************************

/**
* ScrollDisplayObject.<p>
* </p>
*/
package com.wlash.utils {
	import com.wlash.utils.ScrollEvt;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.events.TextEvent;
	import flash.events.MouseEvent;
	
	[IconFile("ScrollDisplayObject.png")]
	public class ScrollDisplayObject extends Sprite {
		private var _scrollTarget:DisplayObject;
		private var _scrollTargetType:String;
		
		private var _scrollBar:DisplayObjectContainer;
		private var _thumb:DisplayObject;
		private var _track:DisplayObject;
		
		private var isDrag:Boolean;
		private var _initPosY:Number;
		
		private var _top:Number;
		/**_bottomInit- thumbHieght所得的值,也就是thumb能移到的最底地方*/
		private var _bottom:Number;
		private var _bottomInit:Number;//初始时的最底位置
		private var _thumbHeight:Number;
		/**track的高度-thumb的高度.*/
		private var _length:Number;
		/**当mouse点下时的位移*/
		private var _thumbOffset:Number;
		/**获取或设置页中所包含的行数。*/
		private var _pageSize:Number	=	10;
		/**thumb最小值*/
		[Inspectable(defaultValue="13", verbose=1, type=Number)]
		public var minSize:Number		=	13;
		/**当scrollTarget对象为DisplayObject时,则要定义maskHeight来移动scrollTarget对象*/
		[Inspectable(defaultValue="0", verbose=0, type=Number)]
		public var maskHeight:Number	=	0;
		
		
		//************************[READ|WRITE]************************************//
		[Inspectable(defaultValue="", type=String, name=scrollTarget)]
		public function set scrollObjectName(value:String):void {
			if (parent.getChildByName(value) != null) {
				scrollTarget	=	parent.getChildByName(value);
			}else {
				
			}
		}
		/**只在参数面版中定义,因为吸附自动命名原因,所以不用scrollTargetName名称.*/
		public function get scrollObjectName():String {
			return _scrollTarget==null ? null : _scrollTarget.name;
		}
		public function set scrollTarget(value:DisplayObject):void {
			if (_scrollTarget != null) {
				_scrollTarget.removeEventListener(Event.CHANGE, onTargetChange, false);
				_scrollTarget.removeEventListener(TextEvent.TEXT_INPUT, onTargetChange, false);
				_scrollTarget.removeEventListener(Event.SCROLL, onTargetScroll, false);
				removeEventListener(ScrollEvt.SCROLL, updateTargetScroll, false);
			}
			if (value is TextField) {
				_scrollTarget		=	value;
				_scrollTargetType	=	"TextField";
				onTargetChange(new Event(Event.CHANGE));
				_scrollTarget.addEventListener(Event.CHANGE, onTargetChange, false, 0, true);//it seem did not work.
				_scrollTarget.addEventListener(TextEvent.TEXT_INPUT, onTargetChange, false, 0, true);
				_scrollTarget.addEventListener(Event.SCROLL, onTargetScroll, false, 0, true);
				addEventListener(ScrollEvt.SCROLL, updateTargetScroll, false, 0, true);
			}else if (value is DisplayObject){
				_scrollTarget		=	value;
				_scrollTargetType	=	"DisplayObject";
				_initPosY			=	value.y;
				addEventListener(ScrollEvt.SCROLL, updateTargetScroll, false, 0, true);
			}else {
				_scrollTargetType	=	null;
			}
		}
		public function get scrollTarget():DisplayObject {
			return _scrollTarget;
		}
		
		[Inspectable(defaultValue="", type=String, name=scrollBar)]
		public function set _targetInstanceName(target:String):void {//scrollTargetName
			if (parent.getChildByName(target) is DisplayObjectContainer) {
				scrollBar	=	parent.getChildByName(target) as DisplayObjectContainer;
			}else {
				throw new TypeError("scrollBar is not flash.display.DisplayObjectContainer. type: " + 
							typeof(parent.getChildByName(target)) + ", target: "+target);
			}
		}
		/**定义scrollBar属性,此属性只在参数面版中修改*/		
		public function get _targetInstanceName():String {//scrollTargetName
			return _scrollBar.name;
		}

		public function set scrollBar(value:DisplayObjectContainer):void {
			if (value.numChildren != 2) {
				throw new Error("TWO DisplayObjectContainers only. one is scroll thumb, " +
						"another is scroll track. numChildren: " + value.numChildren +
						", value: "+value+", valueName: "+value.name);
			}
			track	=	value.getChildAt(0);
			thumb	=	value.getChildAt(1);
			
			_scrollBar	=	value;
		}
		/**定义scrollBar属性*/		
		public function get scrollBar():DisplayObjectContainer {
			return _scrollBar;
		}
		
		protected function set thumb(value:DisplayObject):void {
			_thumb	=	value;
			//当没定义任何值时,thumb不会改变大小.
			updateThumb(percent, 0, _pageSize / _thumb.height * _track.height - _pageSize);
			
			value.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
		}
		/**scroll滚动的bar*/
		protected function get thumb():DisplayObject {
			return _thumb;
		}
		
		protected function set track(value:DisplayObject):void {
			_track			=	value;
			var rect:Rectangle	=	value.getRect(value.parent);
			_top			=	rect.top;
			_bottomInit		=	rect.bottom;
		}
		/**scroll背景的track*/
		protected function get track():DisplayObject {
			return _track;
		}
		[Inspectable(defaultValue="10", verbose=1, type=Number)]
		public function set pageSize(value:Number):void {
			_pageSize	=	value;
			if (_thumb == null)	return;
			updateThumb(percent);
		}
		
		public function get pageSize():Number {
			return _pageSize;
		}
		
		public function set percent(value:Number):void {
			value		=	Math.max(0, Math.min(1, value));
			_thumb.y	=	_length * value + _top;
		}
		/**thumb在track的位置,百分比表示0<=percent<=1*/
		public function get percent():Number {
			return (_thumb.y - _top)/_length;
		}
		
		public function set active(value:Boolean):void {
			
		}
		/**滚动条是否可用*/
		public function get active():Boolean {
			return _thumb.visible;
		}
		//************************[READ ONLY]*************************************//
		
		public static const PRESS_THUMB:String		=	"pressThumb";
		public static const RELEASE_THUMB:String	=	"releaseThumb";
		/**
		 * 构建线条对象.
		 * 
		 */
		public function ScrollDisplayObject(){
			getChildAt(0).visible	=	false;
			
		}
		
		//************************[PRIVATE METHOD]********************************//
		
		
		private function onThumbDown(evt:MouseEvent):void {
			evt.stopImmediatePropagation();//??有无效果?
			_thumbOffset	=	mouseY - _thumb.y;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			isDrag	=	true;
			dispatchEvent(new MouseEvent(PRESS_THUMB, true, false, evt.localX, evt.localY,
						evt.relatedObject));
		}
		
		private function onThumbMove(evt:MouseEvent):void {
			var pos:Number	=	Math.max(_top, Math.min(_bottom, mouseY - _thumbOffset));
			var oldPos:Number	=	_thumb.y;
			var delta:Number	=	pos - oldPos;
			_thumb.y		=	pos;
			if (delta != 0) {
				
				dispatchEvent(new ScrollEvt( delta, percent));
			}
		}
		
		private function onThumbUp(evt:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			isDrag	=	false;
			dispatchEvent(new MouseEvent(RELEASE_THUMB, true, false, evt.localX, evt.localY,
						evt.relatedObject));
		}
		
		private function updateThumb(percentNum:Number, minPos:Number = NaN, maxPos:Number = NaN):void {
			minPos	=	isNaN(minPos) ? _top : minPos;//default value
			maxPos	=	isNaN(maxPos) ? _bottomInit : maxPos;//default value
			var per:Number	=	maxPos - minPos + _pageSize;
			var pSizePer:Number	=	Math.max(0, Math.min(1, _pageSize / per));//不能超过track的高
			_thumbHeight	=	 Math.max(minSize, pSizePer * _track.height);
			_bottom			=	_bottomInit - _thumbHeight;
			_length			=	_bottom - _top;
			_thumb.height	=	_thumbHeight;
			percent			=	percentNum;//重新定位百分比位置.
		}
		
		protected function onTargetChange(evt:Event):void {
			var sTarget:TextField	=	_scrollTarget as TextField;
			updateThumb(percent, 1, sTarget.maxScrollV);
			
		}
		protected function onTargetScroll(evt:Event):void {
			if (isDrag)	return;
			var sTarget:TextField	=	_scrollTarget as TextField;
			//当mouse滚动时,更新thumb位置及大小.
			updateThumb((sTarget.scrollV-1)/(sTarget.maxScrollV-1), 1, sTarget.maxScrollV);
		}
		protected function updateTargetScroll(evt:ScrollEvt):void {
			switch(_scrollTargetType) {
				case "TextField":
					var sTarget:TextField	=	_scrollTarget as TextField;
					sTarget.scrollV	=	Math.round(evt.percent * (sTarget.maxScrollV - 1)) + 1;
					
					break;
				case "DisplayObject":
					
					break;
				default:
					//do nothing
			}
		}
		//***********************[PUBLIC METHOD]**********************************//
		/**
		 * set scroll bar length, <p></p>
		 * this code form MM scroll component.
		 * @param  pSize  page size
		 * @param  mnPos  min position
		 * @param  mxPos  max position
		 */
		public function setScrollProperties(pSize:Number, minPos:Number, maxPos:Number):void {
			_pageSize	=	pSize;
			updateThumb(percent, minPos, maxPos);
		}
		
		
		//***********************[STATIC METHOD]**********************************//
		
		
	}
}

/*
  ---------------------------------------------
*/
