//******************************************************************************
//	name:	ScrollBar 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-1-21 17:52
//	description: 不再使用的类
// 
//******************************************************************************


package com.wlash.scroll {
	import com.wlash.frameset.Component;
	import com.wlash.scroll.ScrollEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	//import flash.geom.Rectangle;
	//import flash.text.TextField;
	//import flash.events.TextEvent;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	//import com.wlash.scroll.ScrollEvent;
	
	/**
	 * 当thumb被按下时广播的事件
	 *
	 * @eventType flash.events.MouseEvent
     *
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	[Event(name = "pressThumb", type = "flash.events.MouseEvent")]
	
	/**
	 * 当thumb被放开时广播的事件
	 *
	 * @eventType flash.events.MouseEvent
     *
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	[Event(name = "releaseThumb", type = "flash.events.MouseEvent")]
	
	/**
	 * 当滑动thumb地，广播的事件。
	 *
	 * @eventType com.wlash.scroll.ScrollEvent
     *
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	[Event(name = "scroll", type = "com.wlash.scroll.ScrollEvent")]
	
	[IconFile("ScrollDisplayObject.png")]
	/**
	* ScrollBar 简单滚动条组件.
	* 
	* <p>把组件拖到定义好的滚动条对象上,滚动条对象要求是DisplayObjectContainer的子类,
	* 并且只有两个可显示对象(DisplayObject)或四个可显示对象（一个向上滚动按键，一是向下按键）。</p>
	* <li>track对象（DisplayObject）：也就是滚动条对象的背景,如果track对象为InteractiveObject类或其子类，
	* 则track可监听点击滑动thumb事件。（必须存在滚动条的最底层，且顶点需对齐滚动条的０点位置y=0，）</li>
	* <li>thumb对象（InteractiveObject）：thumb必须是InteractiveObject的子类，否则不能监听鼠标事件。
	* 上下位置不能超过track显示范围。</li>
	* <li>upBtn对象（InteractiveObject）：(滚动条内不一定要有此按键)在参数面版中指定Up Button Name参数的值，此值为向上按键的按键名(eg:up_btn.name)</li>
	* <li>downBtn对象（InteractiveObject）：(滚动条内不一定要有此按键)在参数面版中指定Down Button Name参数的值，此值为向下按键的按键名(eg:down_btn.name)</li>
	* 
	* <p><b>参数面版：</b><br/>
	* <li>enabledWheel~~：是否能用mouse wheel</li>
	* <li>minSize~~：thumb最小的大小</li>
	* <li>offsetPercent~~：当点击track时，移动的百分比。</li>
	* <li>pageScrollSize~~：当点击track时，移动的距离，如果为０，表示与pageSize定义的一样。</li>
	* <li>pageSize*：决定thumb大小。</li>
	* <li>scaleThumb：是因为pageSize，minValue，maxValue值的改变而改变thumb的值</li>
	* <li>scrollBar：滚动条对象名，直接把组件拖到滚动条上时，组件会吸附在上边，并自动赋值于此。</li>
	* <li>scrollDelay~~：滚动时重复间隔的时间。如按着向上键时，隔多少毫秒再重复一次。也就是相当于连续点击按键。</li>
	* <li>Down Button Name~~：向下按键的名称，如果有向下按键存在的话。</li>
	* <li>Up button Name~~：向上按键的名称，如果有向上按键存在的话。</li>
	* <li>maxValue~~：最大值。</li>
	* <li>minValue~~：最小值。</li>
	* <li>active：是否激活对象。</li>
	* </p>
	* 注：(~~)表示只在Component Inspector面版中出现。Shift+F7
	*/
	public class ScrollBar extends Component {
		private var _scrollTimer:Timer;//自动滚动的Timer类
		private var _scrollBar:DisplayObjectContainer;
		private var _thumb:InteractiveObject;
		private var _track:DisplayObject;
		private var _upBtn:InteractiveObject;
		private var _downBtn:InteractiveObject;
	
		private var _active:Boolean		=	true;

		private var _minValue:Number	=	0;
		private var _maxValue:Number	=	100;
		
		private const _TOP:Number		=	0;
		/**_bottomInit- thumbHieght所得的值,也就是thumb能移到的最底地方*/
		private var _bottom:Number;
		private var _bottomInit:Number;//初始时的最底位置
		private var _thumbHeight:Number;
		/**值=track的高度 - thumb的高度.*/
		private var _length:Number;
		/**当mouse点下时的位移*/
		private var _thumbOffset:Number;
		/**获取或设置页中所包含的行数。*/
		private var _pageSize:Number		=	10;
		/**按track时,应滚动的位置,默认为0表示与pageSize一样大小。*/
		private var _pageScrollSize:Number	=	0;
		/**当按下向上键或向下键时,移动的距离.*/
		private var _pressBtnOffset:Number;
		/**
		 * @private 
		 * 当前按下的对象,有upBtn, downBtn, truck, thumb
		*/
		protected var _pressObj:String;
		
		/**
		 * maxValue-minValue, 两者之间的差值
		 */
		protected var _scrollValue:Number;
		/**
		 * @private 
		 * 当active第一次执行后,_isInit就会变为true
		 */
		protected var _isInit:Boolean			=	false;
		/**
		 * @private 
		 * 在子类中, 如果因其它原因不能显示滚动条, 则把此值定为false, 告诉active不用激活
		*/
		protected var _activeInInit:Boolean		=	true;
		
		
		[Inspectable(defaultValue="0.1", verbose="1", type="Number")]
		/**
		 * 按下向上或向下键时,应移动多少百分比
		 * @default 0.1
		 */
		public var offsetPercent:Number		=	0.1;
		
		[Inspectable(defaultValue="13", verbose="1", type="Number")]
		/**
		 * thumb最小值
		 * @default 0.1
		 */
		public var minSize:Number			=	13;
		
		[Inspectable(defaultValue="false", verbose="0", type="Boolean")]
		/**
		 * thumb是否因为scrollTarget多少而改变大小
		 * @default <code>true</code>
		 */
		public var scaleThumb:Boolean		=	false;

		[Inspectable(defaultValue = "true", verbose = "1", type = "Boolean")]
		/**
		 * 是否能使用mouse wheel
		 * @default <code>true</code>
		 */
		public var mouseWheelEnabled:Boolean	= true;
		
		//************************[READ|WRITE]************************************//
		[Inspectable(defaultValue="", type="String", name="scrollBar")]
		/**@private */
		public function set _targetInstanceName(value:String):void {//scrollTargetName
			if (value.length > 0) {
				var mc:DisplayObjectContainer	=	eval(value) as DisplayObjectContainer;
				if (mc) {
					scrollBar	=	mc;
				}else {
					throw new TypeError("scrollBar is not flash.display.DisplayObjectContainer. type: " + 
								typeof(parent.getChildByName(value)) + ", target: " + value);
				}
			}
		}
		/**
		 * @private
		 * 定义scrollBar属性,此属性只在参数面版中修改
		 */		
		public function get _targetInstanceName():String {//scrollTargetName
			return _scrollBar.name;
		}
		
		public function set scrollBar(value:DisplayObjectContainer):void {
			//if (value.numChildren != 2) {
			//	throw new Error("TWO DisplayObjectContainers only. one is scroll thumb, " +
			//			"another is scroll track. numChildren: " + value.numChildren +
			//			", value: "+value+", valueName: "+value.name);
			//}
			
			var track1:DisplayObject		=	value.getChildAt(0);
			var thumb1:InteractiveObject	=	value.getChildAt(1) as InteractiveObject;
			if (track1.y != 0) {
				throw new Error("TRACK must be on depth 0, and align to top(track.y = 0). | " +
						"current position: track.y= " + track1.y);
			}else if (thumb1.y < 0 || thumb1.y + thumb1.height > track1.height) {
				throw new Error("THUMB did not inside TRACK. | current state: thumb.y= " + thumb1.y +
						", thumb.height= "+thumb1.height+", truck.height= "+track1.height);
			}
			
			this.track	=	track1;
			this.thumb	=	thumb1;
			
			_scrollBar	=	value;
		}
		/**
		 * 定义滚动条对象，必须为DisplayObjectContainer<br/>
		 * track为最底层，且顶点对齐原点<br/>
		 * thumb不能超过trakc的高度.
		 * @throws Error, 当scrollBar不符合所要求的时候。
		 */	
		public function get scrollBar():DisplayObjectContainer {
			return _scrollBar;
		}
		
		[Inspectable(defaultValue="", type="String", verbose="1", name="Up Button Name", category="Button")]
		/**@private */
		public function set upBtnName(value:String):void {
			upBtn	=	_scrollBar.getChildByName(value) as InteractiveObject;
		}
		/**
		 * @private
		 * 此属性只在参数面版中修改
		 */
		public function get upBtnName():String {
			return _upBtn.name;
		}
		
		public function set upBtn(value:InteractiveObject):void {
			if (_upBtn != null) {
				_upBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onUpBtnDown);
			}
			_upBtn	=	value;
		}
		/**向上按键*/
		public function get upBtn():InteractiveObject {
			return _upBtn;
		}
		
		[Inspectable(defaultValue="", type="String", verbose="1", name="Down Button Name", category="Button")]
		/**@private */
		public function set downBtnName(value:String):void {
			downBtn	=	_scrollBar.getChildByName(value) as InteractiveObject;
		}
		/**
		 * @private
		 * 此属性只在参数面版中修改
		 */
		public function get downBtnName():String {
			return _downBtn.name;
		}
		
		public function set downBtn(value:InteractiveObject):void {
			if (_downBtn != null) {
				_downBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onDownBtnDown);
			}
			_downBtn	=	value;
		}
		/**向下按键*/
		public function get downBtn():InteractiveObject {
			return _downBtn;
		}
		
		public function set thumb(value:InteractiveObject):void {
			if (_thumb != null) {
				_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
			}
			_thumb	=	value;
			//当没定义任何值时,thumb不会改变大小.
			updateThumb(percent, 0, _pageSize / _thumb.height * _track.height - _pageSize);
		}
		/**scroll滚动的bar*/
		public function get thumb():InteractiveObject {
			return _thumb;
		}
		
		public function set track(value:DisplayObject):void {
			if (_track != null) {
				_track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackDown);
			}
			_track			=	value;
			_bottomInit		=	value.height;
		}
		/**scroll背景的track*/
		public function get track():DisplayObject {
			return _track;
		}
		
		[Inspectable(defaultValue="10", verbose="1", type="Number")]
		public function set pageSize(value:Number):void {
			if (value <= 0)	return;//不能小于等于0
			_pageSize	=	value;
			if (_thumb == null)	return;
			updateThumb(percent);
		}
		
		public function get pageSize():Number {
			return _pageSize;
		}
		[Inspectable(defaultValue="0", verbose="1", type="Number")]
		public function set pageScrollSize(value:Number):void {
			if (value < 0)	return;//不能小于0
			_pageScrollSize	=	value==0 ? _pageSize : value;
		}
		
		public function get pageScrollSize():Number {
			return _pageScrollSize==0 ? _pageSize : _pageScrollSize;
		}
		
		public function set percent(value:Number):void {
			value		=	Math.max(0, Math.min(1, value));
			_thumb.y	=	_length * value + _TOP;
			renderScrollTarget();//empty function
		}
		/**thumb在track的位置,百分比表示0<=percent<=1*/
		public function get percent():Number {
			var p:Number	=	(_thumb.y - _TOP) / _length;
			if (isNaN(p)) {//if you set mc.y=NaN, i would not be changed in fp9, but it would be change Number.MIN, so
				return 0;
			}else{
				return p;
			}
		}

		public function set curValue(value:Number):void {
			if (_scrollValue == 0)	return;
			percent	=	(value - minValue) / _scrollValue;
		}
		/**根据当前thumb的位置,及最小值与最大值来决定当前值是多少*/
		public function get curValue():Number {
			return percent * _scrollValue + minValue;
		}
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="value")]
		public function set minValue(value:Number):void {
			//if (value == _maxValue)	return;
			_minValue	=	value;
			_scrollValue	=	_maxValue - value;
			if (!_isInit)	return;
			if (_scrollValue == 0) {
				active	=	false;
			}else {
				active	=	true;
			}
		}
		/**最小值*/
		public function get minValue():Number {
			return _minValue;
		}

		[Inspectable(defaultValue="100", verbose="1", type="Number", category="value")]
		public function set maxValue(value:Number):void {
			//if (value == _minValue)	return;
			_maxValue	=	value;
			_scrollValue	=	value - _minValue;
			if (!_isInit)	return;
			if (_scrollValue == 0) {
				active	=	false;
			}else {
				active	=	true;
			}
		}
		/**最大值*/
		public function get maxValue():Number {
			return _maxValue;
		}
		
		[Inspectable(defaultValue = "100", verbose = "1", type = "uint")]
		public function set scrollDelay(value:uint):void {
			if(value>0){
				_scrollTimer.delay	=	value;
			}
		}
		/**自动滚动thumb时移动的值,如每scrollDelay时刷一移动单位,在点击track与up_btn,down_btn时*/
		public function get scrollDelay():uint {
			return _scrollTimer.delay;
		}
		
		[Inspectable(defaultValue="true", verbose="0", type="Boolean", category="Z")]
		public function set active(value:Boolean):void {
			var isAcitve:Boolean	=	false;
			//trace("active| isInit= "+_isInit, "obj: "+this.name, "value: "+value, "oldValue: "+_active);
			if(_isInit){//已经初始化了
				if (_active == value ) return;//如果值没有改变,不要执行以下代码
				if (value) {
					isAcitve	=	true;
				}
			}else {//第一次初始化
				_isInit	=	true;
				if (value) {
					if(_activeInInit){
						isAcitve	=	true;
					}
				}
				//trace("active| isInit= "+value);
			}
			//trace("active| isActive: "+isAcitve);
			if (isAcitve) { 
				_thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDown, false, 0, true);
				_track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackDown, false, 0, true);
				if (_upBtn != null) {
					_upBtn.addEventListener(MouseEvent.MOUSE_DOWN, onUpBtnDown, false, 0, true);
				}
				if (_downBtn != null) {
					_downBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDownBtnDown, false, 0, true);
				}
				updateThumb(percent);
			}else {
				_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
				_track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackDown);
				if (_upBtn != null) {
					_upBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onUpBtnDown);
				}
				if (_downBtn != null) {
					_downBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onDownBtnDown);
				}
				value	=	false;
			}
			setMouseWheel(value && mouseWheelEnabled);
			_active				=
			_scrollBar.visible	=	isAcitve;
			//当scroll对象被激活时,广播此事件
			dispatchEvent(new Event(ScrollEvent.ACTIVE_SCROLL));
		}
		/**滚动条是否可用*/
		public function get active():Boolean {
			return _active=(_scrollBar==null ? false : _scrollBar.visible);
		}
		//************************[READ ONLY]*************************************//
		
		/**
		 * 构建函数.
		 * 并不需要<code>new ScrollDisplayObject()</code>来构造对象，
		 * 只需要从库中拖到滚动条上既可。
		 */
		public function ScrollBar(){
			getChildAt(0).visible	=	false;
			_scrollTimer	=	new Timer(100, 0);
			_scrollTimer.addEventListener(TimerEvent.TIMER, onScrollTimer);
		}
		
		//************************[PRIVATE METHOD]********************************//
		private function onScrollTimer(evt:TimerEvent):void {
			//trace("onScrollTimer: ",_pressObj);
			switch(_pressObj) {
				case "up":
					if (!moveThumbByClickUpBtn(-1)) {//没空间可移动了,停止.
						_scrollTimer.stop();
					}
					break;
				case "down":
					if (!moveThumbByClickDownBtn(1)) {//没空间可移动了,停止.
						_scrollTimer.stop();
					}
					break;
				case "track":
					if (!moveThumbByClickTrack()) {//没空间可移动了,停止.
						_scrollTimer.stop();
					}
					break;
				//case "thumb":
					
					//break;
				default:
					_scrollTimer.stop();
			}
			
		}
		
		/**
		 * 当点击truck时,移动thumb,直到mouse的位置,
		 * 
		 * @return 还能移动,返回true,否则返回false
		 */
		private function moveThumbByClickTrack():Boolean {
			var mousePos:Number		=	_scrollBar.mouseY - _thumb.y;
			var scrollPos:Number	=	Math.min(pageScrollSize, Math.abs(mousePos));
			//trace(scrollPos, _scrollBar.mouseY, mousePos);
			
			var pos:Number;
			var canMove:Boolean;
			if (mousePos<0) {//在thumb上方
				if (-mousePos < _thumb.height) {
					pos	=	_track.mouseY;
				}else {//还有空间
					pos	=	_thumb.y - scrollPos;
					canMove	=	true;
				}
			} else if(mousePos>_thumb.height){//在thumb下方
				if (mousePos < _thumb.height*2) {
					pos	=	_track.mouseY - _thumb.height;
				}else {//还有空间
					pos	=	_thumb.y + scrollPos;
					canMove	=	true;
				}
			}else {//在thumb之间,中止.
				return	false;
			}
			var oldPos:Number	=	_thumb.y;// for delta value
			if (pos <= _TOP) {//不能超过最顶与最下方的边界.
				_thumb.y	=	_TOP;
				canMove		=	false;	
			}else if (pos >= _bottom) {
				_thumb.y	=	_bottom;
				canMove		=	false;
			}else {
				_thumb.y	=	pos;
			}
			
			dispatchEvent(new ScrollEvent( oldPos - _thumb.y));
			return canMove;
		}
		
		
		
		//************************[PROTECTED METHOD]******************************//
		
		/**
		 * 当按下向上按键时，根据num的倍数来移动thumb。
		 * @param	num num 移动offsetPercent的倍数
		 * @return 如果还可以移动，返回<code>true</code>,否则返回<code>false</code>
		 */
		protected function moveThumbByClickUpBtn(num:int=1):Boolean {//在ScrollTextField中会被override
			var canMove:Boolean	=	true;
			var oldPos:Number	=	_thumb.y;
			var pos:Number		=	oldPos + _pressBtnOffset * num;
			
			if (pos <= _TOP) {//不能超过最顶与最下方的边界.
				_thumb.y	=	_TOP;
				canMove		=	false;
			}else {
				_thumb.y	=	pos;
			}
			//trace(canMove,oldPos,_pressBtnOffset);
			dispatchEvent(new ScrollEvent( oldPos - _thumb.y));
			return canMove;
		}
		/**
		 * 当按下向下按键时，根据num的倍数来移动thumb。
		 * @param	num num 移动offsetPercent的倍数
		 * @return 如果还可以移动，返回<code>true</code>,否则返回<code>false</code>
		 */
		protected function moveThumbByClickDownBtn(num:int=1):Boolean {
			var canMove:Boolean	=	true;
			var oldPos:Number	=	_thumb.y;
			var pos:Number		=	oldPos + _pressBtnOffset * num;
			
			if (pos >= _bottom) {//不能超过最顶与最下方的边界.
				_thumb.y	=	_bottom;
				canMove		=	false;	
			}else {
				_thumb.y	=	pos;
			}
			//trace(canMove,oldPos,_pressBtnOffset);
			dispatchEvent(new ScrollEvent( pos - _thumb.y));
			return canMove;
		}
		/**
		 * 当按下thumb时
		 * @param	evt
		 */
		protected function onThumbDown(evt:MouseEvent):void {
			evt.stopImmediatePropagation();//??有无效果?
			_thumbOffset	=	mouseY - _thumb.y;//拖动时,mouse点击的Y轴位置
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			_pressObj	=	"thumb";
			dispatchEvent(new MouseEvent(ScrollEvent.PRESS_THUMB, true, false, evt.localX, evt.localY, evt.relatedObject));
		}
		/**
		 * 当移动thumb时
		 * @param	evt
		 */
		protected function onThumbMove(evt:MouseEvent):void {
			var pos:Number	=	Math.max(_TOP, Math.min(_bottom, mouseY - _thumbOffset));
			
			var delta:Number	=	pos - _thumb.y;
			_thumb.y		=	pos;
			if (delta != 0) {
				//trace(new ScrollEvent( delta, percent));
				dispatchEvent(new ScrollEvent( delta));
			}
		}
		/**
		 * 当放开thumb时
		 * @param	evt
		 */
		protected function onThumbUp(evt:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			//isDrag	=	false;
			_pressObj	=	null;
			dispatchEvent(new MouseEvent(ScrollEvent.RELEASE_THUMB, true, false, evt.localX, evt.localY, evt.relatedObject));
		}
		/**
		 * 当按下track时
		 * @param	evt
		 */
		protected function onTrackDown(evt:MouseEvent):void {
			evt.stopImmediatePropagation();
			stage.addEventListener(MouseEvent.MOUSE_UP, onTrackUp);
			if (moveThumbByClickTrack()) {
				_scrollTimer.start();
			}else {
				//_scrollTimer.stop();
			}
			_pressObj	=	"track";
		}
		/**
		 * 当放开track时
		 * @param	evt
		 */
		protected function onTrackUp(evt:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onTrackUp);
			_scrollTimer.stop();
			_pressObj	=	null;
		}
		
		/**
		 * @private
		 * 当按下向上按键时。
		 * @param	evt
		 */
		protected function onUpBtnDown(evt:MouseEvent):void {
			evt.stopImmediatePropagation();
			moveThumbByClickUpBtn( -1);
			_scrollTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onUpBtnUp);
			_pressObj	=	"up";
		}
		/**
		 * @private
		 * 当放开向上按键时。
		 * @param	evt
		 */
		protected function onUpBtnUp(evt:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUpBtnUp);
			_scrollTimer.stop();
			_pressObj	=	null;
		}
		
		/**
		 * @private
		 * 当按下向上按键时。
		 * @param	evt
		 */
		protected function onDownBtnDown(evt:MouseEvent):void {
			evt.stopImmediatePropagation();
			moveThumbByClickDownBtn(1);
			_scrollTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onDownBtnUp);
			_pressObj	=	"down";
		}
		/**
		 * @private
		 * 当放开向上按键时。
		 * @param	evt
		 */
		protected function onDownBtnUp(evt:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDownBtnUp);
			_scrollTimer.stop();
			_pressObj	=	null;
		}
		/**
		 * @private
		 * 当mouse wheel时。
		 * @param	evt
		 */
		protected function onMouseWheel(evt:MouseEvent):void {
			if (evt.delta > 0) {
				moveThumbByClickUpBtn(-1);
			}else {
				moveThumbByClickDownBtn(1);
			}
		}
		/**
		 * 更新thumb条
		 * @param	percentNum
		 * @param	minPos
		 * @param	maxPos
		 * @return 暂时无用
		 */
		protected function updateThumb(percentNum:Number, minPos:Number = NaN, maxPos:Number = NaN):Boolean {
			if(scaleThumb){
				minPos	=	isNaN(minPos) ? minValue : minPos;//default value
				maxPos	=	isNaN(maxPos) ? maxValue : maxPos;//default value
				var per:Number	=	maxPos - minPos + _pageSize;
				var pSizePer:Number	=	_pageSize / per;
				//trace("pSizePer: "+pSizePer,"per: "+per, "maxPos: "+maxPos, "minPos: "+minPos);
				if (pSizePer >= 1) {//不能超过track的高
					_thumbHeight	=	_track.height;
					percent			=	0;
					return		false;
				}
				_thumbHeight	=	 Math.max(minSize, pSizePer * _track.height);
			}else {
				_thumb.scaleY	=	1;
				_thumbHeight	=	_thumb.height;
			}
			_bottom			=	_bottomInit - _thumbHeight;
			_length			=	_bottom - _TOP;
			_thumb.height	=	_thumbHeight;
			_pressBtnOffset	=	_length * offsetPercent;//当按下向上或向下按键时,移动的位置
			//percent			=	percentNum;//重新定位百分比位置.
			_thumb.y		=	_length * percentNum + _TOP;
			//trace(minPos, maxPos);
			return true;
		}
		/**
		 * 当通过改变percent属性值时，将会触发此函数。
		 * <p>在此类中为空的函数。</p>
		 * <p>在子类ScrollTextField与ScrollDisplayObject中会被覆盖掉。</p>
		 * @see #percent
		 */
		protected function renderScrollTarget():void {
			//empty. must be override in subClass.
		}
		
		//***********************[PUBLIC METHOD]**********************************//
		/**
		 * 定义滚动条属性，这些定义会更改滚动打thumb的大小。
		 * 
		 * @param  pSize  page size
		 * @param  minPos  min position
		 * @param  maxPos  max position
		 * @param  pScrollSize  scroll size when click track
		 */
		public function setScrollProperties(pSize:Number, minPos:Number, maxPos:Number, pScrollSize:Number=0):void {
			_pageSize		=	pSize;
			minValue		=	minPos;
			maxValue		=	maxPos;
			pageScrollSize	=	pScrollSize;
			updateThumb(percent, minPos, maxPos);
		}
		/**
		 * 定义mouse wheel是否可用。
		 * <p>当mouse移到滚动条上方时，或监听的对象上方时，滚动wheel会激活监听的滚动事件。</p>
		 * @param enabled enabled如果是<code>true</code>,则mouse wheel可用。否则不可用。
		 */
		public function setMouseWheel(enabled:Boolean):void {
			if (enabled) {
				_scrollBar.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			}else {
				_scrollBar.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			}
		}
		//***********************[STATIC METHOD]**********************************//
		
		
	}
}

/*
  ---------------------------------------------
*/
