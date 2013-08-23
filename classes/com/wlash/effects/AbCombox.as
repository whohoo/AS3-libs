/*utf8*/
//**********************************************************************************//
//	name:	ComboxSeason 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Wed Feb 24 2010 11:38:16 GMT+0800
//	description: This file was created by "media.fla" file.
//				
//**********************************************************************************//


//[com.wlash.etam.media.AbCombox]
package com.wlash.effects {

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	import com.wlash.scroll.SimpleScrollBar;
	
	
	/**
	 * ComboxSeason.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AbCombox extends AbBaseCombox {
		
		public var scroll_com:SimpleScrollBar
		public var scroll_mc:Sprite;
		public var content_mc:Sprite;//LAYER NAME: "content", FRAME: [2-7], PATH: combox green
		
		///可显示的items数量
		protected var _showItemNum:int;
		///(totalItemNum - _showItemNum = 可滚动的数量)
		protected var _scrollItemNum:int;
		protected var _curIndex:int;
		protected var _datas:Array;
		protected var _defaultName:String;
		//*************************[READ|WRITE]*************************************//

		
		//*************************[READ ONLY]**************************************//
		/**Annotation*/
		public function get selectedIndex():int { return _curIndex; }
		
		public function get totalItemNum():int {
			if (_datas) {
				return _datas.length;
			}else {
				return -1;
			}
		}
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ComboxSeason();]
		 */
		public function AbCombox() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		override public function reset():void {
			super.reset();
			name_txt.text	=	_defaultName;
			_curIndex	=	-1;
		}
		
		public function setData(value:Array):void {
			_datas	=	value;
			_scrollItemNum	=	_datas.length - _showItemNum;
			
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		
		//*************************[PROTECTED METHOD]*******************************//
		protected function _showData(value:int):void {
			
		}
		
		override protected function _onSelectItem():void {
			close();
			super._onSelectItem();
		}
		
		//override protected function _onClickBtn(e:MouseEvent):void {
			//var mc:MovieClip	=	e.currentTarget as MovieClip;
			//_curIndex		=	mc["index"];
			//
			//super._onClickBtn(e);
		//}
		
		//protected function _onOverBtn(e:MouseEvent):void {
			//var mc:MovieClip	=	e.currentTarget as MovieClip;
			//mc["moveIn"]();
		//}
		//
		//protected function _onOutBtn(e:MouseEvent):void {
			//var mc:MovieClip	=	e.currentTarget as MovieClip;
			//mc["moveOut"]();
		//}
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			_curIndex		=	-1;
			_defaultName	=	name_txt.text;
			
			
		}
		
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.etam.media.ComboxSeason]
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
