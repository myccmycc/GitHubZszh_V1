package zszh_WorkSpace2D
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import spark.components.Label;

	
	
	public class WorkSpace2D_Scale extends UIComponent
	{
		private var _lineColor:uint = 0x97bdc6;  
		private var _lineThickness:Number = 1;  
		private var _fillColor:uint = 0x97bdc6;  
		
		public var _scaleWidth:int=800;
		public var _scaleHeight:int=12;

		public var _totalMeter:int;
		public var _scale:Number;

		public function WorkSpace2D_Scale()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,OnCreation_Complete);
		}
		private function OnCreation_Complete(e:FlexEvent):void
		{
			_scale=1.0;
			DrawScale();
		}

		public function SetScale(scale:Number):void
		{
			_scale=scale;
			DrawScale();
		}
		
	    public function DrawScale():void
		{
			if(_scale>1.0)
				_scale=1.0;
			_totalMeter=4/_scale;
			
			graphics.clear();
			graphics.lineStyle(_lineThickness,_lineColor,1);
			graphics.drawRect(0,0,_scaleWidth,_scaleHeight);
			graphics.beginFill(_fillColor);
			for(var i:int=0;i<_totalMeter;i+=2)
			{
				graphics.drawRect(_scaleWidth*i/_totalMeter,0,_scaleWidth/_totalMeter,_scaleHeight);
			}
			graphics.endFill();
		}
		
	}
}