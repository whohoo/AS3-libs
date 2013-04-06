//******************************************************************************
//	name:	ScrollDisplayObject 2.2
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-1-21 17:19
//	description: 1.1 当对象大小有变化时,scrollbar也应跟着有变化.
//			1.2增加了scrollMode方式,NONE,如果为MASK方式,自动得到生成一个mask对象
// 			1.3把Tween类去掉,同时去掉duration属性,改为easeValue
//			2.0把scrollMode属性去掉,因为不太常用.只假设对象在指定的位置移动.
//			2.1把缓冲的终止值加大，从0.1加到0.5，并增加了覆盖active属性
//			2.2当重新定义scrollTarget时，滚动条重新回到0位。添加destroy方法
//******************************************************************************


package com.wlash.scroll {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	
	[InspectableList("scrollObjectName", "easeValue", "maskHeight", "_targetInstanceName",
	"offsetPercent", "minSize", "scaleThumb", "pageSize","direction",
	"pageScrollSize", "scrollDelay", "mouseWheelEnabled", "active")]
	/**
	* 滚动MovieClip内容.
	* 
	* <p>需在参数面版中定义scrollTarget为DisplayObject.
	* </p>
	* <b>参数面版：</b>
	* <li>maskHeight: 定义需要mask的高度。</li>
	* <li>easeValue: 定义缓冲单位的级别,数值越小,缓冲越显示(0.01~1)。</li>
	* 其它参数请参考父类ScrollBar
	* 
	* @see SimpleScrollBar
	* @see ScrollDisplayObject
	* @see ScrollItems
	* @see AbstractScrollObject
	*/
	final public class ScrollDisplayObject extends AbstractScrollObject {
		

		
		
		//************************[READ|WRITE]************************************//
		/**
		 * cannot call in here
		 */
		override public function set maxValue(value:Number):void {
			//empty
		}
		
		[Inspectable(defaultValue = "100", type = "Number", category="X")]
		/**@private */
		public function set maskHeight(value:Number):void {
			_maskHeight	=	value;
			if (!_scrollTarget)	return;
			
			super.maxValue	=	_scrollTarget[getPosProp];
			if (_scrollTarget[getBoundProp] > value) { 
				super.minValue	=	super.maxValue - (_scrollTarget[getBoundProp] - value);
				_setActive(_active);
			}else { 
				_setActive(false);
			}
		}
		
		/**定义mask掉scrollTarget对象的高度.*/
		public function get maskHeight():Number { 
			return _maskHeight;
		}
		
		/**@private */
		override public function set scrollTarget(value:DisplayObject):void {
			super.scrollTarget	=	value;
			
			if (value) {
				maskHeight	=	_maskHeight;
				
				if(thumb && _isInit)	percent		=	0;
			}else {
				_setActive(false);
			}
		}

		
		/**@private */
		override public function set curValue(value:Number):void {
			if (_scrollValue == 0)	return;
			percent	=	(maxValue - value) / _scrollValue;
		}
		/**
		 * 根据当前thumb的位置,及最小值与最大值来决定当前值是多少,由于DisplayObject的值相反,
		 * 所以这里要重新改写此属性
		 */
		override public function get curValue():Number {//_scrollValue:最大值与最小值之间的差值.
			return maxValue - _scrollValue * percent;
		}
		
		/**@private */
		override protected function set scrollBarVisible(value:Boolean):void {
			if(scrollBar){
				if (value) {
					if(_scrollTarget){
						if (_scrollTarget[getBoundProp] > _maskHeight) {
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
		/** @inheritDoc */
		override protected function get isReadyScroll():Boolean { return super.isReadyScroll && Boolean(_scrollTarget); }
		
		private function get getBoundProp():String {return direction==AbstractScrollObject.VERTICAL ? "height" : "width" };
		//************************[STATIC PROPERTIES]*********************************//
		
		
		/**
		 * Construct Function
		 * 并不需要<code>new ScrollDisplayObject()</code>来构造对象，
		 * 只需要从库中拖到滚动条上既可。
		 */
		public function ScrollDisplayObject() {
			super();
		}
		
		//************************[PUBLIC METHOD]*********************************//

		
		/**
		 * <p>更新scrollDisplayObject, 如果scrollTarget对象大小有变化时.</p>
		 * <p><b>注意:</b>当保用此方法来动态显示scorllTarget内容时,也就是当
		 * scorllTarget大小变化时,调用此方法来更新.
		 * 
		 * @see scrollTarget
		 */
		public function update():void {
			if (!_scrollTarget)	return;
			
			if (_scrollTarget[getBoundProp] > _maskHeight) {
				minValue	=	maxValue - (_scrollTarget[getBoundProp] - _maskHeight);
				active		=	true;
				updateThumb((maxValue - _scrollTarget[getPosProp]) / _scrollValue)
			}else {
				active		=	false;
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
			easeScrollTargetTo(curValue);
		}
		
		/**
		 * 直接修改percent=xx时,调用此函数,表示scrollTarget也要跟着修改
		 * 
		 */
		override protected function renderScrollTarget():void {
			if (!_scrollTarget)	return;
			
			_scrollTarget[getPosProp]	=	curValue;
		}
		
		//************************[PRIVATE METHOD]********************************//


	}
}

/*
  ---------------------------------------------
*/
