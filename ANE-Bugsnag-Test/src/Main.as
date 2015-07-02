package
{
	import com.bugsnag.Bugsnag;
	import com.bugsnag.ReleaseStage;
	import com.bugsnag.Severity;

	import flash.display.MovieClip;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.errors.IOError;
	import flash.events.MouseEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Main extends MovieClip
	{
		// TODO: Replace with your Bugsnag API keys
		private const IOS_KEY:String = "";
		private const ANDROID_KEY:String = "";

		private var buttonFormat:TextFormat;
		private var feedback:TextField;

		public function Main()
		{
			super();

			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.SHOW_ALL;

			feedback = new TextField();
			var format:TextFormat = new TextFormat();
			format.font = "_sans";
			format.size = 16;
			format.color = 0x000000;
			feedback.defaultTextFormat = format;
			feedback.width = 400;
			feedback.height = 260;
			feedback.x = 10;
			feedback.y = 170;
			feedback.multiline = true;
			feedback.wordWrap = true;
			addChild(feedback);

			createButtons();
		}


		private function createButtons():void
		{
			// Row
			var tf:TextField = createButton("Initialize");
			tf.x = 10;
			tf.y = 10;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, initialize);
			addChild(tf);

			tf = createButton("Set User Data");
			tf.x = 170;
			tf.y = 10;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, setUserData);
			addChild(tf);

			tf = createButton("Set Release Stage");
			tf.x = 330;
			tf.y = 10;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, setReleaseStage);
			addChild(tf);


			// Row
			tf = createButton("Toggle Auto Notify");
			tf.x = 10;
			tf.y = 50;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, toggleAutoNotify);
			addChild(tf);

			tf = createButton("Crash Native");
			tf.x = 170;
			tf.y = 50;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, crashNative);
			addChild(tf);

			tf = createButton("Set Tab Data");
			tf.x = 330;
			tf.y = 50;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, setTab);
			addChild(tf);


			// Row
			tf = createButton("Notify");
			tf.x = 10;
			tf.y = 90;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, notify);
			addChild(tf);

			tf = createButton("Notify Error");
			tf.x = 170;
			tf.y = 90;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, notifyError);
			addChild(tf);

			tf = createButton("Catch Error");
			tf.x = 330;
			tf.y = 90;
			tf.addEventListener(MouseEvent.MOUSE_DOWN, catchError);
			addChild(tf);

		}

		private function log(text:String, clear:Boolean = true):void
		{
			if (clear)
			{
				feedback.text = "";
			}

			feedback.text += text + "\n\r";
		}

		private function createButton(label:String):TextField
		{
			if (!buttonFormat)
			{
				buttonFormat = new TextFormat();
				buttonFormat.font = "_sans";
				buttonFormat.size = 14;
				buttonFormat.bold = true;
				buttonFormat.color = 0xFFFFFF;
				buttonFormat.align = TextFormatAlign.CENTER;
			}

			var textField:TextField = new TextField();
			textField.defaultTextFormat = buttonFormat;
			textField.width = 140;
			textField.height = 30;
			textField.text = label;
			textField.backgroundColor = 0xCC0000;
			textField.background = true;
			textField.selectable = false;
			textField.multiline = false;
			textField.wordWrap = false;
			return textField;
		}

		private function initialize(event:MouseEvent):void
		{
			Bugsnag.init(IOS_KEY, ANDROID_KEY);
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, Bugsnag.handleUncaughtError);
			Bugsnag.getStackTrace = function(error:Error):String {return error.getStackTrace();}

			log("Bugsnag keys have been initialized");
		}

		private function setUserData(event:MouseEvent):void
		{
			var id:int = Math.random() * 9999;
			var name:String = "user_" + id;

			Bugsnag.setUser(String(id), name);
			log("Bugsnag.setUser(" + id + ", " + name + ");");
		}

		private function setReleaseStage(event:MouseEvent):void
		{
			Bugsnag.releaseStage = ReleaseStage.DEVELOPMENT;
			log("Bugsnag.releaseStage = 'development'");
		}

		private function toggleAutoNotify(event:MouseEvent):void
		{
			Bugsnag.autoNotify = !Bugsnag.autoNotify;
			log("Bugsnag.autoNotify = " + (Bugsnag.autoNotify ? "true" : "false"));
		}

		private function crashNative(event:MouseEvent):void
		{
			Bugsnag.crashNative();
			log("Bugsnag.crashNative()");
		}

		private function setTab(event:MouseEvent):void
		{
			Bugsnag.addAttribute("Var 1", "value 1", "Test Tab");
			Bugsnag.addAttribute("Var 2", "value 2", "Test Tab");
			Bugsnag.addAttribute("Var 3", "value 3", "Test Tab");

			Bugsnag.removeAttribute("Var 3", "Test Tab");

			log("Bugsnag tab data set");
		}

		private function notify(event:MouseEvent):void
		{
			log("Bugsnag notify");
			Bugsnag.notify("Serious Error", "A serious error has occured", Severity.INFO, new Error().getStackTrace());
		}

		private function notifyError(event:MouseEvent):void
		{
			log("Bugsnag notify error");

			var error:Error = new IOError("An IO error has occured");
			Bugsnag.notifyError(error, Severity.WARNING);
		}

		private function catchError(event:MouseEvent):void
		{
			log("Bugsnag catch error");

			gotoAndStop("hello");
		}



	}
}