package {
	import com.wlash.scroll.ScrollBar;
	import com.wlash.scroll.ScrollDisplayObject;
	import com.wlash.scroll.ScrollEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ScrollBarDocument extends MovieClip {
		public var btn_mc:SimpleButton;
		public var image_mc:MovieClip;
		public var scrollV_mc:MovieClip;
		public var scrollH_mc:MovieClip;
		public var scroll2_mc:MovieClip;
		public var scroll1_mc:MovieClip;
		public var scroll_com:ScrollBar;
		public var scrollObj:ScrollDisplayObject;
		public var input_txt:TextField;
		
		
		public function ScrollBarDocument() {
			scroll_com.addEventListener(ScrollEvent.SCROLL, onScroll);
			btn_mc.addEventListener(MouseEvent.CLICK, onImageClick);
			
			scroll_com.addEventListener(ScrollEvent.PRESS_THUMB, onPressThumb);
			scroll_com.addEventListener(ScrollEvent.RELEASE_THUMB, onReleaseThumb);
			scroll_com.addEventListener(ScrollEvent.SCROLL, onScrollThumb);
			//trace(sCom.eval("image_mc.image0_mc"));
			setText(30);
			setLines(10);
		}
		
		private function onScroll(e:ScrollEvent):void {
			trace(this);
		}
		
		function onPressThumb(evt:MouseEvent){
			trace(evt, evt.currentTarget);
		}

		function onReleaseThumb(evt:MouseEvent){
			trace(evt, evt.currentTarget);
			//trace(sCom.percent=0.5)
		}
		function onScrollThumb(evt:ScrollEvent){
			//trace(evt);
		}

		function setText(n){
			var str:String	=	"";
			for(var i=0;i<n;i++){
				//input_txt.appendText((i+1)+". ");
				//input_txt.appendText("\n");
				str	+=	((i+1)+". ");
			}
			input_txt.appendText(str);
			trace("maxH: "+input_txt.maxScrollH, "width: "+input_txt.width);
		}
		function setLines(n){
			var str:String	=	"";
			for(var i=0;i<n;i++){
				//input_txt.appendText((i+1)+". ");
				//input_txt.appendText("\n");
				str	+=	((i+1)+". \n");
			}
			input_txt.appendText(str);
			trace("maxV: "+input_txt.maxScrollV, "bottom: "+input_txt.bottomScrollV);
		}
		
		function onImageClick(e:MouseEvent){
			//e.currentTarget.scaleY	+=	0.2;
			//var mc:MovieClip	=	new MovieClip();
			//var gr:Graphics	=	mc.graphics;
			//gr.beginFill(0x990000);
			//gr.drawRect(0, 0, 50, mc.height+120);
			//gr.endFill();
			//image_mc.image0_mc.addChild(mc);
			image_mc.image0_mc.addChild(new image1()); 
			//trace(image_mc.width);
			scrollObj.update();
			//trace(image_mc.image0_mc.y,image_mc.image0_mc.visible);
		}
	}
}
/*
import com.wlash.scroll.ScrollBar;
import com.wlash.scroll.ScrollEvent;
var sCom:ScrollBar	=	getChildAt(numChildren-1) as ScrollBar;
sCom.addEventListener(ScrollEvent.PRESS_THUMB, onPressThumb);
sCom.addEventListener(ScrollEvent.RELEASE_THUMB, onReleaseThumb);
sCom.addEventListener(ScrollEvent.SCROLL, onScrollThumb);
//trace(sCom.eval("image_mc.image0_mc"));
setText(30);
setLines(10);
//sCom.percent=0.8;
function onPressThumb(evt:MouseEvent){
	trace(evt, evt.currentTarget);
}

function onReleaseThumb(evt:MouseEvent){
	trace(evt, evt.currentTarget);
	//trace(sCom.percent=0.5)
}
function onScrollThumb(evt:ScrollEvent){
	//trace(evt);
}

function setText(n){
	var str:String	=	"";
	for(var i=0;i<n;i++){
		//input_txt.appendText((i+1)+". ");
		//input_txt.appendText("\n");
		str	+=	((i+1)+". ");
	}
	input_txt.appendText(str);
	trace("maxH: "+input_txt.maxScrollH, "width: "+input_txt.width);
}
function setLines(n){
	var str:String	=	"";
	for(var i=0;i<n;i++){
		//input_txt.appendText((i+1)+". ");
		//input_txt.appendText("\n");
		str	+=	((i+1)+". \n");
	}
	input_txt.appendText(str);
	trace("maxV: "+input_txt.maxScrollV, "bottom: "+input_txt.bottomScrollV);
}
btn_mc.addEventListener(MouseEvent.CLICK, onImageClick);
function onImageClick(e:MouseEvent){
	//e.currentTarget.scaleY	+=	0.2;
	var mc:MovieClip	=	new MovieClip();
	var gr:Graphics	=	mc.graphics;
	gr.beginFill(0x990000);
	gr.drawRect(0, 0, 50, mc.height+120);
	gr.endFill();
	//image_mc.image0_mc.addChild(mc);
	image_mc.image0_mc.addChild(new image1());
	scrollObj.update();
}
*/