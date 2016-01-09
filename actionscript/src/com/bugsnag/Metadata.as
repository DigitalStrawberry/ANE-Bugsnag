package com.bugsnag
{
	public class Metadata
	{
		private var _name:String;
		private var _data:Object = {};

		public function Metadata(name:String)
		{
			_name = name;
		}

		public function addAttribute(name:String, value:String):void
		{
			_data[name] = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function get data():Object
		{
			return _data;
		}
	}
}
