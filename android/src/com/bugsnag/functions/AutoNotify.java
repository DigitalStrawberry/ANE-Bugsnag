package com.bugsnag.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.bugsnag.android.Bugsnag;

public class AutoNotify implements FREFunction
{
    @Override
    public FREObject call( FREContext context, FREObject[] args )
    {
        Boolean autoNotify;

        try
        {
            autoNotify = args[0].getAsBool();
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return null;
        }

        // TODO: Not implemented in Bugsnag Android SDK, default to true

        return null;
    }
}