//******************************************************************************
//	name:	LoadingBitRate 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	Wed Sep 05 16:41:24 GMT+0800 (China Standard Time) 2007
//	description: This file was created by "main.fla" file.
//		
//******************************************************************************


package com.wlash.loader {
	
	/**
	 * 事先定义好的常量.
	 * 
	 * <p>在LoaderProgress与ContentLoader类中可以调用,如果simulationMode为"bit/s"
	 * </p>
	 */
	public final class LoadingBitRate extends Object {
		
		/**不限制模拟的下载速度. */
		public static const NONE:uint				=	0;//bit/s
		/**模拟56k modem的下载速度为4800 bit/s. */
		public static const MODEM_BIT_RATE:uint		=	4800;//bit/s
		/**模拟DSL的下载速度为33400 bit/s. */
		public static const DSL_BIT_RATE:uint		=	33400;//bit/s
		/**模拟T1的下载速度为134300 bit/s. */
		public static const T1_BIT_RATE:uint		=	134300;//bit/s
		
		//***********************[PUBLIC METHOD]**********************************//
		
		//***********************[STATIC METHOD]**********************************//
		
		
	}//end class
}
