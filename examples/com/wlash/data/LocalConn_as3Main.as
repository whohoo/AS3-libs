/*utf8*/
//**********************************************************************************//
//	name:	As3Main 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Aug 24 2009 15:14:45 GMT+0800
//	description: This file was created by "as3.fla" file.
//				
//**********************************************************************************//


//[com.wlash.testing.As3Main]
package  {

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import com.wlash.data.LocalConn;
	
	/**
	 * As3Main.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class LocalConn_as3Main extends MovieClip {
		public var result_txt:TextField;
		public var click_btn:SimpleButton;
		
		
		private var _localConn:LocalConn;
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new As3Main();]
		 */
		public function LocalConn_as3Main() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		public function test3(... args:*):String {
			trace([ "test3 : " + (args[2] is Object), args, args.length]);
			showMsg(args[0]);
			if(args[2]){
				_localConn.call(args[2], null, "i form AS2 " + args[0]);
			}
			return "i am from AS3 " + args[0];
		}
		
		public function onResult(d):void {
			trace( "onResutl3 : " + d );
			
		}
		public function onStatus():void{
			
		}
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			_localConn			=	new LocalConn("AS3", "AS2");
			_localConn.client	=	this;
			
			click_btn.addEventListener(MouseEvent.CLICK, _onClick);
		}
		
		private function _onClick(e:MouseEvent):void {
			
			//_localConn.call("test2", {result:'onResult', status:'onStatus'}, "[from AS3]", new Date());
			//_localConn.call("test2", 'onResult', "[from AS3]", new Date());
			_localConn.call("onResult", null, "[from AS3]");
		}
		
		private function showMsg(value:String):void {
			result_txt.text	=	value+"\r";
		}
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.testing.As3Main]
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
