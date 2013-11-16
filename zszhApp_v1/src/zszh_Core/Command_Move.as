package zszh_Core
{
	import flash.geom.Point;

	public class Command_Move extends CommandBase
	{
		

		private var _Target:Object;
		private var _OldValue:Point;
		private var _NewValue:Point;
		
		public function Command_Move(target:Object, oldValue:Point, newValue:Point) 
		{ 

			_Target = target;
			_OldValue = oldValue;
			_NewValue = newValue;
			_title = "编辑 move";
			
		} 
		
		override public function Execute():void
		{
			_Target["x"] = _NewValue.x;
			_Target["y"] = _NewValue.y;
		}
		override public function UnExecute():void
		{
			_Target["x"] = _OldValue.x;
			_Target["y"] = _OldValue.y;
		}
		override protected function Disposing():void
		{
			_Target = null;
			_OldValue = null;
			_NewValue = null;
			super.Disposing();
		}


	}
}