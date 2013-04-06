/*utf8*/
//**********************************************************************************//
//	name:	ColorAverageMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Sat Apr 04 2009 01:04:03 GMT+0800
//	description: This file was created by "ColorAverage.fla" file.
//		
//**********************************************************************************//



package  {

	import fl.controls.Slider;
	import fl.data.DataProvider;
	import fl.events.ColorPickerEvent;
	import fl.events.SliderEvent;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import fl.controls.ColorPicker;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.wlash.utils.ColorAverage;
	import flash.text.TextField;
	
	
	/**
	 * ColorAverageMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class ColorAverageMain extends MovieClip {
		
		public var colorPick_mc:ColorPicker;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: DOM
		public var slider_mc:Slider;
		
		private var colors:Array;
		private var colorContainer:Sprite;
		private var colAv:ColorAverage;
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ColorAverageMain();]
		 */
		public function ColorAverageMain() {
			colors	=	[];
			colAv	=	new ColorAverage();
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
			//var colAv:ColorAverage	=	new ColorAverage([0x2, 0x0]);
			//trace(colAv);
			colorContainer	=	addChild(new Sprite()) as Sprite;
			colorContainer.x	=	4;
			colorContainer.y	=	200;
			colorPick_mc.addEventListener(ColorPickerEvent.CHANGE, onChangeColor);
			slider_mc.addEventListener(SliderEvent.CHANGE, onSliderChange);
		}
		
		private function onSliderChange(e:SliderEvent=null):void {
			colAv.colors	=	(colors.concat());
			colAv.pct		=	slider_mc.value;
			
			var mc:Sprite	=	addColor2(colAv.color);
			mc.x	=	(colorContainer.width-colorContainer.x) * slider_mc.value+colorContainer.x;
			mc.y	=	colorContainer.y+40;
		}
		
		private function onChangeColor(e:ColorPickerEvent):void {
			addColor(e.color);
			onSliderChange();
		}

		private function addColor(col:int):Sprite {
			var mc:Sprite	=	colorContainer.addChild(new Sprite()) as Sprite;
			var g:Graphics	=	mc.graphics;
			g.beginFill(col);
			g.drawRect(0, 0, 50, 10);
			g.endFill();
			mc.x	=	colors.length * 51;
			colors.push(col);
			var txt:TextField	=	mc.addChild(new TextField()) as TextField;
			txt.text	=	formateColor(col);
			txt.y	=	12;
			
			return mc;
		}
		
		private function addColor2(col:int):Sprite {
			var mc:Sprite	=	getChildByName("averageColMC") as Sprite;
			var txt:TextField;
			if(!mc){
				mc 		=	addChild(new Sprite()) as Sprite;
				mc.name	=	"averageColMC";
				txt		=	mc.addChild(new TextField()) as TextField;
				txt.y	=	12;
			}else {
				txt		=	mc.getChildAt(0) as TextField;
			}
			var g:Graphics	=	mc.graphics;
			g.beginFill(col);
			g.drawRect(0, 0, 60, 10);
			g.endFill();
			
			
			txt.text	=	formateColor(col);
			
			return mc;
		}
		
		private function formateColor(col:int):String{
			var r:String = formateNum(col >> 16 & 255);
            var g:String = formateNum(col >> 8 & 255);
            var b:String = formateNum(col & 255);
			return "0x" + r + g + b;
		}
		private function formateNum(n:int):String {
			if (n > 10) {
				return n.toString(16);
			}else {
				return "0" + n;
			}
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
