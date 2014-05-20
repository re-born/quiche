package com.sakailab.quicheroid.app;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Set;


public class ReceiveActivity extends Activity {

    private RequestQueue mRequestQueue;
    private JsonObjectRequest mPostRequest;
    private final Object REQUEST_TAG = new Object();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_receive_layout);
        setWindowInfo();
        mRequestQueue = Volley.newRequestQueue(this);
    }

    private void setWindowInfo() {
        Window window = getWindow();
        window.setType(WindowManager.LayoutParams.TYPE_TOAST);
        window.addFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE);
    }

    private void validateArgument(Bundle extra) throws IllegalArgumentException {
        Set<String> keySet = extra.keySet();
        String text = extra.getString(Intent.EXTRA_TEXT);
        if (!(keySet.contains(Intent.EXTRA_TEXT) && keySet.contains(Intent.EXTRA_SUBJECT)))
            throw new IllegalArgumentException("ブラウザアプリ以外からの受信");

        if (!(ArticleUtil.isHttpsUrl(text) || ArticleUtil.isHttpUrl(text)))
            throw new IllegalArgumentException(text);

        Log.d(Config.DEBUG_TAG, getIntent().getExtras().getString(Intent.EXTRA_TEXT));
        Log.d(Config.DEBUG_TAG, ArticleUtil.getURLString(
                ArticleUtil.getURLString(getIntent().getExtras().getString(Intent.EXTRA_TEXT))));
        Log.d(Config.DEBUG_TAG, getIntent().getExtras().getString(Intent.EXTRA_SUBJECT));
    }

    private void setPostRequest() {
        Bundle extra = getIntent().getExtras();
        JSONObject reqParam = null;
        SharedPreferences pref = getSharedPreferences(Config.APP_CONF, MODE_PRIVATE);
        try {
            validateArgument(extra);

            reqParam = new JSONObject();
            String url = ArticleUtil.getURLString(extra.getString(Intent.EXTRA_TEXT));
            reqParam.put(Config.POST_PARAM_TITLE, extra.getString(Intent.EXTRA_SUBJECT));
            reqParam.put(Config.POST_PARAM_URL, url);
            JSONObject userData = new JSONObject();
            userData.put(Config.POST_PARAM_USER_TWITTER_ID, pref.getString(Config.CONF_ID, ""));
            userData.put(Config.POST_PARAM_USER_OAUTH_TOKEN, "aa1199u398tuoailajflaho");
            reqParam.put(Config.POST_PARAM_USER, userData);

            mPostRequest = new JsonObjectRequest(Request.Method.POST, Config.POST_API, reqParam,
                    new Response.Listener<JSONObject>() {
                        @Override
                        public void onResponse(JSONObject response) {
                            Log.d(Config.DEBUG_TAG, response.toString());
                            pushToast(R.string.post_article_success);
                            finish();
                        }
                    },
                    new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {
                            error.printStackTrace();
                            pushToast(R.string.post_article_success);
                            finish();
                        }
                    }
            );
            mPostRequest.setTag(REQUEST_TAG);
            mRequestQueue.add(mPostRequest);

        } catch (JSONException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            Log.e(Config.DEBUG_TAG, "不正なURLを受け取りました.");
        }

    }

    private void pushToast(int textID) {
        Toast.makeText(this, textID, Toast.LENGTH_LONG).show();
    }

    @Override
    protected void onStart() {
        super.onStart();
        setPostRequest();
    }

    @Override
    protected void onResume() {
        super.onResume();
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
