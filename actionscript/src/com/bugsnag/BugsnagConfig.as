package com.bugsnag
{
	
	public class BugsnagConfig
	{

		private var _iosKey:String;
		private var _androidKey:String;
		private var _releaseStage:String;
		private var _autoDetectErrors:Boolean;

		public function BugsnagConfig()
		{
			_autoDetectErrors = true;
			_releaseStage = ReleaseStage.PRODUCTION;
		}
		

		public function get iosKey():String
		{
			return _iosKey;
		}


		public function set iosKey(value:String):void
		{
			_iosKey = value;
		}


		public function get androidKey():String
		{
			return _androidKey;
		}


		public function set androidKey(value:String):void
		{
			_androidKey = value;
		}


		public function get releaseStage():String
		{
			return _releaseStage;
		}


		public function set releaseStage(value:String):void
		{
			_releaseStage = value;
		}


		public function get autoDetectErrors():Boolean
		{
			return _autoDetectErrors;
		}


		public function set autoDetectErrors(value:Boolean):void
		{
			_autoDetectErrors = value;
		}
	}
	
}
