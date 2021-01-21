package com.bugsnag
{
	import flash.desktop.NativeApplication;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.UncaughtErrorEvent;
	import flash.external.ExtensionContext;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.Capabilities;

	public class Bugsnag extends EventDispatcher
	{
		internal static const TAG:String = "[BugsnagANE]";

		private static const BUGSNAG_URL:String = "https://notify.bugsnag.com";

		private static var _mExtContext:ExtensionContext = null;

		private static var _iosKey:String = null;
		private static var _androidKey:String = null;

		private static var _context:String = "";
		private static var _releaseStage:String = ReleaseStage.PRODUCTION;
		private static var _user:Object = {};
		private static var _autoNotify:Boolean = true;
		private static var _tabs:Object = {};
		private static var _requests:RequestQueue = new RequestQueue();

		public static var getStackTrace:Function = null;


		public static function init(config:BugsnagConfig):void
		{
			_iosKey = config.iosKey;
			_androidKey = config.androidKey;
			_autoNotify = config.autoDetectErrors;
			_releaseStage = config.releaseStage;

			if((iOS || android) && _mExtContext == null)
			{
				// Create the context
				_mExtContext = ExtensionContext.createExtensionContext("com.bugsnag.ANEBugsnag", null);
				if(_mExtContext == null)
				{
					throw new Error("ANEBugsnag extension could not be created");
				}

				if(iOS && _iosKey != null && _iosKey != "")
				{
					_mExtContext.call("init", config);
				}
				else if(android && _androidKey != null && _androidKey != "")
				{
					_mExtContext.call("initialize", config);
				}
			}

			// User id
			_user.id = deviceId;
		}


		public static function handleUncaughtError(event:UncaughtErrorEvent):void
		{
			if(!_autoNotify)
			{
				return;
			}

			event.preventDefault();
			event.stopImmediatePropagation();
			event.stopPropagation();

			if(event.error != null)
			{
				if(event.error is Error)
				{
					trace(TAG, event.error);
					notifyError(event.error);
				}
				else if(event.error is ErrorEvent)
				{
					var errorEvent:ErrorEvent = event.error as ErrorEvent;
					trace(TAG, "Async error occurred:", errorEvent.text);
					notify("Error #" + errorEvent.errorID, "(Asynchronous) " + errorEvent.text);
				}
				else
				{
					trace(TAG, "Custom error:", event.error.toString());
					notify("Custom Error", event.error.toString());
				}
			}
		}


		/**
		 * Notify error
		 * @param error
		 * @param severity
		 */
		public static function notifyError(error:Error, severity:String = "error"):void
		{
			var stackTrace:String = error.getStackTrace();
			if(stackTrace == null && getStackTrace != null)
			{
				stackTrace = getStackTrace(error);
			}

			notify(error.name, error.message, severity, stackTrace);
		}


		/**
		 * Notify
		 * @param name
		 * @param message
		 * @param severity
		 * @param stackTrace
		 * @param metadata
		 */
		public static function notify(name:String, message:String, severity:String = "error", stackTrace:String = null, metadata:Vector.<Metadata> = null):void
		{
			if(actionscriptKey == null)
			{
				return;
			}

			var stackTraceLines:Array = StackTraceParser.parse(stackTrace);
			if(stackTraceLines.length == 0)
			{
				stackTraceLines = StackTraceParser.parse(new Error().getStackTrace());
			}

			var obj:Object = {};
			obj.apiKey = actionscriptKey;
			obj.notifier = {name: "Bugsnag ANE", version: "1.0.0", url: "https://github.com/DigitalStrawberry/ANE-Bugsnag"};

			// Merge metadata
			if(metadata != null && metadata.length > 0)
			{
				for each(var data:Metadata in metadata)
				{
					_tabs[data.name] = data.data;
				}
			}

			// Event
			var event:Object = {};
			event.payloadVersion = "2";
			event.context = _context;
			event.severity = severity;
			event.metaData = _tabs;
			event.user = _user;

			// Grouping hash
			event.groupingHash = name + ':' + message;
			if(stackTraceLines.length > 0)
			{
				var line:StackTraceLine = stackTraceLines[0];
				event.groupingHash = line.file + ':' + line.method + ":" + line.lineNumber + ':' + name + ':' + message;
			}

			// App
			event.app = {};
			event.app.version = appVersion;
			event.app.releaseStage = _releaseStage;
			event.app.id = appId;
			event.app.name = appName;

			// Device
			event.device = {};
			event.device.osVersion = osVersion;
			event.device.screenSize = Capabilities.screenResolutionX + " x " + Capabilities.screenResolutionY;
			event.device.dpi = Capabilities.screenDPI;
			event.device.manufacturer = deviceManufacturer;
			event.device.model = deviceModel;
			event.device.language = Capabilities.language;
			event.device.osName = osName;

			// Exception
			var exception:Object = {};
			exception.errorClass = name;
			exception.message = message;
			exception.stacktrace = stackTraceLines;
			event.exceptions = [exception];

			obj.events = [event];

			// Send request
			var request:URLRequest = new URLRequest();
			request.method = URLRequestMethod.POST;
			request.url = BUGSNAG_URL;
			request.data = JSON.stringify(obj);
			_requests.request(request);

			// Cleanup metadata
			if(metadata != null && metadata.length > 0)
			{
				for each(var data:Metadata in metadata)
				{
					removeParameterFromObject(_tabs, data.name);
				}
			}
		}


		/**
		 * Sets information about the current user. This data is automatically sent with every
		 * exception.
		 * @param id		User id
		 * @param name		Name of user
		 * @param email		Email address of user
		 */
		public static function setUser(id:String, name:String = "", email:String = ""):void
		{
			_user.id = id;

			if(name != "")
			{
				_user.name = name;
			}

			if(email != "")
			{
				_user.email = email;
			}

			if(_mExtContext != null)
			{
				_mExtContext.call("setUser", id, name, email);
			}
		}


		public static function addAttribute(name:String, value:String, tabName:String):void
		{
			if(_tabs[tabName] == undefined)
			{
				_tabs[tabName] = {};
			}

			_tabs[tabName][name] = value;

			if(_mExtContext != null)
			{
				_mExtContext.call("addAttribute", name, value, tabName);
			}
		}


		public static function removeAttribute(name:String, tabName:String):void
		{
			if (_mExtContext != null)
			{
				_mExtContext.call("removeAttribute", name, tabName);
			}

			if(_tabs[tabName] == undefined)
			{
				return;
			}

			removeParameterFromObject(_tabs[tabName], name);
		}


		public static function removeTab(tabName:String):void
		{
			if(_mExtContext != null)
			{
				_mExtContext.call("removeTab", tabName);
			}

			removeParameterFromObject(_tabs, tabName);
		}


		private static function removeParameterFromObject(obj:Object, key:String):void
		{
			if(obj == null || obj[key] == undefined)
			{
				return;
			}

			obj[key] = null;
			delete obj[key];
		}


		public static function crashNative():void
		{
			if(_mExtContext != null)
			{
				_mExtContext.call("crash");
			}
		}


		/**
		 * Returns true if the ANE is supported on this device.
		 * @return
		 */
		public static function isSupported():Boolean
		{
			return true;
		}


		public static function get context():String
		{
			return _context;
		}


		public static function set context(value:String):void
		{
			_context = value;

			if(_mExtContext != null)
			{
				_mExtContext.call("setContext", _context);
			}
		}


		private static function get appVersion():String
		{
			var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = xml.namespace();

			if(xml.ns::versionLabel.children().length() != 0)
			{
				return xml.ns::versionLabel;
			}

			return xml.ns::versionNumber;
		}


		private static function get appName():String
		{
			var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = xml.namespace();
			return xml.ns::name;
		}


		private static function get appId():String
		{
			var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = xml.namespace();
			return xml.ns::id;
		}


		private static function get osName():String
		{
			if(iOS)
			{
				return "iOS";
			}
			else if(android)
			{
				return "Android";
			}
			else
			{
				return "AIR Emulator";
			}
		}


		private static function get osVersion():String
		{
			if(_mExtContext != null)
			{
				return _mExtContext.call("getOSVersion") as String;
			}

			return "0.0.0";
		}


		public static function get deviceModel():String
		{
			if(_mExtContext != null)
			{
				return _mExtContext.call("getDeviceModel") as String;
			}

			return "AIR Emulator";
		}


		public static function get deviceId():String
		{
			if(_mExtContext != null)
			{
				return _mExtContext.call("getDeviceId") as String;
			}

			// For local testing
			return String(Math.round(Math.random() * 999999999));
		}

		private static function get iOS():Boolean
		{
			return Capabilities.manufacturer.indexOf("iOS") > -1;
		}


		private static function get android():Boolean
		{
			return Capabilities.manufacturer.indexOf("Android") > -1;
		}


		private static function get testing():Boolean
		{
			return !iOS && !android;
		}


		private static function get actionscriptKey():String
		{
			if(iOS)
			{
				return _iosKey;
			}

			if(android)
			{
				return _androidKey;
			}

			return _iosKey == null ? _androidKey : _iosKey;
		}


		private static function get deviceManufacturer():String
		{
			if(iOS)
			{
				return "Apple";
			}

			if(android && _mExtContext != null)
			{
				return _mExtContext.call("getDeviceManufacturer") as String;
			}

			return "Adobe";
		}

	}
}