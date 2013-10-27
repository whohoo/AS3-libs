/*utf8*/
//**********************************************************************************//
//	name:	LinesMap 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Fri Oct 25 2013 10:11:17 GMT+0800
//	description: This file was created by "lineMap.fla" file.
//				
//**********************************************************************************//


//[com.wlash.tools.LinesMap]
package com.wlash.tools {

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	
	
	/**
	 * LinesMap.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class LinesMap extends Sprite {
		
		/* the instances placed on the Stage are automatically added to user-defined timeline classes.
		publish settings -> flash -> Actionscript 3.0 settings -> automatically declare stage instance
		*/

		private var _lines:Array;
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new LinesMap();]
		 */
		public function LinesMap() {
			
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
			var commPoint:Object = _getCommPoints();
			for (var i:int = 0; i < _lines.length; i++) {
				var line:LineObj = _lines[i];
				for (var prop:String in commPoint) {
					var cNames:Array = prop.split("_");
					var c0:Object = { pName:cNames[0].substr(0, 1), index:int(cNames[0].substr(1)) };
					var c1:Object = { pName:cNames[1].substr(0, 1), index:int(cNames[1].substr(1)) };
					trace(c0.pName, c0.index, c1.pName, c1.index);
					var line2:LineObj;
					if (line.index == c0.index) {
						line2 = _lines[c1.index];
						if(line.type=="V"){//垂直线
							if (c0.pName == "A") {//pointA
							
								if (c1.pName == "B") {
									if (line.type == line2.type) {//垂直线相连
										line.upA = line2.index;
									}else {
										line.leftA = line2.index;
									}
								}else if (c1.pName == "A") {
									line.rightA = line2.index;
								}else {
									trace("ERROR1: ", c0.pName, c0.index, c1.pName, c1.index);
								}
							}else if (c0.pName == "B") {//pointB
								if(c1.pName=="B"){
									line.leftB = line2.index;
								}else {
									trace("ERROR2: ", c0.pName, c0.index, c1.pName, c1.index);
								}
							}else {
								trace("ERROR3: ", c0.pName, c0.index, c1.pName, c1.index);
							}
						}else if (line.type == "H") {//水平线
							if (c0.pName == "A") {//pointA
								if (c1.pName == "B") {
									if (line.type == line2.type) {//水平线相连
										line.leftA = line2.index;
									}else {
										line.upA = line2.index;
									}
								}else if (c1.pName == "A") {
									line.downA = line2.index;
								}else {
									trace("ERROR4: ", c0.pName, c0.index, c1.pName, c1.index);
								}
							}else if (c0.pName == "B") {//pointB
								if (c1.pName == "B") {
									line.upB = line2.index;
								}else {
									trace("ERROR5: ", c0.pName, c0.index, c1.pName, c1.index);
								}
							}else {
								trace("ERROR6: ", c0.pName, c0.index, c1.pName, c1.index);
							}
						}
					}else
					
					if (line.index == c1.index) {
						line2 = _lines[c0.index];
						if(line.type=="V"){//垂直线
							if (c1.pName == "B") {//pointB
								if (c0.pName == "A") {
									if (line.type == line2.type) {//垂直线相连
										line.downB = line2.index;
									}else {
										line.rightB = line2.index;
									}
								}else if (c1.pName == "B") {
									line.leftB = line2.index;
								}else {
									trace("ERROR1: ", c0.pName, c0.index, c1.pName, c1.index);
								}
							}else if (c1.pName == "A") {//pointA
								if(c0.pName=="A"){
									line.rightA = line2.index;
								}else {
									trace("ERROR2: ", c0.pName, c0.index, c1.pName, c1.index);
								}
							}else {
								trace("ERROR3: ", c0.pName, c0.index, c1.pName, c1.index);
							}
						}else if (line.type == "H") {//水平线
							if (c1.pName == "B") {//pointB
								if (c0.pName == "A") {
									if (line.type == line2.type) {//水平线相连
										line.rightB = line2.index;
									}else {
										line.downB = line2.index;
									}
								}else if (c0.pName == "B") {
									line.upB = line2.index;
								}else {
									trace("ERROR4: ", c0.pName, c0.index, c1.pName, c1.index);
								}
							}else if (c1.pName == "A") {//pointA
								if (c0.pName == "A") {
									line.downA = line2.index;
								}else {
									trace("ERROR5: ", c0.pName, c0.index, c1.pName, c1.index);
								}
							}else {
								trace("ERROR6: ", c0.pName, c0.index, c1.pName, c1.index);
							}
						}
					}
					
				}
			}
			
			
			//out
			var str = "[";
			for (i = 0; i < _lines.length; i++) {
				line = _lines[i]; 
				str += "new Line" + line.type + '("' + line.name + 
				'", {x:' + line.pointA.x + ', y:' + line.pointA.y +
				', up:' + _getLineName(line.upA) + ', down:' + _getLineName(line.downA) + 
				', left:' +_getLineName(line.leftA) +', right:' +_getLineName(line.rightA) + '}' +
				
				', {x:' + line.pointB.x + ', y:' + line.pointB.y +
				', up:' + _getLineName(line.upB) + ', down:' + _getLineName(line.downB) + 
				', left:' +_getLineName(line.leftB) +', right:' +_getLineName(line.rightB) + '}' +'),\n';
			}
			trace(str.substr(0,-2)+"]");
		}
		
		private function _getLineName(value:int):String {
			if (value != -1) {
				return '"'+_lines[value].name+'"';
			}else {
				return null;
			}
		}
		
		private function _getCommPoints():Object {
			var commPoint:Object = { };
			var lines:Array = _getAllLines();
			_lines = lines;
			for (var i:int = 0; i < lines.length; i++) {
				var lObj:LineObj = lines[i];
				for (var ii:int = 0; ii < lines.length; ii++) {
					var lObj2:LineObj = lines[ii];
					if (lObj2 == lObj) {
						continue;
					}
					var commName:String;
					//var dc:Number = _getDistance(lObj.pointA, lObj2.pointA);
					if (_getDistance(lObj.pointA, lObj2.pointA) < 4) {
						commName = "A" + lObj.index + "_" + "A" + lObj2.index;
						if (lObj.type == lObj2.type) {
							commName += "_" + lObj.type;
						}else {
							commName += "_VH" ;
						}
						if (commPoint[commName]==null) {
							commPoint[commName] = { };
						}
					}else if (_getDistance(lObj.pointA, lObj2.pointB) < 4) {
						commName = "A" + lObj.index + "_" + "B" + lObj2.index;
						if (lObj.type == lObj2.type) {
							commName += "_" + lObj.type;
						}else {
							commName += "_VH" ;
						}
						if (commPoint[commName]==null) {
							commPoint[commName] = { };
						}
					}else if (_getDistance(lObj.pointB, lObj2.pointA) < 4) {
						commName = "A" + lObj2.index + "_" + "B" + lObj.index;
						if (lObj.type == lObj2.type) {
							commName += "_" + lObj.type;
						}else {
							commName += "_VH" ;
						}
						if (commPoint[commName]==null) {
							commPoint[commName] = { };
						}
					}else if (_getDistance(lObj.pointB, lObj2.pointB) < 4) {
						commName = "B" + lObj2.index + "_" + "B" + lObj.index;
						if (lObj.type == lObj2.type) {
							commName += "_" + lObj.type;
						}else {
							commName += "_VH" ;
						}
						if (commPoint[commName]==null) {
							commPoint[commName] = { };
						}
					} 
				}
			}
			return commPoint;
		}
		
		private function _getDistance(p1:Point, p2:Point):Number {
			return Math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
		}
		
		private function _getAllLines():Array {
			var arr:Array = [];
			for (var i = 0; i < this.numChildren; i++) {
				var mc:MovieClip = this.getChildAt(i) as MovieClip;
				
				if (mc.rotation != 0) {
					trace("线不能旋转角度", mc);
					continue;
				}
				var lObj:LineObj = new LineObj();
				lObj.index = i;
				lObj.name = mc.name.indexOf("instance")==0 ? "line_" + i : mc.name;
				lObj.type = mc.height > mc.width ? "V" : "H";
				lObj.pointA = new Point(mc.x, mc.y);
				if(lObj.type=="V"){
					lObj.pointB = new Point(mc.x, mc.y+mc.height-4);
				}else {
					lObj.pointB = new Point(mc.x+mc.width-4, mc.y);
				}
				arr.push(lObj);
			}
			return arr;
		}
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
	
	
}
	import flash.geom.Point;
class LineObj extends Object {
	var pointA:Point;
	var pointB:Point;
	var type:String;//V H
	var name:String;
	var index:int;
	var upA:int = -1;
	var downA:int = -1;
	var leftA:int = -1;
	var rightA:int = -1;
	
	var upB:int = -1;
	var downB:int = -1;
	var leftB:int = -1;
	var rightB:int = -1;
	
	function toString():String {
		return "[index:"+index+" ,name:" + name + ", pointA:{x:" + pointA.x + ", y:" + pointA.y + ", up:" + upA + ", down:" + downA + ", left:" + leftA + ", right:" + rightA + "}, " +
		"pointB:{x:" + pointB.x + ", y:" + pointB.y + ", up:"+upB+", down:"+downB+", left:"+leftB+", right:"+rightB+"}]";
	}
	
}
//end class [com.wlash.tools.LinesMap]
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
