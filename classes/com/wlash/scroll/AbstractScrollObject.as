//******************************************************************************
//	name:	AbstractScrollObject 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2010/4/23 12:05
//	description: ScrollDisplayObject与ScrollItems的父类，抽象类，
//				
//******************************************************************************


package com.wlash.scroll {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	

	/**
	* ScrollDisplayObject与ScrollItems类的父类，抽像类。
	* 
	* @see SimpleScrollBar
	* @see ScrollDisplayObject
	* @see ScrollItems
	*/
	public class AbstractScrollObject extends SimpleScrollBar {
		
		protected var _scrollTarget:DisplayObject;

		/**缓冲单位数的级别.*/
		protected var _easeValue:Number	=	0.2;
		protected var _maskHeight:Number	=	100;
		protected var _easeST2Value:Number;
		
		[Inspectable(defaultValue="vertical", verbose="1", type="list", enumeration="vertical,horizontal")]
		public var direction:String	=	VERTICAL;
		
		//************************[READ|WRITE]************************************//
		[Inspectable(defaultValue="", type="String", name="scrollTarget")]
		/**@private */
		public function set scrollObjectName(value:String):void {
			if (value.length == 0)	return;
			var sTraget:DisplayObject	=	eval(value);
			if (sTraget) {
				scrollTarget	=	sTraget;
			}else {
				throw new Error("ERROR: can NOT find ["+value+"] in ["+parent+"]. pls redefine scrollTarget in parameters panel.");
			}
		}
		/**
		 * @private 
		 * 只在参数面版中定义,因为吸附自动命名原因,所以不用scrollTargetName名称.*/
		public function get scrollObjectName():String {
			return _scrollTarget==null ? "" : _scrollTarget.name;
		}
		
		[Inspectable(defaultValue="0.2", verbose="1", type="Number")]
		/**@private */
		public function set easeValue(value:Number):void {
			value	=	value > 1 ? 1 :(value < .01 ? .01 : value);
			_easeValue	=	value;
		}
		/**缓冲单位移动的级别,数值越小,缓冲越明显,最大为1.*/
		public function get easeValue():Number {
			return _easeValue;
		}
		
		
		/**@private */
		public function set scrollTarget(value:DisplayObject):void {
			if (_scrollTarget) {
				_removeEvents();
				_scrollTarget.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
			_scrollTarget		=	value;
			
			
		}
		/**得到scrollTarget对象*/
		public function get scrollTarget():DisplayObject {
			return _scrollTarget;
		}
		

		//************************[READ ONLY]*************************************//
		/** @inheritDoc */
		override protected function get isReadyScroll():Boolean { return super.isReadyScroll && Boolean(_scrollTarget); }
		
		
		protected function get getPosProp():String {
			/*trace( "getPosProp : " + _scrollTarget["x"] );	*/
			return direction == VERTICAL ? "y" : "x";
		}
		
		//************************[STATIC PROPERTIES]*********************************//
		/**垂直滚动文本框,默认*/
		static public const VERTICAL:String		=	"vertical";
		/**水平滚动文本框*/
		static public const HORIZONTAL:String	=	"horizontal";
		
		
		/**
		 * Construct Function
		 * 并不需要<code>new ScrollDisplayObject()</code>来构造对象，
		 * 只需要从库中拖到滚动条上既可。
		 */
		public function AbstractScrollObject() {
			super();
		}
		
		//************************[PUBLIC METHOD]*********************************//
		/**
		 * @inheritDoc 
		 */
		override public function setMouseWheel(enabled:Boolean):void {
			if (!_scrollTarget)	return;
			
			super.setMouseWheel(enabled);
			if (enabled) {
				_scrollTarget.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			}else {
				_scrollTarget.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function destroy():void {
			super.destroy();
			_removeEvents();
			
			if(_scrollTarget)
				_scrollTarget.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		
		//************************[INTERNAL METHOD]*******************************//
		
		
		//************************[PROTECTED METHOD]*****************************//
		/**
		 * 直接修改percent=xx时,调用此函数,表示scrollTarget也要跟着修改
		 * 
		 */
		override protected function renderScrollTarget():void {
			
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function _setActive(value:Boolean):void {
			if (_scrollTarget) {
				super._setActive(value);
				_setScrollTargetActive(value);
				//trace("b",_scrollTarget.y);
			}else {
				super._setActive(false);
				_setScrollTargetActive(false);
			}
			
		}
		
		/**
		 * 当滑动thumb时，移动scrollTarget对象。
		 * @param	evt
		 */
		protected function updateTargetScroll(evt:Event):void { 
			//easeScrollTargetTo(...);
		}
		
		
		
		protected function _addEvents():void {
			addEventListener(SimpleScrollBar.SCROLL, updateTargetScroll, false, 0, true);
		}
		
		protected function _removeEvents():void {
			removeEventListener(Event.ENTER_FRAME, _easeScrollTargetTo, false);
			removeEventListener(SimpleScrollBar.SCROLL, updateTargetScroll, false);
		}
		
		protected function easeScrollTargetTo(value:Number):void {
			_easeST2Value	=	value;
			addEventListener(Event.ENTER_FRAME, _easeScrollTargetTo, false, 0, true);
		}
		
		protected function _easeScrollTargetTo(e:Event):void {
			var pos:Number		=	_easeST2Value - _scrollTarget[getPosProp];
			_scrollTarget[getPosProp]		+=	pos * _easeValue;
			if (Math.abs(pos) < .5) {
				_scrollTarget[getPosProp]	=	_easeST2Value;
				removeEventListener(Event.ENTER_FRAME, _easeScrollTargetTo, false);
			}
		}
		
		protected function _setScrollTargetActive(value:Boolean):void {
			if (_scrollTarget) {
				if (value) {
					_addEvents();
					if(_enabledMouseWheel){
						_scrollTarget.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
					}
				}else {
					_removeEvents();
					_scrollTarget.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				}
			}else {
				_removeEvents();
			}
		}
		//************************[PRIVATE METHOD]********************************//

		
		
	}
}

/*
  ---------------------------------------------
*/
