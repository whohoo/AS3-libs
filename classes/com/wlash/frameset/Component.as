/*utf8*/
//**********************************************************************************//
//	name:	Component 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	2010/4/19 14:19
//	description: This file was created by "videoplayer.fla" file.
//		
//**********************************************************************************//



package com.wlash.frameset {

	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * Component.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class Component extends Sprite {
		
		//*************************[READ|WRITE]*************************************//
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new VideoControl();]
		 */
		public function Component() {
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		/**
		 * 因为AS3不再支持eval事件，此函数为代替品。
		 * @example <listing version="3.0">
		 * 		var man_mc:DisplayObject	=	eval("earth_mc.car_mc.man_mc");
		 * <listing>
		 * @param	value　要eval的路径点路径。
		 * @return 如果对象存在，返回对象，否则返回<code>null</code>
		 */
		protected function eval(value:String):DisplayObject {
			var path:Array	=	value.split(".");
			var len:int		=	path.length - 1;
			var timeline:DisplayObjectContainer	=	parent;// as DisplayObjectContainer;
			var retObj:DisplayObject;
			var arrRet:Boolean	=	path.every(
						function(item:String, index:uint, array:Array):Boolean {
							retObj		=	timeline.getChildByName(item);
							timeline	=	retObj as DisplayObjectContainer;
							if (timeline == null) {//如果不能再包括子对象,
								if (index == len) {//如果已经到最后了,则算是完成.
									return	true;
								}else{//否则,路径不正确.
									return	false;
								}
							}else {//还能再包括子对象,继续查找子对象.
								return true;
							}
						}, null);
			return	arrRet ? retObj : null;
		}
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
		}
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}


//end class
//This template is created by whohoo. ver 1.2.1

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
