package zszh_WorkSpace2D
{
	import mx.core.UIComponent;

	public class Object2D_Base extends UIComponent
	{

		protected var _selected:Boolean;
		
		public function Object2D_Base()
		{
			super();
			_selected=false;
		}
		
		public function SetSelected(b:Boolean):void
		{
			_selected=b;
			Object2DUpdate();
		}
		
		public function GetSelected():Boolean
		{
			return _selected;
		}
		
		public function  Object2DUpdate():void
		{
		}
		
		public function Draw():void
		{
			
		}

	}
}