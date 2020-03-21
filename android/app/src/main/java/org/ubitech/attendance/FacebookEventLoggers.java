package org.ubitech.attendance;
/*

import android.content.Context;
import android.os.Bundle;

import com.facebook.appevents.AppEventsConstants;
import com.facebook.appevents.AppEventsLogger;

import java.math.BigDecimal;
import java.util.Currency;

public class FacebookEventLoggers {
    AppEventsLogger logger;
    public FacebookEventLoggers(Context context){
        this.logger = AppEventsLogger.newLogger(context);
    }
    public void logCompleteRegistrationEvent (String registrationMethod) {
        Bundle params = new Bundle();
        registrationMethod="Phone";
        params.putString(AppEventsConstants.EVENT_PARAM_REGISTRATION_METHOD, registrationMethod);
        this.logger.logEvent(AppEventsConstants.EVENT_NAME_COMPLETED_REGISTRATION, params);
    }
    public void logContactEvent () {
        this.logger.logEvent(AppEventsConstants.EVENT_NAME_CONTACT);
    }
    public void logPurchaseEvent () {
        Bundle params = new Bundle();
        this.logger.logPurchase(BigDecimal.valueOf(60.0), Currency.getInstance("INR"), params);
    }
    public void logRateEvent (String contentType, String contentData, String contentId, int maxRatingValue, double ratingGiven) {
        Bundle params = new Bundle();
        maxRatingValue=5;
        ratingGiven=4;
        contentType="App";
        contentData="Opted in for rating";
        contentId="1";

        params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_TYPE, contentType);
        params.putString(AppEventsConstants.EVENT_PARAM_CONTENT, contentData);
        params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_ID, contentId);
        params.putInt(AppEventsConstants.EVENT_PARAM_MAX_RATING_VALUE, maxRatingValue);
        this.logger.logEvent(AppEventsConstants.EVENT_NAME_RATED, ratingGiven, params);
    }
    public void logStartTrialEvent (String orderId, String currency, double price) {
        Bundle params = new Bundle();
        orderId="1";
        price=60.0;
        currency="INR";
        params.putString(AppEventsConstants.EVENT_PARAM_ORDER_ID, orderId);
        params.putString(AppEventsConstants.EVENT_PARAM_CURRENCY, currency);
        logger.logEvent(AppEventsConstants.EVENT_NAME_START_TRIAL, price, params);
    }

}
*/