package com.bugsnag.functions;

import android.os.Build;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.bugsnag.android.Bugsnag;
import android.os.Build.VERSION;

public class GetOSVersion implements FREFunction
{
    @Override
    public FREObject call( FREContext context, FREObject[] args )
    {
        try
        {
            return FREObject.newObject(VERSION.RELEASE);
        }
        catch (FREWrongThreadException e)
        {
            e.printStackTrace();
        }

        return null;
    }
}