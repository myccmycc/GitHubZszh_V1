package zszh_Core
{
	import mx.core.UIComponent;

	public class Command_Add extends CommandBase
	{
		
		private var _Parent:UIComponent; 
		
		private var _Target:UIComponent; 
		
		private var _Index:int; 
		
		public function Command_Add(parent:UIComponent, target:UIComponent) 
		{ 
			
			_Parent = parent; 
			
			_Target = target; 
			
			_Index = _Parent.numChildren; 
			
			if (_Parent.contains(_Target)) 
				
				_Index = _Parent.getChildIndex(_Target); 
			
			_title = "添加" + _Target.name; 
			
		} 
		
		override public function Execute():void 
			
		{ 
			
			if(_Parent.contains(_Target)) 
				
				return; 
			
			_Parent.addChildAt(_Target, Math.min(_Parent.numChildren, _Index));     
			
		} 
		
		override public function UnExecute():void 
			
		{ 
			
			if(!_Parent.contains(_Target)) 
				
				return; 
			
			_Parent.removeChild(_Target);     
			
		} 
		
		override protected function Disposing():void 	
		{ 
			_Parent = null; 
			_Target = null; 
			super.Disposing(); 
		} 


	}
}