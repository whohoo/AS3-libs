/*utf8*/
//**********************************************************************************//
//	name:	AMFDataMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Sep 28 2009 14:25:32 GMT+0800
//	description: This file was created by "AMFData.fla" file.
//				
//**********************************************************************************//


//[.AMFDataMain]
package  {

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	//created by JSFL | author whohoo@21cn.com
	import com.wlash.data.AMFData;
	import com.adobe.images.JPGEncoder;
	
	/**
	 * AMFDataMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class AMFDataMain extends MovieClip {
		
		public var image_mc:MovieClip;

		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new AMFDataMain();]
		 */
		public function AMFDataMain() {
			
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
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, send);
		}
		
		private function send(e:MouseEvent = null) {
			var jpgEncoder:JPGEncoder	=	new JPGEncoder(90);
			var bmp:BitmapData	=	new BitmapData(image_mc.width, image_mc.height);
			bmp.draw(image_mc);
			var byte:ByteArray	=	jpgEncoder.encode(bmp);
			trace( "byte : " + byte.length );
			
			//var url:String	=	"http://localhost:8080/winterpackage/SubmitImage";
			var url:String	=	"http://localhost:8080/winterpackage/CreateBag";
			var req:URLRequest	=	AMFData.getURLRequest(url, "testw4",byte);
			var urlLoader:URLLoader	=	new URLLoader(req);
			urlLoader.dataFormat	=	URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, onLoaded);
		}
		
		private function onLoaded(e:Event):void {
			var obj:Object	=	AMFData.getResponse(e.currentTarget["data"]);
			trace( "obj : " + obj );
			
		}
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [.AMFDataMain]
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
