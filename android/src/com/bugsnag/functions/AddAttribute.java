package com.bugsnag.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.bugsnag.android.Bugsnag;

public class AddAttribute implements FREFunction
{
    @Override
    public FREObject call( FREContext context, FREObject[] args )
    {
        String name;
        String value;
        String tabName;

        try
        {
            name = args[0].getAsString();
            value = args[1].getAsString();
            tabName = args[2].getAsString();
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return null;
        }

        Bugsnag.addMetadata(tabName, name, value);

        return null;
    }
}