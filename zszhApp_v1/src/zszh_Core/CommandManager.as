package zszh_Core
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import zszh_Core.DisposeUtil;
	
	import zszh_WorkSpace2D.Object2D_Room;
	import zszh_WorkSpace2D.Room_2DFloor;
	
	public class CommandManager extends EventDispatcher
	{
		private static var g_Created:Boolean = false; 
		
		public static var Instance:CommandManager = new CommandManager(); 
		
		public function CommandManager(target:IEventDispatcher=null)
		{
			super(target);			
			if (g_Created) 
				throw new Error("Singleton class. Please use Instance static filed."); 
			g_Created = true; 
		}
		
		//======================命令管理：Undo，Redo============================= 
		
		private var _UndoList:ArrayCollection = new ArrayCollection(); 
		
		private var _RedoList:ArrayCollection = new ArrayCollection(); 
		
		public function get CanRedo():Boolean 
		{ 
			return _RedoList.length > 0; 
		} 
		
		public function get CanUndo():Boolean 
		{ 
			return _UndoList.length > 0; 
		} 
		
		public function ClearAllCommand():void
		{
			DisposeUtil.Dispose(_RedoList); 
			DisposeUtil.Dispose(_UndoList); 
		}
		
		public function Redo():void 
		{ 
			if (!CanRedo) 
				return; 
			
			var command:ICommand = _RedoList.removeItemAt(_RedoList.length - 1) as ICommand; 
			command.Execute(); 
			_UndoList.addItem(command); 
		} 
		
		public function Undo():void 	
		{ 
			if (!CanUndo) 
				return; 
			
			var command:ICommand = _UndoList.removeItemAt(_UndoList.length - 1) as ICommand; 
			command.UnExecute(); 
			_RedoList.addItem(command); 
		} 
		
		//======================命令调用============================= 
		
		private function ExecuteCommand(command:ICommand):void 
		{ 
			command.Execute(); 
			AppendCommand(command); 
		} 
		
		private function AppendCommand(command:ICommand):void 
		{ 
			//有新命令添加时清空RedoList， 
			DisposeUtil.Dispose(_RedoList); 
			while(_UndoList.length>=20)
				_UndoList.removeItemAt(0);
			_UndoList.addItem(command);
		} 
		
		//======================添加、删除、编辑命令============================= 
		
		public function Add(parent:UIComponent, target:UIComponent):void 
		{ 
			var command:ICommand = new Command_Add(parent, target); 
			ExecuteCommand(command); 	
		} 
		
		public function Delete(parent:UIComponent, target:UIComponent):void 
		{ 
			var command:ICommand = new Command_Delete(parent, target); 
			ExecuteCommand(command); 	
		} 
		
		public function Edit(property:String, target:Object, oldValue:Object, newValue:Object):void
		{
			var command:ICommand = new Command_Edit(property, target, oldValue, newValue);
			ExecuteCommand(command);
		}
		
		public function Move(target:Object, oldValue:Point, newValue:Point):void
		{
			var command:ICommand = new Command_Move(target, oldValue, newValue);
			ExecuteCommand(command);
		}
		
		public function ChangeRoomVertex(target:Object2D_Room, oldValue:Vector.<Number>, newValue:Vector.<Number>):void
		{
			var command:ICommand = new Command_ChangeRoomVertex(target, oldValue, newValue);
			ExecuteCommand(command);
		}
		
		public function MoveRoomVertex(target:Object2D_Room, oldValue:Vector.<Number>, newValue:Vector.<Number>):void
		{
			var command:ICommand = new Command_MoveRoomVertex(target, oldValue, newValue);
			ExecuteCommand(command);
		}
		
		public function ChangeRoomFloor(target:Room_2DFloor, oldValue:String, newValue:String):void
		{
			var command:ICommand = new Command_ChangeRoomFloor(target, oldValue, newValue);
			ExecuteCommand(command);
		}
		
	}
}