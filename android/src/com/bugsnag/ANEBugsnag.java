package com.bugsnag;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class ANEBugsnag implements FREExtension
{
    @Override
    public FREContext createContext( String arg0 )
    {
        return new ANEBugsnagContext();
    }

    @Override
    public void dispose()
    {
    }

    @Override
    public void initialize()
    {
    }
}
