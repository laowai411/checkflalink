package
{
	import flash.display.Stage;
	
	/**
	 * 存储全局配置
	 * */
	public class Config
	{
		
		/**
		 * flash.exe安装路径
		 * */
		public static var flashURL:String;
		
		/**
		 * fla所在目录
		 * */
		public static var flaURL:String;
		
		/**
		 * 代码目录
		 * */
		public static var codeSrcURL:String;

		/**
		 * 多少毫秒执行一次搜索fla的link
		 * */
		public static var searchFlaDelay:uint;
		
		/**
		 * 每次搜索fla最多毫秒数
		 * */
		public static var searchFlaMaxTime:uint;
		
		/**
		 * 代码文件搜索delay
		 * */
		public static var searchDelay:uint;
		
		/**
		 * 每次搜索代码最多执行毫秒数
		 * */
		public static var searchMaxTime:uint;
		
		/**
		 * 临时文件存储目录
		 * */
		public static var tempDir:String;
		
		/**
		 * 临时jsfl路径
		 * */
		public static var jsflURL:String;
		
		/**
		 * fla中link的存储
		 * */
		public static var linkURL:String;
		
		/**
		 * 结果文件路径
		 * */
		public static var resultURL:String;
		
		/**
		 * 注册舞台
		 * */
		private static var _stage:Stage;
		
		public static function registerState(stage:Stage):void
		{
			_stage = stage;
		}
		
		public static function get stage():Stage
		{
			return _stage;
		}
	}
}