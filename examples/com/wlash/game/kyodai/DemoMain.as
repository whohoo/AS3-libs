/*utf8*/
//**********************************************************************************//
//	name:	DemoMain 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Jun 21 2010 11:54:06 GMT+0800
//	description: This file was created by "Kyodai.fla" file.
//				
//**********************************************************************************//


//[DemoMain]
package  {

	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.wlash.game.kyodai.KDatas;
	import com.wlash.game.kyodai.KData;
	import com.wlash.game.kyodai.Kyodai;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	
	/**
	 * DemoMain.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class DemoMain extends MovieClip {
		public var h_mc:MovieClip;
		public var s_mc:MovieClip;
		public var out_txt:TextField;
		
		private var _line:Sprite;
		private var _bricks:Sprite;
		
		private var _firstBrick:MovieClip;
		private var kyodai:Kyodai
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new DemoMain();]
		 */
		public function DemoMain() {
			
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
			_bricks	=	new Sprite();
			
			_bricks.x	=	50;
			_bricks.y	=	50;
			addChild(_bricks);
			
			_line	=	new Sprite();
			_line.x	=	_bricks.x;
			_line.y	=	_bricks.y;
			addChild(_line);
			
			kyodai	=	new Kyodai();
			var row:int	=	6+2;
			var col:int	=	10+2;
			kyodai.init(row, col);
			kyodai.createMode1(row * col);
			//kyodai.test(0,0, 1);
			//kyodai.test(1,0, 2);
			//kyodai.test(2,0, 1);
			for (var i:int = 0; i < row; i++) {
				for (var ii:int = 0; ii < col; ii++) {
					var kd:KData	=	kyodai.getKData(i, ii);
					var mc:MovieClip	=	createBrick("" + kd.state);
					mc.stop();
					kd.data	=	mc;
					mc.kd	=	kd;
					_bricks.addChild(mc);
					mc.x	=	30 * ii;
					mc.y	=	40 * i;
					mc.addEventListener(MouseEvent.CLICK, _onClick);
					if (kd.state == 0)	mc.alpha	=	.3;
				}
			}
			
			//shuffle btn
			s_mc.addEventListener(MouseEvent.CLICK, _onClickS);
			s_mc.buttonMode	=	true;
			s_mc.stop();
			s_mc.name_txt.mouseEnabled	=	false;
			s_mc.name_txt.text	=	"S";
			//help btn
			h_mc.addEventListener(MouseEvent.CLICK, _onClickH);
			h_mc.buttonMode	=	true;
			h_mc.stop();
			h_mc.name_txt.mouseEnabled	=	false;
		}
		
		private function _onClickS(e:MouseEvent):void {
			kyodai.shuffle();
		}
		
		private function _onClickH(e:MouseEvent):void {
			var obj:Object	=	kyodai.getHint();
			if (obj) {
				obj.kd0.data.gotoAndStop(2);
				obj.kd1.data.gotoAndStop(2);
			}else {
				out_txt.text	=	"no ?? !!" + obj;
				trace("no??!! "+obj);
			}
		}
		
		private function _onClick(e:MouseEvent):void {
			var mc:MovieClip	=	e.currentTarget as MovieClip;
			if (!_firstBrick) {
				_firstBrick	=	mc;
				_firstBrick.gotoAndStop(2);
			}else {
				mc.gotoAndStop(2);
				var t:Number	=	getTimer();
				var link:Object	=	kyodai.checkLink(_firstBrick.kd, mc["kd"]);
				//trace( "link : " + link.link, link.path );
				if (link.link) {
					drawLine(link.path);
					kyodai.clearKData(_firstBrick.kd, mc.kd);
					_firstBrick.visible	=	false;
					mc.visible	=	false;
					out_txt.text	=	"match!";
					if (kyodai.isWin) {
						trace("WIN!!");
						out_txt.text	=	"Win!!";
						
					}else if (!kyodai.hasPath) {
						trace("no Path");
						out_txt.text	=	"no Path, pls press [S] to shuffle.";
					}
					
				}else {
					trace( "link : " + link.link, link.path );
					out_txt.text	=	"NOT match.";
				}
				out_txt.appendText(" TIME: "+(getTimer()-t)+"ms");
				mc.gotoAndStop(1);
				_firstBrick.gotoAndStop(1);
				_firstBrick	=	null;
			}
		}
		
		private function createBrick(value:String):MovieClip {
			var mc:MovieClip	=	new brick() as MovieClip;
			mc.name_txt.text	=	value;
			return mc;
		}
		
		private function drawLine(arr:Array):void {
			var g:Graphics	=	_line.graphics;
			g.clear();
			var len:int	=	arr.length;
			if (len == 0)	return;
			var kd:KData	=	arr[0];
			var mc:MovieClip	=	kd.data as MovieClip;
			g.lineStyle(1, 0xff0000);
			g.moveTo(mc.x, mc.y);
			for (var i:int = 1; i < len; i++) {
				kd	=	arr[i];
				mc	=	kd.data as MovieClip;
				g.lineTo(mc.x, mc.y);
			}
			g.endFill();
		}
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.game.kyodai.DemoMain]
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
