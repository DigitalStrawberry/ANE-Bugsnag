package com.bugsnag
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
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
				var file:File = File.applicationStorageDirectory.resolvePath(FILENAME);

				// If there are no requests to save then we can delete the file if it exists
				if(_requests.length == 0)
				{
					if(file.exists)
					{
						file.deleteFileAsync();
					}
					return;
				}

				// Serialize the list of URLRequests manually
				var byteArray:ByteArray = new ByteArray();

				// First write the number of requests that the file will contain
				byteArray.writeUnsignedInt(_requests.length);

				// Now write each request's url and data
				for each(var request:URLRequest in _requests)
				{
					byteArray.writeUTF(request.url);
					byteArray.writeUTF(request.data as String);
				}

				// Finally, write the bytes to the file
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

					// First read the number of requests saved
					var numRequests:uint = byteArray.readUnsignedInt();

					// The file is invalid, there will never be 0 requests saved
					if(numRequests == 0)
					{
						file.deleteFileAsync();
					}
					else
					{
						// Reconstruct the list of URLRequests
						_requests = new <URLRequest>[];
						for (var i:int = 0; i < numRequests; ++i)
						{
							// Read request's url, followed by data
							var savedRequest:URLRequest = new URLRequest();
							savedRequest.method = URLRequestMethod.POST;
							savedRequest.url = byteArray.readUTF();
							savedRequest.data = byteArray.readUTF();
							_requests[i] = savedRequest;
						}
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