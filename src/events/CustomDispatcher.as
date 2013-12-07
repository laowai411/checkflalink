package events
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	/**
	 * 自定义事件转发器
	 * */
	public class CustomDispatcher extends EventDispatcher
	{
		
		private static var _instance:CustomDispatcher;
		
		public static function getInstance():CustomDispatcher
		{
			if(!_instance)
			{
				_instance = new CustomDispatcher();
			}
			return _instance;
		}
		
		public function CustomDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}