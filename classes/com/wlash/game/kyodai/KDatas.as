/*utf8*/
//**********************************************************************************//
//	name:	KDatas 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Jun 21 2010 11:52:06 GMT+0800
//	description: This file was created by "Kyodai.fla" file.
//				
//**********************************************************************************//


//[com.wlash.game.kyodai.KDatas]
package com.wlash.game.kyodai {

	import flash.display.DisplayObject;
	import flash.events.Event;
	
	
	
	/**
	 * Kyodai.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class KDatas extends Object {
		private var _data:Array;
		
		
		
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		internal function get col():int {
			return _data.length;
		}
		
		internal function get row():int {
			return (_data[0] as Array).length;
		}
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new KDatas();]
		 */
		public function KDatas(row:int, col:int) {
			_initDatas(row, col);
			
			_init();
		}
		
		
		//*************************[PUBLIC METHOD]**********************************//
		
		
		/**
		 * Show class name.
		 * @return class name
		 */
		public function toString():String {
			return "KDatas|row: " + row + ", col: " + col;
		}

		
		//*************************[INTERNAL METHOD]********************************//
		internal function reset():void {
			var r:int	=	row;
			var c:int	=	col;
			_initDatas(r, c);
		}
		
		internal function _getKData(row:int, col:int):KData {
			return _data[row][col];
		}
		
		internal function equal(kd0:KData, kd1:KData):Boolean {
			return ((kd0.rowIndex == kd1.rowIndex) && (kd0.colIndex == kd1.colIndex));
		}
		
		internal function nextInRow(kd:KData):KData {
			var arr:Array	=	_data[kd.rowIndex] as Array;
			return arr ? arr[kd.colIndex + 1] : null;
		}
		
		internal function nextInCol(kd:KData):KData {
			var arr:Array	=	_data[kd.rowIndex+1] as Array;
			return arr ? arr[kd.colIndex] : null;
		}
		
		internal function prevInRow(kd:KData):KData {
			var arr:Array	=	_data[kd.rowIndex] as Array;
			return arr ? arr[kd.colIndex - 1] : null;
		}
		
		internal function prevInCol(kd:KData):KData {
			var arr:Array	=	_data[kd.rowIndex-1] as Array;
			return arr ? arr[kd.colIndex] : null;
		}
		
		internal function exchange(kd0:KData, kd1:KData):void {
			var row:int		=	kd0.rowIndex;
			var col:int		=	kd0.colIndex;
			kd0.rowIndex	=	kd1.rowIndex;
			kd0.colIndex	=	kd1.colIndex;
			kd1.rowIndex	=	row;
			kd1.colIndex	=	col;
			
			_data[row][col]	=	kd1;
			_data[kd0.rowIndex][kd0.colIndex]	=	kd0;
			
			var x:Number;
			var y:Number;
			if (kd0.data is DisplayObject) {
				x	=	kd0.data.x;
				y	=	kd0.data.y;
				if (kd1.data is DisplayObject) {
					kd0.data.x	=	kd1.data.x;
					kd0.data.y	=	kd1.data.y;
					
					kd1.data.x	=	x;
					kd1.data.y	=	y;
				}
			}
		}
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
		}
		
		private function _initDatas(row:int, col:int):void {
			_data	=	[];
			for (var i:int = 0; i < row; i++) {
				var arr:Array	=	[];
				for (var ii:int = 0; ii < col; ii++) {
					arr.push(new KData(i, ii));
				}
				_data.push(arr);
			}
		}
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
	
	
}//end class [com.wlash.game.kyodai.KDatas]
//This template is created by whohoo. ver 1.3.0

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]



*/
