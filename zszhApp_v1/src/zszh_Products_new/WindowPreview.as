package zszh_Products_new
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class WindowPreview extends Sprite
	{
		public function WindowPreview()
		{
			super();
			this.addEventListener(Event.ENTER_FRAME,OnFrame);
		}
		
		private function OnFrame(event:Event):void
		{
			graphics.clear();
			graphics.lineStyle(1,0xffffff);

			graphics.beginFill(0xff0000,0.8);
			graphics.drawRect(0,0,100,100);

			graphics.endFill();
		}
	}
}