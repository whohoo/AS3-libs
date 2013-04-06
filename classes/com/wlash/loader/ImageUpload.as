/*utf8*/
//**********************************************************************************//
//	name:	ImageUpload 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Apr 20 2009 21:37:12 GMT+0800
//	description: This file was created by "diy_card.fla" file.
//		
//**********************************************************************************//

//[com.wlash.loader.ImageUpload]

package com.wlash.loader {

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;

	import flash.net.FileFilter;
	
	
	/**
	 * ImageUpload.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class ImageUpload extends SimpleImageUpload {
		public var mask_mc:DisplayObject;
		
		private var _scale:Number;
		//*************************[READ|WRITE]*************************************//
		
		//*************************[READ ONLY]**************************************//
		/**Annotation*/
		public function get scale():Number { return _scale; }
		
		//*************************[STATIC]*****************************************//
		static public const FILE_TYPE_ALL:FileFilter	=	new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
		static public const FILE_TYPE_PNG:FileFilter	=	new FileFilter("PNG (*.png)", "*.png");
		static public const FILE_TYPE_JPG:FileFilter	=	new FileFilter("JPG (*.jpg, *.jpeg)", "*.jpg;*.jpeg");
		static public const FILE_TYPE_GIF:FileFilter	=	new FileFilter("GIF (*.gif)", "*.gif");
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ImageUpload();]
		 */
		public function ImageUpload() {
			super();
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		/**
		 * set image mask
		 * @param	mc
		 */
		public function setMask(mc:DisplayObject):void {
			content.mask	=	mc;
			mask_mc			=	mc;
			if (mask_mc) {
				_centerImage();
			}
		}
		
		public function getImageData():BitmapData {
			var bmp:BitmapData	=	new BitmapData(mask_mc.width, mask_mc.height, true, 0xffffffff);
			bmp.draw(this, null, null, null, null, smoothing);
			return bmp;
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		override protected function onImageLoaded():void {
			if (mask_mc == null || _contentImg == null)	return;
			var w:Number	=	mask_mc.width;
			var h:Number	=	mask_mc.height;
			if (_contentImg.width * h > w * _contentImg.height) {
				content.height	=	h;
				content.scaleX	=	content.scaleY;
			}else {
				content.width	=	w;
				content.scaleY	=	content.scaleX;
			}
			_scale		=	content.scaleX;
			_loader.x	=	-_loader.width * .5;
			_loader.y	=	-_loader.height * .5;
		}
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			content.mask	=	mask_mc;
			if (mask_mc) {
				_centerImage();
			}
		}
		
		private function _centerImage():void {
			var rect:Rectangle	=	mask_mc.getBounds(this);
			content.x	=	rect.width * .5 + rect.left;
			content.y	=	rect.height * .5 + rect.top;
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
