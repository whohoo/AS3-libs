/*
  Vector Class 
  Oct. 29, 2002
  (c) 2002 Robert Penner
  
  This is a custom object designed to represent vectors and points
  in two-dimensional space. Vectors can added together,
  scaled, rotated, and otherwise manipulated with these methods.
  
  Dependencies: Math.sinD(), Math.cosD(), Math.acosD() (included below)
  
  Discussed in Chapter 4 of 
  Robert Penner's Programming Macromedia Flash MX
  
  http://www.robertpenner.com/profmx
  http://www.amazon.com/exec/obidos/ASIN/0072223561/robertpennerc-20
*/

/*
  These three trigonometric functions are required for Vector
  The full set of these functions is in trig_functions_degrees.as
*/
//******************************************************************************
//	name:	Vector 1.1
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Aug 03 10:07:24 2007
//	description: 此类参考http://www.robertpenner.com/书中所写的actionscrip 1.0中
//				定义的Vector变化而来.
//******************************************************************************


package com.wlash.utils {
	[IconFile("Vector.png")]
	/**
	* a 2D Vector class.
	* <p>create  2d class with this class, so you could render it with those method.<br>
	* thanks http://www.robertpenner.com/, this class from there.</p>
	* 
	* @example sample code:
	* <listing>
	* var v2d:Vector	=	new Vector(3, 4);
	* v2d.plus(new Vector(4, 5));
	* trace(v2d);
	* </listing>
	*/
	public class Vector extends Object{
		/**x position*/
		public var x:Number	=	0;
		/**y position*/
		public var y:Number	=	0;
		/**@private */
		public function set angle(value:Number):void{
			setAngle(value);
		}
		/**vector's angle */
		public function get angle():Number{
			return getAngle();
		}
		/**@private */
		public function set length(value:Number):void{
			setLength(value);
		}
		/**vector's length */
		public function get length():Number{
			return getLength();
		}
		
		/**
		* create a vector class.
		* @param x 0 are defalut value
		* @param y 0 are defalut value
		*/
		public function Vector(x:Number=0, y:Number=0) {
			reset(x, y);
		}
		//***********************[PUBLIC MEDOTH]********************\\
		/**
		* reset x, y
		* @param x
		* @param y
		*/
		public function reset(x:Number=0, y:Number=0):void {
			this.x =  x;
			this.y =  y;
		}
		
		/**
		* clone a new vector.
		* @return new Vector
		*/
		public function getClone():Vector {//?是不是对于prototype原型的方法或属性只能通过this.xxx来访问?
			return new Vector(x, y);
		}
		
		/**
		* compare two class is equals
		* @param v
		* @return true of false
		*/
		public function equals(v:Vector):Boolean {
			return (x == v.x && y == v.y);
		}
		
		/**
		* plus tow class
		* @param v
		*/
		public function plus(v:Vector):void {
			x += v.x;
			y += v.y;
		}
		
		/**
		* plus and get a new class.
		* @param v
		* @return 
		*/
		public function plusNew(v:Vector):Vector {
			return new Vector(x + v.x, y + v.y);
		}
		
		/**
		* tow class minus.
		* @param v
		*/
		public function minus(v:Vector):void {
			x -= v.x;
			y -= v.y;
		}
		
		/**
		* minus and get a new class.
		* @param v
		* @return
		*/
		public function minusNew(v:Vector):Vector {
			return new Vector(x - v.x, y - v.y);
		}
		
		/**
		* negate
		*/
		public function negate():void {
			x = -x;
			y = -y;
		}
		
		/**
		* ngate and get a new class.
		* @return 
		*/
		public function negateNew():Vector {
			return new Vector(-x, -y);
		}
		
		/**
		* scale this vector3d
		* @param s
		*/
		public function scale(s:Number):void {
			x *= s;
			y *= s;
		}
		
		/**
		* scale and return a new class
		* @param s
		* @return 
		*/
		public function scaleNew(s:Number):Vector {
			return new Vector(x * s, y * s);
		}
		
		
		
		public function rotate(angle:Number):void {
			var ca:Number = cosD (angle);
			var sa:Number = sinD (angle);
			var rx:Number = x * ca - y * sa;
			var ry:Number = x * sa + y * ca;
			x = rx;
			y = ry;
			
		};

		public function rotateNew(angle:Number):Vector {
			var v:Vector = new Vector(x, y);
			v.rotate (angle);
			return v;
		};

		public function getNormal():Vector {
			return new Vector(-y, x); 
		};

		public function isNormalTo(v:Vector):Boolean {
			return (this.dot (v) == 0);
		};

		
		/**
		* dot
		* @param v another vector class.
		* @return  
		*/
		public function dot(v:Vector):Number {
			return (x * v.x + y * v.y );
		}
		
		/**
		* cross and multiply
		* @param v another vector class.
		* @return 
		*/
		public function multiply(v:Vector):Number {
			var cx:Number	=	x*v.y;
			var cy:Number	=	v.x*y;
			return (cx - cy);
		}
		
		/**
		* the angle of tow class.
		* @param v
		* @return angle
		*/
		public function angleBetween(v:Vector):Number {
			//var dp:Number		=	dot(v);
			//var cosAngle:Number	=	dp / (getLength() * v.getLength());
			return acosD(dot(v)/(getLength() * v.getLength()));
		}
		
		
		
		/**
		* show class name
		* @return class value
		*/
		public function toString():String{
			return "[" 	+ Math.round(x * 1000) / 1000 + ","
						+ Math.round(y * 1000) / 1000 + "]";
		}
		
		//***********************[PRIVATE MEDOTH]********************\\
		private function getAngle():Number {
			return atan2D (y, x);
		};

		private function setAngle(angle:Number):void {
			var r:Number	=	getLength();
			x = r * cosD (angle);
			y = r * sinD (angle);
		};

		/**
		* get vector length.
		* @return vector length.
		*/
		private function getLength():Number {
			return Math.sqrt(x * x + y * y);
		}
		
		/**
		* set vector length.
		* @param len 
		*/
		private function setLength(len:Number):void {
			var r:Number = getLength();
			if (r!=0) {
				scale(len / r);
			} else {
				x = len;
			}
		}
		
		//***********************[STATIC MEDOTH]********************\\
		/**
		* get angle cosine value.
		* @param angle 
		* @return 
		*/
		public static function cosD(angle:Number):Number {
			return Math.cos (angle * (Math.PI / 180));
		};
		
		/**
		* get ratio anti-cosine value.
		* @param ratio 
		* @return 
		*/
		public static function acosD(ratio:Number):Number {
			return Math.acos (ratio) * (180 / Math.PI);
		};
		
		/**
		* get angle sine value.
		* @param angle 
		* @return 
		*/
		public static function sinD(angle:Number):Number {
			return Math.sin (angle * (Math.PI / 180));
		};
		
		/**
		* get angle atan2 value.
		* @param x 
		* @param y 
		* @return 
		*/
		public static function atan2D(y:Number, x:Number):Number {
			return Math.atan2 (y, x) * (180 / Math.PI);
		};
		
		
	}

}