package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	* ...
	* @author Default
	*/
	 public class  SimpleMC extends MovieClip{//dynamic
		
		//public var moveIn:Function;
		//public var moveOut:Function;
		
		//prototype.abc	=	9;
		//public var _targetFrame:Number;//Ҫ�����������������,
		//public var _targetFunc:Function;//Ҫ���Ͷ��嶯̬��(dynamic)
		
		public function SimpleMC() {
			init();
			trace("init SimpleMC");
		}
		
		private function init():void {
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut );
		}
		
		private function onOver(e:MouseEvent):void {
			
			//trace(this["abc"]=6);
			//trace(this["abc"]);
			//trace(this["_targetFrame"]);
			this["moveIn"]();
			trace(prototype["moveIn"], this["moveIn"]);
		}
		
		private function onOut(e:MouseEvent):void {
			this["moveOut"]();
		}
	}
	
}