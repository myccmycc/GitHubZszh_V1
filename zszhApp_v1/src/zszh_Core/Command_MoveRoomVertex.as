package zszh_Core
{
	import zszh_WorkSpace2D.Object2D_Room;

	public class Command_MoveRoomVertex extends CommandBase
	{
		private var _Target:Object2D_Room;
		private var _OldValue:Vector.<Number>;
		private var _NewValue:Vector.<Number>;
		
		public function Command_MoveRoomVertex(target:Object2D_Room, oldValue:Vector.<Number>, newValue:Vector.<Number>) 
		{ 
			_Target = target;
			_OldValue = oldValue;
			_NewValue = newValue;
			_title = "改变房间 MoveRoomVertex";
			
		} 
		
		override public function Execute():void
		{
			_Target._vertexVec1=_NewValue;
			_Target.UpdateVertexData();
			_Target.Draw();
			_Target.SetSelected(true);
		}
		
		override public function UnExecute():void
		{
			_Target._vertexVec1=_OldValue;
			_Target.UpdateVertexData();
			_Target.Draw();
			_Target.SetSelected(true);
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