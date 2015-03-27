package com.micro.health.family.health.record;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Html;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

public class SettingsActivity extends Activity implements OnClickListener {
	private Button back;
	private RelativeLayout email;
	private RelativeLayout delete;
	private ImageView passcode;
	private RelativeLayout drop;
	private RelativeLayout feedback;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.setting);

		back = (Button) findViewById(R.id.back);
		
		email = (RelativeLayout) findViewById(R.id.email);
		delete = (RelativeLayout) findViewById(R.id.delete);
		passcode = (ImageView) findViewById(R.id.passcode);
		drop = (RelativeLayout) findViewById(R.id.rel_dropbox);
		feedback = (RelativeLayout) findViewById(R.id.feedback);
		
		back.setOnClickListener(this);
		email.setOnClickListener(this);
		delete.setOnClickListener(this);
		passcode.setOnClickListener(this);
		drop.setOnClickListener(this);
		feedback.setOnClickListener(this);
		
		if(FamilyHealthApplication.prefs.getPassCodeLocked())
			passcode.setSelected(true);
		else
			passcode.setSelected(false);
	}
	
	private Handler handler = new Handler()
	{
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			if(msg.what == 0) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					Utils.alertDialogShow(SettingsActivity.this, getString(R.string.app_name), getString(R.string.historydeleted));
				} else {
					Utils.alertDialogShow(SettingsActivity.this, getString(R.string.app_name), getString(R.string.historynotdeleted));
				}
			}
			
			if(msg.what == 1) {
				Utils.hideActivityViewer();
				String xt = msg.obj.toString();
				if(xt.length() > 0) {
					FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(SettingsActivity.this);
					dbAdapter.open();
					int count = dbAdapter.getFamilyMemberCount();
					dbAdapter.close();
					Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
					emailIntent.putExtra(android.content.Intent.EXTRA_CC, "");
					emailIntent.putExtra(android.content.Intent.EXTRA_BCC, "tonyinae@mac.com");
					emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT,"Family Histories: " + count + "people");
					emailIntent.putExtra(Intent.EXTRA_TEXT,Html.fromHtml(xt));
					emailIntent.setType("text/html");
					startActivity(Intent.createChooser(emailIntent, "Send mail..."));
				} else {
					Utils.alertDialogShow(SettingsActivity.this, getString(R.string.app_name), getString(R.string.nohistoryavailable));
				}
			}
		}
		
	};

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.back:
			onBackPressed();
			break;
		case R.id.rel_dropbox:
			Intent i = new Intent(SettingsActivity.this, DropboxActivity.class);
			startActivity(i);
			break;
		case R.id.email:
			Utils.showActivityViewer(SettingsActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(SettingsActivity.this);
					dbAdapter.open();
					String xt = dbAdapter.getAllFamilyHistories();
					dbAdapter.close();
					Message msg = new Message();
					msg.what = 1;
					msg.obj = xt;
					handler.sendMessage(msg);
				}
			}).start();
			break;
		case R.id.delete:
			Utils.showActivityViewer(SettingsActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(SettingsActivity.this);
					dbAdapter.open();
					boolean x = dbAdapter.deleteAllFamilyHistories();
					dbAdapter.close();
					Message msg = new Message();
					msg.what = 0;
					msg.obj = x;
					handler.sendMessage(msg);
				}
			}).start();
			break;
		case R.id.passcode:
			FamilyHealthApplication.prefs.setPassCodeLocked(!FamilyHealthApplication.prefs.getPassCodeLocked());
			if(FamilyHealthApplication.prefs.getPassCodeLocked())
				passcode.setSelected(true);
			else
				passcode.setSelected(false);
			break;
		case R.id.feedback:
			Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
			String[] recipients = new String[] { "feedback@microhealthonline.com" };
			emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL,recipients);
			emailIntent.putExtra(android.content.Intent.EXTRA_CC, "");
			emailIntent.putExtra(android.content.Intent.EXTRA_BCC, "tonyinae@mac.com");
			emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT,"FeedBack for FamilyHealthRecord 1.1.1");
			emailIntent.setType("text/html");
			startActivity(Intent.createChooser(emailIntent, "Send mail..."));	
			break;
		}
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (!(android.os.Build.VERSION.SDK_INT > android.os.Build.VERSION_CODES.DONUT)
				&& keyCode == KeyEvent.KEYCODE_BACK
				&& event.getRepeatCount() == 0) {
			onBackPressed();
		}
		return super.onKeyDown(keyCode, event);
	}

	public void onBackPressed() {
		finish();
	}
}