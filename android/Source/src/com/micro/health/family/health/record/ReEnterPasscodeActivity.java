package com.micro.health.family.health.record;

import android.app.Activity;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;

public class ReEnterPasscodeActivity extends Activity {
	private EditText passedt1, passedt2, passedt3, passedt4;
	private String t1, t2, t3, t4;
	private Button cancel;
	private String ipasscode="";

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.reenterpasscode);
		
		Bundle bn = getIntent().getExtras();
		if(bn!=null)
		{
			if(bn.containsKey(FamilyHealthApplication.IPASSCODE))
				ipasscode = bn.getString(FamilyHealthApplication.IPASSCODE);
		}

		passedt1 = (EditText) findViewById(R.id.re_passtxt1);
		passedt2 = (EditText) findViewById(R.id.re_passtxt2);
		passedt3 = (EditText) findViewById(R.id.re_passtxt3);
		passedt4 = (EditText) findViewById(R.id.re_passtxt4);
		cancel = (Button) findViewById(R.id.re_cancelbtn);

		cancel.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				onBackPressed();
			}
		});

		passedt1.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
			}

			@Override
			public void afterTextChanged(Editable s) {
				if (s.length() > 0) {
					passedt1.clearFocus();
					passedt2.requestFocus();
					t1 = passedt1.getText().toString();
				}
			}
		});

		passedt2.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
			}

			@Override
			public void afterTextChanged(Editable s) {
				if (s.length() > 0) {
					passedt2.clearFocus();
					passedt3.requestFocus();
					t2 = passedt2.getText().toString();
				}
			}
		});

		passedt3.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
			}

			@Override
			public void afterTextChanged(Editable s) {
				if (s.length() > 0) {
					passedt3.clearFocus();
					passedt4.requestFocus();
					t3 = passedt3.getText().toString();
				}
			}
		});

		passedt4.addTextChangedListener(new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
			}

			@Override
			public void afterTextChanged(Editable s) {
				if (s.length() > 0) {
					passedt4.clearFocus();
					t4 = passedt4.getText().toString();
					String re_password = t1 + t2 + t3 + t4;
					if (re_password.equals(ipasscode)) {
						FamilyHealthApplication.prefs.setLaunchCount(1);
						FamilyHealthApplication.prefs.setPasscode(Integer.parseInt(ipasscode));
						Utils.alertDialogShow(ReEnterPasscodeActivity.this, getString(R.string.backuppassword), getString(R.string.backuppasswordbody),getString(R.string.email), getString(R.string.cancel), dialogListener);
					} else {
						Utils.alertDialogShow(ReEnterPasscodeActivity.this, getString(R.string.app_name), getString(R.string.passcodedonotmatch));
						passedt1.setText("");
						passedt2.setText("");
						passedt3.setText("");
						passedt4.setText("");
					}
				}
			}
		});
	}
	
	private DialogInterface.OnClickListener dialogListener = new DialogInterface.OnClickListener() {
		
		@Override
		public void onClick(DialogInterface dialog, int which) {
			dialog.dismiss();
			dialog.cancel();
			if(which == Dialog.BUTTON_POSITIVE)
			{
				Intent emailIntent = new Intent(Intent.ACTION_SEND);
				emailIntent.putExtra(Intent.EXTRA_CC, "");
				emailIntent.putExtra(Intent.EXTRA_BCC, "");
				emailIntent.putExtra(Intent.EXTRA_SUBJECT,"Family Health Record - Android App" );
				emailIntent.putExtra(Intent.EXTRA_TEXT,Html.fromHtml("Your PIN for Family Health Record<br/>PIN Value is: " + ipasscode)); 
				emailIntent.setType("text/html");
				startActivityForResult(emailIntent, 0);
			}
			if(which == Dialog.BUTTON_NEGATIVE)
			{
				Intent i = new Intent(ReEnterPasscodeActivity.this , MyFamilyActivity.class );
	            startActivity(i);
	            finish();
			}
		}
	};
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if(resultCode == 0)
        {
            Intent i = new Intent(ReEnterPasscodeActivity.this , MyFamilyActivity.class );
            startActivity(i);
            finish();
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
