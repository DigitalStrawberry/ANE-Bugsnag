package com.bugsnag.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.bugsnag.android.Bugsnag;
import com.bugsnag.android.Configuration;
import com.bugsnag.utils.FREUtils;

public class Initialize implements FREFunction
{
    @Override
    public FREObject call( FREContext context, FREObject[] args )
    {
        FREObject freConfig = args[0];

        String apiKey = FREUtils.getStringProperty(freConfig, "androidKey");
        String userId = FREUtils.getStringProperty(freConfig, "userId");
        String userName = FREUtils.getStringProperty(freConfig, "userName");
        String userEmail = FREUtils.getStringProperty(freConfig, "userEmail");
        String releaseStage = FREUtils.getStringProperty(freConfig, "releaseStage");
        boolean autoDetectErrors = FREUtils.getBoolProperty(freConfig, "autoDetectErrors");

        Configuration config = Configuration.load(context.getActivity());
        config.setApiKey(apiKey);
        config.setUser(userId, userEmail, userName);
        config.setReleaseStage(releaseStage);
        config.setAutoDetectErrors(autoDetectErrors);

        Bugsnag.start(context.getActivity(), config);

        return null;
    }
}