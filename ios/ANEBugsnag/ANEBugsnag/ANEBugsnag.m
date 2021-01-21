//
//  ANEBugsnag.m
//  ANEBugsnag
//

#import "FlashRuntimeExtensions.h"
#import "FRETypeUtils.h"
#import "Bugsnag.h"
#import <sys/utsname.h>
@import UIKit;


DEFINE_ANE_FUNCTION(init)
{
    FREObject freConfig = argv[0];
    
    NSLog(@"Bugsnag ANE setup");
    
    NSString* apiKey = FREGetObjectStringProperty(freConfig, @"iosKey");
    
    BugsnagConfiguration* config = [[BugsnagConfiguration alloc] initWithApiKey:apiKey];

    config.releaseStage = FREGetObjectStringProperty(freConfig, @"releaseStage");
    config.autoDetectErrors = FREGetObjectBoolProperty(freConfig, @"autoDetectErrors");
    
    NSUUID *idfv = [[UIDevice currentDevice] identifierForVendor];
    NSString *deviceId = [idfv UUIDString];
    
    [Bugsnag setUser:deviceId withEmail:nil andName:nil];

    [Bugsnag startWithConfiguration:config];

    return NULL;
}


DEFINE_ANE_FUNCTION(setContext)
{
    NSString *myContext = nil;
    if(FREGetObjectAsString(argv[0], &myContext) != FRE_OK)
    {
        return NULL;
    }
    
    [Bugsnag setContext:myContext];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(setUser)
{
    NSString *id = nil;
    NSString *name = nil;
    NSString *email = nil;
    
    if(FREGetObjectAsString(argv[0], &id) != FRE_OK ||
       FREGetObjectAsString(argv[1], &name) != FRE_OK ||
       FREGetObjectAsString(argv[2], &email) != FRE_OK)
    {
        return NULL;
    }
    
    [Bugsnag setUser:id withEmail:email andName:name];
    
    return NULL;
}


DEFINE_ANE_FUNCTION(addAttribute)
{
    NSString *name = nil;
    NSString *value = nil;
    NSString *tabName = nil;
    
    if(FREGetObjectAsString(argv[0], &name) != FRE_OK ||
       FREGetObjectAsString(argv[1], &value) != FRE_OK ||
       FREGetObjectAsString(argv[2], &tabName) != FRE_OK)
    {
        return NULL;
    }
    
    [Bugsnag addMetadata:value withKey:name toSection:tabName];
    
    return NULL;
}


DEFINE_ANE_FUNCTION(removeAttribute)
{
    NSString *name = nil;
    NSString *tabName = nil;
    
    if(FREGetObjectAsString(argv[0], &name) != FRE_OK ||
       FREGetObjectAsString(argv[1], &tabName) != FRE_OK)
    {
        return NULL;
    }
    
    [Bugsnag clearMetadataFromSection:tabName withKey:name];
    
    return NULL;
}


DEFINE_ANE_FUNCTION(removeTab)
{
    NSString *tabName = nil;
    
    if(FREGetObjectAsString(argv[0], &tabName) != FRE_OK)
    {
        return NULL;
    }
    
    [Bugsnag clearMetadataFromSection:tabName];
    
    return NULL;
}



DEFINE_ANE_FUNCTION(crash)
{
    NSLog(@"Manually forced crash");
    
    int *x = NULL;
    *x = 42;
    
    return NULL;
}


DEFINE_ANE_FUNCTION(getOSVersion)
{
    NSString *version = [[UIDevice currentDevice] systemVersion];
    FREObject returnValue = nil;
    FRENewObjectFromString(version, &returnValue);
    
    return returnValue;
}


DEFINE_ANE_FUNCTION(getDeviceModel)
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    FREObject returnValue = nil;
    FRENewObjectFromString(model, &returnValue);
    
    return returnValue;
}


DEFINE_ANE_FUNCTION(getDeviceId)
{
    NSUUID *idfv = [[UIDevice currentDevice] identifierForVendor];
    NSString *deviceId = [idfv UUIDString];
    FREObject returnValue = nil;
    FRENewObjectFromString(deviceId, &returnValue);
    
    return returnValue;
}


void ANEBugsnagContextInitializer(void* extData, const uint8_t* ctxType, FREContext context, uint32_t* numFunctions, const FRENamedFunction** functions)
{
    // Define the functions that can be called from AS
    static FRENamedFunction functionMap[] =
    {
        MAP_FUNCTION(init, NULL),
        MAP_FUNCTION(setContext, NULL),
        MAP_FUNCTION(setUser, NULL),
        MAP_FUNCTION(crash, NULL),
        MAP_FUNCTION(addAttribute, NULL),
        MAP_FUNCTION(removeAttribute, NULL),
        MAP_FUNCTION(removeTab, NULL),
        MAP_FUNCTION(getOSVersion, NULL),
        MAP_FUNCTION(getDeviceModel, NULL),
        MAP_FUNCTION(getDeviceId, NULL)
    };
    
    *numFunctions = sizeof(functionMap) / sizeof(FRENamedFunction);
    *functions = functionMap;
}


void ANEBugsnagContextFinalizer(FREContext context)
{
    
}


void ANEBugsnagInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                              FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &ANEBugsnagContextInitializer;
    *ctxFinalizerToSet = &ANEBugsnagContextFinalizer;
}


void ANEBugsnagFinalizer(void* extData)
{
    
}
