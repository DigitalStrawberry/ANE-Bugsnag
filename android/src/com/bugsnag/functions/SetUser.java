package com.bugsnag.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.bugsnag.android.Bugsnag;

public class SetUser implements FREFunction
{
    @Override
    public FREObject call( FREContext context, FREObject[] args )
    {
        String id = "";
        String name = "";
        String email = "";

        try
        {
            id = args[0].getAsString();
            name = args[0].getAsString();
            email = args[0].getAsString();
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return null;
        }

        Bugsnag.setUser(id, email, name);

        return null;
    }
}