package zszh_Core
{
	import mx.core.UIComponent;

	public class Command_Edit extends CommandBase
	{
		
		private var _Property:String;
		private var _Target:Object;
		private var _OldValue:Object;
		private var _NewValue:Object;
		
		public function Command_Edit(property:String, target:Object, oldValue:Object, newValue:Object) 
		{ 
			
			_Property = property;
			_Target = target;
			_OldValue = oldValue;
			_NewValue = newValue;
			_title = "编辑" + _Property;
			
		} 
		
		override public function Execute():void
		{
			_Target[_Property] = _NewValue;
		}
		override public function UnExecute():void
		{
			_Target[_Property] = _OldValue;
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