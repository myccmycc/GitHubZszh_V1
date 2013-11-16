package
{  
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;  
	public class zszh_Loading  extends DownloadProgressBar  
	{  
		private var logo:Loader;  
		private var txt:TextField;  
		private var _preloader:Sprite;  
		private var bLogoShow:Boolean;
		public function zszh_Loading()  
		{  
			bLogoShow=true;
			logo = new Loader();  
			logo.load(new URLRequest("zszh_res/loading.png"));  
			//logo.contentLoaderInfo.addEventListener(Event.COMPLETE,OnLogoComplete);
			addChild(logo); 
			
			var style:TextFormat = new TextFormat("微软雅黑","16",0xFFFFFF,true,null,null,null,null,"center");  
			txt = new TextField();  
			txt.defaultTextFormat = style;  
			txt.width = 200;  
			txt.selectable = false;  
			txt.height = 30;  
			addChild(txt);  
			super();  
		}  
		//最重要的代码就在这里..重写preloader,让swf执行加载的时候~进行你希望的操作~  
		override public function set preloader(value:Sprite):void
		{  
			_preloader = value  
			//四个侦听~分别是 加载进度 / 加载完毕 / 初始化进度 / 初始化完毕  
			_preloader.addEventListener(ProgressEvent.PROGRESS,load_progress);  
			_preloader.addEventListener(Event.COMPLETE,load_complete);  
			_preloader.addEventListener(FlexEvent.INIT_PROGRESS,init_progress);  
			_preloader.addEventListener(FlexEvent.INIT_COMPLETE,init_complete);  
			stage.addEventListener(Event.RESIZE,resize)  
			resize(null);  
		}  
		
		private function OnLogoComplete(e:Event):void
		{
			bLogoShow=true;
			logo.contentLoaderInfo.removeEventListener(Event.COMPLETE,OnLogoComplete);
		}
		private function remove():void{  
			_preloader.removeEventListener(ProgressEvent.PROGRESS,load_progress);  
			_preloader.removeEventListener(Event.COMPLETE,load_complete);  
			_preloader.removeEventListener(FlexEvent.INIT_PROGRESS,init_progress);  
			_preloader.removeEventListener(FlexEvent.INIT_COMPLETE,init_complete);  
			stage.removeEventListener(Event.RESIZE,resize)  
		}  
		private function resize(e:Event):void{  
			logo.x = (stage.stageWidth - 584)/2;  
			logo.y = (stage.stageHeight - 380)/2;  
			txt.x = logo.x + 520;  
			txt.y = logo.y + 290;  
			graphics.clear();  
			graphics.beginFill(0x333333);  
			graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);  
			graphics.endFill();  
		}  
		private function load_progress(e:ProgressEvent):void{  
			if(bLogoShow)
			txt.text = "正在加载..."+int(e.bytesLoaded/e.bytesTotal*100)+"%";  
		}  
		private function load_complete(e:Event):void{  
			if(bLogoShow)
			txt.text = "加载完毕!"
		}  
		private function init_progress(e:FlexEvent):void{ 
			if(bLogoShow)
			txt.text = "正在初始化..."
		}  
		private function init_complete(e:FlexEvent):void{  
			if(bLogoShow)
			txt.text = "初始化完毕!"
			remove()  
			//最后这个地方需要dpe一个Event.COMPLETE事件..表示加载完毕让swf继续操作~  
			dispatchEvent(new Event(Event.COMPLETE))  
		}  
	}  
}