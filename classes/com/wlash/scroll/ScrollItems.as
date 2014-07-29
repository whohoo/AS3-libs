//******************************************************************************
//	name:	ScrollItems 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2010/4/22 11:38
//	description: 
//******************************************************************************


package com.wlash.scroll {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	[InspectableList("scrollObjectName", "easeValue", "maskItems", "spaceItem","maxValue","direction",
	"_targetInstanceName","offsetPercent", "minSize", "scaleThumb", "pageSize","resetEaseValue",
	"pageScrollSize", "scrollDelay", "mouseWheelEnabled", "active")]
	/**
	* 滚动MovieClip内容.
	* 
	* <p>需在参数面版中定义scrollTarget为DisplayObjectContainer.
	* </p>
	* <b>参数面版：</b>
	* <li>maskHeight: 定义需要mask的高度。</li>
	* <li>easeValue: 定义缓冲单位的级别,数值越小,缓冲越显示(0.01~1)。</li>
	* 其它参数请参考父类SimpleScrollBar
	* 
	* @see SimpleScrollBar
	* @see ScrollTextField
	*/
	public class ScrollItems extends AbstractScrollObject {
		

		private var _initTargetPos:Number;
		private var _easeThumb2Value:Number;
		/**缓冲单位数的级别.*/
		private var _resetEaseValue:Number	=	0.2;
		private var _maskItems:int			=	10;
		private var _spaceItem:Number		=	20;
		private var _unmaskValue:Number;
		
		//************************[READ|WRITE]************************************//
		

		
		[Inspectable(defaultValue="0.2", verbose="1", type="Number")]
		/**@private */
		public function set resetEaseValue(value:Number):void {
			value	=	value > 1 ? 1 :(value < .01 ? .01 : value);
			_resetEaseValue	=	value;
		}
		/**归位到对齐时的缓冲值<p/>缓冲单位移动的级别,数值越小,缓冲越明显,最大为1.*/
		public function get resetEaseValue():Number {
			return _resetEaseValue;
		}
		
		[Inspectable(defaultValue = "10", type = "Number", category="X")]
		/**@private */
		public function set maskItems(value:int):void {
			var cValue:int	=	curValue;
			_maskItems		=	value;
			_maskHeight		=	value * _spaceItem;
			_scrollValue	=	_maxValue - value;
			_unmaskValue	=	(_maxValue-value) * _spaceItem;
			if (_isInit ) {
				if(_render()){
					curValue	=	cValue;
				}else {
					percent		=	0;
				}
			}
		}
		
		/**定义mask掉scrollTarget对象的高度.*/
		public function get maskItems():int { 
			return _maskItems;
		}
		
		[Inspectable(defaultValue = "20", type = "Number", category="X")]
		/**@private */
		public function set spaceItem(value:Number):void {
			_spaceItem	=	value;
			maskItems	=	_maskItems;
		}
		
		/**定义两个Item之间的距离*/
		public function get spaceItem():Number { 
			return _spaceItem;
		}
		
		[Inspectable(defaultValue = "0", verbose = "1", type = "Number", category = "value")]
		/**@private */
		override public function set minValue(value:Number):void {
			//if (value == _maxValue)	return;
			//_minValue		=	0;
			//_scrollValue	=	_maxValue-_maskItems;
			//if (!_isInit)	return;
			//updateThumb(percent);
		}
		

		[Inspectable(defaultValue = "20", verbose = "0", type = "Number", category = "value")]
		/**@private */
		override public function set maxValue(value:Number):void {
			//if (value == _minValue)	return;
			var cValue:int	=	curValue;
			_maxValue		=	value;
			if (_isInit){
				updateThumb(percent);
			}
			maskItems		=	_maskItems;
			
		}
		
		
		/**@private */
		override public function set scrollTarget(value:DisplayObject):void {
			super.scrollTarget	=	value;
			
			if (value is DisplayObjectContainer) {
				_initTargetPos	=	value[getPosProp];
				if (_isInit) {
					_render();
				}
				//scrollBarVisible	=	active;
				//trace(thumb && _isInit);
				if(thumb && _isInit)	percent		=	0;
				
			}else {
				
			}
		}
		
		
		/**
		 * 根据当前thumb的位置,及最小值与最大值来决定当前值是多少,由于DisplayObject的值相反,
		 * 所以这里要重新改写此属性
		 */
		override public function get curValue():Number {//_scrollValue:最大值与最小值之间的差值.
			return Math.round(_scrollValue * percent);
		}
		
		//public function set itemIndex(value:int):void {
			//if (value == _itemIndex)	return;
			//_itemIndex	=	value;
		//}
		//
		///**Annotation*/
		//public function get itemIndex():int { return _itemIndex; }
		
		/**@private */
		override protected function set scrollBarVisible(value:Boolean):void {
			if(scrollBar){
				if (value) {
					if(_scrollTarget){
						if (_maxValue > _maskItems) {
							setScrollBarVisible(true);
						}else {
							setScrollBarVisible(false);
						}
					}else {
						setScrollBarVisible(false);
					}
				}else {
					setScrollBarVisible(false);
				}
			}
		}
		
		
		//************************[READ ONLY]*************************************//
		
		
		
		//************************[STATIC PROPERTIES]*********************************//

		
		/**
		 * Construct Function
		 * 并不需要<code>new ScrollDisplayObject()</code>来构造对象，
		 * 只需要从库中拖到滚动条上既可。
		 */
		public function ScrollItems() {
			super();
		}
		
		//************************[PUBLIC METHOD]*********************************//
		/**
		 * 把滚动条滑动到指定的位置， 
		 * @param value
		 */
		public function moveToValue(value:int):void {
			if (curValue == value || value>maxValue)	return;
			resetScrollTargetTo(value);
		}

		
		/**
		 * <p>更新scrollDisplayObject, 如果scrollTarget对象大小有变化时.</p>
		 * <p><b>注意:</b>当保用此方法来动态显示scorllTarget内容时,也就是当
		 * scorllTarget大小变化时,调用此方法来更新.
		 * 
		 * @see scrollTarget
		 */
		public function update():void {
			if (!_scrollTarget)	return;
			
			if (_render()) {
				
			}else {
				
			}
		}
		//************************[INTERNAL METHOD]*******************************//
		
		
		//************************[PROTECTED METHOD]*****************************//
		/**
		 * 当滑动thumb时，移动scrollTarget对象。
		 * @param	evt
		 */
		override protected function updateTargetScroll(evt:Event):void { 
			super.updateTargetScroll(evt);
			easeScrollTargetTo(_initTargetPos - _unmaskValue * (percent));
		}
		
		
		override protected function onThumbDown(evt:MouseEvent):void {
			super.onThumbDown(evt);
			removeEventListener(Event.ENTER_FRAME, _easeThumbTo, false);
			//removeEventListener(Event.ENTER_FRAME, _easeScrollTargetTo, false);
			//removeEventListener(Event.ENTER_FRAME, _resetScrollTargetTo, false);
		}
		
		override protected function onThumbUp(evt:MouseEvent):void {
			super.onThumbUp(evt);
			resetScrollTargetTo(curValue);
		}
		
		override protected function onTrackDown(evt:MouseEvent):void {
			super.onTrackDown(evt);
			removeEventListener(Event.ENTER_FRAME, _easeThumbTo, false);
			//removeEventListener(Event.ENTER_FRAME, _easeScrollTargetTo, false);
			//removeEventListener(Event.ENTER_FRAME, _resetScrollTargetTo, false);
		}
		
		override protected function onTrackUp(evt:MouseEvent):void {
			super.onTrackUp(evt);
			resetScrollTargetTo(curValue);
		}
		
		/**
		 * 直接修改percent=xx时,调用此函数,表示scrollTarget也要跟着修改
		 * 
		 */
		override protected function renderScrollTarget():void {
			if (_scrollTarget){
				_scrollTarget[getPosProp]	=	_initTargetPos - curValue * _spaceItem;
				//trace( "_scrollTarget[getPosProp] : " + _scrollTarget[getPosProp],percent,curValue );
			}
		}
		
		override protected function _removeEvents():void {
			super._removeEvents();
			removeEventListener(Event.ENTER_FRAME, _easeThumbTo, false);
		}
		//************************[PRIVATE METHOD]********************************//

		private function _render():Boolean {
			if (_maxValue > _maskItems) {
				_setActive(_active);
				return true;
			}else {
				_setActive(false);
				return false;
			}
		}
		
		private function resetScrollTargetTo(value:int):void {
			//_resetST2Value	=	_initTargetPos - value * _spaceItem;
			easeScrollTargetTo(_initTargetPos - value * _spaceItem);
			easeThumbTo(value/_scrollValue);
			//addEventListener(Event.ENTER_FRAME, _resetScrollTargetTo, false, 0, true);
			//removeEventListener(Event.ENTER_FRAME, _easeScrollTargetTo, false);
		}
		
		private function easeThumbTo(value:Number):void {
			_easeThumb2Value	=	value;
			addEventListener(Event.ENTER_FRAME, _easeThumbTo, false, 0, true);
		}
		
		private function _easeThumbTo(e:Event):void {
			var posY:Number		=	_easeThumb2Value - percent;
			setPercent(percent + posY * _resetEaseValue);
			if (Math.abs(posY) < .01) {
				setPercent(_easeThumb2Value);
				removeEventListener(Event.ENTER_FRAME, _easeThumbTo, false);
			}
		}
		
		
	}
}

/*
  ---------------------------------------------
*/
