/*utf8*/
//**********************************************************************************//
//	name:	FlipCover2 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Dec 22 2009 21:22:07 GMT+0800
//	description: This file was created by "coverFlip3.fla" file.
//				
//**********************************************************************************//


//[com.wlash.puma.damouth.FlipCover2]
package  {

	import com.wlash.as3d.SimpleCube;
	import com.wlash.as3d.Vector3D;
	import fl.transitions.easing.Regular;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import gs.plugins.ShortRotationPlugin;
	import gs.plugins.TweenPlugin;
	import gs.TweenLite;
	import sandy.util.DistortImage;
	
	
	/**
	 * FlipCover2.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class FlipCover2 extends SimpleCube {
		
		public var front_mc:MovieClip;//LAYER NAME: "front", FRAME: [1-2], PATH: flipCover
		public var left_mc:MovieClip;//LAYER NAME: "left", FRAME: [1-2], PATH: flipCover
		public var right_mc:MovieClip;//LAYER NAME: "right", FRAME: [1-2], PATH: flipCover
		public var back_mc:MovieClip;//LAYER NAME: "back", FRAME: [1-2], PATH: flipCover
		
		public var vseg:int	=	2;
		public var hseg:int	=	2;
		
		private var mcArr/*String*/:Array;
		
		private var frontDistImg:DistortImage;
		private var leftDistImg:DistortImage;
		private var rightDistImg:DistortImage;
		private var backDistImg:DistortImage;
		
		private var container:Sprite;
		private var isCover:Boolean;
		private var isRotating:Boolean;
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new FlipCover2();]
		 */
		public function FlipCover2() {
			mcArr	=	["front", "right", "back"/*, "left"*/];
			//TweenPlugin.activate([ShortRotationPlugin]);
			isCover	=	true;
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		public function rotate(value:Number, sec:Number=1, clockwise:Boolean=true ):void {//shortRotation:{angleY:value}
			//if (isRotating)	return;
			TweenLite.to(this, 1, { angleY:value, ease:Regular.easeInOut,onUpdate:render, onStart:onRenderStart, onComplete:onRenderStop } );
		}
		
		public function rotateCover():void {//shortRotation:{angleY:value}
			//if (isRotating)	return;
			var value:Number	=	isCover ? 180 : 0;
			updateBmp();
			rotate(value, 2);
			isCover	=	!isCover;
		}
		
		public function updateBmp():void {
			for each(var prop:String in mcArr) {
				var bmp:BitmapData	=	getBmp(this[prop + "_mc"]);
				var distImg:DistortImage	=	this[prop + "DistImg"];
				distImg.target	=	bmp;
				distImg.initialize(vseg, hseg);
			}	
		}
		
		override public function render():void {
			var depths:Array = [];
			for each(var prop:String in mcArr) {
				var distImg:DistortImage	=	this[prop + "DistImg"];
				var side:Array	=	this[prop + "Side"];
				var centerPoint:Vector3D	=	getCenterPoint(side[1] , side[3]);
				var obj:Object	=	{ depth:centerPoint.z, mc:distImg.container };
				depths.push(obj);
				var sideArr:Array	=	sideTo2D(side);
				distImg.setTransform(sideArr[0].x, sideArr[0].y, sideArr[1].x, sideArr[1].y,
									sideArr[2].x, sideArr[2].y, sideArr[3].x, sideArr[3].y);
				//if (prop == "front") {
					//distImg.container.alpha	=	0;
					//
				//}
				//trace(obj.depth, prop, side[1],side[3]);
			}
			depths.sortOn("depth", Array.NUMERIC | Array.DESCENDING);
			renderDepth(depths);
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			container	=	addChild(new Sprite()) as Sprite;
			width3	=	front_mc.width;
			height3	=	front_mc.height;
			depth3	=	20;
			for each(var prop:String in mcArr) {
				var distImg:DistortImage	=	new DistortImage();
				distImg.smooth	=	false;
				distImg.container	=	container.addChild(new Shape());
				this[prop + "DistImg"]	=	distImg;
				this[prop + "_mc"].visible	=	false;
			}
			
			updateBmp();
			render();
		}
		
		private function getBmp(value:DisplayObject):BitmapData {
			var bmp:BitmapData	=	new BitmapData(value.width, value.height, true, 0xffffff);
			bmp.draw(value);
			return bmp;
		}
		
		private function renderDepth(depths:Array):void {
			var len:int	=	depths.length;
			for (var i:int = 0; i < len; i++) {
				var obj:Object	=	depths[i];
				container.setChildIndex(obj.mc, i);
			}
		}
		
		private function onRenderStart():void {
			isRotating	=	true;
		}
		
		private function onRenderStop():void{
			isRotating	=	false;
		}
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.puma.damouth.FlipCover2]
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
