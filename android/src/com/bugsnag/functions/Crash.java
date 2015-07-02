package com.bugsnag.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.bugsnag.android.Bugsnag;

public class Crash implements FREFunction
{
    @Override
    public FREObject call( FREContext context, FREObject[] args )
    {
        throw new RuntimeException("This is a crash");
    }
}