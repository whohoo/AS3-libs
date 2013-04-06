//******************************************************************************
//	name:	PagesObj 1.0
//	author:	whohoo
//	email:	whohoo@21cn.com
//	date:	2008-7-24 15:58
//	description: 
//		
//******************************************************************************



package com.wlash.effects {

	
	/**
	 * PagesObj.
	 * <p>page object</p>
	 * 
	 */
	public class PagesObj extends Object {
		
		private var pagesArr:Array		=	[];
		//************************[READ|WRITE]************************************//
		
		//************************[READ ONLY]*************************************//
		public function get length():uint { return pagesArr.length; }
		
		
		/**
		 * Construction function.<br></br>
		 * Create a class BY [new AMFResponderEvent();]
		 */
		public function PagesObj() {
			
		}
		
		//************************[PRIVATE METHOD]********************************//
		/**
		 * Initializtion this class
		 * 
		 */
		private function init():void{
			
		}
		
		
		//***********************[PUBLIC METHOD]**********************************//
		internal function addPage(page:FlipPage):void {
			var len:int	=	pagesArr.length;
			for (var i:int = 0; i < len; i++) {
				if (pagesArr[i] == page) {
					return;
				}
			}
			pagesArr.push( page );
		}
		
		internal function removePage(page:FlipPage):void{
			var len:int	=	pagesArr.length;
			for (var i:int = 0; i < len; i++) {
				if (pagesArr[i] == page) {
					pagesArr.splice(i, 1);
				}
			}
		}
		
		internal function removePageByIndex(index:uint):void{
			var len:int	=	pagesArr.length;
			//trace('getPageByIndex| index: '+ index+", len: "+len);
			for (var i:int = 0; i < len; i++) {
				if (pagesArr[i].index == index) {
					pagesArr.splice(i, 1);
					break;
				}
			}
			//trace("removePageByIndex| len: "+pagesArr.length);
		}
		
		public function getPageByIndex(index:uint):FlipPage {
			var len:int	=	pagesArr.length;
			for (var i:int = 0; i < len; i++) {
				if (pagesArr[i].index == index) {
					return pagesArr[i];
				}
			}
			return null;
		}
		
		public function getPageAt(index:uint):FlipPage {
			if (index >= pagesArr.length)	return	null;
			return pagesArr[index];
		}
		
		public function existPage(page:FlipPage):Boolean {
			return getPageByIndex(page.index)!=null;
		}
		
		public function toString():String {
			var str:String	=	"";
			var len:int		=	pagesArr.length;
			for (var i:int = 0; i < len; i++) {
				var page:FlipPage	=	pagesArr[i] as FlipPage;
				str		+=	i + ") " + page + "\r";
			}
			return str;
		}
		
		
		//***********************[STATIC METHOD]**********************************//
		
	}
}//end class
//This template is created by whohoo. ver 1.1.0

/*below code were removed from above.
	
	 * dispatch event when targeted.
	 * 
	 * @eventType flash.events.Event
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 
	[Event(name = "sampleEvent", type = "flash.events.Event")]


*/
