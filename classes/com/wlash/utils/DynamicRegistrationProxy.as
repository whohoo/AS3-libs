//******************************************************************************
//	name:	DynamicRegistrationProxy 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-1-7 16:37
//	description: 使影片具有根据xReg与yReg注册点来移动(x2,y2),缩放(scaleX2, scaleX2),
//	转动(rotation2),及当前mouse坐标(mouseX2, mouseX2)只读
//	在AS3版本中,因为不能为类添加可监视的属性,所以只能通过prototype来添加set, get方法,
//	如setX2, getX2, setScaleX2, getRotation2....
//******************************************************************************

// special thanks to Robert Penner (www.robertpenner.com) for providing the
// original code for this in ActionScript 1 on the FlashCoders mailing list



package com.wlash.utils {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import com.wlash.exception.InitError;
	
	[IconFile("DynamicRegistration.png")]
	/**
	* movieclip always rotation on (0,0) when change value of movieclip._rotation.
	* <p>
	* but you could try "com.idescn.utils.DynamicRegistration.initialize()" <br></br>
	* make movieclip had another properties of move, scale, rotation,<br></br>
	* that x2,y2,scaleX2,scaleY2,rotation2,mouseX2,mouseY2 and so on.<br></br>
	* change those value of properties would rotation or sclae by a new Registration point<br>
	* </br></p>
	*  when this class is initialized, all DisplayObject has below Functions:
	* <ul>
	*   <li>getX2()</li>
	*	<li>setX2(value)</li>
	* 	<li>getY2()</li>
	*	<li>setY2(value)</li>
	* 	<li>getScaleX2()</li>
	*	<li>setScaleX2(value)</li>
	* 	<li>getScaleY2()</li>
	*	<li>setScaleY2(value)</li>
	*	<li>getRotation2()</li>
	*	<li>setRotation2(value)</li>
	*	<li>getMouseX2()</li>
	*	<li>getMouseY2()</li>
	* </ul>
	* add below properties to DisplayObject if get DsiplayObject Proxy by new DynamicRegistrationProxy(obj).
	* <ul>
	* 	<li>xReg</li>
	*	<li>yReg</li>
	* 	<li>x2</li>
	*	<li>y2</li>
	* 	<li>sclaeX2</li>
	*	<li>sclaeY2</li>
	* 	<li>rotation2</li>
	*	<li>mouseX2[read only]</li>
	*	<li>mouseY2[read only]</li>
	* </ul>
	* @exmaple 
	* <b>sample:</b>
	* <listing>
	* com.wlash.utils.DynamicRegistrationProxy.initialize();//all DisplayObject
	* target_mc.xReg	=	21;
	* target_mc.xReg	=	50;
	* target_mc.setRotation2(23);
	* //or 
	* var drr:DynamicRegistrationProxy	=	new com.wlash.utils.DynamicRegistrationProxy(target_mc);//
	* //change movieclip new registration point
	* drr.xReg	=	30;//default 0, it would same as _xscale when _xscale2 changed
	* drr.yReg	=	60;//ditto
	* drr.scalseX	=	0.5;
	* </listing>
	* <p>NOTE:</p>
	* special thanks to Robert Penner (www.robertpenner.com) for providing the
	* original code for this in ActionScript 1 on the FlashCoders mailing list.
	*/
	dynamic public class DynamicRegistrationProxy extends Proxy {
		private var _obj:DisplayObject;
		/**
		 * indicate is that initialize this class.
		 */
		public static var isInit:Boolean;
		
		/**
		 * make DisplayObject has DynamicRegistration properties and functions.
		 * 
		 * <p>initiallize target(movieclip), make target had properties of move, scale, rotation<br></br>
		 * if not point out which movieclip you wannna, it would make all movieclips<br></br>
		 * had those properties.</p>
		 * 
		 * @param   target if not movieclip or not undefined, it would regist <br></br>
		 * 		MovieClip.prototype, that means all movieclip would had those <br></br>
		 * 		properties.
		 * @return  <code>true</code> if success, or <code>false</code>
		 * @throws com.wlash.exception.InitError throws InitError, if some functions are defined by other.
		 * @see com.wlash.exception.InitError
		 */
		public static function initialize():Boolean {
			if (isInit)	return true;
			var o:Object	=	Object(DisplayObject.prototype);
			if(o.setPropRel!=null){
				throw new InitError("DisplayObject.setPropRel was defined. [com.wlash.utils.DynamicRegistrationProxy]");
				return false;
			}
			initPrototypeFunction(o);
			
			
			return isInit	=	true;
		}
		

		prototype.setPropRel = function(property:String, amount:Number):void {
			var p:Point		=	DynamicRegistrationProxy.getRegPoint(this);
			var p0:Point	=	this.parent.globalToLocal (this.localToGlobal (p));
			this[property]	=	amount;
			var p1:Point	=	this.parent.globalToLocal (this.localToGlobal (p));
			this.x -= p1.x - p0.x;
			this.y -= p1.y - p0.y;
		}
		
		prototype.getX2 = function():Number {
			var p:Point		=	DynamicRegistrationProxy.getRegPoint(this);
			return this.parent.globalToLocal(this.localToGlobal(p)).x;
		}
		
		prototype.setX2 = function(value:Number):void {
			if (isNaN(value)) {
				throw new TypeError("at " + this.name + ".setX2(" + value + ":" + typeof(value) +
							"), Argument must be Number");
			}
			var p:Point		=	DynamicRegistrationProxy.getRegPoint(this);
			this.x += value - this.parent.globalToLocal(this.localToGlobal(p)).x;
		}

		prototype.getY2 = function():Number {
			var p:Point		=	DynamicRegistrationProxy.getRegPoint(this);
			return this.parent.globalToLocal(this.localToGlobal(p)).y;
		}
		
		prototype.setY2 = function(value:Number):void {
			if (isNaN(value)) {
				throw new TypeError("at " + this.name + ".setY2(" + value + ":" + typeof(value) +
							"), Argument must be Number");
			}
			var p:Point		=	DynamicRegistrationProxy.getRegPoint(this);
			this.y += value - this.parent.globalToLocal(this.localToGlobal(p)).y;
		}
		
		prototype.setScaleX2 = function(value:Number):void {
			if (isNaN(value)) {
				throw new TypeError("at " + this.name + ".setScaleX2(" + value + ":" + typeof(value) +
							"), Argument must be Number");
			}
			this.setPropRel("scaleX", value);
		}
		
		prototype.getScaleX2 = function():Number {
			return this.scaleX;
		}
		
		prototype.setScaleY2 = function(value:Number):void {
			if (isNaN(value)) {
				throw new TypeError("at " + this.name + ".setScaleY2(" + value + ":" + typeof(value) +
							"), Argument must be Number");
			}
			this.setPropRel("scaleY", value);
		}
		
		prototype.getScaleY2=function():Number {
			return this.scaleY;
		}
		
		prototype.setRotation2 = function(value:Number):void {
			if (isNaN(value)) {
				throw new TypeError("at " + this.name + ".setRotation2(" + value + ":" + typeof(value) +
							"), Argument must be Number");
			}
			this.setPropRel("rotation", value);
		}
		
		prototype.getRotation2=function():Number {
			return this.rotation;
		}
		
		prototype.getMouseX2=function():Number {
			return this.mouseX - this.xReg;
		}
		
		prototype.getMouseY2=function():Number {
			return this.mouseY - this.yReg;
		}
		
		private static function initPrototypeFunction(o:Object):void {
			var p:Object		=	DynamicRegistrationProxy.prototype;
			
			p.xReg				=	
			p.yReg				=	
			o.xReg				=	
			o.yReg				=	0;
			
			o.setPropRel		=	p.setPropRel;
			o.getX2				=	p.getX2;
			o.setX2				=	p.setX2;
			o.getY2				=	p.getY2;
			o.setY2				=	p.setY2;
			
			o.setScaleX2		=	p.setScaleX2;
			o.getScaleX2		=	p.getScaleX2;
			o.setScaleY2		=	p.setScaleY2;
			o.getScaleY2		=	p.getScaleY2;
			
			o.setRotation2		=	p.setRotation2;
			o.getRotation2		=	p.getRotation2;
			
			o.getMouseX2		=	p.getMouseX2;
			o.getMouseY2		=	p.getMouseY2;
		}
		
		public static function getRegPoint(obj:DisplayObject):Point {
			var x:Number	=	obj["xReg"];
			var y:Number	=	obj["yReg"];
			if (isNaN(x) || isNaN(y)) {
				throw new TypeError("at name: "+obj.name+"|"+obj+"[DynamicRegistrationProxy], TYPE of property xReg[" + x +
						"] or yReg["+y+"] is not Number.");
			}
			return new Point(x, y);
		}
		
		/**
		 * CONSTRUCT FUNCTION.
		 * create a DisplayObject Proxy.
		 * @param obj
		 * @example 
		 * sample code:
		 * <listing>
		 * var drr:DynamicRegistrationProxy	=	new DynamicRegistrationProxy(target_mc);
		 * 
		 * </listing>
		 */
		public function DynamicRegistrationProxy(obj:DisplayObject) {
			if (!isInit) {
				if (obj["setPropRel"] == null) {
					//initPrototypeFunction(obj);
					obj["xReg"]	=	
					obj["yReg"]	=	0;
					obj["setPropRel"]	=	DynamicRegistrationProxy.prototype.setPropRel;
				}
			}
			
			_obj	=	obj;
		}
		
		override flash_proxy function callProperty(methodName:*, ... args):* {
			var ret:*;
			//trace(methodName);
			switch (methodName.toString()) {//除了setPropRel(),不要把其它函数写到obj内去.
				case "setX2":
				case "setX2":
				case "setY2":
				case "getY2":
				
				case "setScaleX2":
				case "getScaleX2":
				case "setScaleY2":
				case "getScaleY2":
				
				case "setRotation2":
				case "getRotation2":
				
				case "getMouseX2":
				case "getMouseY2":
				
					ret = DynamicRegistrationProxy.prototype[methodName].apply(_obj, args);
					break;
				default:
					ret = _obj[methodName].apply(_obj, args);
			}
			
			return ret;
		}

		override flash_proxy function getProperty(name:*):* {
			var ret:*;
			var p:Object	=	DynamicRegistrationProxy.prototype;
			switch (name.toString()){
				case "x2":
					ret	=	p.getX2.apply(_obj);
					break;
				case "y2":
					ret	=	p.getY2.apply(_obj);
					break;
				case "scaleX2":
					ret	=	p.getScaleX2.apply(_obj);
					break;
				case "scaleY2":
					ret	=	p.getScaleY2.apply(_obj);
					break;
				case "rotation2":
					ret	=	p.getRotation2.apply(_obj);
					break;
				default:
					ret	=	_obj[name];
			}
			return ret;
		}

		override flash_proxy function setProperty(name:*, value:*):void {
			var p:Object	=	DynamicRegistrationProxy.prototype;
			switch (name.toString()){
				case "x2":
					p.setX2.call(_obj, value);
					break;
				case "y2":
					p.setY2.call(_obj, value);
					break;
				case "scaleX2":
					p.setScaleX2.call(_obj, value);
					break;
				case "scaleY2":
					p.setScaleY2.call(_obj, value);
					break;
				case "rotation2":
					p.setRotation2.call(_obj, value);
					break;
				default:
					_obj[name] = value;
			}
			
		}
		//不知道有什么用???!!!
		override flash_proxy function nextNameIndex (index:int):int {
			return 0;
		}
		override flash_proxy function nextName(index:int):String {
			 return "";
		}
		//TypeError
		override flash_proxy function hasProperty(name:*):Boolean{
			return true;
		}
		//TypeError
		override flash_proxy function isAttribute(name:*):Boolean{
			return true;
		}
		/**
		 * show this class
		 * 
		 * @return
		 */
		public function toString():String{
			return "obj name: "+_obj.name+" "+_obj+"[DynamicRegistrationProxy]";
		}
	}
}