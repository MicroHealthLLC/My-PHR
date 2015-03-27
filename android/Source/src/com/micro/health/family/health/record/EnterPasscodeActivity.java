package com.micro.health.family.health.record;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;

public class EnterPasscodeActivity extends Activity {

	private EditText passedt1, passedt2, passedt3, passedt4;
	private String t1, t2, t3, t4;
	private Button cancel;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.enterpasscode);

		passedt1 = (EditText) findViewById(R.id.passtxt1);
		passedt2 = (EditText) findViewById(R.id.passtxt2);
		passedt3 = (EditText) findViewById(R.id.passtxt3);
		passedt4 = (EditText) findViewById(R.id.passtxt4);
		cancel = (Button) findViewById(R.id.cancelbtn);
		
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

					String password = t1 + t2 + t3 + t4;
					if(FamilyHealthApplication.prefs.getLaunchCount() == 0) {
						Intent i = new Intent(EnterPasscodeActivity.this, ReEnterPasscodeActivity.class);
						i.putExtra(FamilyHealthApplication.IPASSCODE, password);
						startActivity(i);
						finish();
					} else {
						if(FamilyHealthApplication.prefs.getPasscode() == Integer.parseInt(password)) {
							Intent i = new Intent(EnterPasscodeActivity.this, MyFamilyActivity.class);
							startActivity(i);
							finish();
						} else {
							Utils.alertDialogShow(EnterPasscodeActivity.this, getString(R.string.app_name), getString(R.string.invalidpasscode));
							passedt1.setText("");
							passedt2.setText("");
							passedt3.setText("");
							passedt4.setText("");
						}
					}
				}
			}
		});
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
