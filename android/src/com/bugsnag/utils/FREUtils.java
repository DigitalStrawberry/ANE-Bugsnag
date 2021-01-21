package com.bugsnag.utils;

import com.adobe.fre.*;

public class FREUtils
{

    public static String getStringProperty(FREObject object, String propertyName)
    {
        try
        {
            FREObject prop = object.getProperty(propertyName);
            return prop.getAsString();
        } catch (Exception e)
        {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean getBoolProperty(FREObject object, String propertyName)
    {
        try
        {
            FREObject prop = object.getProperty(propertyName);
            return prop.getAsBool();
        } catch (Exception e)
        {
            e.printStackTrace();
            return false;
        }
    }

}
