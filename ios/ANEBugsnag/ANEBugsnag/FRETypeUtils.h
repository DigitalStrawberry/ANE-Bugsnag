#ifndef FRETypeUtils_h
#define FRETypeUtils_h

#import "FlashRuntimeExtensions.h"

NSString* FREGetObjectStringProperty(FREObject object, NSString* propertyName);
BOOL FREGetObjectBoolProperty(FREObject object, NSString* propertyName);

FREResult FREGetObjectAsString( FREObject object, NSString** value );

FREResult FRENewObjectFromString( NSString* string, FREObject* asString );
FREResult FRENewObjectFromDate( NSDate* date, FREObject* asDate );

FREResult FRESetObjectPropertyString( FREObject asObject, const uint8_t* propertyName, NSString* value );
FREResult FRESetObjectPropertyBool( FREObject asObject, const uint8_t* propertyName, uint32_t value );
FREResult FRESetObjectPropertyInt( FREObject asObject, const uint8_t* propertyName, int32_t value );
FREResult FRESetObjectPropertyUint( FREObject asObject, const uint8_t* propertyName, uint32_t value );
FREResult FRESetObjectPropertyNum( FREObject asObject, const uint8_t* propertyName, double value );
FREResult FRESetObjectPropertyDate( FREObject asObject, const uint8_t* propertyName, NSDate* value );

#endif
