package
{
    import com.bugsnag.Bugsnag;
	import com.bugsnag.BugsnagConfig;
	import com.bugsnag.ReleaseStage;
    import com.bugsnag.Severity;

    import flash.display.MovieClip;

    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    public class Main extends MovieClip
    {
        // TODO: Replace with your Bugsnag API keys
	    // tehbroski account, iOS Tri and Android Tri projects
        private const IOS_KEY:String = "b97bed88ae53ca2b0e4d44dd8a2afaa0";
        private const ANDROID_KEY:String = "670220c8957e80cd12fcc44b47e3cf8e";

        // dsberry test project
        // ios - 4d168bfdac8b8d7b1f9d2178a3743761
        // android - 112944f0dfe4d6e258ff28b7942d09b2

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

            // You MUST initialize Bugsnag after the ADDED_TO_STAGE event, otherwise it
            // is possible to get a crash on iOS.
            addEventListener(Event.ADDED_TO_STAGE, initialize);
        }


        private function createButtons():void
        {
            // Row
            var tf:TextField = createButton("Set User Data");
            tf.x = 170;
            tf.y = 10;
            tf.addEventListener(MouseEvent.MOUSE_DOWN, setUserData);
            addChild(tf);

            // Row
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

            tf = createButton("Read invalid file");
            tf.x = 10;
            tf.y = 130;
            tf.addEventListener(MouseEvent.MOUSE_DOWN, readInvalidFile);
            addChild(tf);

            tf = createButton("Custom error");
            tf.x = 170;
            tf.y = 130;
            tf.addEventListener(MouseEvent.MOUSE_DOWN, throwCustomError);
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

        private function initialize(event:Event):void
        {
	        var config:BugsnagConfig = new BugsnagConfig();
	        config.iosKey = IOS_KEY;
	        config.androidKey = ANDROID_KEY;
	        config.autoDetectErrors = true;
	        config.releaseStage = ReleaseStage.DEVELOPMENT;

            Bugsnag.init(config);
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, Bugsnag.handleUncaughtError);
            Bugsnag.getStackTrace = function(error:*):String {
	            if(error is Error)
	            {
		            return Error(error).getStackTrace();
	            }
	            return null;
            };

            log("Bugsnag keys have been initialized, hey");
        }

	    private function handleUncaughtError(event:UncaughtErrorEvent):void
	    {
		    trace("MY OWN HANDLER", event);
		    event.preventDefault();
		    event.stopImmediatePropagation();
		    event.stopPropagation();

		    trace( event.error, event.error is Error, event.error is ErrorEvent );

		    if(event.error != null && event.error is Error)
		    {
			    trace("CALLING NOTIFY ERRROR");
			    notifyError(event.error);
		    }
	    }

        private function setUserData(event:MouseEvent):void
        {
            var id:int = Math.random() * 9999;
            var name:String = "user_" + id;

            Bugsnag.setUser(String(id), name);
            log("Bugsnag.setUser(" + id + ", " + name + ");");
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

        private function readInvalidFile(event:MouseEvent):void
        {
            log("Bugsnag read invalid file");
	        
	        var file:File = File.applicationDirectory.resolvePath( "random-file-name.png" ); 
	        var fs:FileStream = new FileStream();
	        fs.openAsync( file, FileMode.READ );
	        fs.close();
        }

        private function throwCustomError(event:MouseEvent):void
        {
            log("Bugsnag custom error - throw \"Hello world\"");

	        throw "Hello world";
        }



    }
}