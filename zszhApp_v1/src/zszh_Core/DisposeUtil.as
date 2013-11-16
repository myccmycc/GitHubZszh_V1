package zszh_Core
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.SWFLoader;

	internal final class DisposeUtil
	{
		
		public static function Dispose(value:Object):void 
		{ 
			
			if (value == null) 
				return; 
	
			if (value is Array) 
			{ 
				ClearArray(value as Array); 
			} 
				
			else if (value is ArrayCollection) 
			{ 
				ClearArrayCollection(value as ArrayCollection); 
			} 
				
			else if (value is SWFLoader) 
			{ 
				DisposeSWFLoader(value as SWFLoader); 
			} 
			
			else if (value is Sprite) 	
			{ 
				DisposeSprite(value as Sprite); 
			} 
				
			else if (value is Dictionary) 
			{ 
				ClearDictionary(value as Dictionary);
			} 
			
		} 
		
		private static function ClearArray(value:Array):void 
		{ 
			if (value == null) 
				return; 
			
			while (value.length > 0) 
			{ 
				var child:IDispose = value.pop() as IDispose; 
				if (child != null) 
					child.Dispose(); 
			} 
		} 
		
		private static function ClearArrayCollection(value:ArrayCollection):void 	
		{ 
			if (value == null) 
				return; 
			
			while (value.length > 0) 
			{ 
				var child:IDispose = value.removeItemAt(0) as IDispose; 
				if (child != null) 
					child.Dispose(); 
			} 
		} 
		
		private static function DisposeSprite(value:Sprite):void 
		{ 

			if (value == null) 
				return; 
			
			while (value.numChildren > 0) 
			{ 
				var child:DisplayObject = value.removeChildAt(0); 
				if (child is IDispose) 
					IDispose(child).Dispose(); 
			} 
			
		} 
		
		private static function DisposeSWFLoader(value:SWFLoader):void 
			
		{ 
			
			if (value == null) 
				return; 
			
			if (value.content is Bitmap) 
			{ 
				Bitmap(value.content).bitmapData.dispose(); 
			} 
				
			else if (value.content is MovieClip) 
			{ 
				MovieClip(value.content).stop(); 
			} 
			
			value.unloadAndStop(true);//flash player 10后支持 
			value.source = null; 
			
		} 
		
		private static function ClearDictionary(value:Dictionary):void 	
		{ 
			
			if (value == null) 
				return; 
			
			for each (var key:* in value) 
			{ 
				var val:IDispose = value[key] as IDispose; 
				if (value != null) 
					val.Dispose(); 
				delete value[key]; 
			} 
			
		} 
		

	}
}