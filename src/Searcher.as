package
{
	import events.CustomDispatcher;
	import events.EventName;
	import events.ParamEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * 搜索
	 * */
	public class Searcher extends EventDispatcher
	{
		
		/**
		 * 代码目录
		 * */
		private var codeSrcURL:File;
		
		/**
		 * 代码文件url存储
		 * */
		private var codeURLList:Array = [];
		
		/**
		 * 代码文件数量
		 * */
		private var codeFileCount:uint = 0;
		
		/**
		 * 每帧起始时间
		 * */
		private var startTime:uint;
		
		/**
		 * link数据的存储列表
		 * */
		private var linkList:Array;
		
		/**
		 * 已有引用的连接存储
		 * */
		private var _useLinkMap:Dictionary;
		
		/**
		 * 代码读取字节流
		 * */
		private var rs:FileStream = new FileStream();
		
		/**
		 * 计时器
		 * */
		private var timer:Timer;
		
		
		public function run(cusList:Array):void
		{
			linkList = cusList;
			codeSrcURL = new File(Config.codeSrcURL);
			
			CustomDispatcher.getInstance().dispatchEvent(new ParamEvent(EventName.PRINT, "开始载入代码..."));
			getCodeURL(codeSrcURL);
			codeFileCount = codeURLList.length;
			
			CustomDispatcher.getInstance().dispatchEvent(new ParamEvent(EventName.PRINT, "代码载入完成，开始搜索..."));
			
			_useLinkMap = new Dictionary();
			
			timer = new Timer(Config.searchDelay);
			timer.addEventListener(TimerEvent.TIMER, onFrameSearchHandler);
			timer.start();
		}
		
		/***
		 * 获取所有代码的路径
		 * */
		private function getCodeURL(file:File):void
		{
			if(file.isDirectory)
			{
				if(file.url.indexOf(".svn") == -1)
				{
					var fileList:Array = file.getDirectoryListing();
					for each(var f:File in fileList)
					{
						getCodeURL(f);
					}
				}
			}
			else if(file.type == ".as")
			{
				codeURLList.push(file);
			}
		}
		
		/**
		 * 每delay搜索方法
		 * */
		private function onFrameSearchHandler(e:TimerEvent):void
		{
			startTime = getTimer();
			while(true)
			{
				if(codeURLList.length<1)
				{
					timer.removeEventListener(TimerEvent.TIMER, onFrameSearchHandler);
					this.dispatchEvent(new Event(Event.COMPLETE));
					return;
				}
				if(getTimer()-startTime > Config.searchMaxTime)
				{
					break;
				}
				var file:File = codeURLList.pop();
				searchAS(file);
				CustomDispatcher.getInstance().dispatchEvent(new ParamEvent(EventName.CHANGE_STATE, {typeName:"代码文件", total:codeFileCount, odd:codeURLList.length}));
			}
		}
		
		/**
		 * 在某个as中搜索所有的Link
		 * */
		private function searchAS(file:File):void
		{
			rs.open(file, FileMode.READ);
			var codeStr:String = rs.readUTFBytes(rs.bytesAvailable);
			rs.close();
			for each(var link:* in linkList)
			{
				var linkStr:String = link.@id;
				if(codeStr.indexOf(linkStr) > -1)
				{
					if(!_useLinkMap[linkStr])
					{
						_useLinkMap[linkStr] = 0;
					}
					_useLinkMap[linkStr]++;
				}
			}
			CustomDispatcher.getInstance().dispatchEvent(new ParamEvent(EventName.PRINT, file.nativePath+" 搜索完成!"));
		}
		
		/**
		 * 返回被引用的link数据
		 * */
		public function get useLinkMap():Dictionary
		{
			return _useLinkMap;
		}
	}
}