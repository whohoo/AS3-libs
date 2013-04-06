/*utf8*/
//**********************************************************************************//
//	name:	WPMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Thu Oct 28 2010 17:43:30 GMT+0800
//	description: This file was created by "index.fla" file.
//				
//**********************************************************************************//


//[com.wlash.frameset.AbMain]
package com.wlash.frameset {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;
	
	
	
	/**
	 * WPMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AbMainDocument extends MovieClip {
		
		protected var _version:String	=	"1.0";
		protected var _prevDeepLink:String;
		protected var _curDeepLink:String;
		protected var _isIgnoreSWFAddress:Boolean;
		
		//*************************[READ|WRITE]*************************************//
		public function set curDeepLink(value:String):void {
			_prevDeepLink	=	_curDeepLink;
			_curDeepLink	=	value;
		}
			
		/**Annotation*/
		public function get curDeepLink():String { return _curDeepLink; }
		
		/**@private */
		public function set active(value:Boolean):void {
			//trace( "active : " + value );
			
			mouseChildren	=	
			mouseEnabled	=	value;
		}
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new WPMain();]
		 */
		public function AbMainDocument() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		protected function startFirstLoading():void {
			stop();
		}
		
		protected function initialize():void {
			stop();
			
		}
		
		protected function _initContextMenu():void {
			var item:ContextMenuItem = new ContextMenuItem("Ver. "+_version);
			item.enabled		=	false;
			var cm:ContextMenu	=	new ContextMenu();
			var cmbi:ContextMenuBuiltInItems;
			cm.hideBuiltInItems();//把默认菜单全部隐藏．
			cmbi			=	cm.builtInItems;
			cmbi.quality	=	true;//除了品质菜单外.
			cm.builtInItems	=	cmbi;
			cm.customItems.push(item);
			//this["contextMenu"]	=	cm;
			this.contextMenu	=	cm;
		}
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			stage.scaleMode	=	"noScale";
			
		}
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.puma.wp2010.WPMain]
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
