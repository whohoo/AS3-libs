/*utf8*/
//**********************************************************************************//
//	name:	AbRequestData 1.3
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	2010/11/26 10:09
//	description: 
//				1.1 增加xmlComplete事件
//					增加requestData的引用
//				1.2 增加dataComplete事件
//				1.3 增加当事件为空的判断
//**********************************************************************************//


//[com.wlash.data.ReqFnRef]
package com.wlash.data {

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;



	/**
	 * RequestData.
	 * <p>annotate here for this class.</p>
	 *
	 */
	public class ReqFnRef extends Object {
		
		public var url:String;
		
		public var data:Object;
		public var paramObj:Object;
		
		public var statusCode:int;
		public var ioErrorText:String;
		public var securityErrorText:String;
		
		internal var requestData:AbRequestData;
		internal var _completeFn:Function;//当加载成功时调用的该当,通过属性来指定
		
		private var _callBackFn:Function;
		private var _errorFn:Function;
		//*************************[READ|WRITE]*************************************//
		public function set callBackFn(value:Function):void {
			if (value == null) {
				_callBackFn	=	function(...args) { };
			}else {
				_callBackFn	=	value;
			}
			
		}

		public function get callBackFn():Function { return _callBackFn; }
		
		public function set errorFn(value:Function):void {
			if (value == null) {
				_errorFn	=	function(...args) { };
			}else {
				_errorFn	=	value;
			}
			
		}

		public function get errorFn():Function { return _errorFn; }
		//*************************[READ ONLY]**************************************//
		
		//*************************[STATIC]*****************************************//

		

		/**
		 * CONSTRUCTION FUNCTION.<br />
		 */
		public function ReqFnRef(reqData:AbRequestData, cb:Function, err:Function, url:String, pObj:Object = null, data:* = null) {
			requestData	=	reqData;
			statusCode	=	-1;
			callBackFn	=	cb;
			errorFn		=	err;
			this.url	=	url;
			paramObj	=	pObj;
			this.data	=	data;
		}

		//*************************[PUBLIC METHOD]**********************************//
		/**
		 * Show class name.
		 * @return class name
		 */
		public function toString():String {
			return "ReqFnRef 1.1 [statusCode=" + statusCode + ", ioErrorText=" + ioErrorText +
						", securityErrorText=" + securityErrorText + ", url=" + url + "]";
		}

		public function destroy():void {
			_completeFn			=	null;
			requestData			=	null;
			
			securityErrorText	=	null;
			statusCode			=	-1;
			ioErrorText			=	null;
			
			url					=	null;
			paramObj			=	null;
			
			callBackFn			=	null;
			errorFn				=	null;
			data				=	null;
			paramObj			=	null;
		}
		

		//*************************[INTERNAL METHOD]********************************//
		/**
		 * 只处理普通的xml样式的返回
		 * @param	e
		 */
		internal function xmlComplete(e:Event):void {
			var urlLoader:URLLoader	=	e.currentTarget as URLLoader;
			var data:Object			=	urlLoader.data;
			if (String(data).length != 0) {
				if (String(data).indexOf("<") >= 0) {
					try{
						var xml:XML		=	new XML(String(data));
						if(_completeFn!=null)	_completeFn(xml, this);
					}catch (err:TypeError) {//1.如果【元素类型“writing”必须以匹配的结束标记“</writing>”结束。】
						//这表示是XML错误，
						//2.如果throw出的是无法访问对象或属性，则是外部定义的_completeFn里的函数
						//某个属性访问不到
						ioErrorText	=	err.message;
						if(errorFn!=null)	errorFn(this);
					}
				}else {
					ioErrorText	=	"not XML format";
					if(errorFn!=null)	errorFn(this);
				}
			}else {
				ioErrorText	=	"empty content";
				if(errorFn!=null)	errorFn(this);
			}
			
			requestData.releaseEvents(urlLoader);
		}
		
		/**
		 * 只处理普通的xml样式的返回
		 * @param	e
		 */
		internal function dataComplete(e:Event):void {
			var urlLoader:URLLoader	=	e.currentTarget as URLLoader;
			var data:Object			=	urlLoader.data;
			if (String(data).length != 0) {
				if(_completeFn!=null)	_completeFn(String(data), this);
			}else {
				ioErrorText	=	"empty content";
				if(errorFn!=null)	errorFn(this);
			}
			
			requestData.releaseEvents(urlLoader);
		}
		
		internal function securityError(e:SecurityErrorEvent):void {
			securityErrorText	=	e.text;
		}
		
		internal function httpStatus(e:HTTPStatusEvent):void {
			statusCode	=	e.status;
			if (statusCode != 200 && //success
				statusCode != 0 &&//for local file
				statusCode < 400) {
				if(errorFn!=null)	errorFn(this);
				
				var urlLoader:URLLoader	=	e.currentTarget as URLLoader;
				requestData.releaseEvents(urlLoader);
			}
		}
		
		internal function ioError(e:IOErrorEvent):void {
			ioErrorText	=	e.text;
			if(errorFn!=null)	errorFn(this);
			
			var urlLoader:URLLoader	=	e.currentTarget as URLLoader;
			requestData.releaseEvents(urlLoader);
		}
		
		

		
		//*************************[PROTECTED METHOD]*******************************//


		//*************************[PRIVATE METHOD]*********************************//
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
	}


}
//end class [com.wlash.puma.wp2010.RequestData]
//This template is created by whohoo. ver 1.3.0

