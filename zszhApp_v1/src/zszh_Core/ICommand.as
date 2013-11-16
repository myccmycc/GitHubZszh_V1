package zszh_Core
{
	public interface ICommand extends IDispose
	{
		function get Title():String;
		function Execute():void;
		function UnExecute():void;
	}
}