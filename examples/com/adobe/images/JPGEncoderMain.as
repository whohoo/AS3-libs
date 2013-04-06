/*utf8*/
//**********************************************************************************//
//	name:	JPGEncoderMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Apr 21 2009 17:32:12 GMT+0800
//	description: This file was created by "JPGEncoder.fla" file.
//		http://www.2solo.cn/log/article.asp?id=523
//		http://www.2solo.cn/log/article.asp?id=526
//**********************************************************************************//



package  {

	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.*;
	import com.adobe.images.JPGEncoder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	
	/**
	 * JPGEncoderMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class JPGEncoderMain extends MovieClip {
		
		public var image_mc:Sprite;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM
		public var out_txt:TextField;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM

		private var jpgEncoder:JPGEncoder;
		private var _loader:Loader;
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new JPGEncoderMain();]
		 */
		public function JPGEncoderMain() {
			jpgEncoder	=	new JPGEncoder(50);
			_loader		=	addChild(new Loader()) as Loader;
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
			image_mc.addEventListener(MouseEvent.CLICK, onClickImage);
			image_mc.buttonMode	=	true;
		}
		
		private function onClickImage1(e:MouseEvent):void {
			var url:URLRequest	=	new URLRequest("http://www.kia-motor.com.cn/event/page/sendMail.aspx");
			var data:URLVariables	=	new URLVariables();
			data.email			=	"test@email.com,abc@email.com";//最少一个邮件地址，最多三个。
			data.cardUrl		=	"http://www.kia-motor.com.cn/event/images/upload/img/20090421/6337595013085650000.jpg";
			url.data			=	data;
            url.method			=	'post';
			var loader:URLLoader	=	new URLLoader(url);
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOerror);
		}
		
		private function onClickImage(e:MouseEvent):void {
			var bmp:BitmapData	=	new BitmapData(image_mc.width, image_mc.height);
			bmp.draw(image_mc);
			var byte:ByteArray	=	jpgEncoder.encode(bmp);
			var url:URLRequest	=	new URLRequest("http://www.kia-motor.com.cn/event/page/byteArray.aspx");
			url.data			=	byte;
            url.method			=	'post';
            url.contentType		=	"application/octet-stream";
			var loader:URLLoader	=	new URLLoader(url);
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(ProgressEvent.PROGRESS, onSaveingBmp);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onSaveHttpStatus);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSaveSecurityError);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOerror);
			
			_loader.loadBytes(byte);
		}
		
		private function onIOerror(e:IOErrorEvent):void {
			output( "onIOerror : " + e );
			
		}
		
		private function onComplete(e:Event):void {
			output( "onComplete : " + "http://www.kia-motor.com.cn"+ e.currentTarget.data );
		}
		

		private function onSaveCardStart(e:Event):void {
			output( "onSaveCardStart : " + e  );
			
		}

		
		private function onSaveingBmp(e:ProgressEvent):void {
			output( "onSaveingBmp ProgressEvent : " + e );
		}
		private function onSaveSecurityError(e:SecurityErrorEvent):void {
			output( "onSaveSecurityError : " + e );
			
		}
		private function onSaveHttpStatus(e:HTTPStatusEvent):void {
			output( "onSaveHttpStatus : " + e );
			
		}

		private function output(str:String):void {
			out_txt.appendText(str + "\r\n");
			trace(str);
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
