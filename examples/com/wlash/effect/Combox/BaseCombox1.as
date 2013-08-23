/*utf8*/
//**********************************************************************************//
//	name:	BaseCombox 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Thu Apr 28 2011 12:10:21 GMT+0800
//	description: This file was created by "promotion.fla" file.
//				
//**********************************************************************************//


//[com.wlash.puma.running2011.BaseCombox]
package  {

	import com.wlash.effects.AbCombox;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * BaseCombox.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class BaseCombox1 extends AbCombox {
		
		public var arrow_mc:Sprite;//LAYER NAME: "arrow down", FRAME: [1-7], PATH: combox green
		public var mask_mc:MovieClip;//LAYER NAME: "mask", FRAME: [2-7], PATH: combox green
		
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new BaseCombox();]
		 */
		public function BaseCombox1() {
			_showItemNum	=	7;
			_defaultName	=	"选择省份";
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		override protected function onInit():void {
			super.onInit();
			content_mc.mask	=	mask_mc;
			
			_showData(0);
			var total:int	=	totalItemNum;
			var len:int	=	total > _showItemNum ? _showItemNum : total;
			for (var i:int = 0; i < len; i++) {
				var mc:MovieClip	=	content_mc["item" + i];
				mc.addEventListener(MouseEvent.ROLL_OVER, _onOverItem);
				mc.addEventListener(MouseEvent.ROLL_OUT, _onOutItem);
				mc.addEventListener(MouseEvent.CLICK, _onClickItem);
			}
			
			
		}
		
		override protected function onEnd():void {
			super.onEnd();
			if (_scrollItemNum<=0) {//滚动条不可见
				scroll_mc.visible	=	false;
			}else {
				scroll_com.addEventListener("scroll", _onScroll);
				scroll_mc["thumb_mc"].buttonMode	=	true;
			}
		}
		
		override protected function _showData(value:int):void {
			super._showData(value);
			var len:int	=	_showItemNum;
			for (var i:int = 0; i < len; i++) {
				var itemName:String = _datas[i + value];
				if (!itemName) {
					itemName	=	"";
				}
				content_mc["item" + i].name_txt.text	=	itemName;
			}
		}
		
		override public function open():void {
			super.open();
			if (currentFrame != totalFrames) {
				play();
			}
		}
		
		override public function close():void {
			super.close();
			gotoAndStop(1);
			addEventListener("enterFrame", function(e:Event):void {//delay ONE frame to excute...
					removeEventListener("enterFrame", arguments.callee);
					_onClose();
				} );
			
		}
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
		}
		
		private function _onScroll(e:Event):void {
			var n:int	=	int(scroll_com.percent * _scrollItemNum);
			_showData(n);
		}
		
		private function _onOverItem(e:MouseEvent):void {
			var mc:MovieClip	=	e.currentTarget as MovieClip;
			mc.gotoAndStop(2);
		}
		
		private function _onOutItem(e:MouseEvent):void {
			var mc:MovieClip	=	e.currentTarget as MovieClip;
			mc.gotoAndStop(1);
		}
		
		private function _onClickItem(e:MouseEvent):void {
			var mc:MovieClip	=	e.currentTarget as MovieClip;
			name_txt.text	=	mc.name_txt.text;
			_onSelectItem();
		}
		

		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.puma.running2011.BaseCombox]
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
