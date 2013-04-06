//******************************************************************************
//	name:	Vector3D 1.1
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Mar 01 14:25:49 GMT+0800 2006
//	description: 此类参考http://www.robertpenner.com/书中所写的actionscrip 1.0中
//				定义的Vector3D变化而来.
//******************************************************************************

package com.wlash.as3d {
	
	/**
	* a 3D vector class.
	* 
	* <p>create 3D class with this class, so you could render it with those method.<br/>
	* thanks http://www.robertpenner.com/, this class from there.</p>
	* 
	* @example The following code sets the Vector3D class:
	* <listing version="3.0">
	* var v3d:Vector3D	=	new Vector3D(2, 4, 6);
	* v3d.rotateX(12);
	* trace(v3d);//[x=?, y=?, z=?]
	* </listing>
	*/
	public class Vector3D extends Object{
		/**x position*/
		public var x:Number	=	0;
		/**y position*/
		public var y:Number	=	0;
		/**z position*/
		public var z:Number	=	0;
		/**
		 * the default view distance
		 * @default 300
		 */
		public static var defaultViewDist:Number	=	300;
		/**
		* create a 3d vector class.
		* @param x 0 are defalut value
		* @param y 0 are defalut value
		* @param z 0 are defalut value
		*/
		public function Vector3D(x:Number=0, y:Number=0, z:Number=0) {
			reset(x, y, z);
		}
		
		/******************[STATIC METHOD]******************/
		/**
		* get angle sine value.
		* @param angle 
		* @return 
		*/
		public static function sinD(angle:Number):Number {
			return Math.sin (angle * (Math.PI / 180));
		};
		
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
		
		
		/******************[PUBLIC METHOD]******************/
		/**
		* reset x, y, z value
		* @param x
		* @param y
		* @param z
		*/
		public function reset(x:Number=0, y:Number=0, z:Number=0):void {
			this.x =  x;
			this.y =  y;
			this.z =  z;
		}
		
		/**
		* clone a new vector3D.
		* @return new Vecotr3D
		*/
		public function getClone():Vector3D {
			return new Vector3D(x, y, z);
		}
		
		/**
		* compare two class is equals
		* @param v
		* @return true of false
		*/
		public function equals(v:Vector3D):Boolean {
			return (x == v.x && y == v.y && z == v.z);
		}
		
		/**
		* plus tow class
		* @param v
		*/
		public function plus(v:Vector3D):void {
			x += v.x;
			y += v.y;
			z += v.z;
		}
		
		/**
		* plus and get a new class.
		* @param v
		* @return 
		*/
		public function plusNew(v:Vector3D):Vector3D {
			return new Vector3D(x + v.x, y + v.y, z + v.z);
		}
		
		/**
		* tow class minus.
		* @param v
		*/
		public function minus(v:Vector3D):void {
			x -= v.x;
			y -= v.y;
			z -= v.z;
		}
		
		/**
		* minus and get a new class.
		* @param v
		* @return
		*/
		public function minusNew(v:Vector3D):Vector3D {
			return new Vector3D(x - v.x, y - v.y, z - v.z);
		}
		
		/**
		* negate
		*/
		public function negate():void {
			x = -x;
			y = -y;
			z = -z;
		}
		
		/**
		* ngate and get a new class.
		* @return 
		*/
		public function negateNew():Vector3D {
			return new Vector3D(-x, -y, -z);
		}
		
		/**
		* scale this Vector3D
		* @param s
		*/
		public function scale(s:Number):void {
			x *= s;
			y *= s;
			z *= s;
		}
		
		/**
		* scale and return a new class
		* @param s
		* @return 
		*/
		public function scaleNew(s:Number):Vector3D {
			return new Vector3D(x * s, y * s, z * s);
		}
		
		/**
		* get vector length.
		* @return vector length.
		*/
		public function getLength():Number {
			return Math.sqrt(x * x + y * y + z * z);
		}
		
		/**
		* set vector length.
		* @param len 
		*/
		public function setLength(len:Number):void {
			var r:Number = getLength();
			if (r!=0) {
				scale(len / r);
			} else {
				x = len;
			}
		}
		
		/**
		* dot
		* @param v another vector class.
		* @return  
		*/
		public function dot(v:Vector3D):Number {
			return (x * v.x + y * v.y + z * v.z);
		}
		
		/**
		* cross and get a new class
		* @param v another vector class.
		* @return 
		*/
		public function cross(v:Vector3D):Vector3D {
			var cx:Number = y * v.z - z * v.y;
			var cy:Number = z * v.x - x * v.z;
			var cz:Number = x * v.y - y * v.x;
			return new Vector3D(cx, cy, cz);
		}
		
		/**
		* the angle of tow class.
		* @param v
		* @return angle
		*/
		public function angleBetween(v:Vector3D):Number {
			//var dp:Number		=	dot(v);
			//var cosAngle:Number	=	dp / (getLength() * v.getLength());
			return acosD(dot(v)/(getLength() * v.getLength()));
		}
		
		/**
		* get perspective
		* @param viewDist
		* @return 
		*/
		public function getPerspective(viewDist:Number=NaN):Number {
			if (isNaN(viewDist)) {
				viewDist = defaultViewDist;
			}
			return viewDist / (z + viewDist);
		}
		
		/**
		* 
		* translate 3d to 2d in screen.
		* @param p perspective value, the default are 300/(z+300).
		*/
		public function persProject(p:Number=NaN):void {
			if (isNaN(p)) {
				p = getPerspective();
			}
			x *= p;
			y *= p;
			z = 0;
		}
		
		/**
		* translate 3d to2d in screen and return a new Vector3D
		* @param p perspective value, the default are 300/(z+300).
		* @return Vector3D.
		*/
		public function persProjectNew(p:Number=NaN):Vector3D {
			if (isNaN(p)) {
				p = getPerspective();
			}
			return new Vector3D(p * x, p * y, 0);
		}
		
		/////////////角度的转动//////////////////////
		/**
		* rotate by X axis.
		* @param angle
		*/
		public function rotateX(angle:Number):void {
			var ca:Number = cosD(angle);
			var sa:Number = sinD(angle);
			rotateX2(ca,sa);
		}
		
		/**
		* rotate by X axis.
		* @param ca
		* @param sa
		*/
		public function rotateX2(ca:Number, sa:Number):void {
			var tempY:Number = y * ca - z * sa;
			var tempZ:Number = y * sa + z * ca;
			y = tempY;
			z = tempZ;
		}
		
		/**
		* rotate by Y axis.
		* @param angle
		*/
		public function rotateY(angle:Number):void {
			var ca:Number = cosD(angle);
			var sa:Number = sinD(angle);
			rotateY2(ca,sa);
		}
		
		/**
		* rotate by Y axis.
		* @param ca
		* @param sa
		*/
		public function rotateY2(ca:Number, sa:Number):void {
			var tempX:Number = x * ca + z * sa;
			var tempZ:Number = x * -sa + z * ca;
			x = tempX;
			z = tempZ;
		}
		/**
		* rotate by Z axis.
		* @param angle
		*/
		public function rotateZ(angle:Number):void {
			var ca:Number = cosD(angle);
			var sa:Number = sinD(angle);
			rotateZ2(ca,sa);
		}
		
		/**
		* rotate by Z axis.
		* @param ca
		* @param sa
		*/
		public function rotateZ2(ca:Number, sa:Number):void {
			var tempX:Number = x * ca - y * sa;
			var tempY:Number = x * sa + y * ca;
			x = tempX;
			y = tempY;
		}
		
		/**
		* rotate by XY axis.
		* @param a X axis
		* @param b Y axis
		*/
		public function rotateXY(a:Number, b:Number):void {
			var ca:Number	= cosD(a);
			var sa:Number	= sinD(a);
			var cb:Number	= cosD(b);
			var sb:Number	= sinD(b);
			rotateXY2(ca,sa,cb,sb);
		}
		
		/**
		* rotate by XY axis.
		* @param ca X axis cosine
		* @param sa X axis sine
		* @param cb Y axis cosine
		* @param sb Y axis sine
		*/
		public function rotateXY2(ca:Number, sa:Number, cb:Number, sb:Number):void {
			//绕x轴旋转
			var rz:Number = y * sa + z * ca;
			y = y * ca - z * sa;
			//绕y轴旋转
			z = x * -sb + rz * cb;
			x = x * cb + rz * sb;
		}
		
		/**
		* rotate by XYZ  axis.
		* @param a X axis
		* @param b Y axis
		* @param c Z axis
		*/
		public function rotateXYZ(a:Number, b:Number, c:Number):void {
			
			var ca:Number = cosD(a);
			var sa:Number = sinD(a);
			var cb:Number = cosD(b);
			var sb:Number = sinD(b);
			var cc:Number = cosD(c);
			var sc:Number = sinD(c);
			
			rotateXYZ2(ca, sa, cb, sb, cc, sc);
		}
		
		/**
		* rotate by XYZ  axis.
		* @param ca X axis cosine
		* @param sa X axis sine
		* @param cb Y axis cosine
		* @param sb Y axis sine
		* @param cc Z axis cosine
		* @param sc Z axis sine
		*/
		public function rotateXYZ2(ca:Number,sa:Number,cb:Number,sb:Number,
													cc:Number,sc:Number):void {
			//绕x轴
			var ry:Number = y * ca - z * sa;
			var rz:Number = y * sa + z * ca;
			//绕y轴
			var rx:Number = x * cb + rz * sb;
			z = x * -sb + rz * cb;
			//绕z轴
			x = rx * cc - ry * sc;
			y = rx * sc + ry * cc;
		}
		
		/**
		* show this class value.
		* @return class value
		*/
		public function toString():String{
			return "[" 	+ Math.round(x * 1000) / 1000 + ","
						+ Math.round(y * 1000) / 1000 + ","
						+ Math.round(z * 1000) / 1000 + "]";
		}
	}

	
}
