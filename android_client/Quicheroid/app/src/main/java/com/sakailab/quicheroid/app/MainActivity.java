package com.sakailab.quicheroid.app;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;


public class MainActivity extends Activity {

    private EditText mIDBox;
    private Button mButton;
    private SharedPreferences mPref;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mIDBox = (EditText) findViewById(R.id.twitter_id);
        mButton = (Button) findViewById(R.id.save_button);
        mPref = getSharedPreferences(Config.APP_CONF, MODE_PRIVATE);

        String idText = mPref.getString(Config.CONF_ID, "");
        mIDBox.setText(idText);

        mButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String text = mIDBox.getText().toString();
                if (text.equals(""))
                    return;
                SharedPreferences.Editor edit = mPref.edit();
                edit.putString(Config.CONF_ID, text);
                edit.commit();
                Toast.makeText(MainActivity.this, R.string.save_id_message, Toast.LENGTH_SHORT).show();
            }
        });
    }

}
