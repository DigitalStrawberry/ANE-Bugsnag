package com.bugsnag.functions;

import android.content.Context;
import android.content.SharedPreferences;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.bugsnag.android.Bugsnag;

import java.util.UUID;

public class GetDeviceId implements FREFunction
{
	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		SharedPreferences preferences = context.getActivity().getSharedPreferences("com.ane-bugsnag", Context.MODE_PRIVATE);
		String deviceId = preferences.getString("uuid", null);

		if(deviceId == null)
		{
			UUID id = UUID.randomUUID();
			deviceId = id.toString();

			SharedPreferences.Editor editor = preferences.edit();
			editor.putString("uuid", deviceId);
			editor.commit();
		}

		try
		{
			return FREObject.newObject(deviceId);
		}
		catch (FREWrongThreadException e)
		{
			e.printStackTrace();
		}

		return null;
	}
}