/*below code were removed from above.

 * dispatch event when targeted.
 *
 * @eventType flash.events.Event
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0

   [Event(name = "sampleEvent", type = "flash.events.Event")]
1**：请求收到，继续处理
2**：操作成功收到，分析、接受
3**：完成此请求必须进一步处理
4**：请求包含一个错误语法或不能完成
5**：服务器执行一个完全有效请求失败

100——客户必须继续发出请求
101——客户要求服务器根据请求转换HTTP协议版本

200——交易成功
201——提示知道新文件的URL
202——接受和处理、但处理未完成
203——返回信息不确定或不完整
204——请求收到，但返回信息为空
205——服务器完成了请求，用户代理必须复位当前已经浏览过的文件
206——服务器已经完成了部分用户的GET请求

300——请求的资源可在多处得到
301——删除请求数据
302——在其他地址发现了请求数据
303——建议客户访问其他URL或访问方式
304——客户端已经执行了GET，但文件未变化
305——请求的资源必须从服务器指定的地址得到
306——前一版本HTTP中使用的代码，现行版本中不再使用
307——申明请求的资源临时性删除

400——错误请求，如语法错误
401——请求授权失败
402——保留有效ChargeTo头响应
403——请求不允许
404——没有发现文件、查询或URl
405——用户在Request-Line字段定义的方法不允许
406——根据用户发送的Accept拖，请求资源不可访问
407——类似401，用户必须首先在代理服务器上得到授权
408——客户端没有在用户指定的饿时间内完成请求
409——对当前资源状态，请求不能完成
410——服务器上不再有此资源且无进一步的参考地址
411——服务器拒绝用户定义的Content-Length属性请求
412——一个或多个请求头字段在当前请求中错误
413——请求的资源大于服务器允许的大小
414——请求的资源URL长于服务器允许的长度
415——请求资源不支持请求项目格式
416——请求中包含Range请求头字段，在当前请求资源范围内没有range指示值，请求
也不包含If-Range请求头字段
417——服务器不满足请求Expect头字段指定的期望值，如果是代理服务器，可能是下
一级服务器不能满足请求

500——服务器产生内部错误
501——服务器不支持请求的函数
502——服务器暂时不可用，有时是为了防止发生系统过载
503——服务器过载或暂停维修
504——关口过载，服务器使用另一个关口或服务来响应用户，等待时间设定值较长
505——服务器不支持或拒绝支请求头中指定的HTTP版本 


 */
