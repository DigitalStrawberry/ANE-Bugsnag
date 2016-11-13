package com.bugsnag
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;

	public class RequestQueue
	{
		private const FILENAME:String = "bugsnag.bin";
		private const MAX_SAVED_REQUESTS:int = 20;
		private const ERROR_TIMEOUT_SECONDS:int = 2;

		private var _requests:Vector.<URLRequest>;
		private var _hasCurrentRequest:Boolean = false;
		private var _errors:int = 0;
		private var _urlLoader:URLLoader;

		public function RequestQueue()
		{
			_requests = new <URLRequest>[];
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, requestComplete, false, 0, true);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, requestError, false, 0, true);

			registerClassAlias('UrlRequest', URLRequest);

			load();
		}


		public function request(urlRequest:URLRequest):void
		{
			if(_requests.length > MAX_SAVED_REQUESTS)
			{
				_requests.splice(0, 1);
			}

			_requests.push(urlRequest);
			save();
			processNextRequest();
		}


		private function processNextRequest():void
		{
			if(_hasCurrentRequest || _requests.length == 0)
			{
				return;
			}

			_hasCurrentRequest = true;

			var urlRequest:URLRequest = _requests[0];
			_urlLoader.load(urlRequest);
		}


		private function requestComplete(event:Event):void
		{
			_errors = 0;
			_hasCurrentRequest = false;
			_requests.splice(0, 1);
			save();

			processNextRequest();
		}


		private function requestError(event:Event):void
		{
			_errors++;
			setTimeout(clearError, (ERROR_TIMEOUT_SECONDS * 1000) * Math.pow(_errors, 2));
		}


		private function clearError():void
		{
			_hasCurrentRequest = false;
			processNextRequest();
		}


		private function save():void
		{
			try
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.writeObject(_requests);

				var file:File = File.applicationStorageDirectory.resolvePath(FILENAME);
				file.preventBackup = true;

				var fileStream:FileStream = new FileStream();
				fileStream.openAsync(file, FileMode.WRITE);
				fileStream.writeBytes(byteArray);
				fileStream.close();
			}
			catch(error:Error)
			{
				trace(Bugsnag.TAG, error);
				Bugsnag.notifyError(error);

			}
		}


		private function load():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath(FILENAME);
			if(file.exists)
			{
				try
				{
					var byteArray:ByteArray = new ByteArray();
					var fileStream:FileStream = new FileStream;
					fileStream.open(file, FileMode.READ);
					fileStream.readBytes(byteArray);
					fileStream.close();

					if(byteArray != null && byteArray.readObject() != null)
					{
						_requests = byteArray.readObject() as Vector.<URLRequest>;
					}
				}
				catch(error:Error)
				{
					trace(Bugsnag.TAG, error);
				}
			}

			if(_requests == null)
			{
				_requests = new Vector.<URLRequest>();
			}

			processNextRequest();
		}


	}
}