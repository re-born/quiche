package com.sakailab.quicheroid.app;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;


public class ReceiveActivity extends Activity {


    private RequestQueue mRequestQueue;
    private JsonObjectRequest mPostRequest;
    private final Object REQUEST_TAG = new Object();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_receive_layout);
        Bundle extra = getIntent().getExtras();
        mRequestQueue = Volley.newRequestQueue(this);
        JSONObject reqParam = null;
        try {
            reqParam = new JSONObject();
            reqParam.put(Config.POST_PARAM_TITLE, extra.getString(Intent.EXTRA_SUBJECT));
            reqParam.put(Config.POST_PARAM_URL, extra.getString(Intent.EXTRA_TEXT));
            JSONObject userData = new JSONObject();
            userData.put(Config.POST_PARAM_USER_TWITTER_ID, "taisho6339");
            userData.put(Config.POST_PARAM_USER_OAUTH_TOKEN, "aa1199u398tuoailajflaho");
            reqParam.put(Config.POST_PARAM_USER, userData);

        } catch (JSONException e) {

        }

        mPostRequest = new JsonObjectRequest(Request.Method.POST, Config.POST_API, reqParam,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        Log.d(Config.DEBUG_TAG, response.toString());
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        error.printStackTrace();
                    }
                }
        );

        mPostRequest.setTag(REQUEST_TAG);
        mRequestQueue.add(mPostRequest);
    }


    @Override
    protected void onStart() {
        super.onStart();
        if (mRequestQueue == null)
            return;
        mRequestQueue.start();
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (mPostRequest == null)
            return;
        mRequestQueue.cancelAll(REQUEST_TAG);
    }
}