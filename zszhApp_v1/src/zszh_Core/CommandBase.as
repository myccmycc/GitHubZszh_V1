package zszh_Core
{
	public class CommandBase implements ICommand
	{
		public function CommandBase()
		{
		}
		
		protected var _title:String;
		
		public function get Title():String
		{
			return _title;
		}
		
		public function Execute():void
		{
			throw new Error("Command Execute function not implementation.");
		}
		
		public function UnExecute():void
		{
			throw new Error("Command UnExecute function not implementation.");
		}
		
		//========================IDispose========================== 
		
		private var _Disposed:Boolean = false; 
		
		protected function Disposing():void 
			
		{ 
			
		} 
		
		public function Dispose():void 
		{ 
			if (_Disposed) 
				return; 
			Disposing(); 
			_Disposed = true; 
		} 

	}
}