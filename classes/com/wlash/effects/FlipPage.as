//******************************************************************************
//	name:	FlipPage 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-7-23 15:57
//	description: 只能由FlipPagesBox创建
//		
//******************************************************************************



package com.wlash.effects {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import flash.utils.getDefinitionByName;
	
	
	
	/**
	 * FlipPage.
	 * <p>由FlipPagesBox创建的页面文件</p>
	 * 
	 */
	public class FlipPage extends Sprite {
		/**page index*/
		public var index:int;
		/**page*/
		public var page:Sprite;
		/**rear page*/
		public var rearPage:Sprite;
		
		internal var side:int;
		internal var face:Sprite;
		internal var pageMask:Sprite;
		internal var position:Object;
		internal var shade:Sprite;
		internal var shadow:Sprite;
		internal var shadowMask:Sprite;
		internal var shadeRatio:Number;
		
		internal var faTop:Sprite;
		internal var faBottom:Sprite;
		internal var faTopInner:Sprite;
		internal var faBottomInner:Sprite;
		
		private  var _depth:int;
		private var _displayObj:Sprite;
		private var _displayObjRear:Sprite;
		private var _buttonEnabled:Boolean;
		
		//************************[READ|WRITE]************************************//
		internal function set depth(value:int):void {
			if (value == _depth)	return;
			var pages:PagesObj	=	mainRef.pages;
			var fp:FlipPage;
			var len:uint	=	pages.length;
			for (var i:int = 0; i < len; i++) {
				fp		=	pages.getPageAt(i);
				if (fp.depth == value) {
					fp.depth++;
				}
			}
			_depth	=	value;
			var arr:Array	=	getSortPages();
			//trace(arr[0].depth, arr[arr.length - 1].depth);
			len		=	arr.length;
			var pObj:Object;//{depth, page, index}
			for (i = 0; i < len; i++) {
				pObj	=	arr[i];
				mainRef.setChildIndex(FlipPage(pObj.page), i);
			}
		}
		internal function get depth():int { return _depth; }
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private*/
		public function set buttonEnabled(value:Boolean):void {
			_buttonEnabled						= value;
			//trace(faTop, value, this);
			if (faTop) {
				faTop.buttonMode				=	
				faTop.mouseEnabled				= value;
			}
			if(faBottom){
				faBottom.buttonMode				=	
				faBottom.mouseEnabled			= value;
			}
			if(faTopInner){
				faTopInner.buttonMode			=	
				faTopInner.mouseEnabled			= value;
			}
			if(faBottomInner){
				faBottomInner.buttonMode		=	
				faBottomInner.mouseEnabled		= value;
			}
		}
		/**Annotation*/
		public function get buttonEnabled():Boolean { return _buttonEnabled; }
		//************************[READ ONLY]*************************************//
		
		
		static public var mainRef:FlipPagesBox;
		/**
		 * Construction function.<br></br>
		 * Create a class BY [new AMFResponderEvent();]
		 */
		public function FlipPage(index:int) {
			super();
			this.index	=	index;
			this.name	=	"Page" + index;
			this.side	= 	(index % 2 == 0) ? -1 : 1;
			init();
			
		}
		
		//************************[PRIVATE METHOD]********************************//
		/**
		 * Initializtion this class
		 * 
		 */
		private function init():void{
			face			=	new Sprite();
			addChild(face);
			face.name		=	"FaceMC";
			
			pageMask		=	new Sprite();
			addChild(pageMask);
			pageMask.name	=	"PageMaskMC";
			pageMask.scaleX	=	-side;
			face.mask		=	pageMask;
		}
		
		private function getSortPages():Array {
			var pages:PagesObj	=	mainRef.pages;
			var len:uint	=	pages.length;
			var pagesArr:Array	=	[];
			for (var i:int = 0; i < len; i++) {
				var page:FlipPage	=	pages.getPageAt(i);
				pagesArr.push({page:page, depth:page.depth, index:page.index});
			}
			pagesArr.sortOn("depth", Array.NUMERIC);
			return pagesArr;
		}
		//***********************[PUBLIC METHOD]**********************************//
		internal function createShade(color:uint):void {
			//shade	=	new PageShade();
			//TODO need improve
			var psClass:Class	=	getDefinitionByName("PageShade") as Class;
			shade	=	new psClass();
			var i:int	=	0;
			if (page) {
				i++;
			}
			if (rearPage) {
				i++;
			}
			face.addChildAt(shade, i);
			
			var colorTransform:ColorTransform	=	new ColorTransform();
			colorTransform.color		=	color;
			var transform:Transform		=	shade.transform;
			transform.colorTransform	=	colorTransform;
			shade.transform				=	transform;
			shade.mouseChildren			=	
			shade.mouseEnabled			=	false;
		}
		
		internal function createShadow(color:uint):void {
			var psClass:Class	=	getDefinitionByName("PageShade") as Class;
			shadow	=	new psClass();
			
			addChildAt(shadow, 0);
			
			var colorTransform:ColorTransform	=	new ColorTransform();
			colorTransform.color		=	color;
			var transform:Transform		=	shadow.transform;
			transform.colorTransform	=	colorTransform;
			shadow.transform			=	transform;
			
			shadowMask			=	new Sprite();
			addChildAt(shadowMask, 1);
			shadowMask.scaleX	=	-side;
			shadow.mask			=	shadowMask;
			shadow.mouseChildren		=	
			shadow.mouseEnabled			=	false;
		}
		
		internal function attachPage(displayObj:Sprite, isRearPage:Boolean = false):void {
			if (isRearPage) {
				if (_displayObjRear) {
					face.removeChild(_displayObjRear);
				}
				_displayObjRear			=	displayObj;
				face.addChildAt(displayObj, 0);
			}else{
				if (_displayObj) {
					face.removeChild(_displayObj);
				}
				_displayObj				=	displayObj;
				if(_displayObjRear){
					face.addChildAt(displayObj, 1);
				}else {
					face.addChildAt(displayObj, 0);
				}
			}
		}
		
		internal function removePage(isRearPage:Boolean=false):void{
			if(_displayObj && !isRearPage){
				face.removeChild(_displayObj);
				_displayObj			=	null;
			}else if (_displayObjRear && isRearPage) {
				face.removeChild(_displayObjRear);
				_displayObjRear		=	null;
			}
		}
		
		override public function toString():String {
			try{
				var childIndex:String	=	mainRef.getChildIndex(this).toString();
			}catch (e:ArgumentError) {
				childIndex	=	"FlipPage可能已经被删除| "+e.getStackTrace();
			}
			return "[FlipPage index=" + index + ", depth=" + _depth +", childIndex=" + childIndex + ", side=" + side + "]";
		}
		
		
		
		//***********************[STATIC METHOD]**********************************//
		
	}
}//end class
//This template is created by whohoo. ver 1.1.0

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]


*/
