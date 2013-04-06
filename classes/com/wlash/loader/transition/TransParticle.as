
package com.wlash.loader.transition{
	//import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	//import flash.display.Sprite;
	import flash.events.EventDispatcher;
	//import flash.text.TextField;
	//import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	//import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	//import flash.events.MouseEvent;

	//import flash.utils.getTimer;
	//import flash.util.trace;
	/**
	 * 很Cool的切换效果, 但没完成.
	 * <p>
	 * 没完成,事件dispatchEvent(new Event(TRANS_FINISH));还没有广播,所以在ContentLoader不
	 * 能换位,此类要分为两为过程,一粒子消失过程,另一过程是重新组合,此类不能应用大的的对象,
	 * 机器会跑不动,具体可参考particleCloud例子.
	 * PS一年前那瘤,今天爆发了,冲动!!为什么,这样的结局一年前就被预言了,已经没有挽回的余地,
	 * 偏偏在这时候爆发,工作不稳定,存款没有,家里悲剧,一起赶上了.一个教训吧.</p>
	 */
	public class TransParticle extends EventDispatcher implements ITransEffect{
		/**
		 * 当切换效果方法结束时的广播名称.
		 */
		public static const TRANS_FINISH:String	=	"transFinish";
		private const EYEANGLE: int = 25;
		private const DISTANCE: int = 100;
		
		//private const IDENTITY: Matrix = new Matrix();
		private const origin: Point = new Point();
		private const blur: BlurFilter = new BlurFilter( 4, 4, 1 );//shadow, disapeared slowly
		private const brighten: ColorTransform = new ColorTransform( 1, 1, 1, 1, 0,0, 0, -32 );//
		
		private var obj0:DisplayObject;
		private var obj1:DisplayObject;
			
		private var pixels0: Array;
		private var pixels1: Array;
		//private var source: BitmapData;
		public  var output: BitmapData;
		private var buffer: BitmapData;
		
		//private var fpsText: TextField;
		//private var fps: int;
		//private var ms: int;
		
		private var mx: Number;
		private var my: Number;
		private var timer: Timer;
		
		/**
		 * 构建一个切换效果对象.
		 * @param	second 多少秒后完成切换效果.默认为1秒.
		 */
		public function TransParticle(second:Number=20){
			timer	=	new Timer(second);
			timer.addEventListener( TimerEvent.TIMER, show );
			
			mx = 0;
			my = 0;
		}
		
		
		
		private function show( event: TimerEvent ): void	{
			buffer.colorTransform( buffer.rect, brighten );
			buffer.applyFilter( buffer, buffer.rect, origin, blur );
			
			//-- clamp angles
			if ( mx < -Math.PI ) {
				mx += Math.PI * 2;
			}else if ( mx > +Math.PI ) {
				mx -= Math.PI * 2;
			}
			if ( my < -Math.PI ) {
				my += Math.PI * 2;
			}else if ( my > +Math.PI ) {
				my -= Math.PI * 2;
			}
			
			if( true )	{
				// force mouse
				mx += ( 100 - 300 / 2 ) / 1000;
				my -= ( 100 - 300 / 2 ) / 1000;
			}else{
				// force origin
				mx *= .9;
				my *= .9;
			}
			
			rotate( my, mx );
			var pixels:Array	=	pixels0;
			var i: uint = pixels.length;
			var pixel: Pixel;
			
			var sx: int;
			var sy: int;
			var p: Number;
			
			while( --i > -1 ){
				pixel = pixels[i];
				
				if( pixel.rz > -DISTANCE ){ // clipping
					p = EYEANGLE / ( pixel.rz + DISTANCE );
					
					sx = int( pixel.rx * p + .5 ) + 300/2;
					sy = int( pixel.ry * p + .5 ) + 300/2;
					
					buffer.setPixel32( sx, sy, pixel.c );
				}
			}
			
			output.copyPixels( buffer, buffer.rect, origin );
			
		}
		
		private function rotate( ax: Number, ay: Number ): void{
			var tx: Number;
			var ty: Number;
			var tz: Number;
			
			var sinax: Number = Math.sin( ax );
			var cosax: Number = Math.cos( ax );
			var sinay: Number = Math.sin( ay );
			var cosay: Number = Math.cos( ay );
			
			var pixels:Array	=	pixels0;
			var i: uint = pixels.length;
			var p: Pixel;
			while( --i > -1 ){
				p = pixels[i];
				
				ty = p.wy * cosax - p.wz * sinax;
				tz = p.wy * sinax + p.wz * cosax;
				p.ry = ty;
				
				tx = p.wx * cosay + tz * sinay;
				p.rz = tz * cosay - p.wx * sinay;
				p.rx = tx;
			}
		}
		
		private function create(bmp:BitmapData): Array{
			var sw: uint = bmp.width;
			var sh: uint = bmp.height;
			
			var x: Number;
			var y: Number;
			var z: Number;
			var c: uint;//getPixel32()
			var p: Number;
			
			var pixels:Array	=	[];
			var pixel: Pixel;
			for( var sy:uint = 0 ; sy < sh ; sy++ ){
				for( var sx:uint = 0 ; sx < sw ; sx++ ){
					c	=	bmp.getPixel32( sx, sy );
					if( ( ( c >> 24 ) & 0xff ) > 0 ){// kill trans pixel
						//-- play here --//
						z = Math.random() * 400 - 100 + DISTANCE;
						//z = .01 * 400 - 100 + DISTANCE;
						//---------------//
						
						p = EYEANGLE / z;
						x = ( sx - sw/2 ) / p;
						y = ( sy - sh/2 ) / p;
						
						pixel = new Pixel( x, y, z - DISTANCE, c );
						
						pixels.push( pixel );
					}
				}
			}
			
			//trace("pixels.length:", pixels.length );
			return pixels;
		}
		
		/**
		 * @private 
		 * 此方法会在ContentLoader类当中自动调用.
		 * @param	obj0
		 * @param	obj1
		 */
		public function trans(obj0:DisplayObject, obj1:DisplayObject):void {
			this.obj0	=	obj0;
			this.obj1	=	obj1;
			var bmp0:BitmapData	=	new BitmapData(obj0.width, obj0.height);
			bmp0.draw(obj0);
			pixels0		=	create(bmp0);
			if(!(obj1.width==0 || obj1.height==0)){
				var bmp1:BitmapData	=	new BitmapData(obj1.width, obj1.height);
				bmp1.draw(obj1);
				pixels1		=	create(bmp1);
				
				buffer		=	bmp0.clone();
				output		=	buffer.clone();
				timer.start();
			}
			
		}
	}
}

	class Pixel{
		public var wx: Number;
		public var wy: Number;
		public var wz: Number;
		public var rx: Number;
		public var ry: Number;
		public var rz: Number;
		
		public var c: uint;
		
		public function Pixel( x: Number, y: Number, z: Number, c: uint ){
			wx = x;
			wy = y;
			wz = z;
			
			this.c = c;
		}
	}
