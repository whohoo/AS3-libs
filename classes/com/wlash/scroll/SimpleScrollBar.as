//******************************************************************************
//	name:	SimpleScrollBar 1.1
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-1-21 17:52
//	description: 重新改写ScrollBar类,去掉不常用的upbtn与downbtn
// 				v1.1,增加了destroy方法，当从场景去除去时，自动执行destroy方法
//******************************************************************************


package com.wlash.scroll {
	
	import com.wlash.frameset.Component;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;

	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * 当滑动thumb，广播的事件。
	 * @eventType flash.events.Event
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	[Event(name = "scroll", type = "flash.events.Event")]
	
	/**
	 * 当滚动条激活时，广播的事件。
	 * @eventType flash.events.Event
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	[Event(name = "activeScroll", type = "flash.events.Event")]
	
	[IconFile("SimpleScrollBar.png")]
	/**
	* SimpleScrollBar 简单滚动条组件.
	* 
	* <p>把组件拖到定义好的滚动条对象上,滚动条对象要求是DisplayObjectContainer的子类,
	* 并且只有两个可显示对象(DisplayObject)或四个可显示对象（一个向上滚动按键，一是向下按键）。</p>
	* <li>track对象（DisplayObject）：也就是滚动条对象的背景,如果track对象为InteractiveObject类或其子类，
	* 则track可监听点击滑动thumb事件。（必须存在滚动条的最底层，且顶点需对齐滚动条的０点位置y=0，）</li>
	* <li>thumb对象（InteractiveObject）：thumb必须是InteractiveObject的子类，否则不能监听鼠标事件。
	* 上下位置不能超过track显示范围。</li>
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
	* <li>maxValue~~：最大值。</li>
	* <li>minValue~~：最小值。</li>
	* <li>active：是否激活对象。</li>
	* </p>
	* 注：(~~)表示只在Component Inspector面版中出现。Shift+F7
	*/
	public class SimpleScrollBar extends Component {
		private var _scrollTimer:Timer;//自动滚动的Timer类
		private var _scrollBar:DisplayObjectContainer;
		private var _thumb:InteractiveObject;
		private var _track:DisplayObject;
	
		protected var _active:Boolean		=	true;

		protected var _minValue:Number	=	0;
		protected var _maxValue:Number	=	100;
		protected var _enabledMouseWheel:Boolean;
		
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
		/**滚动thumb的值,正负值表示移动的方向*/
		protected var _delta:Number;
		/**
		 * @private 
		 * 当前按下的对象,有upBtn, downBtn, truck, thumb
		*/
		protected var _pressObj:String;
		
		/**maxValue-minValue, 两者之间的差值 */
		protected var _scrollValue:Number;
		/**
		 * @private 
		 * 当active第一次执行后,_isInit就会变为true
		 */
		protected var _isInit:Boolean			=	false;
		///**
		 //* @private 
		 //* 在子类中, 如果因其它原因不能显示滚动条, 则把此值定为false, 告诉active不用激活
		 //*/
		//protected var _activeInInit:Boolean		=	true;
		
		[Inspectable(defaultValue="false", verbose="1", type="Boolean")]
		/**
		 * 当不激活状态时，滚动条是否可见,<p/>
		 * true为当不激活状态时可见，<p/>
		 * false为当不激活状态时不可见<p/>
		 * @default false
		 */
		public var inactiveVisible:Boolean		=	false;
		
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
			return _scrollBar==null ? "" : _scrollBar.name;
		}
		
		/**@private */
		public function set scrollBar(value:DisplayObjectContainer):void {
			if (_scrollBar) {
				_setActive(false);
			}
			if (!value)	return;
			
			var track1:DisplayObject		=	value.getChildAt(0);
			var thumb1:InteractiveObject	=	value.getChildAt(1) as InteractiveObject;
			if (track1.y != 0) {
				_scrollBar	=	null;
				throw new Error("TRACK must be on depth 0, and align to top(track.y = 0). | " +
						"current position: track.y= " + track1.y);
			}else if (thumb1.y < 0 || thumb1.y + thumb1.height > track1.height) {
				_scrollBar	=	null;
				throw new Error("THUMB did not inside TRACK. | current state: thumb.y= " + thumb1.y +
						", thumb.height= "+thumb1.height+", truck.height= "+track1.height);
			}
			
			this.track	=	track1;
			this.thumb	=	thumb1;
			
			_scrollBar	=	value;
			if (!_isInit)	return;
			_setActive(_active);
			scrollBarVisible	=	_active;
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
		
		/**@private */
		public function set thumb(value:InteractiveObject):void {
			if (_thumb) {
				_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
			}
			_thumb	=	value;
			//if (!_isInit)	return;
			//当没定义任何值时,thumb不会改变大小.
			//updateThumb(percent, 0, _pageSize / _thumb.height * _track.height - _pageSize);
		}
		/**scroll滚动的bar*/
		public function get thumb():InteractiveObject {
			return _thumb;
		}
		
		/**@private */
		public function set track(value:DisplayObject):void {
			if (_track) {
				_track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackDown);
			}
			_track			=	value;
			_bottomInit		=	value.height;
			//if (!_isInit)	return;
			//当没定义任何值时,thumb不会改变大小.
			//updateThumb(percent, 0, _pageSize / _thumb.height * _track.height - _pageSize);
		}
		/**scroll背景的track*/
		public function get track():DisplayObject {
			return _track;
		}
		
		[Inspectable(defaultValue="10", verbose="1", type="Number")]
		/**@private */
		public function set pageSize(value:Number):void {
			if (value <= 0)	return;//不能小于等于0
			_pageSize	=	value;
			if (!_isInit)	return;
			if (_thumb)	updateThumb(percent);
		}
		/**
		 * scroll page size
		 * @default 10
		 */
		public function get pageSize():Number {
			return _pageSize;
		}
		
		[Inspectable(defaultValue = "0", verbose = "1", type = "Number")]
		/**@private */
		public function set pageScrollSize(value:Number):void {
			if (value < 0)	return;//不能小于0
			_pageScrollSize	=	value==0 ? _pageSize : value;
		}
		/**
		 * scroll page scroll size
		 * @default 0
		 */
		public function get pageScrollSize():Number {
			return _pageScrollSize==0 ? _pageSize : _pageScrollSize;
		}
		
		/**@private */
		public function set percent(value:Number):void {
			setPercent(value);
			renderScrollTarget();//empty function
		}
		/**thumb在track的位置,百分比表示0<=percent<=1*/
		public function get percent():Number {
			var p:Number	=	(_thumb.y - _TOP) / _length;
			if (isNaN(p)) {//if you set mc.y=NaN, it would not be changed in fp9, but it would be change Number.MIN, so
				return 0;
			}else{
				return p;
			}
		}

		/**@private */
		public function set curValue(value:Number):void {
			if (_scrollValue == 0)	return;
			percent	=	(value - minValue) / _scrollValue;
		}
		/**根据当前thumb的位置,及最小值与最大值来决定当前值是多少*/
		public function get curValue():Number {
			return percent * _scrollValue + minValue;
		}
		
		[Inspectable(defaultValue = "0", verbose = "1", type = "Number", category = "value")]
		/**@private */
		public function set minValue(value:Number):void {
			//if (value == _maxValue)	return;
			_minValue	=	value;
			_scrollValue	=	_maxValue - value;
			if (!_isInit)	return;
			updateThumb(percent);
		}
		/**最小值*/
		public function get minValue():Number {
			return _minValue;
		}

		[Inspectable(defaultValue = "100", verbose = "1", type = "Number", category = "value")]
		/**@private */
		public function set maxValue(value:Number):void {
			//if (value == _minValue)	return;
			_maxValue	=	value;
			_scrollValue	=	value - _minValue;
			if (!_isInit)	return;
			updateThumb(percent);
		}
		/**最大值*/
		public function get maxValue():Number {
			return _maxValue;
		}
		
		[Inspectable(defaultValue = "100", verbose = "1", type = "uint")]
		/**@private */
		public function set scrollDelay(value:uint):void {
			if(value>0){
				_scrollTimer.delay	=	value;
			}
		}
		/**自动滚动thumb时移动的值,如每scrollDelay时刷一移动单位,在点击track与up_btn,down_btn时*/
		public function get scrollDelay():uint {
			return _scrollTimer.delay;
		}
		
		[Inspectable(defaultValue = "true", verbose = "0", type = "Boolean", category = "Z")]
		/**@private */
		public function set active(value:Boolean):void {
			if (_scrollBar) {
				_setActive(value);
				
			}else {
				
			}
			_isInit	=	true;
			_active				=	value;
			
			
			
			
			/*var isAcitve:Boolean	=	false;
			//trace("active| isInit= "+_isInit, "obj: "+this.name, "value: "+value, "oldValue: "+_active);
			if(_isInit){//已经初始化了
				if (_active == value ) return;//如果值没有改变,不要执行以下代码
			}else {//第一次初始化
				_isInit		=	true;
			}
			isAcitve	=	value;
			
			//trace("active| isActive: "+isReadyScroll);
			if (!isReadyScroll) {
				scrollBarVisible	=	
				_active				=	false;
				return;
			}
			
			if (isAcitve) {
				_thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDown, false, 0, true);
				_track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackDown, false, 0, true);
				_scrollTimer.addEventListener(TimerEvent.TIMER, onScrollTimer);
				updateThumb(percent);
			}else {
				_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
				_track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackDown);
				_scrollTimer.removeEventListener(TimerEvent.TIMER, onScrollTimer);
				_scrollTimer.stop();
			}
			
			setMouseWheel(isAcitve && mouseWheelEnabled);
			scrollBarVisible	=	
			_active				=	isAcitve;
			
			//当scroll对象被激活时,广播此事件
			dispatchEvent(new Event(ACTIVE_SCROLL));*/
		}
		/**滚动条是否可用*/
		public function get active():Boolean {
			return _active;//=(_scrollBar==null ? false : _scrollBar.visible)
		}
		
		/**@private */
		protected function set scrollBarVisible(value:Boolean):void {
			if (_scrollBar) {
				if(value){
					setScrollBarVisible(true);
				}else {
					setScrollBarVisible(false);
				}
			}
		}
		//************************[READ ONLY]*************************************//
		/**滚动thumb的值,正负值表示移动的方向,正值表示向下,负值表示向上*/
		public function get delta():Number { return _delta; }
		/**是否可以滚动,如果滚动条存在,则应可以滚动*/
		protected function get isReadyScroll():Boolean { return Boolean(_scrollBar)};
		
		//************************[STATIC PROPERTIES]*****************************//
		/**
         * 定义<code>scroll</code>滑动thumb时产生的<code>type</code>事件.
         * @eventType scroll
         */
		public static const SCROLL:String			=	"scroll";
		
		/**
         * 定义<code>activeScroll</code>激活滚动条时产生的<code>type</code>事件。
         * @eventType activeScroll
         */
		public static const ACTIVE_SCROLL:String	=	"activeScroll";
		
		
		/**
		 * 构建函数.<p/>
		 * 并不需要<code>new ScrollDisplayObject()</code>来构造对象，
		 * 只需要从库中拖到滚动条上既可。
		 */
		public function SimpleScrollBar(){
			getChildAt(0).visible	=	false;
			_scrollTimer	=	new Timer(100, 0);
			_scrollTimer.addEventListener(TimerEvent.TIMER, onScrollTimer);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemoveStage);
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
			_enabledMouseWheel	=	enabled;
		}
		
		/**
		 * 当按下向上按键时，根据num的倍数来移动thumb。
		 * @param	num num 移动offsetPercent的倍数
		 * @return 如果还可以移动，返回<code>true</code>,否则返回<code>false</code>
		 */
		public function moveThumbUp(num:int=-1):Boolean {//在ScrollTextField中会被override
			var canMove:Boolean	=	true;
			var oldPos:Number	=	_thumb.y;
			var pos:Number		=	oldPos + _pressBtnOffset * num;
			
			if (pos <= _TOP) {//不能超过最顶与最下方的边界.
				_thumb.y	=	_TOP;
				canMove		=	false;
			}else {
				_thumb.y	=	pos;
			}
			
			//_delta	=	oldPos - thumb.y;
			dispatchScrollEvent(oldPos);
			return canMove;
		}
		
		/**
		 * 当按下向下按键时，根据num的倍数来移动thumb。
		 * @param	num num 移动offsetPercent的倍数
		 * @return 如果还可以移动，返回<code>true</code>,否则返回<code>false</code>
		 */
		public function moveThumbDown(num:int=1):Boolean {
			var canMove:Boolean	=	true;
			var oldPos:Number	=	_thumb.y;
			var pos:Number		=	oldPos + _pressBtnOffset * num;
			
			if (pos >= _bottom) {//不能超过最顶与最下方的边界.
				_thumb.y	=	_bottom;
				canMove		=	false;	
			}else {
				_thumb.y	=	pos;
			}
			
			//_delta	=	oldPos - thumb.y;
			dispatchScrollEvent(oldPos);
			return canMove;
		}
		
		/**
		 * 除去注册的事件
		 */
		public function destroy():void {
			if(_scrollBar){
				_scrollBar.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
				_track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackDown);
			}
			
			_scrollTimer.removeEventListener(TimerEvent.TIMER, onScrollTimer);
			
			if(stage){
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onTrackUp);
			}
		}
		
		/**
		 * 如果滚动条的大小有变化，则应调用render重新计算滚动位置
		 * @param	value
		 */
		public function render(value:Number = NaN):void {
			_bottomInit		=	_track.height;
			updateThumb(isNaN(value) ? percent : value);
		}
		//************************[INTERNAL METHOD]******************************//
		
		
		
		//************************[PROTECTED METHOD]******************************//
		protected function setPercent(value:Number):void {
			value		=	value > 1 ? 1 : (value < 0 ? 0 : value);
			_thumb.y	=	_length * value + _TOP;
		}
		
		protected function _setActive(value:Boolean):void {
			if (value) {
				_thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDown, false, 0, true);
				_track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackDown, false, 0, true);
				_scrollTimer.addEventListener(TimerEvent.TIMER, onScrollTimer);
				updateThumb(percent);
			}else {
				_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
				_track.removeEventListener(MouseEvent.MOUSE_DOWN, onTrackDown);
				_scrollTimer.removeEventListener(TimerEvent.TIMER, onScrollTimer);
				_scrollTimer.stop();
			}
			setMouseWheel(value && mouseWheelEnabled);
			scrollBarVisible	=	value;
			if(_isInit)
				dispatchEvent(new Event(ACTIVE_SCROLL));
		}
		
		protected function dispatchScrollEvent(oldPos:Number):void {
			_delta	=	oldPos - _thumb.y;
			if(_delta!=0){
				dispatchEvent(new Event(SCROLL));
			}
		}
		
		/**
		 * 当按下thumb时
		 * @param	evt
		 */
		protected function onThumbDown(evt:MouseEvent):void {
			//evt.stopImmediatePropagation();//??有无效果?
			_thumbOffset	=	mouseY - _thumb.y;//拖动时,mouse点击的Y轴位置
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onThumbMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
			_pressObj	=	"thumb";
		}
		
		/**
		 * 当移动thumb时
		 * @param	evt
		 */
		protected function onThumbMove(evt:MouseEvent):void {
			var pos:Number	=	mouseY - _thumbOffset;
			pos				=	pos < _TOP ? _TOP : (pos > _bottom ? _bottom : pos);
			var oldPos:Number	=	_thumb.y;
			_thumb.y		=	pos;
			dispatchScrollEvent(oldPos);
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
		 * 当mouse wheel时。
		 * @param	evt
		 */
		protected function onMouseWheel(evt:MouseEvent):void {
			if (evt.delta > 0) {
				moveThumbUp(-1);
			}else {
				moveThumbDown(1);
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
			//trace( "SimpleScrollBar.updateThumb > percentNum : " + percentNum + ", minPos : " + minPos + ", maxPos : " + maxPos );
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
				//_thumbHeight	=	Math.max(minSize, pSizePer * _track.height);
				_thumbHeight	=	pSizePer * _track.height;
				_thumb.height	=	
				_thumbHeight	=	Math.round(_thumbHeight < minSize ? minSize : _thumbHeight);
			}else {
				_thumb.scaleY	=	1;
				_thumbHeight	=	_thumb.height;
			}
			
			_bottom			=	_bottomInit - _thumbHeight;
			_length			=	_bottom - _TOP;
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
			//empty. must be override in subclass.
		}
		
		/**
		 * 如果当滚动条不可用时，滚动条track可见。
		 * @param value 如果false,滚动条不可用，
		 */
		protected function setScrollBarVisible(value:Boolean):void {
			if (value) {
				_scrollBar.visible	=	true;
				_thumb.visible		=	true;
				if (_track is InteractiveObject) {
					InteractiveObject(_track).mouseEnabled	=	true;
				}
			}else{
				if (inactiveVisible) {
					_scrollBar.visible	=	true;
					_thumb.visible		=	false;
					if (_track is InteractiveObject) {
						InteractiveObject(_track).mouseEnabled	=	false;
					}
				}else{
					_scrollBar.visible	=	false;
				}
			}
		}
		//************************[PRIVATE METHOD]********************************//
		private function onScrollTimer(evt:TimerEvent):void {
			//trace("onScrollTimer: ",_pressObj);
			switch(_pressObj) {
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
			//var scrollPos:Number	=	Math.min(pageScrollSize, Math.abs(mousePos));
			var scrollPos:Number	=	Math.abs(mousePos);
			scrollPos				=	scrollPos > pageScrollSize ? pageScrollSize : scrollPos;
			//trace(scrollPos, _scrollBar.mouseY, mousePos);
			
			var pos:Number;
			var canMove:Boolean;
			if (mousePos<0) {//在thumb上方
				if (-mousePos < _thumb.height) {
					pos	=	_scrollBar.mouseY - _thumb.height * .5;
				}else {//还有空间
					pos	=	_thumb.y - scrollPos;
					canMove	=	true;
				}
			} else if(mousePos>_thumb.height){//在thumb下方
				if (mousePos < _thumb.height * 2) { 
					pos	=	_scrollBar.mouseY - _thumb.height * .5;
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
			//_delta	=	oldPos - _thumb.y;
			dispatchScrollEvent(oldPos);
			return canMove;
		}
		
		private function _onRemoveStage(e:Event):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemoveStage);
			destroy();
		}
		//***********************[STATIC METHOD]**********************************//
		
		
	}
}

/*
  ---------------------------------------------
*/
