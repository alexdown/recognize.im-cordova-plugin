package com.phonegap.plugin;

import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import pl.itraff.TestApi.ItraffApi.ItraffApi;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Base64;
import android.util.Log;


/**
 * @author alexdown
 * @author Alessio BAsso
 * 
 *         Plugin to use the recognize.im libraries from js
 */
public class RecognizeImPlugin extends CordovaPlugin {
	
	private final String pluginName = "RecogniseImPlugin";
	
	// tag for debug
	private static final String TAG = "SharpAssistant";
	
	private CallbackContext callbackContext;
	
	static Boolean debug = true;
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see com.phonegap.api.Plugin#execute(java.lang.String,
	 * org.json.JSONArray, java.lang.String)
	 */
	@Override
	public boolean execute(final String action, final JSONArray data, CallbackContext callbackContext) { //final String callBackId) {
		Log.d(pluginName, "Recognise.im called with options: " + data);
		
		this.callbackContext = callbackContext;
		
		if (action.equals("match")) {
			this.recognize(data);
            return true;
        }
		
        return false;
	}

	public void recognize(final JSONArray data) {
		final Context currentCtx = cordova.getActivity();
		
		try {
			JSONObject obj = data.getJSONObject(0);
			String client = obj.getString("client");
			String clientKey = obj.getString("clientKey");
			String img = obj.getString("img");
			
			byte[] pictureData = Base64.decode(img, Base64.DEFAULT);
			if (ItraffApi.isOnline(currentCtx)) {
				// send photo
				ItraffApi api = new ItraffApi(Integer.parseInt(client), clientKey, TAG, debug);
				api.sendPhoto(pictureData, itraffApiHandler);
			} else {
				callbackContext.error("Network unavailable");
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}

	}
	
	// handler that receives response from api
	private Handler itraffApiHandler = new Handler() {
		// callback from api
		@Override
		public void handleMessage(Message msg) {
			Log.d(pluginName, "Recognise.im replied: " + msg);
			Bundle data = msg.getData();
			if (data != null) {
				Integer status = data.getInt(ItraffApi.STATUS, -1);
				String response = data.getString(ItraffApi.RESPONSE);
				// status ok
				if (status == 0) {
					callbackContext.success(response);
					// application error (for example timeout)
				} else if (status == -1) {
					callbackContext.error("Image Recognition API Error");
					// error from api
				} else {
					callbackContext.error("Network unavailable");
				}
			}
		}
	};

}
