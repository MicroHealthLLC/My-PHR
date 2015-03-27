package com.micro.health.family.health.record;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

public class SplashActivity extends Activity {
	protected static final String TAG = SplashActivity.class.getName();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.splash);
		
		 new Thread(new Runnable() {

			@Override
			public void run() {
				try {
					Thread.sleep(3000);
				} catch (InterruptedException e) {
					Log.v(TAG,  e.toString());
				}
			  handler.sendEmptyMessage(0);
			}
		}).start();
	}
	
	private Handler handler = new Handler()
	{
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			if(msg.what == 0) {
				if(FamilyHealthApplication.prefs.getPassCodeLocked()) {
					Intent intent = new Intent(SplashActivity.this, EnterPasscodeActivity.class);
					startActivity(intent);
					finish();
				} else {
					Intent intent = new Intent(SplashActivity.this, MyFamilyActivity.class);
					startActivity(intent);
					finish();
				}
			}
		}
	};

}
