package com.bugsnag.functions;

import android.os.Build;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

public class GetDeviceManufacturer implements FREFunction
{
	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		try
		{
			return FREObject.newObject(Build.MANUFACTURER);
		}
		catch (FREWrongThreadException e)
		{
			e.printStackTrace();
		}

		return null;
	}
}