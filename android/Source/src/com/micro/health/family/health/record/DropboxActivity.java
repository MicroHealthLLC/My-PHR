package com.micro.health.family.health.record;

import java.io.File;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.dropbox.client2.DropboxAPI;
import com.dropbox.client2.android.AndroidAuthSession;
import com.dropbox.client2.session.AccessTokenPair;
import com.micro.health.family.health.record.dropbox.UploadZipToDropbox;

public class DropboxActivity extends Activity implements OnClickListener {
	private static final String TAG = DropboxActivity.class.getCanonicalName();
	
	AndroidAuthSession session;

	private RelativeLayout link;
	private RelativeLayout dropboxBackup;
	private RelativeLayout dropboxRestore;
	private RelativeLayout block;

	private TextView linkTv;
	private TextView dropbackupTv;
	private TextView droprestoreTv;
	
	private RelativeLayout bottom;
	private Button cancel;
	private ProgressBar progressBar;
	
	private Button back;
	public static UploadZipToDropbox uploadTask;
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dropboxset);

		link = (RelativeLayout) findViewById(R.id.link_drop);
		dropboxBackup = (RelativeLayout) findViewById(R.id.dropback);
		dropboxRestore = (RelativeLayout) findViewById(R.id.droprestore);
		linkTv = (TextView) findViewById(R.id.linkdroptt);
		dropbackupTv = (TextView) findViewById(R.id.dropbackuptxt);
		droprestoreTv = (TextView) findViewById(R.id.droprestoretxt);
		block = (RelativeLayout) findViewById(R.id.blockshadow);
		
		bottom = (RelativeLayout) findViewById(R.id.bottom);
		cancel = (Button) findViewById(R.id.cancel);
		progressBar = (ProgressBar) findViewById(R.id.progress);

		back = (Button) findViewById(R.id.back);
		
		back.setOnClickListener(this);
		link.setOnClickListener(this);
		dropboxBackup.setOnClickListener(this);
		dropboxRestore.setOnClickListener(this);
		cancel.setOnClickListener(this);
		
		bottom.setVisibility(View.GONE);
		block.setVisibility(View.GONE);
		
		AndroidAuthSession session = Utils.buildDropboxSession(DropboxActivity.this);
	    FamilyHealthApplication.setmDBApi(new DropboxAPI<AndroidAuthSession>(session));

		setButtons(FamilyHealthApplication.prefs.getDropBoxLinked());
	}
	
	private void setButtons(boolean mLinked) {
		if(mLinked){
			linkTv.setText(getString(R.string.unlinkdrop));
			dropbackupTv.setEnabled(true);
			droprestoreTv.setEnabled(true);
		} else {
			linkTv.setText(getString(R.string.linkdrop));
			dropbackupTv.setEnabled(false);
			droprestoreTv.setEnabled(false);
		}
	}

	@Override
	protected void onResume() {
		super.onResume();
		if(!FamilyHealthApplication.prefs.getDropBoxLinked()) {
		    if (FamilyHealthApplication.getmDBApi(DropboxActivity.this).getSession().authenticationSuccessful()) {
		        try {
		        	FamilyHealthApplication.getmDBApi(DropboxActivity.this).getSession().finishAuthentication();
		            AccessTokenPair tokens = FamilyHealthApplication.getmDBApi(DropboxActivity.this).getSession().getAccessTokenPair();
		            storeKeys(tokens.key, tokens.secret);
		            FamilyHealthApplication.prefs.setDropBoxLinked(true);
		            setButtons(true);
		        } catch (IllegalStateException e) {
		            Log.i(TAG, "Error authenticating", e);
		        }
		    }
		}
	}


	  private void storeKeys(String key, String secret) {
	       	SharedPreferences prefs = getSharedPreferences(FamilyHealthApplication.ACCOUNT_PREFS_NAME, 0);
	        Editor edit = prefs.edit();
	        edit.putString(FamilyHealthApplication.ACCESS_KEY_NAME, key);
	        edit.putString(FamilyHealthApplication.ACCESS_SECRET_NAME, secret);
	        edit.commit();
	    }

	    private void clearKeys() {
	        SharedPreferences prefs = getSharedPreferences(FamilyHealthApplication.ACCOUNT_PREFS_NAME, 0);
	        Editor edit = prefs.edit();
	        edit.clear();
	        edit.commit();
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

	@Override
	public void onClick(View v) {
		switch(v.getId()) {
			case R.id.link_drop:
				if(FamilyHealthApplication.prefs.getDropBoxLinked()) {
					FamilyHealthApplication.getmDBApi(DropboxActivity.this).getSession().unlink();
			        clearKeys();
			        FamilyHealthApplication.prefs.setDropBoxLinked(false);
			        setButtons(false);
				} else {
					FamilyHealthApplication.getmDBApi(DropboxActivity.this).getSession().startAuthentication(DropboxActivity.this);
				}
				break;
			case R.id.back:
				onBackPressed();
				break;
			case R.id.dropback:
				back.setEnabled(false);
				link.setEnabled(false);
				dropboxBackup.setEnabled(false);
				dropboxRestore.setEnabled(false);
				block.setVisibility(View.VISIBLE);
				bottom.setVisibility(View.VISIBLE);
				File file1 = new File(FamilyHealthApplication.PATH, FamilyHealthApplication.FILENAMEARCHIVE + System.currentTimeMillis() + ".zip");
				uploadTask = new UploadZipToDropbox(this, FamilyHealthApplication.getmDBApi(DropboxActivity.this),"/" + FamilyHealthApplication.DROPBOX_PATH_BACKUP + "/", file1, progressBar, bottom, block, link, dropboxBackup, dropboxRestore, back);
				uploadTask.execute();
                break;
			case R.id.droprestore:
				Intent intent = new Intent(DropboxActivity.this, DropboxRestoreActivity.class);
				startActivity(intent);
				break;
			case R.id.cancel:
				uploadTask.cancelBackup();
				break;
		}
	}
	


	
	
}
