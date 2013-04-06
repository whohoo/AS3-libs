package {
	
	import com.wlash.utils.Debug;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class DebugMain extends MovieClip {
		public var a_mc:Sprite;
		public var test_txt:TextField;
		var mcFather:Sprite;
		var mcChild:MovieClip
		var mcLoader:Loader
		
		public function DebugMain() {
			var a:uint	=	12;
			a++;
			//trace(getQualifiedClassName(a_mc), typeof a);
			//trace(getQualifiedSuperclassName(a_mc), typeof a);
			var b	=	true;
			createMc();
			//trace(mcChild.parent.name);
			//trace(Debug.targetPath(mcChild));
			var color:ColorTransform	=	new ColorTransform();
			color.color	=	0xdd882d;
			//Debug.tt(color);
			//var date:Date	=	new Date();
			//Debug.tt(date);
			//var arr:Array	=	[1, 2, 4, 5, 98, "sta"];
			//Debug.tt(mcFather.transform.matrix);
			//Debug.tt(new Point());
			//Debug.tt(mcFather.getBounds(this));
			var sound:Sound	=	new Sound();
			var dic:Dictionary	=	new Dictionary();
			dic.a	=	"abc";
			dic.b	=	123;
			Debug.tt(dic);
			var ab:String	;
			//trace(typeof(ab), ab is String, getQualifiedClassName(ab), ab ===null, ab==undefined);
			Debug.tt(a_mc);
			addEventListener(Event.ENTER_FRAME, function(e:Event) {
						//Debug.tt(loaderInfo);
						//trace(mcLoader.loaderInfo.swfVersion, mcLoader.loaderInfo.loader);
						removeEventListener(Event.ENTER_FRAME, arguments.callee);
					});
		}
		
		private function createMc():void {
			mcFather	=	new Sprite();
			addChild(mcFather);
			mcFather.name	=	"father_mc";
			
			mcChild		=	new MovieClip();
			mcFather.addChild(mcChild);
			
			mcLoader	=	new Loader();
			mcChild.addChild(mcLoader);
			
		}
	}
}