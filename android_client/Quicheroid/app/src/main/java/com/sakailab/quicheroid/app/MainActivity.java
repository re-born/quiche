package com.sakailab.quicheroid.app;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.webkit.URLUtil;


public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        boolean flag = URLUtil.isValidUrl("こんにちは http://www.google.com");
        Log.d(Config.DEBUG_TAG, "flag:" + flag);
        Log.d(Config.DEBUG_TAG, URLUtil.guessUrl("こんにちは http://www.google.com"));
    }
}
