/*utf8*/
//**********************************************************************************//
//	name:	Content 2.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Sun Aug 09 2009 20:58:58 GMT+0800
//	description: This file was created by "main.fla" file.
//				v1.2 增加了destroy方法
//				v2.0 把一些方法再分到AbLoader类中
//**********************************************************************************//


//[com.wlash.skoda.superb.Content]
package com.wlash.loader {

	import flash.display.DisplayObject;
	

	
	/**
	 * Content.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AbContent extends AbLoader {

	
		private var _isExcuteShowWoShow:Boolean;
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new Content();]
		 */
		public function AbContent() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		override public function loadContent(url:String, showFn:Function = null):void {
			super.loadContent(url, showFn);
			_isExcuteShowWoShow	=	false;
		}
		
		override public function unloadCurLoader():void {
			var mc:DisplayObject	=	curContent;
			if (!mc) return;
			if(mc.hasOwnProperty("destroy")){
				mc["destroy"]();
			}
			if (curLoader.hasOwnProperty("unloadAndStop")) {
				curLoader["unloadAndStop"]();
			}else {
				super.unloadCurLoader();//curLoader.unload();
			}
		}

		override public function showContent(...args:*):void {
			if(!_isExcuteShowWoShow){
				showContentWithoutShow();
			}
			var mc:DisplayObject	=	curContent;
			if (mc.hasOwnProperty("show")) {
				mc["show"].apply(null, args);
			}
		}
		
		public function showContentWithoutShow():void {
			unloadCurLoader();
			curLoader			=	preLoader;
			curLoader.visible	=	true;
			var mc:DisplayObject	=	curContent;
			if (mc.hasOwnProperty("showWithoutPlay")) {
				mc["showWithoutPlay"]();
			}
			_isExcuteShowWoShow	=	true;
		}
		

		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
		}
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.skoda.superb.Content]
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
