# Bugsnag Air Native Extension

This is an Adobe Air Native Extension for the [Bugsnag](https://bugsnag.com/) bug reporting platform for iOS and Android applications. This extension allows you to track:

* Native iOS and Android crashes
* Unhandled Actionscript errors
* Manual Actionscript errors/messages

## Version

This extension uses the Bugsnag SDK version 4.0.7 for iOS and SDK version 3.2.6 for Android.


## Requirements

This extension requires iOS 6.0 or higher and Android 2.2 (API level 8) or higher.

## Binary Files

You can find the final compiled ANE binary along with the swc file in the bin folder.


## Setup the Extension

### Manifest Setup

When using the extension on the Android platform you'll need to add the following permissions in the app manifest file:

```
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

There is no additional code required for the iOS platform.

### Project Setup

Before you can begin tracking bugs you will need to set up a two new projects on the Bugsnag website. Create a project for iOS and another one for Android tracking. You'll need the API keys for each project.

### Initialize

Start off by initializing the Bugsnag extension with your API key:

```
Bugsnag.init("IOS_KEY", "ANDROID_KEY");
```

> *NOTE*: If you want to initialize Bugsnag when your application starts, you need to do so after the ```ADDED_TO_STAGE``` event fires. Otherwise a crash can occur on iOS.

```
addEventListener(Event.ADDED_TO_STAGE, init);
private function init(event:Event):void
{
    Bugsnag.init("IOS_KEY", "ANROID_KEY");
}
```

### Catch Unhandled Errors (Optional)

Bugsnag can catch and report unhandled errors in Actionscript. You'll need access to your app's loaderInfo object do to this. Use the following code:

```
loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, Bugsnag.handleUncaughtError);
```

Alternatively you can catch unhandled errors yourself and pass them directly into Bugsnag for reporting:

```
Bugsnag.notifyError(event.error);
```

Unhandled errors and crashes in the native code are already set up and do not require any additional code.

### Stack Traces (Optional)

If you'd like Bugsnag to record stack traces for errors (highly recommended), add the following code:

```
Bugsnag.getStackTrace = function(error:Error):String{return error.getStackTrace();}
```

## Using the Extension

### Track Unhandled Actionscript Errors

If you followed the setup instructions to catch unhandled errors, then these errors will be automatically reported to Bugsnag as they occur.

Native exceptions and crashes are reported automatically.

### Track Handled Error

You can easily track handled errors using the following code:

```
try
{

}
catch(e:Error)
{
    Bugsnag.notifyError(e);
}
```

You can also pass in a severity value to the method:

```
Bugsnag.notifyError(new Error(), Severity.WARN);
```

### Track Manual Errors

You aren't limited to tracking only ```Error``` objects. You can send a generic error:

```
Bugsnag.notify("Big Error", "A really big error has occured");
```

You can also add a severity to it:

```
Bugsnag.notify("Big Error", "A really big error has occured", Severity.INFO);
```

It may be helpful to provide a stacktrace of where the error occured:

```
Bugsnag.notify("Big Error", "A really big error has occured", Severity.INFO, new Error().getStackTrace());
```

## Additional Settings

### User Data

You can set custom data for users to track their errors:

```
Bugsnag.setUser("123456", "user_123456", "user123456@example.com");
```

By default the iOS extension will use the IDFV for the user id. Android will generate and save a random UUID value for the user id.

### Release Stage

You can tell Bugsnag which release stage your app is in to more easily group errors:

```
Bugsnag.releaseStage = ReleaseStage.DEVELOPMENT;
```

By default the release stage is set to ```PRODUCTION```.


### Auto Notify

You can enable or disable auto notification of unhandled exceptions:

```
Bugsnag.autoNotify = false;
```

### Notify Release Stages

You can also tell Bugsnag to only notify errors in certain production stages:

```
Bugsnag.notifyReleaseStages = [ReleaseStage.PRODUCTION];
```

The code above restricts automatic notification to production stages only. Errors in all other production stages will be ignored.

### Custom Data and Tabs

You can add custom data and custom tabs to your error reports. The following code adds custom data to the 'user' tab:

```
Bugsnag.addAttribute("City", "New York", "User");
```

You can also remove attributes:

```
Bugsnag.removeAttribute("Attribute", "Tab Name");
```

Or even remove entire custom tabs:

```
Bugsnag.removeTab("My Tab");
```

### Context

The context represents the state the application is in before the error. You can set the context:

```
Bugsnag.context = "Store";
```

### Offline Mode

If an error occurs while the user is offline, the error will be queued until network connectivity is re-established. 


## Further Documentation

You can learn more about the inner workings of the Bugsnag platform using the following resources:

* [Bugsnag Documentation](https://bugsnag.com/docs/notifiers)
* [Bugsnag iOS SDK](https://bugsnag.com/docs/notifiers/cocoa)
* [Bugsnag Android SDK](https://bugsnag.com/docs/notifiers/android)
* [Bugsnag API](https://bugsnag.com/docs/notifier-api)


## Compiling from Source

You can compile the Air Native Extension from source by renaming the build/sample-build.conf file to build/build.conf, then changing the path settings to match your development enviroment. Then run the ant command in the build folder to build the entire project.

There are also IntelliJ IDEA project files included to make editing and testing the Java and Actionscript easier.


## Special Thanks

Special thanks to the [StickSports](https://github.com/StickSports/) ANEs for the initial build script and testing code and the [ANEZipFile](https://github.com/xperiments/ANEZipFile) project for the FRETypeUtils code for iOS.
