/*utf8*/
//**********************************************************************************//
//	name:	Flipbox 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Tue Nov 04 2008 23:53:29 GMT+0800
//	description: This file was created by "FlipPageBox_src.fla" file.
//		
//**********************************************************************************//



package  {

	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import com.wlash.effects.FlipPagesBox;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	
	/**
	 * Flipbox.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class Flipbox extends Sprite {
		
		public var flipPages_mc:FlipPagesBox;//LAYER NAME: "Layer 1", FRAME: [1-2], PATH: flipbox
		public var left_btn:SimpleButton;
		public var right_btn:SimpleButton;
		
		private var pressBtn:SimpleButton;
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new Flipbox();]
		 */
		public function Flipbox() {
			
			init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function init():void {
			listeningEvents();
			this.addEventListener(Event.ENTER_FRAME, autoSway);
			//autoSway();
			//right_btn.addEventListener(MouseEvent.CLICK, onClick, true);
		}
		
		private function autoSway(e=null):void {
			var curPage:int	=	flipPages_mc.curPage;
			flipPages_mc.startFlip(curPage + 1, "bottom", 168, 250);
			this.removeEventListener(Event.ENTER_FRAME, autoSway);
			pressBtn	=	right_btn;
		}
		
		private function listeningEvents():void {
			left_btn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			right_btn.addEventListener(MouseEvent.ROLL_OVER, onOver);
			
		}
		
		private function onClick(e:MouseEvent):void {
			trace( "onClick : " + onClick );
			
		}
		
		private function onDown(e:MouseEvent):void {
			e.currentTarget.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			
			left_btn.removeEventListener(MouseEvent.ROLL_OVER, onOver);
			right_btn.removeEventListener(MouseEvent.ROLL_OVER, onOver);
			
			//e.currentTarget.addEventListener(MouseEvent.MOUSE_UP, onUp, true)
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp, false);//释放事件
		}
		
		private function onUp(e:MouseEvent):void {
			if (e.target == pressBtn) {
				trace("other page");
			}else {
				flipPages_mc.stopFlip();
			}
			pressBtn	=	null;
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp, false);
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoving);
			listeningEvents();
		}
		
		private function onOver(e:MouseEvent):void {
			var p:Point	=	new Point(e.stageX, e.stageY);
			p			=	flipPages_mc.globalToLocal(p);
			
			if(pressBtn!=e.currentTarget){
				flipPages_mc.stopFlip( -1, true);
			}
			
			pressBtn	=	e.currentTarget as SimpleButton;
			var curPage:int	=	flipPages_mc.curPage;
			var ret:Boolean;
			if (e.currentTarget == left_btn) {
				ret	=	flipPages_mc.startFlip(curPage, "bottom", p.x, p.y);
			}else {
				ret	=	flipPages_mc.startFlip(curPage + 1, "bottom", p.x, p.y);
			}
			
			
			addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoving);//监听移动动作
			e.currentTarget.addEventListener(MouseEvent.ROLL_OUT, onOut);//移出事件
			e.currentTarget.addEventListener(MouseEvent.MOUSE_DOWN, onDown);//按下事件
		}
		private function onOut(e:MouseEvent):void {
			var curPage:int	=	flipPages_mc.curPage;
			if (e.currentTarget == left_btn) {
				flipPages_mc.stopFlip();
			}else {
				flipPages_mc.stopFlip();
			}
			removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoving);//不监听移动动作
			e.currentTarget.removeEventListener(MouseEvent.ROLL_OUT, onOut);
			e.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		
		private function _onMouseMoving(e) {
			var p:Point	=	new Point(e.stageX, e.stageY);
			p	=	flipPages_mc.globalToLocal(p);
			
			var curPage:int	=	flipPages_mc.curPage;
			if (pressBtn == right_btn) {
				curPage	++;
			}
			var ret	=	flipPages_mc.startFlip(curPage, "bottom", p.x, p.y);
			
		}
				
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class
//This template is created by whohoo. ver 1.2.0

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
