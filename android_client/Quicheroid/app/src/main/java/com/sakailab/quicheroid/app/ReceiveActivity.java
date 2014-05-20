package com.sakailab.quicheroid.app;

import android.app.Activity;
import android.content.Intent;
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


public class ReceiveActivity extends Activity {

    private RequestQueue mRequestQueue;
    private JsonObjectRequest mPostRequest;
    private final Object REQUEST_TAG = new Object();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_receive_layout);
        setWindowInfo();

        Log.d(Config.DEBUG_TAG, getIntent().getExtras().getString(Intent.EXTRA_TEXT));
        Log.d(Config.DEBUG_TAG, ArticleUtil.getURLString(
                ArticleUtil.getURLString(getIntent().getExtras().getString(Intent.EXTRA_TEXT))));
        Log.d(Config.DEBUG_TAG, getIntent().getExtras().getString(Intent.EXTRA_SUBJECT));
    }

    private void setWindowInfo() {
        Window window = getWindow();
        window.setType(WindowManager.LayoutParams.TYPE_TOAST);
        window.addFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE);
    }

    private void setPostRequest() {
        Bundle extra = getIntent().getExtras();
        mRequestQueue = Volley.newRequestQueue(this);

        JSONObject reqParam = null;
        try {
            reqParam = new JSONObject();
            String url = ArticleUtil.getURLString(extra.getString(Intent.EXTRA_TEXT));
            if (url.equals(""))
                throw new IllegalArgumentException(extra.getString(Intent.EXTRA_TEXT));

            reqParam.put(Config.POST_PARAM_TITLE, extra.getString(Intent.EXTRA_SUBJECT));
            reqParam.put(Config.POST_PARAM_URL, url);
            JSONObject userData = new JSONObject();
            userData.put(Config.POST_PARAM_USER_TWITTER_ID, "taisho6339");
            userData.put(Config.POST_PARAM_USER_OAUTH_TOKEN, "aa1199u398tuoailajflaho");
            reqParam.put(Config.POST_PARAM_USER, userData);

        } catch (JSONException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            Log.e(Config.DEBUG_TAG, "不正なURLを受け取りました.");
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
                        finish();
                    }
                }
        );

        mPostRequest.setTag(REQUEST_TAG);
        mRequestQueue.add(mPostRequest);
    }

    @Override
    protected void onStart() {
        super.onStart();
        Toast.makeText(this, R.string.post_article_success, Toast.LENGTH_LONG).show();
        finish();
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
