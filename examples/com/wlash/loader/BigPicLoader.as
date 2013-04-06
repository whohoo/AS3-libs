/*utf8*/
//**********************************************************************************//
//	name:	BigshoeLoader 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Thu Jun 23 2011 14:18:21 GMT+0800
//	description: This file was created by "vans_legend.fla" file.
//				
//**********************************************************************************//



package  {

	import com.wlash.loader.AbImageLoader2;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;

	
	
	
	/**
	 * BigshoeLoader.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class BigPicLoader extends AbImageLoader2 {
		
		public var loading_mc:Sprite;
		public var image_mc:Sprite;
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new BigshoeLoader();]
		 */
		public function BigPicLoader() {
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		override protected function _createContainer():void {
			//super._createContainer();
			_container	=	image_mc;
		}
		
		override protected function openHandler(e:Event):void {
			super.openHandler(e);
			
		}
		
		override protected function completeHandler(e:Event):void {
			super.completeHandler(e);
			_setFitToMask(preLoader, true);
			//_setLoaderCenter(preLoader);
		}
		
		override protected function _onSwitchImageDone():void {
			super._onSwitchImageDone();
			
			mouseScroll	=	true;
			
		}
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			_setContainerCenter();
		}
		
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.vans.legend.shoe.BigshoeLoader]
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
