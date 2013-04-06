/*utf8*/
//**********************************************************************************//
//	name:	ListBox0 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Wed Jan 06 2010 20:42:48 GMT+0800
//	description: This file was created by "login.fla" file.
//				
//**********************************************************************************//


//[com.wlash.puma.effects.ListBox0]
package com.wlash.effects {

	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	//import gs.TweenLite;
	
	
	
	/**
	 * ListBox0.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class ListBox0 extends Sprite {
		
		public var up_btn:SimpleButton;//LAYER NAME: "up", FRAME: [1-2], PATH: listbox folder/listbox content
		public var down_btn:SimpleButton;//LAYER NAME: "down", FRAME: [1-2], PATH: listbox folder/listbox content

		[Inspectable(defaultValue=".2", type="Number", verbose="0")]
		public var easeValue:Number	=	.2;
		
		[Inspectable(defaultValue="8", type="Number", verbose="0")]
		public var maxItem:int	=	8;
		
		[Inspectable(defaultValue="listbox0.Item", type="String", verbose="0")]
		public var itemName:String	=	"listbox0.Item";
		
		private var _itemHeight:Number;
		private var _data:Array;
		private var _maskMC:Shape;
		private var _listMC:Sprite;
		private var _ItemClass:Class;
		private var _curIndex:int;
		private var _tPos:Number;
		private var _sPos:Number;//start position, _curIndex=0;
		private var _onShowingFn:Function;
		private var _clickItem:Sprite;
		private var _isHover:Boolean;
		//private var _movePathArr:Array;
		//*************************[READ|WRITE]*************************************//
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		public function set active(value:Boolean):void {
			mouseChildren	=	
			mouseEnabled	=	value;
		}
		
		//*************************[READ ONLY]**************************************//
		/**Annotation*/
		public function get clickItem():Sprite { return _clickItem; }
		
		public function get clickName():String { return _clickItem["name_txt"].text; }
		
		/**Annotation*/
		public function get clickIndex():int { return _clickItem ? _clickItem["index"] : -1; }
		
		public function get data():Array { return _data};
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ListBox0();]
		 */
		public function ListBox0() {
			
			_init();
			//addEventListener(Event.ENTER_FRAME, _delay1Frame, false, 0, true);
			
		}
		
		//private function _delay1Frame(e:Event):void {
			//removeEventListener(Event.ENTER_FRAME, _delay1Frame, false);
			//
			//var arr:Array	=	["北京", "上海", "广州", "长沙", "武汉", "郑州", "大连", "哈尔滨", "成都", "南京", "沈阳"];
			//arr.length	=	4;
			//setData(arr);
			//show();
		//}
		//*************************[PUBLIC METHOD]**********************************//
		public function setData(value:Array):void {
			_data	=	value;
			_clearItems();
			_createList(value);
		}
		
		public function show():void {
			_clickItem	=	null;
			visible	=	true;
			active	=	false;
			_tPos	=	_sPos;
			_onShowingFn	=	_onShowFn;
			addEventListener(Event.ENTER_FRAME, _onShowing, false, 0, true);
			removeEventListener(Event.ENTER_FRAME, _onChanging);
			//TweenLite.to(_listMC, .3, {y:_tPos, onUpdate:_onUpdateRender, onComplete:_onComplete});
			addEventListener(MouseEvent.ROLL_OVER, _onOver);
			addEventListener(MouseEvent.ROLL_OUT, _onOut);
			stage.addEventListener(MouseEvent.MOUSE_UP, _onClickStage, false);
		}
				
		public function hide():void {
			_tPos	=	down_btn.y-down_btn.height;
			_onShowingFn	=	_onHideFn;
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onClickStage, false);
			addEventListener(Event.ENTER_FRAME, _onShowing, false, 0, true);
			removeEventListener(Event.ENTER_FRAME, _onChanging);
			//TweenLite.to(_listMC, .3, {y:_tPos, onUpdate:_onUpdateRender, onComplete:_onComplete});
		}
		
		public function showItem(value:uint):Boolean {
			var len:int	=	_data.length;
			if (len <= maxItem)	return	false;
			if (value>=len-maxItem)	return	false;
			if (_curIndex == value)	return false;
			_tPos	=	_sPos - value * _itemHeight;
			_curIndex	=	value;
			addEventListener(Event.ENTER_FRAME, _onChanging, false, 0, true);
			removeEventListener(Event.ENTER_FRAME, _onShowing);
			return true;
		}
		
		public function moveUp():Boolean {
			var ret:Boolean	=	true;
			if ((_curIndex+1) >= (_data.length - maxItem)) {
				ret	=	false;
			}
			showItem(_curIndex + 1);
			return ret;
		}
		
		public function moveDown():Boolean {
			var ret:Boolean	=	true;
			if (_curIndex <=1) {
				ret	=	false;
			}
			showItem(_curIndex - 1);
			return ret;
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			visible	=	false;
			down_btn.y	=	0;
			up_btn.y	=	down_btn.y - down_btn.height-up_btn.height;
			//try{
				//_ItemClass	=	getDefinitionByName(itemName) as Class;
				_ItemClass		=	root.loaderInfo.applicationDomain.getDefinition(itemName) as Class;
			//}catch (err:Error) {
				//trace(err);
			//}
			
			_maskMC		=	new Shape();
			_listMC		=	new Sprite();
			addChildAt(_listMC,0);
			addChildAt(_maskMC,1);
			_drawMask();
			_maskMC.visible	=	false;
			_listMC.mask	=	_maskMC;
			//_maskMC.x	=	-5;
			_maskMC.y		=	down_btn.y - down_btn.height;
			
			var mc:Sprite	=	new _ItemClass() as Sprite;
			_itemHeight		=	mc.height;
			_maskMC.width	=	mc.width;
			
			
			_initBtnEvents();
		}
		
		private function _createList(arr:Array):void {
			var len:int		=	arr.length;
			var mc:Sprite	=	null;
			for (var i:int = 0; i < len; i++) {
				mc	=	new _ItemClass() as Sprite;
				_listMC.addChild(mc);
				mc["bg_mc"].gotoAndStop(i % mc["bg_mc"].totalFrames + 1);
				mc["index"]		=	i;
				mc["name_txt"].text	=	arr[i];
				mc.y	=	i * _itemHeight;
				TextField(mc["name_txt"]).mouseEnabled	=	false;
				mc.addEventListener(MouseEvent.CLICK, _onClickBtnItem);
				mc.buttonMode	=	true;
			}
			if (i > maxItem) {
				i	=	maxItem;
			}else {
				up_btn.mouseEnabled	=
				up_btn.enabled		= false;
			}
			down_btn.mouseEnabled	=
			down_btn.enabled		=	false;
			
			_sPos	=	-down_btn.height - i * _itemHeight;
			//up_btn.y	=	_sPos - up_btn.height;
			_maskMC.height	=	0;
			
			//_maskMC.height	=	-_sPos;
		}
		
		private function _clearItems():void{
			var len:int	=	_listMC.numChildren;
			while (len--) {
				_listMC.removeChildAt(0);
			}
		}
		
		private function _drawMask():void {
			var g:Graphics	=	_maskMC.graphics;
			g.beginFill(0, .5);
			
			g.drawRect( -50, -100, 100, 100);
			g.endFill();
		}
		
		private function _onChanging(e:Event):void {
			var diff:Number	=	_listMC.y - _tPos;
			_listMC.y	-=	diff * easeValue;
			if (Math.abs(diff) < 1) {
				removeEventListener(Event.ENTER_FRAME, _onChanging);
				_listMC.y		=	_tPos;
			}
		}
		
		
		
		private function _onUpdateRender():void {
			_maskMC.height	=	-_listMC.y - down_btn.height;
			up_btn.y		=	_listMC.y - up_btn.height;
		}
		
		private function _onComplete():void{
			_maskMC.height	=	-_listMC.y - down_btn.height;
			up_btn.y		=	_listMC.y - up_btn.height;
			if(_onShowingFn!=null){
				_onShowingFn();
				_onShowingFn	=	null;
			}
		}
		
		private function _onShowing(e:Event):void {
			var diff:Number	=	_listMC.y - _tPos;
			_listMC.y	-=	diff * easeValue;
			_onUpdateRender();
			if (Math.abs(diff) < .5) {
				removeEventListener(Event.ENTER_FRAME, _onShowing);
				_listMC.y		=	_tPos;
				_maskMC.height	=	_tPos - down_btn.height;
				if(_onShowingFn!=null){
					_onShowingFn();
					_onShowingFn	=	null;
				}
			}
		}
		
		private function _onShowFn():void {
			active	=	true;
			_curIndex	=	0;
		}
		
		private function _onHideFn():void {
			visible	=	false;
		}
		
		private function _onClickBtnItem(e:MouseEvent):void {
			_clickItem	=	e.currentTarget as Sprite;
			e.stopImmediatePropagation();
			hide();
			dispatchEvent(new Event("onClickItem"));
		}
		
		private function _onClickStage(e:MouseEvent):void {
			if (!_isHover) {
				_clickItem	=	null;
				hide();
			}
		}
		
		private function _onOver(e:MouseEvent):void {
			_isHover	=	true;
		}
		
		private function _onOut(e:MouseEvent):void {
			_isHover	=	false;
		}
		///////////////////////////////Begin Initialize Buttons/////////////////////////////////////////
		/**
		 * initialize SimpleButton events.
		 * @internal AUTO created by JSFL.
		 */
		private function _initBtnEvents():void {
			up_btn.addEventListener(MouseEvent.CLICK, _onClickBtn, false);
			//up_btn.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtn, false);
			//up_btn.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtn, false);
			
			down_btn.addEventListener(MouseEvent.CLICK, _onClickBtn, false);
			//down_btn.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtn, false);
			//down_btn.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtn, false);
			
		};
		
		/**
		 * SimpleButton click event.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _onClickBtn(e:MouseEvent):void {
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "up_btn" : 
					if (!moveUp()) {
						btn.mouseEnabled	=	
						btn.enabled		=	false;
					}
					down_btn.mouseEnabled	=	
					down_btn.enabled	=	true;
				break;
				case "down_btn" : 
					if (!moveDown()) {
						btn.mouseEnabled	=	
						btn.enabled		=	false;
					}
					up_btn.mouseEnabled	=	
					up_btn.enabled	=	true;
				break;
			};
			e.stopImmediatePropagation();
		};
		
		/**
		 * SimpleButton rollover event.
		 * @param e MouseEvent.
		 * @internal AUTO created by JSFL.
		 */
		private function _onRollOverBtn(e:MouseEvent):void {
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "up_btn" : 
					
				break;
				case "down_btn" : 
					
				break;
			};
		};
		
		/**
		 * SimpleButton rollout event.
		 * @internal AUTO created by JSFL.
		 */
		private function _onRollOutBtn(e:MouseEvent):void {
			var btn:SimpleButton	=	e.currentTarget as SimpleButton;
			switch(btn.name) {
				case "up_btn" : 
					
				break;
				case "down_btn" : 
					
				break;
			};
		};
		///////////////////////////////End Initialize Buttons/////////////////////////////////////////

		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.puma.effects.ListBox0]
//This template is created by whohoo. ver 1.3.0

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]

		[Inspectable(defaultValue="", type="String", verbose="1", name="_targetInstanceName", category="")]
		private var _targetInstanceName:String;


*/
