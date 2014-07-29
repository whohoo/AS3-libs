//******************************************************************************
//	name:	SceenAlign 1.2
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2010/10/12 12:03
//	description: source from xyz.
//		v1.2 add min and max bounds
//		v1.1 当x或y轴方向没有改变时，就不要使用Tweenlite去移动
//			 移动的TweenLite移到init中判断，
//			 对Tweenlite增加了overwrite,此值班为0(false),就是不会覆盖原来的tweenlite
//******************************************************************************


//[com.wlash.frameset.ScreenAlign]
package controls {	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	//import flash.display.StageAlign;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * @author 		xyz
	 * @version		自适应舞台类：Align 1.0
	 * email:		xxxyyyzzzhi@163.com
	 * 日期:		2009.09.29 准备回老家过节咯
	 * description	这家伙很懒，什么也没留下
	 * 用法：	
			import com.wlash.frameset.ScreenAlign;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			ScreenAlign.init(stage, new Rectangle(0, 0, 1250, 850);	
			//设置舞台原始区域
			ScreenAlign.rate = .3;
			//自适应缓动的速度,默认为0.5
			ScreenAlign.add(logo_mc, StageAlign.BOTTOM_RIGHT); 
			//设置需要自适应的元件和对齐方式,默认为左上对齐
	 */ 
	public class ScreenAlign {		    
		
		static public var rate		=	0.5;
		
		static private var _stageRect:Rectangle;
		static private var stage:Stage;
		static private var mcArr:Array = [];
		
		static private var _isInit:Boolean;
		static private var _pause:Boolean;
		static private var _visible:Boolean;
		static private var _twClass:Class;
		
		static private var _diffX:Number;
		static private var _diffY:Number;
		//*************************[READ|WRITE]*************************************//
		/**Annotation*/
		static public function get pause():Boolean { return _pause; }
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		static public function set pause(value:Boolean):void {
			_pause	=	value;
			if (value) {
				_onStageResize(null);
			}
		}
		
		/**Annotation*/
		static public function get visible():Boolean { return _visible; }
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		static public function set visible(value:Boolean):void {
			_visible	=	value;
			var len:int = mcArr.length;
			for (var i:int = 0; i < len; i++) {
			//for each(var obj:Object in mcArr){
				var obj:Object = mcArr[i];
				if(obj["mc"]){
					obj["mc"].visible	=	value;
				}
			}
		}
		//*************************[READ ONLY]**************************************//
		/**Annotation*/
		static public function get stageRect():Rectangle { return _stageRect; }
		
		static public function get diffX():Number { return _diffX; }
		static public function get diffY():Number { return _diffY; }
		
		//*************************[STATIC]*****************************************//
		
		
		
		//*************************[PUBLIC METHOD]**********************************//
		static public function init(s:Stage, stageRect:Rectangle):Boolean {
			if (_isInit)	return true;
			if (s == null) throw new Error("ERROR: stage is null.");
			s.scaleMode 	=	"noScale";
			stage			=	s;
			_stageRect		=	stageRect;
			startAlign();
			
			try{
				_twClass	=	getDefinitionByName("com.greensock.TweenLite") as Class;
			}catch (e:Error) { };
			
			_isInit	=	true;
			return true;
		}
		
		static public function startAlign():void {
			stage.addEventListener(Event.RESIZE, _onStageResize);
			_onStageResize(null);
		}
		
		static public function stopAlign():void {
			stage.removeEventListener(Event.RESIZE, _onStageResize);
		}
		
		/**
		 * @param mc
		 * @param align
		 * @param props {minX,maxX,minY,maxY}
		 */
		static public function add(mc:DisplayObject, align:String = "TL", props:Object=null):void {  
			if (mc) {
				var obj:Object	=	{ mc:mc, align:align.toUpperCase() , x:mc.x, y:mc.y };
				for(var name:String in props){
					obj[name] = props[name];
				}
				mcArr.push(obj  );
				_renderMc(obj);
			}
		}
		
		static public function remove(mc:DisplayObject):void {  
			var len:int = mcArr.length;
			for (var i:int = 0; i < len; i++) {
				var obj:Object = mcArr[i];
				if (obj.mc == mc) {
					mcArr.splice(i, 1);
					break;
				}
			}
		}
		
		//*************************[PRIVATE METHOD]**********************************//
		static private function _onStageResize(e:Event):void { 
			if (_pause)	return;
			_diffX	=	stage.stageWidth - _stageRect.width;
			_diffY	=	stage.stageHeight - _stageRect.height;
			var len:int = mcArr.length;
			for (var i:int = 0; i < len; i++) {
			//for each(var obj:Object in mcArr){
				var obj:Object = mcArr[i];
				if (!_renderMc(obj)) {
					mcArr.splice(i, 1);
				}
			}
			
		}
		
		static private function _renderMc(obj:Object):Boolean {
			var mc:DisplayObject	=	obj.mc;
			if (!mc)	return	false;
			var gox:Number = mc.x;
			var goy:Number = mc.y;
			switch (obj.align) {
				case "T":// StageAlign.TOP:
					goy = obj.y - _diffY * .5;
					break; 
				case "B"://StageAlign.BOTTOM:
					goy = obj.y + _diffY * .5;
					break; 
				case "L"://StageAlign.LEFT:
					gox = obj.x - _diffX * .5; 
					break; 
				case "R"://StageAlign.RIGHT:
					gox = obj.x + _diffX * .5; 
					break;  
				case "TL"://StageAlign.TOP_LEFT:
					goy = obj.y - _diffY * .5;
					gox = obj.x - _diffX * .5; 
					break; 
				case "TR"://StageAlign.TOP_RIGHT:
					goy = obj.y - _diffY * .5;
					gox = obj.x + _diffX * .5; 
					break; 
				case "BL"://StageAlign.BOTTOM_LEFT:
					goy = obj.y + _diffY * .5;
					gox = obj.x - _diffX * .5; 
					break; 
				case "BR"://StageAlign.BOTTOM_RIGHT:
					goy = obj.y + _diffY * .5;
					gox = obj.x + _diffX * .5; 
					break;  
				//default:
					//goy = obj.y - _diffY * .5;
					//gox = obj.x - _diffX * .5; 
					//break;
			}   
			
			if(obj.minX && gox<obj.minX){
				gox = obj.minX;
			}else if(obj.maxX && gox>obj.maxX){
				gox = obj.maxX;
			}
			
			if(obj.minY && goy<obj.minY){
				goy = obj.minY;
			}else if(obj.maxY && gox>obj.maxY){
				goy = obj.maxY;
			}
			var twClass:Class	=	_twClass;
			
			if (twClass) {
				var twObj:Object	=	{overwrite:0 };
				var isTween:Boolean;
				if (mc.x != gox) {
					twObj.x	=	gox;
					isTween	=	true;
				}
				if (mc.y != goy) {
					twObj.y	=	goy;
					isTween	=	true;
				}
				if (isTween)	twClass["to"](mc, rate, twObj );
			}else {
				mc.x	=	gox;
				mc.y	=	goy;
			}
			return true;
		}
		
		
	}
}