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
	
	
	
	public class Form extends Object{
		
		
		function Form():void{
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
			//var pattern:RegExp	=	/^0?1(3\d|5[0-9])\d{8}$/;
			var pattern:RegExp	=	/^0?1(3\d|5\d|8\d)\d{8}$/;
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
		 * 去除左右空白字符
		 * @param	char
		 * @return
		 */
		public static function trim(char:String):String{
			if(char==null){
				return null;
			}
			return rtrim(ltrim(char));
		}

		/**
		 * 去除左空白字符
		 * @param	char
		 * @return
		 */
		public static function ltrim(char:String):String{
			if(char==null){
				return null;
			}
			var pattern:RegExp=/^\s*/;
			return char.replace(pattern, "");
		}
		
		/**
		 * 去除右空白字符
		 * @param	char
		 * @return
		 */
		public static function rtrim(char:String):String{
			if(char==null){
				return null;
			}
			var pattern:RegExp=/\s*$/;
			return char.replace(pattern, "");
		} 
	}
}