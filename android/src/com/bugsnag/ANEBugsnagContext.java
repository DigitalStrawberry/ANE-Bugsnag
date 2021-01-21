package com.bugsnag;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

import com.bugsnag.functions.*;

public class ANEBugsnagContext extends FREContext
{
	@Override
	public void dispose()
	{
	}

	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("initialize", new Initialize());
		functionMap.put("setContext", new SetContext());
		functionMap.put("crash", new Crash());
		functionMap.put("addAttribute", new AddAttribute());
		functionMap.put("removeAttribute", new RemoveAttribute());
		functionMap.put("removeTab", new RemoveTab());
		functionMap.put("getOSVersion", new GetOSVersion());
		functionMap.put("getDeviceModel", new GetDeviceModel());
		functionMap.put("getDeviceId", new GetDeviceId());
		functionMap.put("getDeviceManufacturer", new GetDeviceManufacturer());

		return functionMap;
	}

}