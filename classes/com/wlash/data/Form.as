//******************************************************************************
//	name:	Form 2.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-2-3 15:32
//	description: 表单,输入框内按回车或按tab切换,当到最后一项时,直接执行onRelease
//				一个swf中只能存在一个form,因为按键事件
//			邮件不能为以下字符 *|,\":<>[]{}`';()&$#%
//			增加身份证号生日与最后一位的验证.
//******************************************************************************


package com.wlash.data {
	import fl.transitions.easing.Strong;
	import flash.display.InteractiveObject;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	
	/**
	* 一个实用的表单提交检查类.
	* 
	* <p>可定义输入文本框的顺序，对于单行输入框，按下回车(Enter)键时，可自动跳到下一
	* 文本框中。最后一个文本框中按下回画键，相当于提交数据。</p>
	* <p>还可对邮件，手机，身份证号，日期等数据进行检验。</p>
	* 
	* @example 以下是调用的方法：
	* <listing>
	* var form:Form	=	new Form.getInstance();//因为要消除原来可能存在旧的form对象， 
	* form.addItem(name_txt);//把用户名文本框添加入
	* form.addItem(password_txt);//把输入密码框添加入
	* form.addItem(okay_btn);//添加提交按键
	* form.build(true);//构建form对象，可以使用回车键进行切换。
	* //如果要使用提示信息，必先添加信息框到Form当中。如下：
	* Form.setHintText(hints_txt);//hints_txt为文本框，把要显示的字体embed进去，可有fade效果。
	* //然后可以使用
	* Fomr.showHintText("要显示的字符。");//自动显示“要显示的字符”
	* //同时可以限制文本框可接受的字符。
	* email_txt.restrict = "A-Za-z0-9\\-_.@";
	* phone_txt.restrict = "0-9\\-"	;
	* </listing>
	* 
	*/
	public class Form extends Object{
		
		private var _item:Array;
		
		/**
		* set the hint text, when some info wanna hint.<br></br>
		* this is a textfield embed font that you wannna hint.
		*/
		private  static var _hintText:TextField;
		
		private static var _form:Form;
		private static var _timer:Timer;
		private static var _tween:Tween;
		
		/**
		* contruct function.<br></br>
		* in stage, it just only one form instance, so you could not create instance
		* by this function. you must create instance by Form.getInstance();
		* @example example code:
		* <listing>
		* var form:Form	=	Form.getInstance();//correct
		* var form:Form	=	new Form();//WRONG
		* </listing>
		*/
		function Form():void{
			this._item		=	[];
		}
		
		/**
		* create only one form.<br></br>
		* this class no contruct function, you only create instance by the method.
		* @return the only form you could create.
		*/
		public static function getInstance():Form{
			if(_form!=null){
				_form.destroy();//把原来的key事件去除,
			}
			_form	=	new Form();
			
			return _form;
		}
		
		//******************[PRIVATE METHOD]******************//
		/**
		* when user press keyCode, skip next input textfield or release button.
		* @param keyEvent
		*/
		private function onKeyUp(keyEvent:KeyboardEvent):void {
			if(keyEvent.keyCode==Keyboard.ENTER){
				var curObj:Object		=	keyEvent.target.stage.focus;
				var nextObj:Object		=	nextItem(curObj);
				
				if (nextObj is TextField) {
					if(nextObj.multiline==false){
						keyEvent.target.stage.focus	=	nextObj;
					}
				}else {
					if (nextObj.hasEventListener(MouseEvent.CLICK)) {
					//if (nextObj.willTrigger(MouseEvent.CLICK){//区别hasEventListener??
						nextObj.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					}
				}
			}
		};
		private function onBtnRemove(event:Event):void {
			destroy();
		}
		
		/**
		* seek next button or input textfield
		* @param  current text or button
		* @return next text or button
		*/
		private function nextItem(item:Object):Object{
			var i:Number	=	this._item.length;
			//item			=	eval(item);
			while(i--){
				if(this._item[i]==item){
					return	this._item[i+1];
				};
			};
			return null;
		};
		
		/**
		* destroy this Form
		*/
		private function destroy():void {
			try {
				var obj:Object	=	_item[_item.length - 1];
				obj.parent.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
				obj.removeEventListener(Event.REMOVED, onBtnRemove);
			}catch (e:TypeError) {
				trace("obj: " + obj, e);
			}
			this._item	=	null;
		}
		
		//******************[PUBLIC METHOD]******************//
		/**
		* add a InteractiveObject.<br></br>
		* 
		* @param item TextField or button or movieclip.
		* @throws Error if there are more then one SimpleButton or DisplayObjectContainer
		* 
		* @example sample code:
		* <listing>
		* form.addItem(input_txt);
		* form.addItem(submit_btn);
		* </listing>
		*/
		public function addItem(item:InteractiveObject):void {
			if (_item.length == 0) {
				_item.push(item);
				return ;
			}
			var obj:InteractiveObject	=	_item[_item.length - 1] as InteractiveObject;
			if(obj is TextField){
				_item.push(item);
			}else{
				throw new Error("only ONE SimpleButton|DisplayObjectContainer is supported. [(" +
									_item.length+".) "+typeof(item)+"], last item is ["+
									_item[_item.length-1].name+"].");
			}
		}
		
		/**
		* build listen event, when add all item to Form, you ought to build to start
		* listening the user action.
		* 
		* @param enabled if true, could skip next input TextField by press <b>Enter</b>.
		* 
		* @example sample code:
		* <listing>
		* form.build(true);//support Enter Key. default
		* </listing>
		*/
		public function build(enabled:Boolean=true):void{
			var i:Number	=	_item.length;
			var obj:InteractiveObject	=	null;
			while(i--){
				obj	=	this._item[i] as InteractiveObject;
				obj.tabIndex	=	i;
			}
			obj.stage.focus	=	obj;//光标在第一个文本框上.

			if(enabled){
				obj	=	_item[_item.length - 1] as InteractiveObject;
				if (obj is TextField)	return;
				try{
					obj.parent.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
					obj.addEventListener(Event.REMOVED_FROM_STAGE, onBtnRemove);
				}catch (e:TypeError) {
					trace("obj: " + obj, e);
				}
			}
		}
		
		/**
		* reset all input TextField.<br/>
		* all input TextField are reset to Empty.
		*/
		public function resetTextField():void{
			var len:uint	=	_item.length;
			var txt:InteractiveObject;
			for(var i:uint=0;i<len;i++){
				txt	=	_item[i] as InteractiveObject;
				if(txt is TextField){
					txt["text"]	=	"";
				}
			}
		}
		
		
		
		/**
		* show this class name
		* @return class name
		*/
		public function toString():String{
			return "[Form 2.0] item.length= "+_item.length;
		}
		
		
		//**************[static function]*********//
		/**
		* check email.
		* <p>建议用 [restrict = "A-Za-z0-9\\-_.&#64;"]来限制文本框的输入.
		* 只对输入的邮件的大概结构做判断,而不是全面合法性判断.
		* 要求邮件地址:只能以字母或数字开头,可以有(_或-)连继的存在,如a---b&#64;live.com
		* 但不能有a...b&#64;live.com的存在,因为不合法,也不能是abc.&#64;live.com
		* 可以是以IP地址结尾的电子邮件,如abc&#64;123.22.34.32
		* </p>
		* @param mailStr eamil address
		* @return true or false
		* 
		* @example sample code:
		* <listing>
		* Form.checkEmail("whohoo&#64;21cn.com");//return <code>true</code>
		* </listing>
		*/
		public static function checkEmail(mailStr:String):Boolean {
			//var pattern:RegExp =^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$;
			//var pattern:RegExp =^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$;
			//var pattern:RegExp =\\w+@(\\w+\\.)+[a-z]{2,3};
			//var pattern:RegExp = /([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}/;
			//var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;// flash上的帮助文档
			//^[a-z0-9]表示只能由字母与数字开头,在后边有个+表示这字母可以是一个或多个(词)
			//[.]?表示此点可有可无,但只有能一个点.这表示不可以有连续的点存在,如a...b@live.com
			//[\w-]+表示点的后边须跟字母或数字或_,且必须有一个或多个(词)以上,
			//以上是@前的规则说明. xxx@live.com可以以_或-开头,但hotmail.com不可以
			//gmail不准_或-符号,
			//([a-z0-9][a-z0-9-]*[.])+[a-z]{2,4},这是判断域名,因为可能有二级,三级,四级域名,
			//所以这里没有限制有多少级的域名存在.
			//[a-z0-9]表示必须以字母或数字开头,
			//[a-z0-9-]*表示域名当中除了有0个或多个字母或数字,还可以有-,但不能以-开头.
			//([a-z0-9][a-z0-9-]*[.])+一个以上这样的结构,
			//[a-z]{2,4}最后必须是字母结尾,现还搞不清楚最后顶级,有些是写6个,但我了解到的只有4个,
			//所以暂时先用4个表示.
			//有些邮件地址没有域名,只有IP地址,所以也要有IP地址的可能,
			//((25[0-5]|2[0-4]\d|[01]?\d\d?)[.]){3}(25[0-5]|2[0-4]\d|[01]?\d\d?) 这样可以规定的结构是
			//0.0.0.0到255.255.255.255, 实际上,有些特殊的IP地址是不可能为邮件地址的,如最后一位为0的时候
			//表示是广播地址,或127.0.0.1表示本机等.所以这个判断只是结构判断,而不是真正的合法性判断,
			//"^(([0-9a-zA-Z]+)|([0-9a-zA-Z]+[_.0-9a-zA-Z-]*[0-9a-zA-Z]+))@([a-zA-Z0-9-]+[.])+([a-zA-Z]{2}|net|NET|cn|CN|com|COM|gov|GOV|mil|MIL|org|ORG|edu|EDU|int|INT)$"
			var pattern:RegExp	=	/^[a-z0-9]+([.]?[\w-]+)*@(([a-z0-9][a-z0-9-]*[.])+[a-z]{2,4}|((25[0-5]|2[0-4]\d|[01]?\d\d?)[.]){3}(25[0-5]|2[0-4]\d|[01]?\d\d?))$/i;
            return pattern.test(mailStr);
		}
		
		/**
		* check mobile number,<br>
		* </br>
		* olny for china eare.
		* 手机号码从130到139,且还有新增的158,159
		* 注意,有些手机后跟有分机号码,在此不做判断
		* @param mobileNum mobile number
		* @return false if invaild.
		* 
		* @example sample code:
		* <listing>
		* Form.checkMobile("137614874464");//return false for length>11.
		* </listing>
		*/
		public static function checkMobile(mobileNum:String):Boolean {
			//0?表示可以在前有0或无0(外地手机),
			//1(3\d)表示130到139段
			//1(5[8-9])表示158到159,
			//最后再跟8个数字
			//有些手机后可能跟有分机,在此不做判断.
			var pattern:RegExp	=	/^0?1(3\d|5[8-9])\d{8}$/;
			return pattern.test(mobileNum);
			
		}
		
		/**
		* check date valid
		* @param dateStr format[yyyy-MM-dd hh:mm:ss]
		* 
		* @example sample code:
		* <listing>
		* Form.checkDate("2007-01-22");//return true
		* Form.checkDate("2007-02-32");//return false
		* Form.checkDate("2007-02-22 12:11");//return true
		* </listing>
		*/
		public static function checkDate(dateStr:String):Boolean{
			var dateStrArr:Array	=	dateStr.split(" ", 19);
			var dateStrArrLen:uint	=	dateStrArr.length;
			var timeArr:Array		=	["12", "00", "00"];//default time
			var dateArr:Array;
			switch (dateStrArrLen) {
				case 2://time
					timeArr		=	dateStrArr[1].split(":", 8);
				case 1://date
					dateArr		=	dateStrArr[0].split("-", 10);
					break;
				default:
					return false;
			}

			if (dateArr.length != 3)	return false;//达不到YYYY-MM-DD的格式
			var year:Number			=	Number(dateArr[0]);
			var month:Number		=	Number(dateArr[1])-1;
			var day:Number			=	Number(dateArr[2]);
			
			var hour:Number;
			var minute:Number;
			var second:Number	=	0;//default value
			switch (timeArr.length) {
				case 3:
					second	=	Number(timeArr[2]);
				case 2:
					hour	=	Number(timeArr[0]);
					minute	=	Number(timeArr[1]);
					break;
				default://达不到HH-MM格式,最后的SS可以省略.
					return false;
			}
			
			var dateTime:Date	=	new Date(year, month, day, hour, minute, second, 0);
			
			if(year!=dateTime.getFullYear()){
				return false;
			}else if(month!=dateTime.getMonth()){
				return false;
			}else if(day!=dateTime.getDate()){
				return false;
			};
			
			if(hour!=dateTime.getHours()){
				return false;
			}else if(minute!=dateTime.getMinutes()){
				return false;
			}else if(second!=dateTime.getSeconds()){
				return false;
			}
			return true;
		}
		
		/**
		* check id number valid
		* only for RPC id card number.
		* @param id a string of id number.
		* @return true if it is valid.
		* 
		* @example sample code:
		* <listing>
		* Form.checkID("4501314486437535445");//return false
		* </listing>
		*/
		public static function checkID(id:String):Boolean{
			var idStr:String;
			var idLen:Number	=	id.length;
			if(idLen==15){
				idStr	=	id.substr(0, 6)+"19"+id.substr(6);
			}else if(idLen==18){
				idStr	=	id.substr(0,17);
			}else{
				return false;
			}
			
			//////检查出生日期的正确性
			var dateStr:String	=	idStr.substr(6, 4)+"-"+idStr.substr(10, 2)+"-"+
																idStr.substr(12, 2);
			if (!checkDate(dateStr)) {
				return false;
			}else if (idLen == 15) {//如果是15位长度的旧版ID号,
				return true;
			}//18位的继续检查最后一位验证码是否正确.
			
			//检查最后一位数字,如果是18位的身分证号
			var arr:Array	=	idStr.split("");
			var WI:Array	=	[7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
			var VERIFYCODE:String	=	"10X98765432";
			var s:uint	=	0;
			for(var i:uint=0;i<17;i++){
				s	+=	uint(arr[i])*WI[i];
			}
			var lastDigit:String	=	VERIFYCODE.charAt(s%11);
			
			return id.substr(17, 1) == lastDigit;
		}
		
		/**
		* hints, you must embed font in that textfield or you would not see the words,<br/>
		* because the textfield display by fadeIn or fadeOut.
		* before call this function, you ought to call Form.setHintText(hints_txt);
		* 
		* @param text show text
		* @param second [optional] invisble after second, default 4 sec.
		* 
		* @see setHintText
		* 
		* @example sample code:
		* <listing>
		* Form.showHint("user name is empty.");
		* </listing>
		*/
		public static function showHint(text:String, second:uint=4):void {
			if (_hintText == null) {
				trace("ERROR:\ryou must call [Form.setHintText(txt)] before call [Form.showHint(text)].");
				return;
			}

			_timer.delay	=	second * 1000;
			_timer.start();
			_hintText.text	=	text;
			_hintText.alpha	=	100;
		}
		
		/**
		 * 定义的提示框,当调用Form.showHint()时,会慢慢消失文字
		 * @param	txt
		 */
		public static function setHintText(txt:TextField):void {
			_hintText	=	txt;
			if (_timer == null) {
				_timer	=	new Timer(4000);
				_timer.addEventListener(TimerEvent.TIMER, onTimer);
			}
			_timer.stop();
			if (_tween == null) {
				_tween =	new Tween(txt, "alpha", 
							Strong.easeOut,
							100, 0, 1.5, true);
				_tween.stop();
				_tween.addEventListener(TweenEvent.MOTION_FINISH, onMotionFinish);
			}
			
		}
		//EVENTS.
		private static function onTimer(tEvent:TimerEvent):void {
			tEvent.target.stop();
			_tween.start();//让文字消失
		}
		
		private static function onMotionFinish(tEvent:TweenEvent):void {
			_hintText.text	=	"";
		}
	}
}