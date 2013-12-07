package events
{
	import flash.events.Event;
	
	/**
	 * 自定义事件，带有Object参数
	 * */
	public class ParamEvent extends Event
	{
		
		public var param:Object;
		
		public function ParamEvent(type:String, data:Object=null):void
		{
			super(type);
			param = data;
		}
	}
}