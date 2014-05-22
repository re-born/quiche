package com.sakailab.quicheroid.app;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


public class ReceiveActivity extends Activity {


    private ExecutorService mExecutor = Executors.newSingleThreadExecutor();
    private Handler mHandler = new Handler();
    private boolean mIsFinish = false;
    private ImageView mWaitImage;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_receive_layout);
        setWindowInfo();
        mWaitImage = (ImageView) findViewById(R.id.wait_image);
        callWaitAnimation();
    }

    @Override
    protected void onResume() {
        super.onResume();
        setPostRequest();
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

            postURL(reqParam);

        } catch (JSONException e) {
            e.printStackTrace();
            finish();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            Log.e(Config.DEBUG_TAG, "不正なURLを受け取りました.");
            finish();
        }
    }

    private void postURL(final JSONObject reqParams) {
        mIsFinish = false;
        mExecutor.execute(new Runnable() {
            @Override
            public void run() {
                final JSONObject data = RequestUtil.requestPost(Config.POST_API, reqParams);
                if (data == null)
                    return;
                Log.d(Config.DEBUG_TAG, data.toString());
                mHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        doCallBack(data);
                    }
                });
            }
        });
        mExecutor.shutdown();
    }

    private void callWaitAnimation() {
        if (mIsFinish) {
            mWaitImage.setVisibility(View.GONE);
        } else {
            mWaitImage.setRotation(mWaitImage.getRotation() + 30f);
            mHandler.postDelayed(new Runnable() {
                @Override
                public void run() {
                    callWaitAnimation();
                }
            }, 100);
        }
    }

    private void pushToast(int textID) {
        Toast.makeText(this, textID, Toast.LENGTH_LONG).show();
    }

    private void pushToast(String text) {
        Toast.makeText(this, text, Toast.LENGTH_LONG).show();
    }

    private void doCallBack(JSONObject responce) {
        try {
            mIsFinish = true;
            String text = responce.getString(Config.POST_RESPONCE_RESULT);
            pushToast(text);
        } catch (JSONException e) {
            e.printStackTrace();
        } finally {
            finish();
        }
    }

}