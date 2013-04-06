//********************************************
//	class:	FlipPagesBox 1.0
// 	author:	whohoo
// 	email:	whohoo@21cn var com
// 	date:	2008/7/22 10:50
//	description:	把原来改为AS2后的代码转为AS3
//********************************************

package com.wlash.effects {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.display.Graphics;
	
	/**
	 * if rear page remove, isRearPage would be true, or it is null.
	 * @eventType com.wlash.effects.FlipPagesEvent
	 */
	[Event(name = "onRemovePage", type = "com.wlash.effects.FlipPagesEvent")]
	/**
	 * if rear page create, isRearPage would be true, or it is null
	 * @eventType com.wlash.effects.FlipPagesEvent
	 */
	[Event(name = "onCreatePage", type = "com.wlash.effects.FlipPagesEvent")]
	/**
	 * adjust the page when according to its position,
	 * @eventType com.wlash.effects.FlipPagesEvent
	 */
	[Event(name = "onAdjustPage", type = "com.wlash.effects.FlipPagesEvent")]
	/**
	 * when set flip area.
	 * @eventType com.wlash.effects.FlipPagesEvent
	 */
	[Event(name = "onSetFlipArea", type = "com.wlash.effects.FlipPagesEvent")]
	/**
	 * when resize page.
	 * @eventType com.wlash.effects.FlipPagesEvent
	 */
	[Event(name = "onResizePage", type = "com.wlash.effects.FlipPagesEvent")]
	/**
	 * when press flip area.
	 * @eventType com.wlash.effects.FlipPagesEvent
	 */
	[Event(name = "onPressFlip", type = "com.wlash.effects.FlipPagesEvent")]
	/**
	 * when release flip area. flip2Face is true if flip the page to other side, or not.
	 * @eventType com.wlash.effects.FlipPagesEvent
	 */
	[Event(name = "onReleaseFlip", type = "com.wlash.effects.FlipPagesEvent")]
	/**
	 * when start fliping.
	 * @eventType com.wlash.effects.FlipPagesEvent
	 */
	[Event(name = "onStartFlip", type = "com.wlash.effects.FlipPagesEvent")]
	/**
	 * when stop fliping.  flip2Face is true if flip the page to other side, or not.
	 * @eventType com.wlash.effects.FlipPagesEvent
	 */
	[Event(name = "onStopFlip", type = "com.wlash.effects.FlipPagesEvent")]
	/**
	 * after finish fliping.  flip2Face is true if flip the page to other side, or not.
	 * @eventType com.wlash.effects.FlipPagesEvent
	 */
	[Event(name = "onFinishFlip", type = "com.wlash.effects.FlipPagesEvent")]
	/**
	 * when moving page.
	 * @eventType com.wlash.effects.FlipPagesEvent
	 */
	[Event(name = "onMovePage", type = "com.wlash.effects.FlipPagesEvent")]
	/**
	 * when draging page.
	 * @eventType com.wlash.effects.FlipPagesEvent
	 */
	[Event(name = "onDragPage", type = "com.wlash.effects.FlipPagesEvent")]
	
	
	[IconFile("FlipPagesBox.png")]
	/**
	* component for FlipPagesBox.
	* <p></p>
	* you could drag FlipPagesBox from component panel(Ctrl+F7) in flash to stage<br></br>
	* and define properties in Parameters panel(Alt+F7).<br></br>
	* <b>Parameters:</b>
	* <ul>
	* <li><b>active:</b> if true the flip page would active, or not. default is true</li>
	* <li><b>adjustEventPage:</b> if true the flip page would event page, default is false.</li>
	* <li><b>autoPage:</b> if true the flip page would automatically go to the definite frame, default is true</li>
	* <li><b>multiFlip:</b> if true the flip page would allow few flip page fliping. default is false.</li>
	* <li><b>pageId:</b> a identifier of movieclip linkage.</li>
	* <li><b>showRearPage:</b> is show rear page?</li>
	* <li><b>visiblePages:</b> number of visible pages ?</li>
	* <li><b>curPage:</b> a number of current page.</li>
	* <li><b>firstPage:</b> a number of first page.</li>
	* <li><b>lastPage:</b> a number of first page.</li>
	* <li><b>dragAccRatio:</b> drag page ratio of acceleration.</li>
	* <li><b>moveAccRatio:</b> move page ratio of acceleration.</li>
	* </ul>
	* <p></p>
	*/
	public class FlipPagesBox extends Sprite {
		
		/**postion precision when fliping*/
		public	const POS_PRECISION:Number		= 0.5;	//精确度
		
		private var _pageWidth:Number;		//pageWidth
		private var _pageHeight:Number;		//pageHeight
		private var _pageId:String			= "";		//pageId
		private var _adjustEvenPage:Boolean	= true;		//adjustEvenPage
		private var _autoPage:Boolean		= true;		//autoPage
		private var _firstPage:uint			= 0;		//firstPage
		private var _lastPage:uint			= 0;		//lastPage
		private var _curPage:uint			= 0;		//curPage
		private var _visiblePages:uint		= 1;		//visiblePages
		private var _showRearPage:Boolean	= false;	//showRearPage
		private var _shade:Object	=	{show:true, color:0x000000, sizeMin:10, sizeMax:30, alphaMin:10, alphaMax:30};
		private var _pageShadow:Object	=	{show:true, color:0x000000, sizeMin:20, sizeMax:120, alphaMin:40, alphaMax:60};
		private var _flipArea:Object	=	{leftTop:true,rightTop:true,leftBottom:true,rightBottom:true,leftTopInner:false,rightTopInner:false,leftBottomInner:false,rightBottomInner:false};
		private var _flipSize:Object	=	{width:40, height:30, innerWidth:80, innerHeight:50};//flipAreaSize
		private var _dragAccRatio:Number	= 0;		//dragAccRatio
		private var _moveAccRatio:Number	= 0;		//moveAccRatio
		private var _multiFlip:Boolean		= false;	//multiFlip
		private var _active:Boolean			= true;		//active
		private var _pages:PagesObj			= new PagesObj();		//list of the visible page objects
		private var _flipPages:PagesObj		= new PagesObj();		//list of the flipped page objects
		private var _flipCount:int			= 0;		//count of the flipped pages (<0 means the flipped pages are on the left)
		private var _topPageDepth:int	= 10000;	//depth of the topmost static page
		private var _pretreating:Boolean	= true;		//if it is pretreating
		
		private var _dragingFa:Sprite;
		private var _isFlipInner:Boolean;
		////属性存取方法
		
		public function set pageWidth(value:Number):void{
			resizePage(value, _pageHeight);
		}
		/**the width of the page*/
		public function get pageWidth():Number{
			return _pageWidth;
		}
		
		public function set pageHeight(value:Number):void{
			resizePage(_pageWidth, value);
		}
		/**the height of the page*/
		public function get pageHeight():Number{
			return _pageHeight;
		}
		
		[Inspectable(defaultValue="", type=String)]
		public function set pageId(value:String):void{
			if (_pageId == value)	return;
			
			_pageId		=	value;
			var len:int	=	_pages.length;
			for (var i:int = 0; i < len; i++) {
				_createPageMC(_pages.getPageAt(i));
			}
			
		}
		/**the linkage id of the page content movie clip*/
		public function get pageId():String{
			return _pageId;
		}
		
		[Inspectable(defaultValue=false, verbose=1, type=Boolean )]
		public function set adjustEvenPage(value:Boolean):void{
			_adjustEvenPage		= 	value;
			var dx:Number		= 	value ? 0 : _pageWidth;
			var len:uint		=	_pages.length;
			for (var i:uint = 0; i < len; i++) {
				var page:FlipPage	=	_pages.getPageAt(i);
				page.page.x			= 	dx * -page.side;
				if (page.rearPage){
					page.rearPage.x = 	dx * -page.side;
				}
			}
		}
		/**if adjust even page's content position*/
		public function get adjustEvenPage():Boolean{
			return _adjustEvenPage;
		}
		
		[Inspectable(defaultValue=true, verbose=1, type=Boolean)]
		public function set autoPage(value:Boolean):void{
			if (_autoPage = value) {
				var len:int	=	_pages.length;
				for (var i:int = 0; i < len; i++) {
					var page:FlipPage	=	_pages.getPageAt(i);
					if(page.page is MovieClip){
						page.page['gotoAndStop'](page.index + 1);
					}
					if(page.rearPage is MovieClip){
						page.rearPage['gotoAndStop'](page.index + 1);//page.rearPage.index + 1
					}
				}
			}
		}
		/**automatically go to the definite frame when the page movie clip is created*/
		public function get autoPage():Boolean{
			return _autoPage;
		}
		
		[Inspectable(defaultValue=0, type=Number, category="Page", name=" firstPage")]
		public function set firstPage(value:uint):void{
			setPageRange(value, _lastPage);
		}
		/**first page's index*/
		public function get firstPage():uint{
			return _firstPage;
		}
		
		[Inspectable(defaultValue=1, type=Number, category="Page", name="  lastPage")]
		public function set lastPage(value:uint):void{
			setPageRange(_firstPage, value);
		}
		/**last page's index*/
		public function get lastPage():uint{
			return _lastPage;
		}
		
		[Inspectable(defaultValue=0, type=Number, category="Page")]
		public function set curPage(value:uint):void {
			if (_pretreating) {
				_pretreating	=	false;
				gotoPage(value, true);
			}else {
				gotoPage(value, false);
			}
		}
		/**index of the current page*/
		public function get curPage():uint{
			return _curPage;
		}
		
		[Inspectable(defaultValue=1, verbose=1, type=Number)]
		public function set visiblePages(value:uint):void{
			var visiblePages:uint	= _visiblePages;
			_visiblePages	=
			value 			=		uint(Math.max(value, 1));
			if (_pretreating || visiblePages == value){
				return;
			}
			var flipped:Number	=	_flipCount;
			var index1:int;
			var index2:int;
			var i:uint;
			if (visiblePages > value) {
				index1		= _curPage - value*2 + (flipped < 0 ? flipped*2 : 0);
				index2		= (_curPage+1) + value*2 + (flipped > 0 ? flipped*2 : 0);
				for (i = value; i < visiblePages; i++, index1 -= 2, index2 += 2) {
					_removePage(_pages.getPageByIndex(index1));
					_removePage(_pages.getPageByIndex(index2));
				}
			} else {
				index1		= _curPage - visiblePages*2 + (flipped < 0 ? flipped*2 : 0);
				index2		= (_curPage+1) + visiblePages*2 + (flipped > 0 ? flipped*2 : 0);
				for (i = visiblePages; i < value; i++, index1 -= 2, index2 += 2) {
					_createPage(index1, _topPageDepth + (index1 - _curPage));
					_createPage(index2, _topPageDepth - (index2 - _curPage));
				}
			}
		}
		/**max count of the visible pages on one side*/
		public function get visiblePages():uint{
			return _visiblePages;
		}
		
		[Inspectable(defaultValue=false, verbose=1, type=Boolean)]
		public function set showRearPage(value:Boolean):void {
			var fpEvent:FlipPagesEvent;
			_showRearPage	= value;
			//var rearDepth:Number		= _rearPageDepth;
			var dx:Number				= _adjustEvenPage ? 0 : _pageWidth;
			var len:int	=	_pages.length;
			for (var i:int = 0; i < len; i++) {
				var page:FlipPage			=	_pages.getPageAt(i);
				var rear:Sprite		=	page.rearPage;
				if (!value && rear != null) {
					fpEvent			=	new FlipPagesEvent(FlipPagesEvent.REMOVE_PAGE, page);
					fpEvent.page	=	rear;
					fpEvent.isRearPage	=	true;
					dispatchEvent(fpEvent);
					//removeChild(rear);
					page.removePage(true);
					rear			= 
					page.rearPage 	= null;
				}
				if (!value || rear != null){
					return;
				}
				var index:int		= page.index + page.side;
				if (index < _firstPage || index > _firstPage){
					continue;
				}

				if(_pageId!=""){
					var pageClass:Class;
					try{
						pageClass	=	getDefinitionByName(_pageId) as Class;
					}catch(e:ReferenceError ){
						trace("ERROR: "+e.toString());
					}
					page.rearPage	=	new pageClass();
				}else{
					page.rearPage	=	new Sprite();
				}
				page.attachPage(page.rearPage, true);
				
				rear	=	page.rearPage;
				rear.name		= index.toString();
				rear.scaleX		= -1;
				rear.x			= dx * -page.side;
				if (_autoPage) {
					if(rear is MovieClip){
						rear['gotoAndStop'](index + 1);
					}
				}
				fpEvent			=	new FlipPagesEvent(FlipPagesEvent.CREATE_PAGE, page);
				fpEvent.page	=	rear;
				fpEvent.isRearPage	=	true;
				dispatchEvent(fpEvent);
			}
		}
		/**if the rear page is shown (used in transparent pages)*/
		public function get showRearPage():Boolean{
			return _showRearPage;
		}
		[Inspectable(name="shade", defaultValue="show:true,color:0x000000,sizeMin:10,sizeMax:30,alphaMin:10,alphaMax:30", category="Object", verbose="1" )]
		public function set shade(value:Object):void{
			_shadeSetting("_shade", value);
		}
		/**the settings of the boundary shade*/
		public function get shade():Object{
			return _shade;
		}
		[Inspectable(name="pageShadow", defaultValue="show:true,color:0x000000,sizeMin:20,sizeMax:120,alphaMin:60,alphaMax:80", category="Object", verbose="1")]
		public function set pageShadow(value:Object):void{
			_shadeSetting("_pageShadow", value);
		}
		/**the settings of the page shadow*/
		public function get pageShadow():Object{
			return _pageShadow;
		}
		[Inspectable(name="flipArea", defaultValue="leftTop:true,rightTop:true,leftBottom:true,rightBottom:true,leftTopInner:false,rightTopInner:false,leftBottomInner:false,rightBottomInner:false", category="Object", verbose="1")]
		public function set flipArea(value:Object):void{
			for (var prop:String in _flipArea) {
				if (value[prop] != null && !isNaN(value[prop])){
					_flipArea[prop] = value[prop] ? true : false;
				}
			}
			var len:uint	=	_pages.length;
			for (var i:int = 0; i < len; i++) {
				var page:FlipPage	=	_pages.getPageAt(i);
				_setFlipArea(page);
			}
		}
		/**the button areas that can respond to the flip action*/
		public function get flipArea():Object{
			return _flipArea;
		}
		[Inspectable(name="flipSize", defaultValue="width:40,height:30,innerWidth:80,innerHeight:50", category="Object", verbose="1")]
		public function set flipSize(value:Object):void{
			setFlipSize(value.width, value.height, value.innerWidth, value.innerHeight);
		}
		/**the size (in percentage of the page width) of the flip areas*/
		public function get flipSize():Object{
			return _flipSize;
		}
		
		[Inspectable(defaultValue=0.5, type=Number, category="speed")]
		public function set dragAccRatio(value:Number):void{
			_dragAccRatio = value > 1 ? 1 : value > 0 ? Number(value) : 0;
		}
		/**the dragging accelerate ratio (0~1)*/
		public function get dragAccRatio():Number{
			return _dragAccRatio;
		}
		
		[Inspectable(defaultValue=0.2, type=Number, category="speed")]
		public function set moveAccRatio(value:Number):void{
			_moveAccRatio = value > 1 ? 1 : value > 0 ? Number(value) : 0;
		}
		/**the moving accelerate ratio (0~1)*/
		public function get moveAccRatio():Number{
			return _moveAccRatio;
		}
		
		[Inspectable(defaultValue=false, verbose=1, type=Boolean)]
		public function set multiFlip(value:Boolean):void{
			_multiFlip = value;
		}
		/**if multiple flipping is allowed*/
		public function get multiFlip():Boolean{
			return _multiFlip;
		}
		
		[Inspectable(defaultValue=true, verbose=1, type=Boolean)]
		public function set active(value:Boolean):void {
			//if (_active == value)	return;
			_active	= value;
			var len:int	=	_pages.length;
			for (var i:int = 0; i < len; i++) {
				var page:FlipPage	=	_pages.getPageAt(i);
				page.buttonEnabled	=	value;
			}
			if (value){
				//addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove, false, 0, true);
			}else{
				removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			}
		}
		/**if the pages can response to mouse actions*/
		public function get active():Boolean{
			return _active;
		}
		
		//*****只读属性******//
		/**list of the visible page objects*/
		public function get pages():PagesObj{
			return _pages;
		}
		/**list of the flipped page objects*/
		public function get flipPages():PagesObj{
			return _flipPages;
		}
		/**the main flipped page's index (nearest to the current page), -1 means no flipping pages*/
		public function get flipPage():int {
			return _flipCount == 0 ? -1 : _curPage + (_flipCount < 0 ? -1 : 2);
		}
		/**count of the flipped pages (<0 means the flipped pages are on the left)*/
		public function get flipCount():int{
			return _flipCount;
		}
		/**if it is flipping now*/
		public function get flipping():Boolean{
			return _flipCount != 0;
		}
		
		static private const FLIP_BUTTON_NAME:Array	=	["faTopInner", "faBottomInner", "faTop", "faBottom"];
		static private const FLIP_AREA_NAME:Object	=	{FlipArea0:"topInner", FlipArea1:"bottomInner", FlipArea2:"top", FlipArea3:"bottom" };
		
		//******************************************************************//
		/**
		* construct function.<br></br>
		* you not use new FlipPagesBox() to constrruct. you ought to drag FlipPagesBox from<br></br>
		* Component panel(Ctrl+F7) to stage.
		*/
		public function FlipPagesBox(){
			if (isNaN(pageWidth)){
				pageWidth	=	scaleX * 120;
			}else{
				pageWidth	=	width / 2;
			}
			if (isNaN(pageHeight)){
				pageHeight	=	scaleY * 160;
			}else{
				pageHeight	=	height;
			}
			scaleX		= 
			scaleY		= 1;
			FlipPage.mainRef	=	this;
			init();
		}
		
		/**
		* initialize this class
		*/
		private function init():void{
			removeChildAt(0);
			addEventListener(Event.ENTER_FRAME, _onEnterFrame, false, 0, true);
		}
		
		/**
		* create a page movie clip and its rear page movie clip
		* @param page
		*/
		private function _createPageMC(page:FlipPage):void {
			var fpEvent:FlipPagesEvent;
			if (page.page) {
				fpEvent			=	new FlipPagesEvent(FlipPagesEvent.REMOVE_PAGE, page);
				fpEvent.page	=	page.page;
				dispatchEvent(fpEvent);
				page.removePage(false);
			}
			var pageClass:Class;
			if(_pageId!=""){
				try{
					pageClass	=	getDefinitionByName(_pageId) as Class;
				}catch(e:ReferenceError ){
					trace("ERROR: "+e.toString());
				}
				page.page	=	new pageClass();
			}else{
				page.page	=	new Sprite();
			}
			page.attachPage(page.page, false);
			page.page.name		= page.index.toString(); 
			var dx:Number		= _adjustEvenPage ? 0 : _pageWidth;
			page.page.x			= dx * -page.side;
			if (_autoPage){
				if(page.page is MovieClip){
					page.page['gotoAndStop'](page.index + 1);
				}
			}
			fpEvent			=	new FlipPagesEvent(FlipPagesEvent.CREATE_PAGE, page);
			fpEvent.page	=	page.page;
			dispatchEvent(fpEvent);

			if (_showRearPage) {
				if (page.rearPage != null) {
					fpEvent			=	new FlipPagesEvent(FlipPagesEvent.REMOVE_PAGE, page);
					fpEvent.page	=	page.rearPage;
					fpEvent.isRearPage	=	true;
					dispatchEvent(fpEvent);
					page.removePage(true);
				}
				var index:int	= page.index + page.side;
				if (index < _firstPage || index > _lastPage) return;//out range
				if(_pageId!=""){
					try{
						pageClass	=	getDefinitionByName(_pageId) as Class;
					}catch(e:ReferenceError ){
						trace("ERROR: "+e.toString());
					}
					page.rearPage	=	new pageClass();
				}else{
					page.rearPage	=	new Sprite();
				}
				page.attachPage(page.rearPage, true);
				
				page.rearPage.name		= index.toString();
				page.rearPage.scaleX	= -1;
				page.rearPage.x			= dx * -page.side;
				if (_autoPage){
					if(page.page is MovieClip){
						page.rearPage['gotoAndStop'](index + 1);
					}
				}
				fpEvent		=	new FlipPagesEvent(FlipPagesEvent.CREATE_PAGE, page);
				fpEvent.page	=	page.rearPage;
				fpEvent.isRearPage	=	true;
				dispatchEvent(fpEvent);
			}
		};

		/**
		* create a page object
		* @param index
		* @param depth
		* @param position
		*/
		private function _createPage(index:uint, depth:Number, position:Object = null):FlipPage {
			if (index < _firstPage || index > _lastPage) {
				return	null;
			}
			//trace("_createPage: index="+index+", depth="+depth);
			var page:FlipPage	=	new FlipPage(index);
			addChild(page);
			
			_createPageMC(page);
			if (_shade.show) {
				page.createShade(_shade.color);
			}
			if (_pageShadow.show) {
				page.createShadow(_pageShadow.color);
			}
			page.position	=	position;
			_adjustPage(page);
			_setFlipArea(page);
			_pages.addPage(page);
			page.depth		=	depth;
			return page;
		};

		/**
		* remove a page display object
		* @param page
		*/
		private function _removePage(page:FlipPage):void{
			if (page == null){
				return;
			}
			var fpEvent:FlipPagesEvent	=	new FlipPagesEvent(FlipPagesEvent.REMOVE_PAGE, page);
			fpEvent.page	=	page.page;
			dispatchEvent(fpEvent);
			page.removePage(false);
			if (page.rearPage != null) {
				fpEvent			=	new FlipPagesEvent(FlipPagesEvent.REMOVE_PAGE, page);
				fpEvent.page	=	page.rearPage;
				fpEvent.isRearPage	=	true;
				dispatchEvent(fpEvent);
				page.removePage(false);
			}
			if (_flipPages.existPage(page)) {
				_flipCount	+= page.side;
				//trace("_flipPages.removePage| page="+page);
				_flipPages.removePage(page);//delete [page.index];
			}
			_pages.removePage(page);
			removeChild(page);
		};

		/**
		* adjust the page and its mask and shades according to its position
		* @param page
		*/
		private function _adjustPage(page:FlipPage):void {
			if (!page)	return;
			
			var width:Number		= _pageWidth;
			var height:Number		= _pageHeight;
			var side:Number			= page.side;//-1, for the first default
			var pos:Object			= page.position;//null, for the first defualt
			//trace("_adjustPage| width: "+width+", height: "+height);
			//calculate the mask range
			var top:Number;
			var range:Object	=	{type:null,a:null,b:null,angle:null,angle2:null,length:null}; 
			if (!pos) {
				top		= 1;
				range	= {type:1, a:width, b:width, angle:0, angle2:90, length:height};
				pos		= {x:side * width, y:0};
			} else {
				top		= pos.top;
				range	= pos.range != null ? pos.range : _getMaskRange( -side * pos.x, top > 0 ? pos.y : height - pos.y);
				pos.range	=	range;
				//listRange(pos.range);
				pos.x	= -side * range.x;
				pos.y	= top > 0 ? range.y : height-range.y;
			}
			
			//adjust page face movie clip
			var tempMC:Sprite	=	page.face;
			tempMC.x			=	pos.x;
			tempMC.y			=	pos.y;
			tempMC.rotation		=	side * top * range.angle;
		
			page.page.y	= top > 0 ? 0 : -height;
			
			if (page.rearPage){
				page.rearPage.y = top > 0 ? 0 : -height;
			}
			//adjust shade movie clip
			var ratio:Number	= 
			page.shadeRatio		= range.type==0 ? (range.a/width < range.b/height ? range.a/width/2 : range.b/height/2) : 
														(range.a/width/2 + range.b/width/2);
			var shade:Sprite	=	page.shade;
			if (page.shade) {
				var shadeSet:Object	=	_shade;
				shade.x			=	range.a * -side;
				shade.y			=	0;
				shade.rotation	=	(range.angle2 - 90) * side * top;
				shade.scaleX	=	(ratio * shadeSet.sizeMax + (1-ratio) * shadeSet.sizeMin) / 100 * width * side/100;
				shade.scaleY	=	top * range.length/100;
				shade.alpha		=	(ratio * shadeSet.alphaMax + (1 - ratio) * shadeSet.alphaMin) / 100;
			}
			
			//adjust page mask movie clip
			_drawMask(page.pageMask, range.type, range.a, range.b);
			tempMC				=	page.pageMask;
			tempMC.x			=	pos.x;
			tempMC.y			=	pos.y;
			tempMC.rotation		=	side * top * range.angle;
			tempMC.scaleY		=	top;
			
			//adjust page shadow movie clip
			if (page.shadow) {
				if (page.position == null) {
					page.shadow.visible	= false;
				} else {
					var shadowSet:Object	=	_pageShadow;
					tempMC				=	page.shadow;
					tempMC.visible		=	true;
					tempMC.x			=	(range.a - width) * side;
					tempMC.y			=	top > 0 ? 0 : height;
					tempMC.rotation		=	(90 - range.angle2) * side * top;
					tempMC.scaleX		=	((ratio * shadowSet.sizeMax + (1-ratio) * shadowSet.sizeMin) / 100 * width * side)/100;
					tempMC.scaleY		=	(top * (range.length > width ? range.length : width))/100;
					tempMC.alpha		=	(ratio * shadowSet.alphaMax + (1-ratio) * shadowSet.alphaMin)/100;
					//adjust shadow mask movie clip
					_drawMask(page.shadowMask, 13-range.type, range.a, range.b);
					tempMC				=	page.shadowMask;
					tempMC.y			=	top > 0 ? 0 : height;
					tempMC.scaleY		=	top;

				}
			}
			//adjust rear page's mask
			var rearPage:FlipPage	= _pages.getPageByIndex(page.index+side);// _pages[page.index + side];
			if (rearPage) {
				_drawMask(rearPage.pageMask, 3-range.type, range.a, range.b);
				tempMC				=	rearPage.pageMask;
				tempMC.y			=	top > 0 ? 0 : height;
				tempMC.scaleY		=	top;
			}
			
			//adjust opposite page's shade
			var oppoPage:FlipPage 	=	_pages.getPageByIndex(page.index-side);//_pages[page.index - side];
			if(oppoPage){
				if (oppoPage.shade) {
					oppoPage.shadeRatio	= ratio;
					tempMC				=	oppoPage.shade;
					tempMC.x			= -shade.x;
					tempMC.y			= top > 0 ? 0 : height;
					tempMC.rotation		= -shade.rotation;
					tempMC.scaleX		= -shade.scaleX;
					tempMC.scaleY		= shade.scaleY;
					tempMC.alpha		= shade.alpha;
				}
			}
			var fpEvent:FlipPagesEvent	=	new FlipPagesEvent(FlipPagesEvent.ADJUST_PAGE, page);
			fpEvent.page	=	page.page;
			fpEvent.range	=	range;
			dispatchEvent(fpEvent);
		};

		/**
		* get the mask range according to the right page's top corner at the specified position
		* @param x
		* @param y
		*/
		private function _getMaskRange(x:Number, y:Number):Object {
			var width:Number		= _pageWidth;
			var height:Number		= _pageHeight;
			//adjust x, y to be in the valid range
			//trace("_getMaskRange| x: "+x+", y: "+y+", width: "+width+", height: "+height);
			var dTop:Number		= Math.sqrt(x*x + y*y);
			if (dTop > width) {
				x			*= width / dTop;
				y			*= width / dTop;
			}
			var dBottom:Number		= Math.sqrt(x*x + (y-height) * (y-height));
			var diagonal:Number		= Math.sqrt(width*width + height*height);
			if (dBottom > diagonal) {
				x			*= diagonal / dBottom;
				y			= (y-height) * diagonal / dBottom + height;
			}
			//calculate the range
			var w_x:Number			= width - x;
			var range:Object		= { x:x, y:y, b:0 };
			if (w_x == 0) {
				range.type			= 0;	//corner type, 0:triangle, 1:quadrangle
				range.a				= 0;	//side width of the corner
				range.b				= 0;
				range.angle			= 0;	//page rotation angle
				range.sin			= 0;	//sin, cos of page rotation angle
				range.cos			= 1;
				range.angle2		= 45;	//shade rotation angle
				range.length		= 0;	//length of the boundary
			} else {
				range.a				= (w_x + y*y / w_x) / 2;
				range.angle			= Math.atan2(y, w_x - range.a);
				range.sin			= Math.sin(range.angle);
				range.cos			= Math.cos(range.angle);
				range.angle			*= 180/Math.PI;
				if (w_x*w_x + (y-height)*(y-height) <= height*height) {
					range.type		= 0;
					range.b			= range.a * w_x / y + range.a * 0.005;
					range.angle2	= Math.atan2(range.b, range.a) * 180/Math.PI;
					range.length	= Math.sqrt(range.a*range.a + range.b*range.b);
				} else {
					range.type		= 1;
					range.b			= range.a - height * y / w_x + (range.a + range.b) * 0.005;
					range.angle2	= Math.atan2(height, range.a - range.b) * 180/Math.PI;
					range.length	= Math.sqrt(height*height + (range.a-range.b) * (range.a-range.b));
				}
			}
			//listRange(range);
			return range;
		};

		/**
		* draw mask with specified type, a, b is the side width of the corner
		* @param mask
		* @param type
		* @param a
		* @param b
		*/
		private function _drawMask(maskObj:Sprite, type:Number, a:Number, b:Number):void {
			var w:Number	=	_pageWidth;
			var h:Number	=	_pageHeight;
			var g:Graphics	=	maskObj.graphics;
			//trace("_drawMask| type: "+type+", a: "+a+", b: "+b+", width: "+w+", height: "+h);
			g.clear();
			g.beginFill(0, .3);
			//g.lineStyle(1,0xffff00,100);
			g.moveTo(type <= 1 || type > 10 ? 0 : w, 0);
			g.lineTo(type > 10 ? w - a : a, 0);
			switch (type) {
				case 0:		//triangle (flip page)
					g.lineTo(0, b);
					break;
				case 1:		//quadrangle (flip page)
					g.lineTo(b, h);
					g.lineTo(0, h);
					break;
				case 2:		//quadrangle
					g.lineTo(b, h);
					break;
				case 12:	//quadrangle2
					g.lineTo(w - b, h);
					break;
				case 3:		//pentagon
					g.lineTo(0, b);
					g.lineTo(0, h);
					break;
				case 13:	//pentagon2
					g.lineTo(w, b);
					g.lineTo(w, h);
					break;
			}
			if (type > 1) {
				g.lineTo(type < 10 ? w : -w, h);
				g.lineTo(type < 10 ? w : -w, 0);
			}
			if (type <= 1 || type > 10) g.lineTo(0, 0);
			g.endFill();
		};

		/**
		* reset the flip areas in the specified page
		* @param page
		*/
		private function _setFlipArea(page:FlipPage):void {
			var name1:Array		=	null;
			if (page.side < 0) {
				name1	= ["leftTopInner", "leftBottomInner", "leftTop", "leftBottom"];
			} else {
				name1	= ["rightTopInner", "rightBottomInner", "rightTop", "rightBottom"];
			}
			var faNames:Array		= FLIP_BUTTON_NAME;
			var width:Number		= -page.side * _flipSize.width / 100 * _pageWidth;
			var height:Number		= _flipSize.height / 100 * _pageHeight;
			var innerWidth:Number	= -page.side * _flipSize.innerWidth / 100 * _pageWidth;
			var innerHeight:Number	= _flipSize.innerHeight / 100 * _pageHeight;
			//trace("faNames: "+faNames+", width: "+width+", height: "+height+", innerWidth: "+innerWidth+", innerHeight: "+innerHeight);
			
			for (var i:uint = 0; i < 4; i++) {
				if (_flipArea[name1[i]]) {
					var fa:Sprite		= page[faNames[i]];
					if (fa == null) {
						//如果为第一页或最后一页,则按键不能使用
						var pageNum:int		=	page.index;
						//trace(pageNum , Math.floor(_firstPage/2)*2, Math.floor(_lastPage/2) * 2 + 1);
						if (pageNum == Math.floor(_firstPage/2)*2 || pageNum==Math.floor(_lastPage/2) * 2 + 1) {
							continue;
						}
						//fa		= page[faNames[i]] = page.face.attachMovie("HotArea", "FlipArea"+i, _flipAreaDepth+i,{_alpha:0});
						fa		=	new Sprite();
						page[faNames[i]]	=	fa;
						
						fa.name	=	"FlipArea" + i;
						page.face.addChild(fa);
						fa.addEventListener(MouseEvent.MOUSE_DOWN, _faPress, false, 0, true);
						fa.addEventListener(MouseEvent.ROLL_OVER, _faRollOver, false, 0, true);
						fa.addEventListener(MouseEvent.ROLL_OUT, _faRollOut, false, 0, true);
						fa.buttonMode			=
						fa.mouseEnabled			=	_active;
					}
					var xFa:Number	=	0;
					var yFa:Number	=	i % 2 == 0 ? 0 : _pageHeight;
					var wFa:Number	=	(i > 1 ? width : innerWidth);
					var hFa:Number	=	((i % 2 == 0 ? 1 : -1) * (i > 1 ? height : innerHeight));
					
					var g:Graphics	=	fa.graphics;
					g.clear();
					g.beginFill(0, 0);
					g.drawRect(0, 0, wFa, hFa);
					g.endFill();
					fa.x	=	xFa;
					fa.y	=	yFa;
					//trace("fa| page: "+fa.parent.parent['index']+", x: " + fa.x + ", y: " + fa.y + ", width: " + fa.width + ", height: " + fa.height);
				} else if (page[faNames[i]] != null) {
					//page[faNames[i]].removeMovieClip();
					removeChild(page[faNames[i]]);
					page[faNames[i]]		=	null;
				}
			}
			
			var fpEvent:FlipPagesEvent	=	new FlipPagesEvent(FlipPagesEvent.SET_FLIP_AREA, page);
			dispatchEvent(fpEvent);
		};

		/**
		* adjust the size of the flip areas in the specified page
		* @param page
		*/
		private function _adjustFlipSize(page:FlipPage):void {
			var faNames:Array			= FLIP_BUTTON_NAME;
			
			var pageHeight:Number		= this._pageHeight;
			var width:Number			= -page.side * this._flipSize.width / 100 * this._pageWidth;
			var height:Number			= this._flipSize.height / 100 * pageHeight;
			var innerWidth:Number		= -page.side * this._flipSize.innerWidth / 100 * this._pageWidth;
			var innerHeight:Number		= this._flipSize.innerHeight / 100 * pageHeight;
			for (var i:Number = 0; i < 4; i++) {
				var fa:Sprite			= page[faNames[i]];
				
				if (fa == null) continue;
				var xFa:Number	=	0;
				var yFa:Number	= (i%2 == 0 ? 0 : pageHeight) - (page.position ? (page.position.top < 0 ? pageHeight : 0) : 0);
				var wFa:Number	= (i > 1 ? width : innerWidth);
				var hFa:Number	= ((i % 2 == 0 ? 1 : -1) * (i > 1 ? height : innerHeight));
				
				var g:Graphics	=	fa.graphics;
				g.clear();
				g.beginFill(0, 0);
				g.drawRect(0, 0, wFa, hFa);
				g.endFill();
				fa.x	=	xFa;
				fa.y	=	yFa;
			}
		};

		/**
		* onPress event handler of flip areas
		*/
		private function _faPress(e:MouseEvent):void {
			var fa:Sprite				=	e.currentTarget as Sprite;
			var page:FlipPage			=	fa.parent.parent as FlipPage;
			var fpEvent:FlipPagesEvent	=	new FlipPagesEvent(FlipPagesEvent.PRESS_FLIP, page);
			fpEvent.dragButton			=	FLIP_AREA_NAME[fa.name];
			dispatchEvent(fpEvent);
			
			
			var flipOK:Boolean			=	startFlip(page.index, FLIP_AREA_NAME[fa.name]);
			
			//TODO 多页翻转??!!没问题了?
			if (!flipOK && !_multiFlip)	return;
			_dragingFa					=	fa;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, _faRelease, false, 0, true);
		};
		private function _faRollOver(e:MouseEvent):void {
			var fa:Sprite				=	e.currentTarget as Sprite;
			var page:FlipPage			=	fa.parent.parent as FlipPage;
			var fpEvent:FlipPagesEvent	=	new FlipPagesEvent(FlipPagesEvent.ROLL_OVER_FLIP, page);
			fpEvent.dragButton			=	FLIP_AREA_NAME[fa.name];
			dispatchEvent(fpEvent);
		}
		private function _faRollOut(e:MouseEvent):void {
			var fa:Sprite				=	e.currentTarget as Sprite;
			var page:FlipPage			=	fa.parent.parent as FlipPage;
			var fpEvent:FlipPagesEvent	=	new FlipPagesEvent(FlipPagesEvent.ROLL_OUT_FLIP, page);
			fpEvent.dragButton			=	FLIP_AREA_NAME[fa.name];
			dispatchEvent(fpEvent);
		}
		//onPress event handler of flip areas
		private function _faRelease(e:MouseEvent):void {
			var page:FlipPage			=	_dragingFa.parent.parent as FlipPage;
			var fpEvent:FlipPagesEvent	=	new FlipPagesEvent(FlipPagesEvent.RELEASE_FLIP, page);
			fpEvent.dragButton			=	FLIP_AREA_NAME[_dragingFa.name];
			fpEvent.flipToFace			=	page.index % 2 == 0 ? mouseX > 0 : mouseX < 0;
			if (_isFlipInner)	fpEvent.flipToFace	=	!fpEvent.flipToFace;
			dispatchEvent(fpEvent);
			
			stopFlip(page.index, false);
			
			_dragingFa					=	null;
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, _faRelease, false);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove, false);
			e.stopImmediatePropagation();
		};

		/**
		* onMouseMove event handler
		*/
		private function _onMouseMove(e:MouseEvent):void {
			var mx:Number	= mouseX;
			var my:Number	= mouseY;
			var len:uint	=	_flipPages.length;
			for (var i:int = 0; i < len; i++) {
				var pos:Object	= _pages.getPageByIndex(_flipPages.getPageAt(i).index).position;
				if (pos.trackMouse) {
					pos.aimX	= mx;
					pos.aimY	= my;
				}
			}
		};

		/**
		* adjust position according to the neighbour pages
		* @param page
		*/
		private function _adjustPagePos(page:FlipPage):void {
			var pos:Object			=	page.position;
			if (pos==null)	return;
			//trace("_adjustPagePos| pos.x: "+pos.x+", pos.y: "+pos.y);
			var range:Object		=	_getMaskRange( -page.side * pos.x, pos.top > 0 ? pos.y : _pageHeight - pos.y);
			var fPage:FlipPage		=	_flipPages.getPageByIndex(page.index + 2 * page.side);
			var innerRange:Object;
			if (fPage) {
				innerRange			=	fPage.position.range;
			}
			
			var outterRange:Object;
			fPage					=	_flipPages.getPageByIndex(page.index - 2 * page.side);
			if (fPage) {
				outterRange			=	fPage.position.range;
			}
			
			var a:Number			=	range.a;
			var b:Number			=	range.b;
			var type:int			=	range.type;
			
			if (innerRange != null) {
				if (a > innerRange.a){
					a = innerRange.a;
				}
				if (type > innerRange.type) {
					type	= innerRange.type;
					b		= innerRange.b;
				} else if (type == innerRange.type && b > innerRange.b) {
					b		= innerRange.b;
				}
			}
			if (outterRange != null) {
				if (a < outterRange.a) a = outterRange.a;
				if (type < outterRange.type) {
					type	= outterRange.type;
					b		= outterRange.b;
				} else if (type == outterRange.type && b < outterRange.b) {
					b		= outterRange.b;
				}
			}
			if (a == range.a && b == range.b && type == range.type) {
				pos.range	= range;
			} else {
				var angle:Number	= (type == 0 ? Math.atan2(b, a) : Math.atan2(_pageHeight, a - b)) * 2;
				pos.range			= _getMaskRange(_pageWidth - a * (1-Math.cos(angle)), a * Math.sin(angle));
			}
			_adjustPage(page);
		};

		/**
		* set the settings of boundary shade or page shadow
		* @param name
		* @param value
		*/
		private function _shadeSetting(name:String, value:Object):void {
			var mcName:Object		= {_shade:"shade", _pageShadow:"shadow"}[name];
			var setting:Object		= this[name];
			if (value.show != null) {
				setting.show = value.show ? true : false;
			}
			if (value.color) setting.color = parseInt(value.color) & 0xffffff;
			var rangeName:Object	= {sizeMin:0, sizeMax:1, alphaMin:2, alphaMax:3};
			for (var prop:String in rangeName) {
				if (value[prop] != null) setting[prop] = value[prop] > 0 ? Number(value[prop]) : 0;
			}
			var width:Number		=	_pageWidth;
			var len:uint			=	_pages.length;
			for (var i:int = 0; i < len; i++) {
				var page:FlipPage	= _pages.getPageAt(i);// _pages[i];
				var mc:Sprite		= page[mcName] as Sprite;
				if (!setting.show && mc) {
					mc.parent.removeChild(mc);
					mc		= page[mcName] = null;
				}
				if (!setting.show) return;
				if (mc == null) {
					if(name=="_shade"){
						page.createShade(setting.color);
					}else {
						page.createShadow(setting.color);
					}
				}
				if (name == "_shadow") {
					mc.visible		= page.position != null;
					if (page.position == null) continue;
				}
				var ratio:Number	= page.shadeRatio;
				mc.scaleX	= (ratio * setting.sizeMax + (1-ratio) * setting.sizeMin) / 100 * width * page.side/100;
				mc.alpha	= (ratio * setting.alphaMax + (1-ratio) * setting.alphaMin)/100;
			}
		};
		
		/**
		 * onEnterFrame event handler
		 */
		private function _onEnterFrame(e:Event = null):void {
			//removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
			//trace("start onEnter");
			var moveAcc:Number			= _moveAccRatio;
			var dragAcc:Number			= _dragAccRatio;
			var fpEvent:FlipPagesEvent;
			var len:uint	=	_flipPages.length;
			for (var i:int = 0; i < len; i++) {
				//trace("loop in _flipPages: "+_flipPages.getPageAt(i), ", pages: "+_pages.getPageAt(i));
				var fPage:FlipPage, page:FlipPage;
				fPage	=	_flipPages.getPageAt(i);
				if(fPage){
					var index:uint	=	fPage.index;
					page			=	_pages.getPageByIndex(index);
				}else {
					//trace("ERROR: i=" + i + "/" + len + ": \r" + _flipPages);
					return;
				}
				
				var pos:Object			=	page.position;
				//trace("pos: "+pos.trackMouse, "page: "+page);
				if (pos.trackMouse==null) {//stop drag and auto flip other side or not.
					if (moveAcc == 0)	continue;
					//trace("len: "+i+"/"+len, pos.x, pos.y, pos.aimX, pos.aimY);
					pos.x		+= (pos.aimX - pos.x) * moveAcc;
					if (pos.range.angle < 0 && pos.x * page.side < 0) {
						pos.y	+= (pos.aimY - pos.y) * moveAcc * 2;
					} else {
						pos.y	+= (pos.aimY - pos.y) * moveAcc;
					}
					_adjustPagePos(page); 
					
					fpEvent		=	new FlipPagesEvent(FlipPagesEvent.MOVE_PAGE, page);
					fpEvent.x	=	pos.x;
					fpEvent.y	=	pos.y;
					dispatchEvent(fpEvent);

					var dx:Number		= pos.aimX - pos.x;
					var dy:Number		= pos.aimY - pos.y;
					
					//trace( "POS_PRECISION : " + POS_PRECISION , Math.sqrt(dx * dx + dy * dy) <= Math.abs(POS_PRECISION));
					if (Math.sqrt(dx * dx + dy * dy) <= Math.abs(POS_PRECISION)) {
						stopFlip(index, true);
					}
					//trace("loop: "+i+"/"+len);
				} else if(pos.trackMouse==true){//draging by user
					if (dragAcc == 0)	continue;
					
					pos.x		+= (pos.aimX - pos.x) * dragAcc;
					pos.y		+= (pos.aimY - pos.y) * dragAcc;
					
					_adjustPagePos(page);
					//trace(pos.x, pos.y, pos.aimX, pos.aimY);
					fpEvent		=	new FlipPagesEvent(FlipPagesEvent.DRAG_PAGE, page);
					fpEvent.x	=	pos.x;
					fpEvent.y	=	pos.y;
					dispatchEvent(fpEvent);
				} else if (pos.trackMouse == false) {
					if (moveAcc == 0)	continue;
					//trace("len: "+i+"/"+len, pos.x, pos.y, pos.aimX, pos.aimY);
					pos.x		+= (pos.aimX - pos.x) * moveAcc;
					pos.y		+= (pos.aimY - pos.y) * moveAcc;
					
					_adjustPagePos(page); 
					
					fpEvent		=	new FlipPagesEvent(FlipPagesEvent.MOVE_PAGE, page);
					fpEvent.x	=	pos.x;
					fpEvent.y	=	pos.y;
					dispatchEvent(fpEvent);
				}
			}
			//trace("end onEnter");
		};
		
		/**
		 * swap page depth
		 * @param	index page's index
		 * @param	depth depth
		 */
		private function _swapPageDepth(index:int, depth:int):void {
			var swapPage:FlipPage	=	_pages.getPageByIndex(index);
			if(swapPage){
				swapPage.depth	=	depth;
			}
		}
		////////////////////////////[PUBLIC METHOD]\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
		/**
		* resize the page
		* @param width
		* @param height
		*/
		public function resizePage(width:Number, height:Number):void {
			var fpEvent:FlipPagesEvent;
			
			_pageWidth 		=	width;
			_pageHeight 	=	height;
			
			var w:Number	=	width;
			var h:Number	=	height;
			var dx:Number	=	_adjustEvenPage ? 0 : w;
			var page:FlipPage;
			
			var len:int	=	_pages.length;
			for (var i:int = 0; i < len; i++) {
				page	=	_pages.getPageAt(i);
				if (_flipPages.existPage(page)) continue;
				page.page.x			= dx * -page.side;
				if (page.rearPage){
					page.rearPage.x	= dx * -page.side;
				}
				_adjustPage(page);
				_adjustFlipSize(page);
				
				fpEvent	=	new FlipPagesEvent(FlipPagesEvent.RESIZE_PAGE, page);
				fpEvent.width	=	w;
				fpEvent.height	=	h;
				dispatchEvent(fpEvent);
			}
			len		=	_flipPages.length;
			for (i = 0; i < len; i++) {
				page		= _pages.getPageByIndex(i);// _pages[prop];
				page.page.x	= dx * -page.side;
				if (page.rearPage != null){
					page.rearPage.x 	= dx * -page.side;
				}
				var pos:Object			= page.position;
				if (pos.top < 0) {
					page.page.y		= 
					page.rearPage.y	= -h;
				}
				if (pos.trackMouse == null) {
					pos.aimX	= w * (pos.x < 0 ? -1 : 1);
					pos.aimY	= pos.top > 0 ? 0 : h;
				}
				_adjustPagePos(page);
				_adjustFlipSize(page);
				
				fpEvent		=	new FlipPagesEvent(FlipPagesEvent.RESIZE_PAGE, page);
				fpEvent.width	=	w;
				fpEvent.height	=	h;
				dispatchEvent(fpEvent);
			}
		};

		/**
		* set the sizes of the flip areas
		* @param width if width is object, it would ignore other parameters
		* @param height
		* @param innerWidth
		* @param innerHeight
		*/
		public function setFlipSize(width:Number, height:Number, innerWidth:Number, innerHeight:Number):void {
			var flipSize:Object	=	{width:width, height:height, innerWidth:innerWidth, innerHeight:innerHeight};
			for (var prop:String in _flipSize) {
				if (flipSize[prop] != null && !isNaN(flipSize[prop])) _flipSize[prop] = Number(flipSize[prop]);
			}
			var len:int	=	_pages.length;
			for (var i:int = 0; i < len; i++) {
				var page:FlipPage	=	_pages.getPageAt(i);
				_adjustFlipSize(page);
			}
		};

		/**
		* start to flip the page att the specified index by the certain corner
		* @param index
		* @param corner
		* @param aimX [optional]
		* @param aimY [optional]
		* @return Boolean
		*/
		public function startFlip(index:uint, corner:String="top", aimX:Number=NaN, aimY:Number=NaN):Boolean {
			var page:FlipPage	=	_pages.getPageByIndex(index);
			
			if (!page)	return false;
			
			var side:int		=	page.side;
			//如果index不在可显示的页数内,不要翻页.
			if (side < 0 ? index <= _firstPage : index >= _lastPage)	return false;
			
			var cornerInt:int		=	{top:1, bottom:-1, topInner:2, bottomInner:-2}[corner];
			if (cornerInt == 0)	cornerInt = 1;
			_isFlipInner	=	Math.abs(cornerInt)==2;
			//create new flipped page
			var width:Number		= _pageWidth;
			var height:Number		= _pageHeight;
			var cPage:Number		= _curPage;
			var flipped:Number		= _flipCount;
			var topDepth:Number		= _topPageDepth;
			
			var i:int, f:int, top:int, n:int, m:int;
			//trace("startFlip| flipped: "+flipped+", index: "+index);
			if (flipped != 0) {//there's flipped pages
				var s:int		= flipped < 0 ? -1 : 1;
				if (index < cPage + (s<0 ? flipped*2 : 0) || index > cPage+1 + (s<0 ? 0 : flipped*2)){
					return false;
				}
				f		= cPage + (s<0 ? 0 : 1);
				top		= _pages.getPageByIndex(f+s).position.top;
				if (cornerInt != top * (side == s ? 1 : 2)){
					return false;
				}
				
				if (index == f + flipped*2) {//flip the outter corner page
					if (!_multiFlip)	return false;
					
					flipped			= _flipCount = flipped + s;
					n				= (_visiblePages + flipped * s - 1) * 2;
					_createPage(f + n * s, topDepth-n - (s<0 ? 0 : 1));
					page	= _createPage(f-s + flipped*2, topDepth + flipped*s, {x:width*s, y:top>0 ? 0 : height, top:top});
				} else if (index == f - s) {//flip the opposite page
					if (!_multiFlip)	return false;
					
					f			= (_curPage -= 2*s) + (s<0 ? 0 : 1);
					flipped		= 
					_flipCount	= flipped + s;
					n			= (_visiblePages - 1) * 2;
					m			= flipped * s * 2;
					_createPage(f, 0);
					for (i = n + m; i >= 0; i -= 2) {
						_swapPageDepth(f + i * s, topDepth - i - (s < 0 ? 0 : 1));
					}
					for (i = m; i >= 2; i -= 2) {
						_swapPageDepth(f + (i - 1) * s, topDepth + i / 2);
					}
					_createPage(f - (1 + n) * s, 0);
					for (i = 0; i <= n; i += 2) {
						_swapPageDepth(f - (i + 1) * s, topDepth - i - (s < 0 ? 1 : 0));
					}
					page			= _pages.getPageByIndex(f + s);
					page.position	= {x:-width*s, y:top>0 ? 0 : height, top:top};
					_adjustPage(page);
				} else if (side == s) {//flip the flipped page
					page			= _pages.getPageByIndex(index+s);
				}
			} else {//there's no flipped page
				if (index < cPage || index > cPage+1)	return false;
				
				f	= 	cPage + (side<0 ? 0 : 1);//不管按左边还是右边,都是与index相等
				n	= 	_visiblePages * 2;
				
				if (Math.abs(cornerInt) == 1) {//flip at outter corner
					flipped	= _flipCount = side;
					_createPage(f + n * side, topDepth - n - (side < 0 ? 0 : 1));
					page	= _createPage(f + side, topDepth + 1, {x:width*side, y:cornerInt > 0 ? 0 : height, top:cornerInt});
				} else {//flip at inner corner
					flipped		=	_flipCount = -side;
					for (i = n; i >= 2; i -= 2) {
						_swapPageDepth(f - (i - 1) * side, topDepth - i - (side < 0 ? 1 : 0));
					}
					f		= 	(_curPage += 2*side) + (side<0 ? 0 : 1);
					_createPage(f - side, topDepth + (side < 0 ? -1 : 0));
					page.depth		=	topDepth + 1;
					page.position	=	{x:width*side, y:cornerInt > 0 ? 0 : height, top:cornerInt/2};
					_adjustPage(page);
					_createPage(f + (n - 2) * side, 0);
					for (i = 0; i <= n - 2; i += 2) {
						_swapPageDepth(f + i * side, topDepth - i - (side < 0 ? 0 : 1));
					}
				}
			}
			//set flipped page
			_adjustFlipSize(page);
			var pos:Object	= 	page.position;
			pos.trackMouse	= 	isNaN(aimX);
			pos.aimX		= 	pos.trackMouse ? mouseX : aimX;
			pos.aimY		= 	pos.trackMouse ? mouseY : aimY;
			_flipPages.addPage(page);// [page.index]	= page;
			//trace('start: ',_flipPages);
			
			var fpEvent:FlipPagesEvent	=	new FlipPagesEvent(FlipPagesEvent.START_FLIP, page);
			fpEvent.page	=	page.page;
			dispatchEvent(fpEvent);
			return true;
		};

		/**
		* stop a flipped page, if index is null, all flipped page will be stoped, 
		* side can be 'left' or 'right'
		* @param index [optional]
		* @param finish [optional]
		* @param side [optional]
		* @return true or false
		*/
		public function stopFlip(index:int=-1, finish:Boolean=false, side:String="none"):Boolean {
			var flipped:Number		=	_flipCount;
			if (flipped == 0){
				return false;
			}
			//trace("stopFlip| index="+index+", finish="+finish+"\r"+_flipPages);
			var fpEvent:FlipPagesEvent;
			//stop all flipped pages
			var len:uint;
			if (index < 0) {
				if (finish) {
					while (_flipCount != 0) {
						len		=	_flipPages.length;
						for (var i:int = 0; i < len; i++) {
							stopFlip(_flipPages.getPageAt(i).index, true);
						}
					}
				} else {
					len		=	_flipPages.length;
					for (i = 0; i < len; i++) {
						stopFlip(_flipPages.getPageAt(i).index, false);
					}
				}
				return true;
			}
			
			//set the aim position
			//index		= Math.round(index);
			index		-= flipped < 0 ? (index%2 == 0 ? 1 : 0) : (index%2 == 0 ? 0 : -1);
			var page:FlipPage	= _flipPages.getPageByIndex(index);
			
			var pos:Object		= page.position;
			if (pos == null)	return false;
			
			var side0:int;
			
			if (pos.trackMouse != null) {
				pos.trackMouse	= null;
				side0			= {left:-1, right:1}[side];
				pos.aimX		= _pageWidth * (side0 != 0 ? side0 : pos.x < 0 ? -1 : 1);
				pos.aimY		= pos.top > 0 ? 0 : _pageHeight;
			}
			if (!finish) {
				fpEvent		=	new FlipPagesEvent(FlipPagesEvent.STOP_FLIP, page);
				//如果翻页成功, flipToFace为true
				fpEvent.flipToFace	=	page.index % 2 == 0 ? pos.x<0 : pos.x>0;
				if (_isFlipInner)	fpEvent.flipToFace	=	!fpEvent.flipToFace;
				//trace("flipToFace: " + fpEvent.flipToFace + ", index: " + page.index + ", [0|1]: " + page.index % 2 +
				//		", pos.x: "+pos.x+", side0: "+side0+", aimX: "+pos.aimX+", side:"+page.side);
				dispatchEvent(fpEvent);
				return true;
			}
			
			//finish flipping
			side0	= page.side;
			var n:Number		= _visiblePages * 2;
			//trace(pos.aimX * side0 > 0 && index == _curPage + (side0 > 0 ? -1 : 2), pos.aimX * side0< 0 && index == _curPage + (side0 > 0 ? 1 : 0) + flipped*2);
			fpEvent		=	new FlipPagesEvent(FlipPagesEvent.FINISH_FLIP, page);
			if (pos.aimX * side0 > 0 && index == _curPage + (side0 > 0 ? -1 : 2)) {//flip to the face side
				var topDepth:Number		= _topPageDepth;
				var m:Number			= flipped * -side0 * 2;
				//trace(_pages.getPageByIndex(index + side0), (index + side0), (index + n * side0), n, index, side0);
				_removePage(_pages.getPageByIndex(index + side0));
				_removePage(_pages.getPageByIndex(index + n * side0));
				
				for (var k:int = n - 2; k >= 0; k -= 2) {
					//trace("A: ", (index + k * side0), topDepth - k - (side0 > 0 ? 1 : 0));
					_swapPageDepth(index + k * side0, topDepth - k - (side0 > 0 ? 1 : 0));
				}
				for (k = 2; k < n + m; k += 2) {
					//trace("B: ", (index + (1 - k) * side0), topDepth - k + (side0 > 0 ? 2 : 1));
					_swapPageDepth(index + (1 - k) * side0, topDepth - k + (side0 > 0 ? 2 : 1));
				}
				for (k = 2; k < m; k += 2) {
					//trace("C: ", (index - k * side0), topDepth + k / 2);
					_swapPageDepth(index - k * side0, topDepth + k / 2);
				}
				
				_curPage		-= 2 * side0;
				_flipCount	+= side0;
				//trace(_flipPages, index);
				_flipPages.removePageByIndex(index);
				page.position	= null;
				
				_adjustPage(page);
				_adjustFlipSize(page);
				fpEvent.flipToFace	=	!_isFlipInner;
			} else if (pos.aimX * side0< 0 && index == _curPage + (side0 > 0 ? 1 : 0) + flipped*2) {//flip to the corner side
				_removePage(page);
				_removePage(_pages.getPageByIndex(index - (n - 1) * side0));
				_adjustPage(_pages.getPageByIndex(index + side0));
				fpEvent.flipToFace	=	_isFlipInner;
			} else {
				return false;
			}
			dispatchEvent(fpEvent);
			
			return true;
		};

		/**
		 * set flipped page's aim position, if not given, it will be set to 
		 * track mouse
		 * @usage   
		 * @param   index 
		 * @param   aimX  [optional]
		 * @param   aimY  [optional]
		 * @return  true or false
		 */
		public function setAimPos(index:int, aimX:Number=NaN, aimY:Number=NaN):Boolean {
			var page:FlipPage		= _flipPages.getPageByIndex(index);
			if (!page)	return false;
			
			var pos:Object	= page.position;
			pos.trackMouse	= isNaN(aimX);
			pos.aimX		= pos.trackMouse ? mouseX : aimX;
			pos.aimY		= pos.trackMouse ? mouseY : aimY;
			return true;
		};

		

		/**
		 * goto the specified page
		 * 
		 * @param   index        
		 * @param   rebuildPages 
		 * @return  if goto page would return true, or index is null or isn't number.
		 */
		public function gotoPage(index:uint, rebuildPages:Boolean=false):Boolean {
			//trace("gotoPage: "+index+", rebuildPages: "+rebuildPages);
			index			=	Math.floor(index / 2) * 2;
			var fPage2:int	=	Math.floor(_firstPage / 2) * 2;
			if (index < fPage2){
				index	= fPage2;
			}
			var lPage2:int	=	Math.floor(_lastPage / 2) * 2;
			if (index > lPage2){
				index	= lPage2;
			}
			
			var prop:String;
			if (_pretreating) {
				_curPage	=	index;
			} else if (rebuildPages) {
				var len:int	=	_pages.length;
				for (var i:int = 0; i < len; i++) {
					_removePage(_pages.getPageAt(i));
				}
				
				var visiblePages:Number	= _visiblePages;
				var topDepth:Number		= _topPageDepth;
				var j:uint;
				for (i = 0, j = index; i < visiblePages; i++, j-=2){
					_createPage(j, topDepth - i * 2);
				}
				for (i = 0, j = index+1; i < visiblePages; i++, j+=2){
					_createPage(j, topDepth - i * 2 - 1);
				}
				_curPage		= index;
			} else {
				stopFlip(-1, true);
				var cPage:Number	= _curPage;
				_curPage			= index;
				if (index == cPage){
					return true;
				}
				var tempPagesObje:PagesObj	= new PagesObj();
				len	=	_pages.length;
				for (i = 0; i < len; i++) {
					var page:FlipPage	=	_pages.getPageAt(i);
					j					=	page.index - cPage + index;
					page.index			=	j;
					page.name			=	"Page" + j;
					tempPagesObje.addPage(page);
				}
				_pages				=	tempPagesObje;
			}
			return true;
		};

		/**
		* set the index range of the pages
		* @param first
		* @param last
		*/
		public function setPageRange(first:int, last:int):void {
			if (last < first) {
				var t:int	= first;
				_firstPage	= last;
				_lastPage	= t;
			}else {
				_firstPage	=	first;
				_lastPage	=	last;
			}
			//trace("setPageRange: ", first, last, _firstPage, _lastPage);
			gotoPage(_curPage, true);
		};
		
		//////DEBUG
		//static public function ttObj(o:*):void {
			//for (var prop:String in o) {
				//trace(prop+" = "+o[prop]);
			//}
		//}
		//static public function listRange(obj:Object):void {
			//var str:String	=	"";
			//if (obj) {//length=4.96213726633998, angle2=45.1428819469873, type=0, cos=6.12303176911189e-17, sin=1, angle=90, a=3.5, x=116.5, y=3.5, b=3.5175, 
				//trace("length=" + obj.length + ", angle2=" + obj.angle2 + ", angle="+obj.angle+", type=" + obj.type + ", cos=" + obj.cos + 
						//", sin=" + obj.sin +	", a="+obj.a+", b="+obj.b+", x="+obj.x+", y="+obj.y);
				//trace( "type: "+obj.type, a:null, b:null, angle:null, angle2:null, length:null );
			//}else {
				//trace(obj);
			//}
		//}
	}
	
	
}