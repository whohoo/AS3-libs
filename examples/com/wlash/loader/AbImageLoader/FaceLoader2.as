/*utf8*/
//**********************************************************************************//
//	name:	AbFace 1.0
//	author:	Wally.Ho
//	email:	whohoo@21cn.com
//	date:	Wed Sep 21 2011 22:14:19 GMT+0800
//	description: This file was created by "post.fla" file.
//				
//**********************************************************************************//


//[com.wlash.puma.social.renren.post.AbFace]
package  {

	import com.wlash.loader.AbImageLoader2;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	/**
	 * AbFace.
	 * <p>annotate here for this class.</p>
	 * 
	 */
	public class FaceLoader2 extends AbImageLoader2 {
		

		
		
		//*************************[READ|WRITE]*************************************//
		
		
		//*************************[READ ONLY]**************************************//
		
		
		//*************************[STATIC]*****************************************//
		
		
		/**
		 * CONSTRUCTION FUNCTION.<br />
		 * Create this class BY [new AbFace();]
		 */
		public function FaceLoader1() {
			//_checkPolicyFile	=	true;
			_init();
		}
		//*************************[PUBLIC METHOD]**********************************//
		
		
		//*************************[INTERNAL METHOD]********************************//
		
		
		//*************************[PROTECTED METHOD]*******************************//
		override protected function completeHandler(e:Event):void {
			super.completeHandler(e);
			//_setContainerCenter();//居中
			_fitToMask	=	true;
			_setFitToMask(preLoader, true);//自适应到mask大小
			smoothing	=	true;//平滑
		}
		
		//*************************[PRIVATE METHOD]*********************************//
		/**
		 * Initialize this class when be instantiated.<br />
		 */
		private function _init():void {
			
		}
		
		
		
		//*************************[STATIC METHOD]**********************************//
		
		
	}
}//end class [com.wlash.puma.social.renren.post.AbFace]
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
