package com.bugsnag
{
	public class StackTraceParser
	{
		public static function parse(stackTrace:String):Array
		{
			if(stackTrace == null)
			{
				return [new StackTraceLine()];
			}

			var lines:Array = [];
			var strLines:Array = stackTrace.split("\tat ");
			strLines.shift();

			for each(var line:String in strLines)
			{
				lines.push(parseLine(line));
			}

			return lines;
		}

		private static function parseLine(line:String):StackTraceLine
		{
			var stackTraceLine:StackTraceLine = new StackTraceLine();

			var stack:String = line;
			var debug:String = '';
			if(line.indexOf('[') != -1)
			{
				stack = line.substring(0, line.indexOf('['));
				debug = line.substring(line.indexOf('[') + 1, line.indexOf(']'));
			}

			stackTraceLine.method = stack.substring(stack.lastIndexOf('/') + 1);
			stackTraceLine.file = stack.substring(0, stack.lastIndexOf('/'));

			if(debug != "")
			{
				stackTraceLine.lineNumber = int(debug.substring(debug.lastIndexOf(':') + 1));
				stackTraceLine.file = debug.substring(0, debug.lastIndexOf(':'));
			}

			return stackTraceLine;
		}
	}
}
