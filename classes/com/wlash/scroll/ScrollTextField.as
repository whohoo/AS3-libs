//******************************************************************************
//	name:	ScrollTextField 1.6
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-1-21 17:19
//	description: 1.5 20090623 修改文本滚动bug
// 				v1.6添加destroy方法,调整些程序。
//				
//******************************************************************************


package com.wlash.scroll {
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.TextEvent;
	
	
	[InspectableList("scrollObjectName", "duration", "direction", "_targetInstanceName", "minSize", 
	"scaleThumb","pageSize", "pageScrollSize", "scrollDelay", "mouseWheelEnabled", "active")]
	/**
	* 滚动TextField框内容.
	* 
	* <p>需在参数面版中定义scrollTarget为文本框对象。
	* </p>
	* <b>参数面版：</b>
	* <li>direction: 水平方向或垂直方向滚动文本框。</li>
	* 其它参数请参考父类ScrollBar
	* 
	* @see SimpleScrollBar
	* @see ScrollDisplayObject
	*/
	final public class ScrollTextField extends SimpleScrollBar {
		private var _scrollTarget:TextField;
		private var _isTextType:Boolean;
		
		[Inspectable(defaultValue="vertical", type="list", enumeration="vertical,horizontal")]
		public var direction:String	=	VERTICAL;
		//************************[READ|WRITE]************************************//
		[Inspectable(defaultValue="", type="String", name="scrollTarget")]
		/**@private */
		public function set scrollObjectName(value:String):void {
			if (value.length == 0)	return;
			var sTraget:TextField	=	eval(value) as TextField;
			
			if (sTraget) {
				scrollTarget	=	sTraget;
			}else {
				throw new Error("ERROR: can NOT find ["+value+"] in ["+parent+"]. pls redefine scrollTarget in parameters panel.");
			}
			
		}
		/**
		 * @private
		 * 只在参数面版中定义,因为吸附自动命名原因,所以不用scrollTargetName名称.
		 */
		public function get scrollObjectName():String {
			return _scrollTarget==null ? "" : _scrollTarget.name;
		}
		
		/**@private */
		public function set scrollTarget(value:TextField):void {
			if (_scrollTarget) {
				_scrollTarget.removeEventListener(Event.CHANGE, onTargetChange, false);//it seem did not work.
				//_scrollTarget.addEventListener(TextEvent.TEXT_INPUT, onTargetChange, false, 0, true);
				_scrollTarget.removeEventListener(Event.SCROLL, onTargetScroll, false);
				removeEventListener(SimpleScrollBar.SCROLL, updateTargetScroll, false);
			}
			_scrollTarget		=	value;
			
			if(value){
				//onTargetChange(new Event(Event.CHANGE));
				if (active) {
					_setActive(true);
				}
				
				if (direction == VERTICAL) {//垂直滚动,默认
					minValue	=	1;
					maxValue	=	value.maxScrollV;
					
				}else {//水平滚动.
					minValue	=	0;
					maxValue	=	value.maxScrollH;
					
				}
				scrollBarVisible	=	active;
			}else {
				
			}
			
		}
		/**得到scrollTarget对象*/
		public function get scrollTarget():TextField {
			return _scrollTarget;
		}
		
		/**@private */
		override protected function set scrollBarVisible(value:Boolean):void {
			if (value) {
				if (direction == VERTICAL) {
					if (maxValue > 1) {
						setScrollBarVisible(true);
					}else {
						setScrollBarVisible(false);
					}
				}else {
					if (maxValue > 0) {
						setScrollBarVisible(true);
					}else {
						setScrollBarVisible(false);
					}
				}
			}else {
				setScrollBarVisible(false);
			}
		}
		//************************[READ ONLY]*************************************//
		/** @inheritDoc */
		override protected function get isReadyScroll():Boolean { return super.isReadyScroll && Boolean(_scrollTarget); }
		
		
		//************************[STATIC PROPERTIES]*********************************//
		/**垂直滚动文本框,默认*/
		static public const VERTICAL:String		=	"vertical";
		/**水平滚动文本框*/
		static public const HORIZONTAL:String	=	"horizontal";
		
		/**
		 * 构造函数
		 * 并不需要<code>new ScrollDisplayObject()</code>来构造对象，
		 * 只需要从库中拖到滚动条上既可。
		 */
		public function ScrollTextField() {
			super();
		}
		
		//************************[PUBLIC METHOD]*********************************//
		/**
		 * @inheritDoc 
		 */
		override public function setMouseWheel(enabled:Boolean):void {
			if (!_scrollTarget) 	return;
			
			super.setMouseWheel(enabled);
			_scrollTarget.mouseWheelEnabled	=	enabled;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function destroy():void {
			super.destroy();
			if(_scrollTarget){
				_scrollTarget.removeEventListener(Event.CHANGE, onTargetChange, false);//it seem did not work.
				//_scrollTarget.addEventListener(TextEvent.TEXT_INPUT, onTargetChange, false, 0, true);
				_scrollTarget.removeEventListener(Event.SCROLL, onTargetScroll, false);
			}
			removeEventListener(SimpleScrollBar.SCROLL, updateTargetScroll, false);
		}
		
		/**
		 * <p>更新scrollTextField, 如果scrollTarget对象滚动位置有变化时.</p>
		 * <p><b>注意:</b>当保用此方法来动态显示scorllTarget内容时,也就是当
		 * scorllTarget滚动位置变化时,调用此方法来更新
		 * 
		 * @see scrollTarget
		 */
		public function update():void {
			if (!_scrollTarget)	return;
			
			onTargetChange(null);
			active	=	true;
		}
		
		/**
		 * 当点向上按键时，上移一行。
		 * @param	num 行数的倍数，默认为1
		 * @return 如果还可以继续移动，返回<code>true</code>
		 */
		override public function moveThumbUp(num:int=1):Boolean {
			var canMove:Boolean	=	true;
			var oldPos:Number	=	thumb.y;
			if (direction == VERTICAL) {
				_scrollTarget.scrollV	--;
				curValue	=	_scrollTarget.scrollV;
				if (_scrollTarget.scrollV <= 1) {
					canMove	=	false;
				}
			}else {
				_scrollTarget.scrollH	-=	pageScrollSize;//横向滚动移动的像素值
				curValue	=	_scrollTarget.scrollH;
				if (_scrollTarget.scrollH <= 0) {
					canMove	=	false;
				}
			}
			//_delta	=	oldPos - thumb.y
			dispatchScrollEvent(oldPos);
			return canMove;
		}
		
		/**
		 * 当点向下按键时，下移一行。
		 * @param	num 行数的倍数，默认为1
		 * @return 如果还可以继续移动，返回<code>true</code>
		 */
		override public function moveThumbDown(num:int=1):Boolean {
			var canMove:Boolean	=	true;
			var oldPos:Number	=	thumb.y;
			if (direction == VERTICAL) {
				_scrollTarget.scrollV	++;
				curValue	=	_scrollTarget.scrollV;
				if (_scrollTarget.scrollV >= _scrollTarget.maxScrollV) {
					canMove	=	false;
				}
			}else {
				_scrollTarget.scrollH	+=	pageScrollSize;//横向滚动移动的像素值
				curValue	=	_scrollTarget.scrollH;
				if (_scrollTarget.scrollH >= _scrollTarget.maxScrollH) {
					canMove	=	false;
				}
			}
			//ldPos - thumb.y
			dispatchScrollEvent(oldPos);
			return canMove;
		}
		
		//************************[INTERNAL METHOD]*******************************//

		
		
		//************************[PROTECTED METHOD]*****************************//
		/**
		 * @inheritDoc 
		 */
		override protected function _setActive(value:Boolean):void {
			if(_scrollTarget){
				super._setActive(value);
				_setScrollTargetActive(value);
			}else {
				super._setActive(false);
				_setScrollTargetActive(false);
			}
		}
		
		/**
		 * 当通过改变percent属性值时,会调用此函数
		 */
		override protected function renderScrollTarget():void {
			if (_scrollTarget == null) 	return;
			
			if(direction==VERTICAL){
				_scrollTarget.scrollV	=	Math.round(curValue);
			}else {
				_scrollTarget.scrollH	=	Math.round(curValue);
			}
		}
		
		//************************[PRIVATE METHOD]********************************//
		/**
		 *	当拖动thumb时广播的onScroll事件,触发此事件.
		 * @param evt
		 */
		private function updateTargetScroll(e:Event):void {
			
			renderScrollTarget();
			
			/*//if (_pressObj==null)	return;//实际不太需要这个判断.
			if (direction == VERTICAL) {
				//trace(Math.round(evt.currentTarget.percent * (_scrollTarget.maxScrollV - 1)) + 1, Math.round(curValue));
				//_scrollTarget.scrollV	=	Math.round(percent * (_scrollTarget.maxScrollV - 1)) + 1;
				_scrollTarget.scrollV	=	Math.round(curValue);
			}else {
				//_scrollTarget.scrollH	=	Math.round(percent * (_scrollTarget.maxScrollH));
				_scrollTarget.scrollH	=	Math.round(curValue);
			}*/
		}
		
		/**
		 * 这个不知道有什么用,是从官方组件中拿来的
		 * @param	e
		 */
		private function onTargetChange(e:Event):void {
			
			var vMaxScroll:int;
			var vScroll:int;
			if (direction == VERTICAL) {
				maxValue	=	_scrollTarget.maxScrollV;
				vMaxScroll	=	_scrollTarget.maxScrollV - 1;
				vScroll		=	_scrollTarget.scrollV - 1;
				//trace( "_scrollTarget.scrollV : " + _scrollTarget.scrollV );
			}else {
				maxValue	=	_scrollTarget.maxScrollH;
				vMaxScroll	=	_scrollTarget.maxScrollH;
				vScroll		=	_scrollTarget.scrollH;
			}
			
			vScroll		=	vScroll > vMaxScroll ? vMaxScroll : vScroll;
			//trace( "vScroll : " + vScroll );
			if(vMaxScroll>0){
				updateThumb(vScroll / vMaxScroll);
				scrollBarVisible	=	true;
			}else {
				scrollBarVisible	=	inactiveVisible;
			}
		}
		
		/**
		 * 外边变化时,比如 wheel或改变值.
		 * @param	evt
		 */
		private function onTargetScroll(evt:Event):void {
			//trace("onTargetScroll",_pressObj,  this.name);
			//如果有横竖两个滚动条同时关注同一个文本框,则这会广播两次.
			if (_pressObj!=null)	return;
			//当mouse滚动时,更新thumb位置及大小.
			onTargetChange(evt);
			
			//var vMaxScroll:int;
			//if (direction == VERTICAL) {
				//maxValue	=	_scrollTarget.maxScrollV;
				//vMaxScroll	=	_scrollTarget.maxScrollV - 1;
				//if(vMaxScroll>0){
					//updateThumb((_scrollTarget.scrollV - 1) / vMaxScroll);
					//scrollBar.visible	=	true;
				//}else {
					//scrollBar.visible	=	false;
				//}
			//}else {
				//maxValue	=	_scrollTarget.maxScrollH;
				//vMaxScroll	=	_scrollTarget.maxScrollH - 1;
				//if(vMaxScroll>0){
					//updateThumb((_scrollTarget.scrollH) / vMaxScroll);
					//scrollBar.visible	=	true;
				//}else {
					//scrollBar.visible	=	false;
				//}
			//}
		}
		
		
		private function _setScrollTargetActive(value:Boolean):void{
			if (_scrollTarget) {
				if (value) {
					addEventListener(SimpleScrollBar.SCROLL, updateTargetScroll, false, 0, true);
					_scrollTarget.addEventListener(Event.CHANGE, onTargetChange, false, 0, true);//it seem did not work.
					//_scrollTarget.addEventListener(TextEvent.TEXT_INPUT, onTargetChange, false, 0, true);
					_scrollTarget.addEventListener(Event.SCROLL, onTargetScroll, false, 0, true);
				}else {
					_scrollTarget.removeEventListener(Event.CHANGE, onTargetChange, false);//it seem did not work.
					//_scrollTarget.addEventListener(TextEvent.TEXT_INPUT, onTargetChange, false, 0, true);
					_scrollTarget.removeEventListener(Event.SCROLL, onTargetScroll, false);
					removeEventListener(SimpleScrollBar.SCROLL, updateTargetScroll, false);
				}
			}else {
				removeEventListener(SimpleScrollBar.SCROLL, updateTargetScroll, false);
			}
		}
		
	}

}

/*
  ---------------------------------------------
  
*/
