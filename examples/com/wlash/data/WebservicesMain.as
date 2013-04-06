/*utf8*/
//**********************************************************************************//
//	name:	WebservicesMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Apr 07 2009 16:47:47 GMT+0800
//	description: This file was created by "webservices_Sample.fla" file.
//		
//**********************************************************************************//



package  {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.wlash.data.WebService;
	import com.wlash.data.WebServicesEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	
	/**
	 * WebservicesMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class WebservicesMain extends MovieClip {
		
		private var webUrl:String	=	"http://webservices.bacardi.com/stagebacardi/Mail.asmx";
		//private var webUrl:String	=	"http://localhost:41743/FluorineFxWebsite/testWS2.asmx";
		//private var webUrl:String	=	"http://www.ecubicle.net/iptocountry.asmx";
		
		private var webServices:WebService;
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new WebservicesMain();]
		 */
		public function WebservicesMain() {
			
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
			webUrl		=	"http://www.ecubicle.net/iptocountry.asmx";
			webUrl		=	"http://localhost:41743/FluorineFxWebsite/testWS2.asmx";
			webUrl		=	"http://webservice.webxml.com.cn/WebServices/MobileCodeWS.asmx";
			webUrl		=	"http://222.44.49.230/alt/GetMessage.asmx";
			//webUrl		=	"http://ws.cdyne.com/WeatherWS/Weather.asmx";
			webServices	=	new WebService(webUrl);
			webServices.callWay	=	2;
			stage.addEventListener(MouseEvent.CLICK, onClickStage);
			webServices.addEventListener(WebServicesEvent.IO_ERROR, wsIOErrorHandler);
			webServices.addEventListener(WebServicesEvent.SECURITY_ERROR, wsSecurityErrorHandler);
			//onClickStage();
		}
		
		private function wsSecurityErrorHandler(e:WebServicesEvent):void {
			trace(e);
		}
		
		private function wsIOErrorHandler(e:WebServicesEvent):void {
			trace(e);
		}
		
		private function wsCompleteHandler(obj:*):void {
			//trace( "wsCompleteHandler : " + e, e is Event, e is WebServicesEvent );
			trace(obj);
		}
		
		private function onClickStage(e:MouseEvent = null):void {
			
			//sendMail();
			//webServices.call("GetWeatherInformation",wsCompleteHandler);
			//webServices.call("FindCountryAsString",wsCompleteHandler, "58.215.64.147");
			//webServices.call("heyString",wsCompleteHandler, "58.215.64.147");
			//webServices.call("getMobileCodeInfo",wsCompleteHandler, "137610413444","");
			//webServices.call("heyInt",wsCompleteHandler, 45);
			//webServices.call("heyObject",wsCompleteHandler, {name:"wally"});
			//webServices.call("heyDate",wsCompleteHandler, new Date());
			//webServices.call("heyVoid",wsCompleteHandler);
			webServices.call("GetDate",wsCompleteHandler, "guiwei", "guiwei", "1");
			//directCall2();
		}
		
		private function directCall2():void{
			var urlLoader:URLLoader		=	new URLLoader();
			var urlReq:URLRequest		=	new URLRequest(webUrl + "/GetDate?user=guiwei&pass=guiwei&Version=1");
			urlReq.method	=	"post";
			var varData:URLVariables	=	new URLVariables();
			varData.i	=	3;
			urlReq.data	=	varData;
			urlLoader.load(urlReq);
			urlLoader.addEventListener(Event.COMPLETE, directCallComplete);
		}
		
		private function directCall():void{
			var urlLoader:URLLoader		=	new URLLoader();
			var urlReq:URLRequest		=	new URLRequest(webUrl + "/getMobileCodeInfo?mobileCode=13761041344&userID=");
			urlReq.method	=	"post";
			var varData:URLVariables	=	new URLVariables();
			varData.i	=	3;
			urlReq.data	=	varData;
			urlLoader.load(urlReq);
			urlLoader.addEventListener(Event.COMPLETE, directCallComplete);
		}
		
		private function directCallComplete(e:Event):void {
			trace(e.target.data);
		}
		
		private function sendMail():void{
			var session:String	=	"";
			var username:String	=	"GUY";
			var url:String		=	"";
			var email:String	=	"whohoo.ho@gmail.com";
			//"<username>agency</username><password>@63ncy</password>"+session, 
			webServices.call("sendEmail", wsCompleteHandler, {username:"agency",password:"1@63ncy",session:""},
				'<![CDATA[<html xmlns="http://www.w3.org/1999/xhtml">'+
					'<head>'+
					'<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'+
					'<title>Untitled Document</title>'+
					'</head>'+
					'<body> Dear '+username + " : <br/>"+
					"这里是邮件内容<br/> " +
					"<a href='" + url + "' target='_blank' alt='Bacardi VJ master'>click</a><br/>" +
					"</body></html>]]>", 
					"如果您不能正常查看本邮件，请点击www.bacardi.com/#/china/zh 获得更多详情. ",
				("百加得，邮件主题"), email, "the_mix@bacardi.com", 12, "");
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
