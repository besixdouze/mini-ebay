package com.example.miniebay_fall2025;

import androidx.appcompat.app.AppCompatActivity;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    public Activity activity;

    protected String hostAddress = "10.0.2.2:8080";

    protected String servletName = "/project1/authenticateApplicationDummy";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        activity = this;
        Button sbButton = findViewById(R.id.buttonSubmit);

        sbButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                new GetItems(activity).execute();
            }
        });
    }

    private class GetItems extends AsyncTask<Void, Void, Void> {

        private Activity activity;
        private String serverResponse;
        private String url;

        protected GetItems(Activity activity) {
            url = "http://" + hostAddress + servletName;
            this.activity = activity;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            Toast.makeText(MainActivity.this, "Authenticating..." + url, Toast.LENGTH_LONG).show();
        }

        protected Void doInBackground(Void... arg0) {
            String userName, passWord;
            userName = ((EditText) findViewById(R.id.editUsername)).getText().toString();
            passWord = ((EditText) findViewById(R.id.editPwd)).getText().toString();

            HttpHandler handler = new HttpHandler();
            serverResponse = handler.makeServiceCallPost(url, userName, passWord);

            return null;
        }

        protected void onPostExecute(Void result) {
            String msgToast;

            if (serverResponse == null || serverResponse.trim().compareTo("not") == 0) {
                msgToast = "Wrong user or password";
                Toast.makeText(getApplicationContext(), msgToast, Toast.LENGTH_LONG).show();
            } else {
                jsonPerson jPerson = new jsonPerson(serverResponse);
                Intent i = new Intent(MainActivity.this, ProductListActivity.class);
                i.putExtra("jPerson", jPerson);
                startActivity(i);
            }
        }
    }
}
