//******************************************************************************
//	name:	InitError 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-2-3 15:32
//	description: 当自定类初始化失败时,调用此类
//******************************************************************************

package com.wlash.exception {
	/**
	 * 自定义类初始化失败时.
	 * 
	 */
	public class InitError extends Error {
		
		/**
		 * 构建新类
		 * @param	message
		 * @param	id
		 */
		public function InitError(message:String = "", id:int = 0) {
			super(message, id);
		}
		/**
		 * 当throw错误时,显示的信息.
		 * @return
		 */
		public function toString():String {
			return "Initialize ERROR: "+message;
		}
	}
}