/*utf8*/
//**********************************************************************************//
//	name:	DatePicker 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Sun Feb 21 2010 23:33:41 GMT+0800
//	description: This file was created by "date_picker.fla" file.
//				
//**********************************************************************************//


//[com.wlash.effects.date.DatePicker]
package com.wlash.effects.date {

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	
	/**
	 * on click next month or previous month<br/>
	 *
	 * @eventType flash.events.Event
     * 
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	[Event(name = "changeMonth", type = "flash.events.Event")]
	
	/**
	 * 当thumb被按下时广播的事件<br/>
	 * DateEvent extend flash.events.Event
	 * DateEvent.data property.
	 * @eventType flash.events.Event
     * 
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 */
	[Event(name = "choose", type = "flash.events.Event")]
	
	
	/**
	 * DatePicker.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class DatePicker extends Sprite {
		
		public var dates_mc:Sprite;
		public var dayNames_mc:Sprite;
		public var title_mc:Sprite;//LAYER NAME: "dp_month_title", FRAME: [1-2], PATH: date_picker

		private var _dayNames/*String*/:Array;
		private var _monthNames/*String*/:Array;
		private var _today:Date;
		private var _firstDayOfWeek:int;
		private var _dateMcArr/*MovieClip*/:Array;
		private var _renderDate:Date;
		private var _showToday:Boolean;
		
		private var _todayMc:MovieClip;
		private var _disabledRanges:Array;
		private var _disabledDays:Array;
		private var _selectedDate:Date;
		private var _selectableRange:Object;
		//*************************[READ|WRITE]*************************************//
		/**@private */
		public function set today(value:Date):void {
			_today	=	value;
			_render();
		}
		
		/**set or get today*/
		public function get today():Date { return _today; }
		
		/**@private */
		public function set dayNames(value:Array):void {
			_dayNames	=	value;
			_renderDayNames();
		}
		
		/**
		 * an array containing the names of the days of the week. 
		 * Sunday is the first day (at index position 0) and the rest of the day names follow in order. 
		 * The default value is ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], you could set
		 * ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"] or
		 * ["S", "M", "T", "W", "T", "F", "S"]
		 * @example
		 * <listing version="3.0">
		 * my_dc.dayNames = new Array("Su", "Mo", "Tu", "We", "Th", "Fr", "Sa");
		 * </listing>
		 */
		public function get dayNames():Array { return _dayNames; }
		
		/**@private */
		public function set monthNames(value:Array):void {
			_monthNames	=	value;
			_renderMonthNames();
		}
		
		/**
		 * an array of strings indicating the month names at the top of the DateChooser component.
		 * The default value is  ["January","February","March","April","May", "June","July","August","September", "October", "November", "December"]
		 * @example
		 * <listing version="3.0">
		 * my_dc.monthNames = ["Jan", "Feb","Mar","Apr", "May", "June","July", "Aug", "Sept","Oct", "Nov", "Dec"];
		 * </listing>
		 */
		public function get monthNames():Array { return _monthNames; }
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		public function set firstDayOfWeek(value:int):void {
			_firstDayOfWeek	=	value;
			_renderDayNames();
			_render();
		}
		
		/**
		* a number indicating which day of the week (0-6, 0 being the first element of the dayNames array) 
		* is displayed in the first column of the DateChooser component. Changing this property changes 
		* the order of the day columns but has no effect on the order of the dayNames property. 
		* The default value is 0 (Sunday).
		* @example
		* <listing version="3.0">
		*   // Sets the first day of the week to Monday in the calendar.
		*	my_dc.firstDayOfWeek = 1;
		*	// Disables day 0 (Sunday). Even though Monday is now the first day in the DateChooser, Sunday is still array index 0.
		*	my_dc.disabledDays = [0];
		* </listing>
		*/
		public function get firstDayOfWeek():int { return _firstDayOfWeek; }
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		public function set displayedMonth(value:int):void {
			_renderDate.month	=	value;
		}
		
		/**
		 * a number indicating which month is displayed. The number indicates an element in the monthNames array, 
		 * with 0 being the first month. The default value is the month of the current date.
		 * @example
		 * <listing version="3.0">
		 * my_dc.displayedMonth = 11;
		 * </listing>
		 */
		public function get displayedMonth():int { return _renderDate.month; }
		
		[Inspectable(defaultValue="2010", verbose="1", type="Number", category="")]
		/**@private */
		public function set displayedYear(value:int):void {
			_renderDate.fullYear	=	value;
		}
		
		/**
		 * a four-digit number indicating which year is displayed. The default value is the current year.
		 * @example
		 * <listing version="3.0">
		 * my_dc.displayedYear = 2010;
		 * </listing>
		 */
		public function get displayedYear():int { return _renderDate.fullYear; }
		
		[Inspectable(defaultValue="true", verbose="1", type="Boolean", category="")]
		/**@private */
		public function set showToday(value:Boolean):void {
			_showToday	=	value;
			
			_renderShowToday();
		}
		
		/**
		 * a Boolean value that determines whether the current date is highlighted. The default value is true.
		 * @example
		 * <listing version="3.0">
		 * //The following example turns off the highlighting on today's date:
		 * my_dc.showToday = false;
		 * </listing>
		 */
		public function get showToday():Boolean { return _showToday; }
		
		/**@private */
		public function set disabledRanges(value:Array):void {
			_disabledRanges	=	value;
			if (value.length == 0) {
				_disabledRanges	=	undefined;
			}
			_render();
		}
		
		/**
		 * disables a single day or a range of days. This property is an array of objects. 
		 * Each object in the array must be either a Date object that specifies a single day to disable, 
		 * or an object that contains either or both of the properties rangeStart and rangeEnd, 
		 * each of whose value must be a Date object. The rangeStart and rangeEnd properties describe 
		 * the boundaries of the date range. If either property is omitted, the range is unbounded in that direction.
		 * The default value of disabledRanges is undefined.
		 * Specify a full date when you define dates for the disabledRanges property. 
		 * For example, specify new Date(2003,6,24) rather than new Date(). If you don't specify a full date, 
		 * the Date object returns the current date and time. If you don't specify a time, 
		 * the time is returned as 00:00:00.
		 * @example
		 * <listing version="3.0">
		 * //The following example defines an array with rangeStart  and rangeEnd Date objects that disable the dates between May 7 and June 7:
		 * my_dc.disabledRanges = [{rangeStart: new Date(2003, 4, 7), rangeEnd: new Date(2003, 5, 7)}];
		 * //The following example disables all dates after November 7:
		 * my_dc.disabledRanges = [ {rangeStart: new Date(2003, 10, 7)} ];
		 * //The following example disables all dates before October 7:
		 * my_dc.disabledRanges = [ {rangeEnd: new Date(2002, 9, 7)} ];
		 * //The following example disables only December 7:
		 * my_dc.disabledRanges = [ new Date(2003, 11, 7) ];
		 * //The following example disables April 7 and April 21:
		 * my_dc.disabledRanges = [ new Date(2003, 3, 7), new Date(2003, 3, 21)];
		 * </listing>
		 */
		public function get disabledRanges():Array { return _disabledRanges; }
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		public function set year(value:int):void {
			if (_renderDate.fullYear == value)	return;
			_renderDate.fullYear	=	value;
			_render();
		}
		
		/**Annotation*/
		public function get year():int { return _renderDate.fullYear; }
		
		[Inspectable(defaultValue="0", verbose="1", type="Number", category="")]
		/**@private */
		public function set month(value:int):void {
			if (_renderDate.month == value)	return;
			_renderDate.month	=	value;
			_render();
		}
		
		/**Annotation*/
		public function get month():int { return _renderDate.month; }
		
		[Inspectable(defaultValue="", verbose="1", type="Array", category="")]
		/**@private */
		public function set disabledDays(value:Array):void {
			_disabledDays	=	value;
			_render();
		}
		
		/**
		 * an array indicating the disabled days of the week. All the dates in a month that fall on 
		 * the specified day are disabled. The elements of this array can have values from 0 (Sunday) to 6 (Saturday). 
		 * The default value is [] (an empty array).
		 * @example
		 * <listing version="3.0">
		 * //The following example disables Sundays and Saturdays so that users can select only weekdays:
		 * my_dc.disabledDays = [0, 6];
		 * </listing>
		 */
		public function get disabledDays():Array { return _disabledDays; }
		
		[Inspectable(defaultValue="", verbose="1", type="Object", category="")]
		/**@private */
		public function set selectableRange(value:Object):void {
			_selectableRange	=	value;
			_render();
		}
		
		/**
		 * sets a single selectable date or a range of selectable dates. The user cannot scroll beyond the 
		 * selectable range. The value of this property is an object that consists of two Date objects named 
		 * rangeStart and rangeEnd. The rangeStart and rangeEnd properties designate the boundaries of 
		 * the selectable date range. If only rangeStart is defined, all the dates after rangeStart are enabled. 
		 * If only rangeEnd is defined, all the dates before rangeEnd are enabled. The default value is undefined.
		 * If you want to enable only a single day, you can use a single Date object as the value of selectableRange.
		 * Specify a full date when you define dates--for example, new Date(2003,6,24) rather than new Date(). 
		 * If you don't specify a full date, the Date object returns the current date and time. If you don't specify a time,
		 * the time is returned as 00:00:00.The value of DateChooser.selectedDate is set to undefined 
		 * if it falls outside the selectable range.The values of DateChooser.displayedMonth and 
		 * DateChooser.displayedYear are set to the nearest last month in the selectable range if the current month 
		 * falls outside the selectable range. For example, if the current displayed month is August, 
		 * and the selectable range is from June 2003 to July, 2003, the displayed month changes to July 2003.
		 * @example
		 * <listing version="3.0">
		 * //The following example defines the selectable range as the dates between and including May 7 and June 7:
		 * my_dc.selectableRange = {rangeStart: new Date(2001, 4, 7), rangeEnd: new Date(2003, 5, 7)};
		 * //The following example defines the selectable range as the dates after and including May 7:
		 * my_dc.selectableRange = {rangeStart: new Date(2005, 4, 7)};
		 * //The following example defines the selectable range as the dates before and including June 7:
		 * my_dc.selectableRange = {rangeEnd: new Date(2005, 5, 7)};
		 * //The following example defines the selectable date as June 7 only:
		 * my_dc.selectableRange = new Date(2005, 5, 7);
		 * </listing>
		 */
		public function get selectableRange():Object { return _selectableRange; }
		
		[Inspectable(defaultValue="", verbose="1", type="Date", category="")]
		/**@private */
		public function set selectedDate(value:Date):void {
			_selectedDate	=	value;
			_render();
		}
		
		/**
		 * a Date object that indicates the selected date if that value falls within the value of the selectableRange 
		 * property. The default value is undefined.
		 * You cannot set the selectedDate property within a disabled range, outside a selectable range, 
		 * or on a day that has been disabled. If this property is set to one of these dates, the value is undefined.
		 * @example
		 * <listing version="3.0">
		 * //The following example sets the selected date to June 7:
		 * my_dc.selectedDate = new Date(2005, 5, 7);
		 * </listing>
		 */
		public function get selectedDate():Date { return _selectedDate; }
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new DatePicker();]
		 */
		public function DatePicker() {
			_showToday		=	true;
			_firstDayOfWeek	=	0;
			_disabledDays	=	[];
			_dayNames		=	["Sun", "Mon", "Tus", "Wed", "Thu", "Fri", "Sat"];
			_monthNames		=	["January","February","March","April","May", "June","July","August","September",
									"October", "November", "December"];
			
			initDatesArr();
			_init();
			
		}
		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * next month
		 */
		public function nextMonth():void {
			_renderDate.month++;
			_render();
		}
		
		/**
		 * previous month
		 */
		public function prevMonth():void {
			_renderDate.month--;
			_render();
		}
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		
		
		protected function _render():void{
			var len:int		=	_dateMcArr.length;
			var first:Date	=	getFirtDayOfMonth(_renderDate);
			var firstDay:int	=	(first.day - _firstDayOfWeek + 7) % 7;
			var last:Date	=	getLastDayOfMonth(_renderDate);
			var lastDate:int	=	last.date + firstDay;
			for (var i:int = 0; i < len; i++) {
				var mc:MovieClip	=	_dateMcArr[i];
				var txt:TextField	=	mc["date_txt"];
				if (i >= firstDay && i < lastDate) {
					var d:int	=	(i - firstDay + 1);
					mc["dateStr"]	=	
					txt.text	=	d < 10 ? " " + d : "" + d;
					mc["state"]	=	"enabled";
					mc.gotoAndStop("enabled");
					mc.buttonMode		=
					mc.mouseChildren	=	
					mc.mouseEnabled		=	true;
				}else {
					txt.text	=	"";
					mc["state"]	=	"none";
					mc.gotoAndStop("none");
					mc.buttonMode		=
					mc.mouseChildren	=	
					mc.mouseEnabled		=	false;
				}
			}
			
			_renderShowToday();
			_renderMonthNames();
			_renderDisabledRange();
			_renderDisabledDays();
			_renderSelectableRange();
			_renderSelectedDate();
		}
		
		protected function _renderShowToday():void {
			
			if (_renderDate.fullYear == _today.fullYear && _renderDate.month == _today.month) {
				var mc:MovieClip	=	getDateMcByDate(_today.date);
				if (_showToday) {
					mc["today_mc"].visible	=	true;
					_todayMc	=	mc;
				}else {
					mc["today_mc"].visible	=	false;
					_todayMc	=	null;
				}
			}else {
				if(_todayMc){
					_todayMc["today_mc"].visible	=	false;
					_todayMc	=	null;
				}
			}
		}
		
		protected function _renderDayNames():void {
			for (var i:int = 0; i < 7; i++) {
				var mc:Sprite		=	dayNames_mc["dayName" + i];
				mc["name_txt"].text	=	_dayNames[(i + _firstDayOfWeek) % 7];
			}
		}
		
		protected function _renderMonthNames():void {
			title_mc["title_txt"].text	=	_monthNames[_renderDate.month] + " " + _renderDate.fullYear;
		}
		
		protected function _renderDisabledDays():void {
			var len:int	=	_disabledDays.length;
			var first:Date	=	getFirtDayOfMonth(_renderDate);
			var firstDate:int	=	first.date;
			var last:Date	=	getLastDayOfMonth(_renderDate);
			var lastDate:int	=	last.date;
			var d:Date		=	new Date();
			d.setTime(d.getTime());
			for (var i:int = firstDate; i <= lastDate; i++) {
				var mc:MovieClip	=	_dateMcArr[i];
				d.setDate(i);
				for (var ii:int = 0; ii < len; ii++) {
					if (d.day == _disabledDays[ii]) {
						_setDisabled(i);
					}
				}
			}
		}
		
		protected function _renderDisabledRange():void {
			var value:Array	=	_disabledRanges;
			var d:Date;
			var dateMc:MovieClip;
			var curYear:int		=	_renderDate.fullYear;
			var curMonth:int	=	_renderDate.month;
			var obj:Object;
			if (!value) {//all enabled
				//enabledAllDates();
			}else if (value[0] is Date) {
				//enabledAllDates();
				var len:int	=	value.length;
				for (var i:int = 0; i < len; i++) {
					d	=	value[i];
					if (d.fullYear == curYear && d.month == curMonth) {
						_setDisabled(d.date);
					}
				}
			}else if (Object(value[0]).hasOwnProperty("rangeStart") || Object(value[0]).hasOwnProperty("rangeEnd")) {
				//enabledAllDates();
				obj	=	value[0];
				var rStart:Date	=	obj["rangeStart"] as Date;
				var rEnd:Date	=	obj["rangeEnd"] as Date;
				if (!rStart) {
					rStart	=	new Date();
					rStart.time	=	0;
				}
				if (!rEnd) {
					rEnd	=	new Date();
					rEnd.time	=	int.MAX_VALUE;
				}
				
				if (rEnd.time >= rStart.time) {
					len	=	getLastDayOfMonth(_renderDate).date + 1;//当前月的天数
					var rStartI:Number	=	rStart.time;
					var rEndI:Number	=	rEnd.time;
					d	=	new Date();
					d.time	=	_renderDate.time;
					for (i = 1; i < len; i++) {
						d.date	=	i;
						var t:Number	=	d.time;
						if (t >= rStartI && t <= rEndI) {//比较大小
							_setDisabled(d.date);
						}
					}
				}else {
					throw new Error("_renderDisabledRange|bad Date | rangeStart : " + rStart +" large than rangeEnd : " + rEnd);
				}
				
			}
		}
		
		protected function _renderSelectableRange():void {
			var value:Object	=	_selectableRange;
			var d:Date;
			var dateMc:MovieClip;
			var curYear:int		=	_renderDate.fullYear;
			var curMonth:int	=	_renderDate.month;
			if (!value) {//no selected
				//
			}else if (value is Date) {
				d	=	value as Date;
				if (d.fullYear == curYear && d.month == curMonth) {
					_setSelected(d.date);
				}
			}else if (Object(value).hasOwnProperty("rangeStart") || Object(value).hasOwnProperty("rangeEnd")) {
				//enabledAllDates();
				var rStart:Date	=	value["rangeStart"] as Date;
				var rStartYear:int	=	rStart.fullYear;
				var rStartMonth:int	=	rStart.month;
				var rStartDate:int	=	rStart.date;
				var rEnd:Date	=	value["rangeEnd"] as Date;
				var rEndYear:int	=	rEnd.fullYear;
				var rEndMonth:int	=	rEnd.month;
				var rEndDate:int	=	rEnd.date;
				
				if (!rStart) {
					rStart		=	new Date();
					rStart.time	=	0;
				}
				if (!rEnd) {
					rEnd		=	new Date();
					rEnd.time	=	int.MAX_VALUE;
				}
				if (rEnd.time >= rStart.time) {
					var len:int	=	getLastDayOfMonth(_renderDate).date + 1;//当前月的天数
					var rStartI:Number	=	rStart.time;
					var rEndI:Number	=	rEnd.time;
					d	=	new Date();
					d.time	=	_renderDate.time;
					for (var i:int = 1; i < len; i++) {
						d.date	=	i;
						var t:Number	=	d.time;
						//trace( "t : " + t, rStartI,rEndI );
						if (t >= rStartI && t <= rEndI) {//比较大小
							_setSelected(d.date);
						}
					}
				}else {
					throw new Error("_renderSelectableRange|bad Date | rangeStart : " + rStart +" large than rangeEnd : " + rEnd);
				}
				
			}
		}
		
		protected function _renderSelectedDate():void {
			if (!_selectedDate)	return;
			if (_renderDate.fullYear==_selectedDate.fullYear && _renderDate.month == _selectedDate.month) {
				_setSelected(_selectedDate.date);
			}
		}
		
		protected function enabledAllDates():void {
			var len:int	=	_dateMcArr.length;
			for (var i:int = 0; i < len; i++) {
				var mc:MovieClip	=	_dateMcArr[i];
				if(mc.currentFrame>1){
					mc.gotoAndStop("enabled");
				}
			}
		}
		
		protected function disabledAllDates():void {
			var len:int	=	_dateMcArr.length;
			for (var i:int = 0; i < len; i++) {
				_dateMcArr[i].gotoAndStop("disabled");
			}
		}
		
		protected function getFirtDayOfMonth(value:Date):Date {
			var d:Date	=	new Date();
			d.setTime(value.getTime());
			d.setDate(1);
			return d;
		}
		
		protected function getLastDayOfMonth(value:Date):Date {
			var d:Date	=	getFirtDayOfMonth(value);
			d.month++;
			d.date--;
			return d;
		}
		
		protected function getDateMcByDate(value:int):MovieClip {
			var first:Date	=	getFirtDayOfMonth(_renderDate);
			var firstDay:int	=	(first.day - _firstDayOfWeek + 7) % 7;
			return _dateMcArr[firstDay + value-1];
		}
		
		protected function init():void {
			title_mc["left_btn"].addEventListener(MouseEvent.CLICK, _onClickPrev);
			title_mc["right_btn"].addEventListener(MouseEvent.CLICK, _onClickNext);
			
		}
		
		protected function _onClickPrev(e:MouseEvent):void {
			prevMonth();
			
			var de:DateEvent	=	new DateEvent("changeMonth"); 
			var d:Date	=	new Date();
			d.time	=	_renderDate.time;
			de.date	=	d;
			dispatchEvent(de);
		}
		
		protected function _onClickNext(e:MouseEvent):void {
			nextMonth();
			
			var de:DateEvent	=	new DateEvent("changeMonth"); 
			var d:Date	=	new Date();
			d.time	=	_renderDate.time;
			de.date	=	d;
			dispatchEvent(de);
		}
		
		protected function _setSelected(value:int):void {
			var mc:MovieClip	=	getDateMcByDate(value);
			if (mc["state"] != "none" || mc["state"] != "disabled") {
				mc["state"] = "selected";
				mc.gotoAndStop("selected");
			}
		}
		
		protected function _setDisabled(value:int):void {
			__setEnabled(value, false);
		}
		
		protected function _setEnabled(value:int):void {
			__setEnabled(value, true);
		}
		
		/////////////Date Events///////////////
		protected function _onClickDate(e:MouseEvent):void {
			var de:DateEvent	=	new DateEvent("choose"); 
			var mc:MovieClip	=	e.currentTarget as MovieClip;
			var d:Date	=	new Date();
			d.time	=	_renderDate.time;
			d.date	=	int(mc["date_txt"].text);
			de.date	=	d;
			dispatchEvent(de);
		}
			
		protected function _onOverDate(e:MouseEvent):void {
			var mc:MovieClip	=	e.currentTarget as MovieClip;
			//trace( "mc[\"state\"] _onOverDate: " + mc["state"] );
			if (mc["state"] == "selected")	return;
			//trace( "mc : " + mc );
			mc.gotoAndStop("hover");
			//trace( "mc.date_txt : " + mc.date_txt,mc["dateStr"] );
			mc.date_txt.text	=		mc["dateStr"];
			
		}
		
		protected function _onOutDate(e:MouseEvent):void {
			var mc:MovieClip	=	e.currentTarget as MovieClip;
			//trace( "mc[\"state\"] _onOutDate: " + mc["state"] );
			if (mc["state"] == "selected")	return;
			mc.gotoAndStop("enabled");
			mc.date_txt.text	=		mc["dateStr"];
		}
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			_renderDate	=	new Date();
			_today		=	new Date();
			//disabledRanges	=	[new Date()];
			_renderDayNames();
			_render();
			init();
		}
		
		private function initDatesArr():void {
			_dateMcArr	=	[];
			var len:int	=	dates_mc.numChildren;
			for (var i:int = 0; i < len; i++) {
				var mc:MovieClip	=	dates_mc.getChildAt(i) as MovieClip;
				mc["today_mc"].visible		=	
				mc["today_mc"].mouseEnabled	=
				mc["today_mc"].mouseChildren	=
				mc.date_txt.mouseEnabled	=	false;
				mc["dateStr"]	=	"0";
				mc["state"]		=	"none";
				mc.stop();
				mc.addEventListener(MouseEvent.CLICK, _onClickDate);
				mc.addEventListener(MouseEvent.ROLL_OVER, _onOverDate);
				mc.addEventListener(MouseEvent.ROLL_OUT, _onOutDate);
				_dateMcArr.push(mc);
			}
		}
		
		private function __setEnabled(value:int, value1:Boolean):void {
			var mc:MovieClip	=	getDateMcByDate(value);
			mc["state"]	=	 value1 ? "enabled" : "disabled";
			mc.gotoAndStop(mc["state"]);
			//TODO i don't know why??!!
			var d1:int	=	value;
			mc.date_txt.text	=		mc["dateStr"];
			mc.buttonMode		=
			mc.mouseChildren	=	
			mc.mouseEnabled		=		value1;
		}
		//*************************[STATIC METHOD]**********************************//
		
		
	}
	
	
	
}

import flash.events.Event;
class DateEvent extends Event {
	public var date:Date;
	
	public function DateEvent(type:String) {
		super(type, false, false);
	}
}
	
//end class [com.wlash.effects.date.DatePicker]
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
