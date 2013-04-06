/*utf8*/
//**********************************************************************************//
//	name:	SecurityMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Mar 24 2009 14:36:39 GMT+0800
//	description: This file was created by "security.fla" file.
//		在IDE里或设置了信任目录或SWF文件的，Security.sandboxType的值是为Local trust
//
//		在网络上，Security.sandboxType的值总是remote
//
//		在本地player里，如果发布设置为“本地”，则不能访问网络，会弹出窗口询问让你设置
//		本地文件是可能随意访问。
//
//		如果发布设置为“网络”，也不能访问网络，加载后会收到SecurityErrorEvent安全错误。
//		错误提示为:安全沙箱冲突, 可通过在网站上crossdomain.xml文件解决此问题
//		如果访问本地文件，直接try...catch到SecurityError的错误。
//**********************************************************************************//



package com.wlash.test {

	import flash.display.MovieClip;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * SecurityMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class SecurityMain extends MovieClip {
		
		public var out_txt:TextField;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM

		
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		static public const DOMAIN:String	=	"http://blog.wlash.com/";
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new SecurityMain();]
		 */
		public function SecurityMain() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			//Security.exactSettings
			outMsg( "Security.exactSettings : " + Security.exactSettings );
			outMsg( "Security.sandboxType : " + Security.sandboxType );
			//Security.allowDomain("*");
			//Security.loadPolicyFile(DOMAIN+"crossdomain.xml");
			stage.addEventListener(MouseEvent.CLICK, onClickStage);
		}
		
		private function loadText():void {
			var urlLoader:URLLoader	=	new URLLoader();
			outMsg("start load text");
			try {
				urlLoader.load(new URLRequest(DOMAIN+"test.txt"));
			}catch (err:SecurityError) {
				outMsg("SecurityError: "+err);
			}catch (err:Error) {
				outMsg("Error: "+err);
			}
			urlLoader.addEventListener(Event.COMPLETE, onTextLoaded);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			outMsg("end load text");
		}
		
		private function onClickStage(e:MouseEvent):void {
			loadText();
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void {
			outMsg("onSecurityError: "+e);
		}
		
		private function onTextLoaded(e:Event):void {
			var urlLoader:URLLoader	=	e.currentTarget as URLLoader;
			outMsg(urlLoader.data as String);
		}
		
		
		private function outMsg(str:*):void {
			str	=	str.toString();
			out_txt.appendText(str + "\r\n");
			out_txt.scrollH	=	out_txt.maxScrollH;
		}
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class
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
