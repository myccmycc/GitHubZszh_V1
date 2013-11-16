package zszh_Core
{
	import zszh_WorkSpace2D.Room_2DFloor;

	public class Command_ChangeRoomFloor extends CommandBase
	{
		private var _Target:Room_2DFloor;
		private var _OldValue:String;
		private var _NewValue:String;
		
		public function Command_ChangeRoomFloor(target:Room_2DFloor, oldValue:String, newValue:String) 
		{ 
			_Target = target;
			_OldValue = oldValue;
			_NewValue = newValue;
			_title = "改变房间 ChangeRoomFloor";
			
		} 
		
		override public function Execute():void
		{
			_Target.SetFloorTexture(_NewValue);
		}
		
		override public function UnExecute():void
		{
			_Target.SetFloorTexture(_OldValue);
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