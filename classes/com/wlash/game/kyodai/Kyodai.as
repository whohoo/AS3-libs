/*utf8*/
//**********************************************************************************//
//	name:	Kyodai 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Mon Jun 21 2010 11:52:06 GMT+0800
//	description: This file was created by "Kyodai.fla" file.
//				
//**********************************************************************************//


//[com.wlash.game.kyodai.Kyodai]
package com.wlash.game.kyodai {

	import flash.events.Event;
	import flash.utils.getTimer;
	
	
	
	/**
	 * Kyodai.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class Kyodai extends Object {
		
		protected var _kdatas:KDatas;
		
		private var _twinsObj:Object;
		private var _row:int;
		private var _col:int;
		private var _numsArr:Array;
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		/** check is all clear*/
		public function get isWin():Boolean { return getUnclearKData().length == 0; }
		
		/**	check has path to link? */
		public function get hasPath():Boolean {
			
			return getHint()!=null;
		}
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new Kyodai();]
		 */
		public function Kyodai() {
			
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		public function clearKData(kd0:KData, kd1:KData):void {
			var arr:Array	=	_twinsObj[String(kd0.state)];
			if (arr) {
				var len:int	=	arr.length;
				for (var i:int = 0; i < len; i++) {
					if (kd0 == arr[i]) {
						arr.splice(i, 1);
						break;
					}
				}
			}
			arr	=	_twinsObj[String(kd1.state)];
			if (arr) {
				len	=	arr.length;
				for (i = 0; i < len; i++) {
					if (kd0 == arr[i]) {
						arr.splice(i, 1);
						break;
					}
				}
			}
			
			//_traceTwinsObj();
			//trace( "_traceTwinsObj : " + _traceTwinsObj );
			kd0.state	=	0;
			kd1.state	=	0;
			//_traceTwinsObj();
		}
		
		/**
		 * 无外边，线条不可以从最外边连接
		 * @param	value
		 */
		public function createMode1(value:int):void {
			_twinsObj	=	{};
			_numsArr	=	getRandomArr(value);
			var len:int;
			if (_col % 2 == 0) {
				len	=	_col * .5;
				for (var i:int = 0; i < _row; i++) { 
					for (var ii:int = 0; ii < len; ii++) {
						if (_numsArr.length == 0) {
							_numsArr	=	getRandomArr(value);
						}
						var num:int	=	_numsArr.pop() + 1;
						var kd0:KData	=	_kdatas._getKData(i, ii * 2);
						kd0.state	=	num;
						
						var kd1:KData	=	_kdatas._getKData(i, ii*2 + 1);
						kd1.state	=	num;
						if (_twinsObj[String(num)]) {
							_twinsObj[String(num)].push(kd0);
							_twinsObj[String(num)].push(kd1);
						}else {
							_twinsObj[String(num)]	=	[kd0, kd1];
						}
					}
				}
			}else if (_row % 2 == 0) {
				len	=	_row * .5;
				for (i = 0; i < len; i++) {
					for (ii = 0; ii < _col; ii++) {
						if (_numsArr.length == 0) {
							_numsArr	=	getRandomArr(value);
						}
						num	=	_numsArr.pop();
						kd0	=	_kdatas._getKData(i * 2, ii);
						kd0.state	=	num;
						
						kd1	=	_kdatas._getKData(i * 2 + 1, ii);
						kd1.state	=	num;
						if (_twinsObj[String(num)]) {
							_twinsObj[String(num)].push(kd0);
							_twinsObj[String(num)].push(kd1);
						}else {
							_twinsObj[String(num)]	=	[kd0, kd1];
						}
					}
				}
			}
			
			shuffle();
			while (!hasPath) {
				shuffle();
				//trace( "shuffle : "  );
			}
		}
		
		/**
		 * 有外边，线条可以从最外边连接
		 * @param	value
		 */
		public function createMode2(value:int):void {
			if (_col < 5 || _row < 5)	return;
			_twinsObj	=	{};
			_numsArr	=	getRandomArr(value);
			var len:int;
			var len2:int;
			if (_col % 2 == 0) {
				len		=	_col * .5;
				len2	=	_row - 1;
				for (var i:int = 1; i < len2; i++) { 
					for (var ii:int = 1; ii < len; ii++) {
						if (_numsArr.length == 0) {
							_numsArr	=	getRandomArr(value);
						}
						var num:int	=	_numsArr.pop() + 1;
						var kd0:KData	=	_kdatas._getKData(i, ii * 2-1);
						kd0.state	=	num;
						
						var kd1:KData	=	_kdatas._getKData(i, ii * 2 );
						kd1.state	=	num;
						if (_twinsObj[String(num)]) {
							_twinsObj[String(num)].push(kd0);
							_twinsObj[String(num)].push(kd1);
						}else {
							_twinsObj[String(num)]	=	[kd0, kd1];
						}
					}
				}
			}else if (_row % 2 == 0) {
				len		=	_row * .5;
				len2	=	_col - 1;
				for (i = 1; i < len; i++) {
					for (ii = 1; ii < len2; ii++) {
						if (_numsArr.length == 0) {
							_numsArr	=	getRandomArr(value);
						}
						num	=	_numsArr.pop();
						kd0	=	_kdatas._getKData(i * 2-1, ii);
						kd0.state	=	num;
						
						kd1	=	_kdatas._getKData(i * 2 , ii);
						kd1.state	=	num;
						if (_twinsObj[String(num)]) {
							_twinsObj[String(num)].push(kd0);
							_twinsObj[String(num)].push(kd1);
						}else {
							_twinsObj[String(num)]	=	[kd0, kd1];
						}
					}
				}
			}
			
			shuffle();
			while (!hasPath) {
				shuffle();
				//trace( "shuffle : "  );
			}
			//_traceTwinsObj();
		}
		
		/**
		 * 初始化，建议方格数组
		 * @param	row
		 * @param	col
		 */
		public function init(row:int, col:int):void {
			var num:int	=	row * col;
			if(num>=6 && num%2==0){
				_row	=	row;
				_col	=	col;
				_kdatas	=	new KDatas(row, col);
			}else {
				throw new Error("ERROR| row or col must be even and large than 2. row = " + row + ", col = " + col);
			}
			//test();
		}
		
		/**
		 * 把state不为0的数据随机排列。
		 */
		public function shuffle():void {
			var arr:Array	=	getUnclearKData();
			var kd:KData;
			var kd1:KData;
			
			var len:int	=	arr.length;
			for (var i:int = 0; i < len; i++) {
				kd	=	arr[i];
				var r:int	=	int(getRandom(len));
				if (r == i) continue;
				kd1	=	arr[r];
				_kdatas.exchange(kd, kd1);
			}
		}
		
		/**
		 * 根据位置得到数据
		 * @param	row
		 * @param	col
		 * @return
		 */
		public function getKData(row:int, col:int):KData {
			if (row >= _row || row < 0 || col>=_col || col<0)	return null;
			return _kdatas._getKData(row, col);
		}
		
		/**
		 * 比较两个数据是否一样
		 * @param	kd0
		 * @param	kd1
		 * @return
		 */
		public function equal(kd0:KData, kd1:KData):Boolean {
			if (!kd0 || !kd1)	return false;
			return _kdatas.equal(kd0, kd1);
		}
		
		/**
		 * 比较连接
		 * @param	kd0
		 * @param	kd1
		 * @return object {link:Boolean, path:Array}
		 */
		public function checkLink(kd0:KData, kd1:KData):Object {
			var link:Object = { link:false, path:[], length:0 };
			if (kd0.state != kd1.state || kd0==kd1)	return link;
			
			if (kd0.rowIndex == kd1.rowIndex || kd0.colIndex == kd1.colIndex) {//direct link
				link	=	_checkLink0(kd0, kd1);
				if (link.link) {//直线相连
					
				}else {//可能2折线相连
					link	=	_checkLink2(kd0, kd1);
				}
			}else {//1折线相连
				link	=	_checkLink1(kd0, kd1);
				if (link.link) {//1折线相连
					
				}else {//可能2折线相连
					link	=	_checkLink2(kd0, kd1);
				}
			}
			
			return link;
		}
		
		public function getHint():Object {
			for each (var obj:Array in _twinsObj) {
				if (obj) {
					var arr:Array	=	obj.concat();
					var len:int	=	arr.length;
					for (var i:int = 0; i < len; i++) {
						var kd0:KData	=	arr.shift();
						if (kd0.state == 0)	continue;
						var len2:int	=	arr.length;
						for (var ii:int = 0; ii < len2; ii++) {
							var kd1:KData	=	arr[ii];
							if (checkLink(kd0, kd1).link) {
								return { kd0:kd0, kd1:kd1 };
							}
						}
					}
				}
				
			}
			
			return null;
		}
		
		public function destroy():void {
			_col	=	0;
			_row	=	0;
			_kdatas	=	null;
			_numsArr	=	null;
		}
		
		/**
		 * Show class name.
		 * @return class name
		 */
		public function toString():String {
			var str:String	=	"Kyodai 1.0\n";
			for (var i:int = 0; i < _row; i++) {
				for (var ii:int = 0; ii < _col; ii++) {
					var kd:KData	=	_kdatas._getKData(i, ii);
					var nStr:String	=	String("   " + kd.state).substr(-3, 3);
					str	+= nStr + ",";
				}
				str	+=	"\n";
			}
			return str;
		}

		/**
		 * set value,
		 * @param	row
		 * @param	col
		 * @param	state
		 */
		public function __debugSingle(row:int, col:int, state:int):KData {
			var kd:KData	=	_kdatas._getKData(row, col);
			kd.state	=	state;
			return kd;
		}
		
		/**
		 * set values
		 *  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
		 *  0,  8,  2,  8,  7,  0,  1,  0,  5,  1,  9,  0,
		 *  0,  4,  0,  0,  3,  0,  0,  0,  7,  1,  8,  0,
		 *  0,  6,  0,  0,  0,  2, 10,  0,  0, 10,  6,  0,
		 *  0,  0,  5,  8,  0,  1,  0,  4,  0,  3,  9,  0,
		 *  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
		 * @param	value
		 */
		public function __debug(value:String):void {
			var arr:Array	=	value.split(",");
			//var len:int	=	arr.length;
			//if (len != _row)	throw new Error("ERROR| row not match, row= " + _row + ", row2=" + len);
			//var arr2:Array	=	arr[0].split(",");
			//var len2:int	=	arr2.length;
			//if (len2 != _col)	throw new Error("ERROR| col not match, col= " + _col + ", col2=" + len2);
			//
			//for (var i:int = 0; i < len; i++) {
				//arr2	=	arr[i].split(",");
			//}
			var obj:Object	=	{};
			var iii:int;
			for (var i:int = 0; i < _row; i++) {
				for (var ii:int = 0; ii < _col; ii++) {
					var sStr:String	=	arr[iii];
					var s:int	=	int(sStr);
					var kd:KData	=	__debugSingle(i, ii, s);
					if (s != 0) {
						if (obj[String(s)]) {
							obj[String(s)].kd1	=	kd;
						}else {
							obj[String(s)]	=	{kd0:kd };
						}
					}
					iii++;
				}
			}
			
			_twinsObj	=	{};
			for each (var prop:Object in obj) {
				if (!prop.kd1) {
					throw new Error("ERROR: __debug: kd1= null, kd0= " + prop.kd0);
				}
				if (_twinsObj[String(prop.kd0)]) {
					_twinsObj[String(prop.kd0)].push(prop.kd0);
					_twinsObj[String(prop.kd0)].push(prop.kd1);
				}else {
					_twinsObj[String(prop.kd0)]	=	[prop.kd0, prop.kd1];
				}
				
			}
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
		}
		
		private function getUnclearKData():Array {
			var arr:Array	=	[];
			var kd:KData;
			for (var i:int = 0; i < _row; i++) {
				for (var ii:int = 0; ii < _col; ii++) {
					kd	=	_kdatas._getKData(i, ii);
					if (kd.state == 0)	continue;
					arr.push(kd);
				}
			}
			return arr;
		}
		
		private function _checkLink2(kd0:KData, kd1:KData):Object {
			var retObj0:Object	=	{link:false, path:[], length:int.MAX_VALUE};
			var retObj1:Object	=	{link:false, path:[], length:int.MAX_VALUE};
			//先纵
			//var col0Arr:Array	=	_getCol(kd0);
			//var col1Arr:Array	=	_getCol(kd1);
			if (kd0.rowIndex == kd1.rowIndex) {
				retObj0	=	_getColLinkObj(kd0, kd1, _getCol(kd0), _getCol(kd1));
			}else if (kd0.colIndex == kd1.colIndex) {
				retObj1	=	_getRowLinkObj(kd0, kd1, _getRow(kd0), _getRow(kd1));
			}else{
				retObj0	=	_getColLinkObj(kd0, kd1, _getCol(kd0), _getCol(kd1));
				retObj1	=	_getRowLinkObj(kd0, kd1, _getRow(kd0), _getRow(kd1));
			}
			
			if (retObj0.link || retObj1.link) {//如果这样到线路，选出最短的
				if (retObj0.length < retObj1.length) {
					return retObj0;
				}else {
					return retObj1;
				}
			}else {//找不到线路
				return {link:false, path:[],lenth:0 };
			}
			
		}
		
		private function _checkLink1(kd0:KData, kd1:KData):Object {
			var kd00:KData	=	_kdatas._getKData(kd0.rowIndex, kd1.colIndex);
			if (kd00.state == 0) {
				if (_checkLink0(kd0, kd00).link && _checkLink0(kd00, kd1).link) {
					return {link:true, path:[kd0, kd00, kd1], length:_shortPathLength([kd0, kd00, kd1])};
				}
			}
			var kd11:KData	=	_kdatas._getKData(kd1.rowIndex, kd0.colIndex);
			if (kd11.state == 0) {
				if (_checkLink0(kd0, kd11).link && _checkLink0(kd11, kd1).link) {
					return {link:true, path:[kd0, kd11, kd1], length:_shortPathLength([kd0, kd11, kd1])};
				}
			}
			return { link:false, path:[], lenth:0 };
		}
		
		private function _checkLink0(kd0:KData, kd1:KData):Object {
			var len:int;
			var kd:KData;
			if (kd0.rowIndex == kd1.rowIndex) {//in the same row
				var dCol:int	=	kd0.colIndex - kd1.colIndex;
				if (dCol==1 || dCol==-1) {
					return {link:true,path:[], lenth:0};
				}else if (dCol > 1) {
					kd	=	kd1;
					while(true){
						kd	=	_kdatas.nextInRow(kd);
						if (kd.colIndex >= kd0.colIndex)	break;
						if (kd.state!=0) return {link:false,path:[], length:0};
					};
					return {link:true,path:[kd0, kd1], length:_getPathLength(kd0, kd1)};
				}else  {
					kd	=	kd0;
					while(true){
						kd	=	_kdatas.nextInRow(kd);
						if (kd.colIndex >= kd1.colIndex)	break;
						if (kd.state!=0) return {link:false,path:[], length:0};
					};
					return {link:true,path:[kd0, kd1], length:_getPathLength(kd0, kd1)};
				}
			}else {// in the same col
				var dRow:int	=	kd0.rowIndex - kd1.rowIndex;
				if (dRow==1 || dRow==-1) {
					return {link:true,path:[], lenth:0};
				}else if (dRow > 1) {
					kd	=	kd1;
					while(true){
						kd	=	_kdatas.nextInCol(kd);
						if (kd.rowIndex >= kd0.rowIndex)	break;
						if (kd.state!=0) return {link:false,path:[], length:0};
					};
					return {link:true,path:[kd0, kd1], length:_getPathLength(kd0, kd1)};
				}else {
					kd	=	kd0;
					while(true){
						kd	=	_kdatas.nextInCol(kd);
						if (kd.rowIndex >= kd1.rowIndex)	break;
						if (kd.state!=0) return {link:false,path:[], length:0};
					};
					
					return { link:true, path:[kd0, kd1], length:_getPathLength(kd0, kd1) };
				}
			}
			
		}
		
		private function _getColLinkObj(kd0:KData, kd1:KData, arr0:Array, arr1:Array):Object {
			var link:Object;
			var checkObj:Object	=	{ };
			var retObj:Object	=	{link:false, path:[], length:int.MAX_VALUE};
			var arr:Array;
			var shareObj:Array;
			var kds:Object;
			var kd:KData;
			var len2:int;
			var len:int	=	arr0.length;
			
			for (var i:int = 0; i < len; i++) {
				kd	=	arr0[i];
				checkObj[kd.rowIndex]	=	{kd:kd };
			}
			shareObj	=	[];
			len	=	arr1.length;
			for (i = 0; i < len; i++) {
				kd	=	arr1[i];
				if (checkObj[kd.rowIndex]) {
					shareObj.push({kd00:checkObj[kd.rowIndex].kd, kd11:kd});
				}
			}
			
			len	=	shareObj.length;
			for (i = 0; i < len; i++) {
				kds	=	shareObj[i];
				link	=	_checkLink0(kds.kd00, kds.kd11);
				if (link.link) {
					arr		=	[kd0, kds.kd00, kds.kd11, kd1];
					len2	=	_shortPathLength(arr);
					if (len2 < retObj.length) {
						retObj	= {link:true, path:arr, length:len2 };
					}
				}
			}
			return retObj;
		}
		
		private function _getRowLinkObj(kd0:KData, kd1:KData, arr0:Array, arr1:Array):Object {
			var link:Object;
			var checkObj:Object	=	{ };
			var retObj:Object	=	{link:false, path:[], length:int.MAX_VALUE};
			var arr:Array;
			var shareObj:Array;
			var kds:Object;
			var kd:KData;
			var len2:int;
			var len:int	=	arr0.length;
			
			for (var i:int = 0; i < len; i++) {
				kd	=	arr0[i];
				checkObj[kd.colIndex]	=	{kd:kd };
			}
			shareObj	=	[];
			len	=	arr1.length;
			for (i = 0; i < len; i++) {
				kd	=	arr1[i];
				if (checkObj[kd.colIndex]) {
					shareObj.push({kd00:checkObj[kd.colIndex].kd, kd11:kd});
				}
			}
			
			len	=	shareObj.length;
			for (i = 0; i < len; i++) {
				kds	=	shareObj[i];
				link	=	_checkLink0(kds.kd00, kds.kd11);
				if (link.link) {
					arr		=	[kd0, kds.kd00, kds.kd11, kd1];
					len2	=	_shortPathLength(arr);
					if (len2 < retObj.length) {
						retObj	= {link:true, path:arr, length:len2 };
					}
					
				}
			}
			return retObj
		}
		
		private function _getCol(kd0:KData):Array {
			var arr:Array	=	[];
			var kd:KData	=	kd0;
			while (true) {//up
				kd	=	_kdatas.prevInCol(kd);
				if (!kd || kd.state!=0)	break;
				arr.push(kd);
			}
			
			kd	=	kd0;
			while (true) {//down
				kd	=	_kdatas.nextInCol(kd);
				if (!kd || kd.state!=0)	break;
				arr.push(kd);
			}
			return arr;
		}
		
		private function _getRow(kd0:KData):Array {
			var arr:Array	=	[];
			var kd:KData	=	kd0;
			while (true) {//up
				kd	=	_kdatas.prevInRow(kd);
				if (!kd || kd.state!=0)	break;
				arr.push(kd);
			}
			
			kd	=	kd0;
			while (true) {//down
				kd	=	_kdatas.nextInRow(kd);
				if (!kd || kd.state!=0)	break;
				arr.push(kd);
			}
			return arr;
		}
		
		private function _shortPathLength(arr:Array):int {
			var len2:int	=	arr.length;
			var len:int;
			var kd:KData	=	arr[0];
			for (var i:int = 1; i < len2; i++) {
				len	+=	_getPathLength(kd, arr[i]);
				kd	=	arr[i];
			}
			return len;
		}
		
		private function _getPathLength(kd0:KData, kd1:KData):int {
			var len:int;
			if (kd0.rowIndex == kd1.rowIndex) {//direct link
				len	=	Math.abs(kd0.colIndex - kd1.colIndex);
			}else if (kd0.colIndex == kd1.colIndex) {
				len	=	Math.abs(kd0.rowIndex - kd1.rowIndex);
			}else if(!_kdatas.equal(kd0, kd1)){
				len	=	Math.abs(kd0.colIndex - kd1.colIndex) + Math.abs(kd0.rowIndex - kd1.rowIndex);
			}
			return len;
		}
		
		private function _traceTwinsObj():void {
			var str:String	=	"_twinsObj: \n";
			var count:int;
			for each(var obj:Array in _twinsObj) {
				str += count+": ";
				if (obj) {
					var len:int	=	obj.length;
					for (var i:int = 0; i < len; i++) {
						var kd:KData	=	obj[i];
						str +=	kd +" | ";
					}
					str +=	"\n";
				}
				count++;
			}
			trace(str);
		}
		//*************************[STATIC METHOD]**********************************//
		
		static public function getRandom(max:Number=10, min:Number=0):Number {
			return Math.random() * (max - min) + min;
		}
		
		static public function getRandomArr(num:int):Array {
			var retArr:Array	=	[];
			for (var i:int = 0; i < num; i++) {
				retArr.push(i);
			}
			var num2:int	=	num - 1;
			for (i = 0; i < num; i++) {
				var n:int	=	retArr.shift();
				retArr.splice(Math.floor(Math.random()*num2),0, n);
			}
			return retArr;
		}
		
	}
	
}//end class [com.wlash.game.kyodai.Kyodai]
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
