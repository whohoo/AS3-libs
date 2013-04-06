//******************************************************************************
//	name:	ColorAverage 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2009/4/4 0:49
//	description: average colors, source copy from http://www.insidepiet.com
//		optimize the code
//******************************************************************************


package com.wlash.utils {
	
	/**
	 * ColorAverage.
	 * <p>average colors value</p>
	 * 
	 */
    public class ColorAverage extends Object {
		
        private var _pct:Number		= 0;
        private var _colors:Array;

		//*************************[READ|WRITE]*************************************//
		/**@private */
        public function set colors(colArr:Array) : void {
			if(colArr){
				_colors		=	[];
				var i:int	=	colArr.length;
				while (i--) {
					_colors.push(convertColor(colArr[i]));
				}
			}else {
				_colors	=	null;
			}
        }
		/**all color array*/
        public function get colors() : Array{
            return _colors;
        }
		
		/**@private */
        public function set pct(val:Number) : void{
            if (val > 0){
                val = val % 1;
            }
            if (val < 0){
                val = val % 1 + 1;
            }
            //param1 = Math.max(0, Math.min(1, param1));
            _pct = val > 1 ? 1 : (val < 0 ? 0 : val);
        }
		/**0~1,default value 0*/
        public function get pct() : Number{
            return _pct;
        }
		//*************************[READ ONLY]**************************************//
		/**get average color value*/
        public function get color() : int{
            var col:int;
			var len:int	=	_colors.length;
            if (!_colors) {
                //col = 0;
            }else if (len == 1) {
				var obj:Object	=	_colors[0];
                col = obj.r * 255 << 16 | obj.g * 255 << 8 | obj.b * 255;
            }else {
				var c0:int		=	len-2;//i don't know why?
				//var c1:int	=	Math.floor(pct * _colors.length--);//default is 0 for pct is 0
				var c1:int		=	Math.floor(pct * len);//default is 0 for pct is 0
				var col1:int	=	c0 > c1 ? c1 : c0;//the one which smaller
                var col2:int	=	col1 + 1;//next color
				//pctNum	=	pct * _colors.length-- % 1;//why desc this
				var pctNum:Number	=	pct * len % 1;
				if (pct == 1)  pctNum = 1;
				
                var colObj1:Object =	_colors[col1];
                var colObj2:Object =	_colors[col2];
				
                var colR:Number	= (1 - pctNum) * colObj1.r + pctNum * colObj2.r;
                var colG:Number	= (1 - pctNum) * colObj1.g + pctNum * colObj2.g;
                var colB:Number	= (1 - pctNum) * colObj1.b + pctNum * colObj2.b;
                col		= colR * 255 << 16 | colG * 255 << 8 | colB * 255;
            }
            return col;
        }
		//*************************[STATIC]*****************************************//
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new ColorAverage();]
		 * @param colArr color array
		 */
        public function ColorAverage(colArr:Array = null){
            _pct		= 0;
            if (colArr){
                colors = colArr;
            }
        }
		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * show color value and length.
		 * @return
		 */
		public function toString():String {
			return "color average: 0x" + String(color) + ", colors length: " + (_colors == null ? "null" : String(_colors.length));
		}
		
        public function destroy() : void {
            _colors = null;
        }
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
        private function convertColor(col:Number) : Object {
            var colObj:Object	=	{};
            colObj.r = (col >> 16 & 255) / 255;
            colObj.g = (col >> 8 & 255) / 255;
            colObj.b = (col & 255) / 255;
			//trace(col);
			//debugColor(colObj);
            return colObj;
        }
		
		//debug test
		//private function debugColor(obj:Object):void {
			//trace("r: "+obj.r+", g: "+obj.g+", b: "+obj.b)
		//}
    }
}
