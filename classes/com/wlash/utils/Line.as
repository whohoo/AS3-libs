//******************************************************************************
//	name:	Line 1.1
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Fri Aug 03 10:07:24 2007
//	description: http://www.17play.org/forum/viewthread.php?tid=75
//			http://topic.csdn.net/t/20030921/15/2284126.html
// 1.1 增加了静态方法intersectLines();
//******************************************************************************


package com.wlash.utils {
	import com.wlash.utils.Vector;
	
	[IconFile("Line.png")]
	/**
	* a line class.
	* <p>检测两条直接是否相交.</p>
	* 
	*/
	public class Line extends Object{
		public var p0:Vector;
		public var p1:Vector;
		
		/**
		 * 构建线条对象.
		 * 
		 * @param   startVector 
		 * @param   endVector   
		 * @return  
		 */
		public function Line(startVector:Vector, endVector:Vector){
			p0	=	startVector;
			p1	=	endVector;
		}
		/**
		 * 点p是否在此线条上
		 * @param	p
		 * @return
		 */
		public function online(p:Vector):Boolean{
			//(multiply(l.e,p,l.s)==0)   &&
			//(((p.x-l.s.x)*(p.x-l.e.x)<=0   )&&(   (p.y-l.s.y)*(p.y-l.e.y)<=0)));
			var ret:Boolean	=	false;
			if(p1.minusNew(p0).multiply(p.minusNew(p0))==0){
				if((p.x-p0.x)*(p.x-p1.x)<=0){
					if((p.y-p0.y)*(p.y-p1.y)<=0){
						ret	=	true;
					}
				}
			}
			return ret;
		}
		/**
		* check is intersect to line
		* @param line
		* @return
		*/
		public function intersect(line:Line):Boolean{
			var ret:Boolean	=	false;
			if(compareLine(this, line, "x")){//排斥实验  
				if(compareLine(line, this, "x")){
					if(compareLine(this, line, "y")){
						if(compareLine(line, this, "y")){//相交实验
							if(crossLine(this, line)){
								if(crossLine(line, this)){
									ret =	true;//BANAN!!!
								}
							}
						}
					}	
				}
			}
			return ret;
		}
		/**
		 * 返回此线的点座标
		 * @return
		 */
		public function toString():String{
			return "p0: "+p0+" | p1: "+p1;
		}
		/**
		 * 主要在intersect方法内调用
		 * @param	lineA
		 * @param	lineB
		 * @param	prop x座标或y座标.
		 * @return
		 */
		private static function compareLine(lineA:Line, lineB:Line, prop:String):Boolean{
			return Math.max(lineA.p0[prop], lineA.p1[prop])>=
				Math.min(lineB.p0[prop], lineB.p1[prop]);
		}
		
		/**
		 * 由四点构成的两条直接是否相交
		 * @param	line0Ax 线0,A点的x轴座标
		 * @param	line0Ay 线0,A点的y轴座标
		 * @param	line0Bx 线0,B点的x轴座标
		 * @param	line0By 线0,B点的y轴座标
		 * @param	line1Ax 线1,A点的x轴座标
		 * @param	line1Ay 线1,A点的y轴座标
		 * @param	line1Bx 线1,B点的x轴座标
		 * @param	line1By 线1,B点的y轴座标
		 * @return return <code>true</code> if tow lines are intersect, or <code>false</code>
		 */
		public static function intersectLines(line0Ax:Number, line0Ay:Number,
											line0Bx:Number, line0By:Number,
											line1Ax:Number, line1Ay:Number,
											line1Bx:Number, line1By:Number):Boolean {
			var line0:Line	=	new Line(new Vector(line0Ax, line0Ay), new Vector(line0Bx, line0By));
			var line1:Line	=	new Line(new Vector(line1Ax, line1Ay), new Vector(line1Bx, line1By));
			return line0.intersect(line1);
		}
		
		/**
		 * 两线条是否十字相交.(跨立实验 )
		 * @param	lineA
		 * @param	lineB
		 * @return return <code>true</code> if tow lines are intersect, or <code>false</code>
		 */
		public static function crossLine(lineA:Line, lineB:Line):Boolean{
			var line:Vector	=	lineA.p1.minusNew(lineA.p0);
			return lineB.p0.minusNew(lineA.p0).multiply(line)*
					line.multiply(lineB.p1.minusNew(lineA.p0))>=0;
		}
		
	}

}

/*参考(multiply(v.s,u.e,u.s)*multiply(u.e,v.e,u.s)>=0)&&                   //跨立实验  
                  (multiply(u.s,v.e,v.s)*multiply(v.e,u.e,v.s)>=0)); 
class   POINT  
  {  
  public:  
  double   x,y;  
  };  
   
  class   LINESEG  
  {  
  public:  
  POINT   s,e;  
  }  
  l[2000];  
   
  double   max(double   a,double   b)  
  {  
        return   a>b?a:b;  
  }  
  double   min(double   a,double   b)  
  {  
        return   a<b?a:b;  
  }  
  double   multiply(POINT   sp,POINT   ep,POINT   op)  
  {  
  return((sp.x-op.x)*(ep.y-op.y)-(ep.x-op.x)*(sp.y-op.y));  
  }  
  bool   online(LINESEG   l,POINT   p)  
  {  
  return(   (multiply(l.e,p,l.s)==0)   &&(   (   (p.x-l.s.x)*(p.x-l.e.x)<=0   )&&(   (p.y-l.s.y)*(p.y-l.e.y)<=0   )   )   );  
  }  
   
  //   如果线段u和v相交(包括相交在端点处)时，返回true  
  bool   intersect(LINESEG   u,LINESEG   v)  
  {  
  return(   (max(u.s.x,u.e.x)>=min(v.s.x,v.e.x))&&                                           //排斥实验  
                  (max(v.s.x,v.e.x)>=min(u.s.x,u.e.x))&&  
                  (max(u.s.y,u.e.y)>=min(v.s.y,v.e.y))&&  
                  (max(v.s.y,v.e.y)>=min(u.s.y,u.e.y))&&  
                  (multiply(v.s,u.e,u.s)*multiply(u.e,v.e,u.s)>=0)&&                   //跨立实验  
                  (multiply(u.s,v.e,v.s)*multiply(v.e,u.e,v.s)>=0));  
  }
  ---------------------------------------------
*/
