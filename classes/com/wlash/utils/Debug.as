//******************************************************************************
//	name:	Debug 2.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri May 19 15:02:43 2006
//	description: debug code,
//******************************************************************************



package com.wlash.utils {
	import flash.display.AVM1Movie;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MorphShape;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.ID3Info;
	import flash.media.Microphone;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.StaticText;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.display.Shape;
	import flash.media.Video;
	import flash.media.Sound;
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	
	[IconFile("Debug.png")]
	/*
	* a method can intead of _global.trace(obj)
	* <p></p>
	* to use this method, you must import com.idescn.utils.Debug,<br></br>
	* and Debug.tt(obj); all informations would show in Output panel(F2)
	* <p>
	* <b>this class only use TEST your code, recommend you delete it after complete code</b>
	* </p>
	* this last trace information would save Debug.outMsg.
	*/
	public class Debug extends Object{
		
		/**
		* the output messages.<br></br>
		* and last output message would save here.
		*/
		public static var outMsg:String	=	null;
		
		/**
		 * the only public method in this class, you could trace object with "Debug.tt(obj);"<br>
		 * @usage   
		 * @param   value 
		 */
		static public function tt(value:*):void{
			new Debug(value);
		}
		
		/**
		 * trace MoiveClip path.
		 * @param	value
		 */
		static public function ttMovieClip(value:DisplayObject):void {
			trace(targetPath(value));
		}
		
		/**
		 * get a DisplayObject path string like AS2
		 * @param	value a DisplayObject
		 * @return path eg: stage.root1.....
		 */
		static public function targetPath(value:DisplayObject):String {
			if (!value)		return "null";
			
			var pathArr:Array		=	[value];
			var parentValue:DisplayObjectContainer	=	value.parent;
			while (parentValue) {
				pathArr.unshift(parentValue);
				parentValue		=	parentValue.parent;
			}
			
			var len:int	=	pathArr.length;
			var obj:DisplayObject	=	pathArr[0] as DisplayObject;
			var retPath:String;
			var retClassName:String;
			if (obj == obj.stage) {
				retPath			=	"stage.";
			}else {
				retPath	=	obj.name + ".";
			}
			//retClassName	=	"[" + getQualifiedClassName(obj) + "]";
			for (var i:int = 1; i < len; i++) {
				obj		=	pathArr[i] as DisplayObject;
				retPath	+=	obj.name + ".";
				//retClassName	+=	"[" + getQualifiedClassName(obj) + "]";
			}
			
			return retPath.substr(0, retPath.length - 1);// + " " + retClassName + "";
		}
		
		/**
		 * this Contruct function is private, so you can't new Debug() to get a instance.
		 * 
		 * @usage   
		 * @private 
		*/
		public function Debug(obj:*) {
			outMsg	=	"";
			init(obj);
		}
		
		/**
		 * initialize this class when user Debug.tt();
		 * 
		 * @usage   
		 * @param   obj 
		 */
		private function init(obj:*):void{
			traceObj(obj, "", "");
			trace(toString());
		}
		
		/**
		 * parse obj 
		 * 
		 * @usage   
		 * @param   obj   
		 * @param   name  
		 * @param   space 
		 */
		private function traceObj(obj:*, name:String, space:String):void {
			//trace("traceObj|typeof = "+typeof(obj));
			switch(true) {
				case getQualifiedClassName(obj) == "int" :
					traceOut(space + "[int] " + name + ": " + obj);
					break;
				case getQualifiedClassName(obj) == "Number" :
					traceOut(space + "[Number] " + name + ": " + obj);
					break;
				case typeof(obj) == "string" :
					var length:String	=	obj==null ? "" : "\t(length = " + obj.length + ")";
					traceOut(space + "[String] " + name + ": " + obj +  length);
					break;
				case typeof(obj) == "boolean" :
					traceOut(space + "[" + typeof(obj) + "] " + name + ": " + obj);
					break;
				case obj is DisplayObject :
					traceDisplayObject(obj as DisplayObject, name, space);
					break;
				case obj is LoaderInfo :
					try{
						var	flashVer:String	=	"flash" + LoaderInfo(obj).swfVersion + " as" + LoaderInfo(obj).actionScriptVersion;
										flashVer	+=	", frameRate: " + LoaderInfo(obj).frameRate + ", bytesTotal: " + 
										Math.round((LoaderInfo(obj).bytesTotal/1024)*100) / 100 + "(kb)";
					}catch (e:Error) {//Error #2099: 正在加载的对象因尚未完全加载而无法提供此信息。
						flashVer	=	e.message;
					}
					traceOut(space + "[LoaderInfo] " + name + ": " + obj + "\t" + flashVer);
					break;
				case obj is XML :
					traceOut(space + "[XML] " + name + ": " + XML(obj).toXMLString());
					break;
				case obj is XMLList :
					traceOut(space + "[XMLList] " + name + ": " + XMLList(obj).toXMLString());
					break;
				case obj is XMLDocument :
					traceOut(space + "[XMLDocument] " + name + ": " + XMLDocument(obj).toString());
					break;
				case obj is XMLNode :
					traceOut(space + "[XMLNode] " + name + ": " + XMLNode(obj).toString());
					break;
				case obj is Date :
					traceOut(space + "[Date] " + name + ": " + obj.toString());
					break;
				case obj is Sound :
					traceOut(space + "[Sound] " + name + ": duration=" + Sound(obj).length * .001 + "(sec), url: " + Sound(obj).url);
					break;
				case obj is ID3Info : 
					var id3:String	=	"album= " + ID3Info(obj).album + ", artist= " + ID3Info(obj).artist +", songName= "+
						ID3Info(obj).songName + ", year= " + ID3Info(obj).year + ", genre= " + ID3Info(obj).genre + ", track= " +
						ID3Info(obj).track + ", comment= " + ID3Info(obj).comment;
					traceOut(space + "[ID3Info] " + name + ": " + id3);
					break;
				case obj is SoundChannel :
					traceOut(space + "[SoundChannel] " + name + ": position= " + SoundChannel(obj).position * .001 + "(sec)");
					break;
				case obj is SoundTransform :
					traceOut(space + "[SoundTransform] " + name + ": volume= " + SoundTransform(obj).volume);
					break;
				case obj is ColorTransform :
					var color:String	=	"00000" + ColorTransform(obj).color.toString(16);
					traceOut(space + "[ColorTransform] " + name + ": 0x" + color.substr(color.length - 6));
					break;
				case obj is Camera :
					traceOut(space + "[Camera] " + name + ": currentFPS= " + Camera(obj).currentFPS+", motionLevel= "+Camera(obj).motionLevel);
					break;
				case obj is Microphone :
					traceOut(space + "[Microphone] " + name + ": rate= " + Microphone(obj).rate+", activityLevel= "+Microphone(obj).activityLevel);
					break;
				case obj is Matrix :
					traceOut(space + "[Matrix] " + name + ": " + obj);
					break;
				case obj is Rectangle :
					traceOut(space + "[Rectangle] " + name + ": " + obj);
					break;
				case obj is Point :
					traceOut(space + "[Point] " + name + ": " + obj);
					break;
				case obj is ByteArray :
					traceOut(space + "[ByteArray] " + name + ": length= " + ByteArray(obj).length);
					break;
				case obj is Array :
					traceOut(space + "[Array] " + name + ": length= "+ obj.length);
					ttObject(obj, space);
					break;
				case obj is Dictionary : 
					traceOut(space + "[Dictionary] " + name + ": ");
					ttObject(obj, space);
					break;
				case obj is Object || typeof(obj) == "object" :
					if (obj === null) {
						traceOut(space + "[NULL] " + name + ": " + obj);
					}else if (obj === undefined) {
						traceOut(space + "[UNDERFINED] " + name + ": " + obj);
					}else{
						traceOut(space + "[Object] " + name + ": ");
						ttObject(obj, space);
					}
					break;
				case typeof(obj)!="object" :
						traceOut(space + "*****unknow type***** " +name + ": " + obj);
				break;
				default :
					traceOut(space + "*****unknow type***** " +name + ": " + obj);
			}
		}
		
		private function traceDisplayObject(obj:DisplayObject, name:String, space:String):void {
			switch (true) {// AVM1Movie, Bitmap, InteractiveObject, MorphShape, Shape, StaticText, Video 
				case obj is InteractiveObject: 
					traceInteractiveObject(obj as InteractiveObject, name, space);
				break;
				case obj is Bitmap: 
					traceOut(space + "[Bitmap] " + name + ": " + targetPath(obj));
				break;
				case obj is MorphShape: 
					traceOut(space + "[MorphShape] " + name + ": " + targetPath(obj));
				break;
				case obj is Shape: 
					traceOut(space + "[Shape] " + name + ": " + targetPath(obj));
				break;
				case obj is AVM1Movie: 
					traceOut(space + "[AVM1Movie] " + name + ": " + targetPath(obj));
				break;
				case obj is StaticText: 
					var text:String	=	StaticText(obj).text;
					text	=	text.substr(0, 15) + "..." + text.substr(text.length - 5);
					traceOut(space + "[StaticText] " + name + ": " + targetPath(obj) + "\ttext: " + text);
				break;
				case obj is Video: 
					traceOut(space + "[Video] " + name + ": " + targetPath(obj) + "\tvideoWidth: " + Video(obj).videoWidth +
									", videoHeight: " + Video(obj).videoHeight);
				break;
				default:
					traceOut(space + "[UNKNOW TYPE " + getQualifiedClassName(obj) + "/DisplayObject] " + name + ": " + targetPath(obj));
			}
		}
		
		private function traceInteractiveObject(obj:InteractiveObject, name:String, space:String):void {
			switch (true) {//DisplayObjectContainer, SimpleButton, TextField
				case obj is DisplayObjectContainer: 
					traceDisplayObjectContainer(obj as DisplayObjectContainer, name, space);
				break;
				case obj is SimpleButton: 
					traceOut(space + "[SimpleButton] " + name + ": " + targetPath(obj) + "\tenabled: " + SimpleButton(obj).enabled);
				break;
				case obj is TextField: 
					var text:String	=	TextField(obj).text;
					text	=	text.substr(0, 15) + "..." + text.substr(text.length - 5);
					traceOut(space + "[TextField] " + name + ": " + targetPath(obj) + "\ttext: " + text);
				break;
				default:
					traceOut(space + "[UNKNOW TYPE " + getQualifiedClassName(obj) + "/InteractiveObject] " + name + ": " + targetPath(obj));
			}
		}
		
		private function traceDisplayObjectContainer(obj:DisplayObjectContainer, name:String, space:String):void {
			switch (true) {//Loader, Sprite, Stage
				case obj is Sprite: 
					var className:String	=	getQualifiedClassName(obj);
					if (obj is MovieClip) {
						if (className == "flash.display::MovieClip") {
							className	=	"MovieClip";
						}
						traceOut(space + "["+className+"] " + name + ": " + targetPath(obj) + "\tframes: " + 
												MovieClip(obj).currentFrame+ "/"+MovieClip(obj).totalFrames);
					}else {
						if (className == "flash.display::Sprite") {
							className	=	"Sprite";
						}
						traceOut(space + "["+className+"] " + name + ": " + targetPath(obj) + "\tbuttonMode: " + Sprite(obj).buttonMode);
					}
				break;
				case obj is Loader: 
					var content:DisplayObject	=	Loader(obj).content;
					var url:String	=	"null";
					if (content) {
						url	=	content.loaderInfo.url;
					}
					traceOut(space + "[Loader] " + name + ": " + targetPath(obj) + "\turl:" + url);
				break;
				case obj is Stage: 
					traceOut(space + "[Stage] " + name + ": " + targetPath(obj) + "\tframeRate: " + Stage(obj).frameRate +
								", stageWidth: " + Stage(obj).stageWidth +", stageHeight: " + Stage(obj).stageHeight);
				break;
				default:
					traceOut(space + "[UNKNOW TYPE " + getQualifiedClassName(obj) + "/DisplayObjectContainer] " + name + ": " + targetPath(obj));
			}
		}
		
		/**
		 * loop obj, and get all properties and value
		 * 
		 * @usage   
		 * @param   obj   
		 * @param   space 
		 */
		private function ttObject(obj:Object, space:String):void{
			for(var prop:String in obj){
				traceObj(obj[prop], prop, space + "   ");
			}
		}
		
		/**
		 * put output string to outMsg and add a new line
		 * 
		 * @usage   
		 * @param   str 
		 */
		private function traceOut(str:String):void{
			outMsg	+=	str + "\r";
		}
		
		/**
		 * get the last output value
		 * 
		 * @return  last output string
		 */
		private function toString():String{
			return outMsg;
		}
	}
}