// Thanks to https://github.com/xperiments/ANEZipFile

#import "FRETypeUtils.h"

FREResult FREGetObjectAsString( FREObject object, NSString** value )
{
    FREResult result;
    uint32_t length = 0;
    const uint8_t* tempValue = NULL;
    
    result = FREGetObjectAsUTF8( object, &length, &tempValue );
    if( result != FRE_OK ) return result;
    
    *value = [NSString stringWithUTF8String: (char*) tempValue];
    return FRE_OK;
}

FREResult FRENewObjectFromString( NSString* string, FREObject* asString )
{
    const char* utf8String = string.UTF8String;
    unsigned long length = strlen( utf8String );
    return FRENewObjectFromUTF8( length + 1, (uint8_t*) utf8String, asString );
}

FREResult FRENewObjectFromDate( NSDate* date, FREObject* asDate )
{
    NSTimeInterval timestamp = date.timeIntervalSince1970 * 1000;
    FREResult result;
    FREObject time;
    result = FRENewObjectFromDouble( timestamp, &time );
    if( result != FRE_OK ) return result;
    result = FRENewObject( (uint8_t*) "Date", 0, NULL, asDate, NULL );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( *asDate, (uint8_t*)"time", time, NULL);
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

FREResult FRESetObjectPropertyString( FREObject asObject, const uint8_t* propertyName, NSString* value )
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromString( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

FREResult FRESetObjectPropertyBool( FREObject asObject, const uint8_t* propertyName, uint32_t value )
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromBool( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}



FREResult FRESetObjectPropertyInt( FREObject asObject, const uint8_t* propertyName, int32_t value )
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromInt32( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

FREResult FRESetObjectPropertyUint( FREObject asObject, const uint8_t* propertyName, uint32_t value )
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromUint32( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}


FREResult FRESetObjectPropertyNum( FREObject asObject, const uint8_t* propertyName, double value )
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromDouble( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

FREResult FRESetObjectPropertyDate( FREObject asObject, const uint8_t* propertyName, NSDate* value )
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromDate( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}