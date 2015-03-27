package com.micro.health.family.health.record;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.dropbox.client2.exception.DropboxException;
import com.micro.health.family.health.record.dropbox.DownloadZipFromDropbox;
import com.micro.health.family.health.record.dto.BackupRestore;
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

public class DropboxRestoreActivity extends Activity implements OnClickListener {
	private static final String TAG = DropboxRestoreActivity.class.getCanonicalName();
	private Button back;
	private Button edit;
	private Button cancel;
	private RelativeLayout bottom;
	private RelativeLayout block;
	private ProgressBar progressBar;
	
	public static DownloadZipFromDropbox downloadTask;
	
	private ListView restoreListView;
	private RestoreAdapter restoreAdapter;
	private ArrayList<BackupRestore> restoreList;
	private boolean isEdit=false;
	
	private Button restoreHistoryDialog;
	private Button cancelHistoryDialog;
	
	private Animation bottomUpAnimation, bottomDownAnimation;
	private LinearLayout LLbot;
	
	private boolean isMenuVisible = false;
	
	private int currentSelection = -1;
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dropboxrestore);
		
		back = (Button) findViewById(R.id.back);
		bottom = (RelativeLayout) findViewById(R.id.bottom);
		block = (RelativeLayout) findViewById(R.id.blockshadow);
		cancel = (Button) findViewById(R.id.cancel);
		progressBar = (ProgressBar) findViewById(R.id.progress);
		LLbot = (LinearLayout) findViewById(R.id.bottom_up_detailpage);
		
		restoreListView = (ListView) findViewById(R.id.restorelist);
		edit = (Button) findViewById(R.id.edit);
		restoreHistoryDialog = (Button) findViewById(R.id.restorefamilymedicalhistory);
		cancelHistoryDialog = (Button) findViewById(R.id.cancel_photo_detail);
		
		back.setOnClickListener(this);
		edit.setOnClickListener(this);
		cancel.setOnClickListener(this);
		restoreHistoryDialog.setOnClickListener(this);
		cancelHistoryDialog.setOnClickListener(this);
		
		bottom.setVisibility(View.GONE);
		block.setVisibility(View.GONE);		
		AnimationInitialization();
		
	}
	
	public void AnimationInitialization() {
		bottomUpAnimation = AnimationUtils.loadAnimation(this, R.anim.bottom_up);
		bottomDownAnimation = AnimationUtils.loadAnimation(this,R.anim.bottom_down);
	}

	@Override
	protected void onResume() {
		super.onResume();
			Utils.showActivityViewer(DropboxRestoreActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(DropboxRestoreActivity.this);
					dbAdapter.open();
					restoreList = dbAdapter.getRestoreList();
					Collections.sort(restoreList, Collections.reverseOrder());
					dbAdapter.close();
					handler.sendEmptyMessage(0);
				}
			}).start();
	}
	
	private Handler handler = new Handler(){

		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			if(msg.what == 0) {
				if(restoreList.size() > 0) {
					restoreAdapter = new RestoreAdapter(DropboxRestoreActivity.this, R.layout.restorelistitem);
					restoreListView.setAdapter(restoreAdapter);
				}
				Utils.hideActivityViewer();
			}
			
			if(msg.what == 1) {
				restoreAdapter.notifyDataSetChanged();
				Utils.hideActivityViewer();
			}
		}
		
	};

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (!(android.os.Build.VERSION.SDK_INT > android.os.Build.VERSION_CODES.DONUT)
				&& keyCode == KeyEvent.KEYCODE_BACK
				&& event.getRepeatCount() == 0) {
			onBackPressed();
		}
		return super.onKeyDown(keyCode, event);
	}
	
	private class RestoreAdapter extends ArrayAdapter<BackupRestore> { // --CloneChangeRequired
		private ImageView minus;
		private TextView title;
		private TextView subtitle;
		private RelativeLayout rl;
		private int clayout;

		
		public RestoreAdapter(Context context, int textViewResourceId) { // --CloneChangeRequired
			super(context, textViewResourceId, restoreList);
			this.clayout = textViewResourceId;
		}

		public View getView(final int position, View convertView,
				ViewGroup parent) {
			View view = convertView;
			try {
				if (view == null) {
					LayoutInflater vi = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
					view = vi.inflate(clayout, null); // --CloneChangeRequired(list_item)
				}
				
				minus = (ImageView) view.findViewById(R.id.minus);
				title = (TextView) view.findViewById(R.id.title);
				subtitle= (TextView) view.findViewById(R.id.subtitle);
				rl = (RelativeLayout) view.findViewById(R.id.re_module);
			
				final BackupRestore md = restoreList.get(position);
				if(md!=null) {
					minus.setOnClickListener(new View.OnClickListener() {
						@Override
						public void onClick(View v) {
							Utils.showActivityViewer(DropboxRestoreActivity.this,"", false);
							new Thread(new Runnable() {
								
								@Override
								public void run() {
									try {
										FamilyHealthApplication.getmDBApi(DropboxRestoreActivity.this).delete("/" + FamilyHealthApplication.DROPBOX_PATH_BACKUP + "/" + md.getRevision());
									} catch (DropboxException e) {
										Log.e(TAG, e.toString());
										e.printStackTrace();
									}
									FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(DropboxRestoreActivity.this);
									dbAdapter.open();
									boolean x = dbAdapter.deleteBackupRestore(md.getId());
									dbAdapter.close();
									Message msg = new Message();
									msg.what = 1;
									msg.obj = x;
									if(x) {
										restoreList.remove(position);
									}
									handler.sendMessage(msg);		
								}
							}).start();
						}
					});
					
					title.setText(md.getNotes() +" "+ getString(R.string.notes) + ", " + md.getPics() + " " + getString(R.string.pics) + ", " + md.getVoice() + " " + getString(R.string.voice) + ", " + md.getFiles() + " " + getString(R.string.files) + ", " + md.getVideos()+ " " + getString(R.string.videos)  + ", " + md.getDrawings() + " " + getString(R.string.drawings) + " " + getString(R.string.memos));
					DateFormat df = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy");
					DateFormat df1 = new SimpleDateFormat("MM/dd/yy HH:mm aaa");
					Date dated = (Date)df.parse(md.getDateMed());
					
					subtitle.setText(getString(R.string.backedupon) + " " + df1.format(dated));
					if(isEdit) {
						minus.setVisibility(View.VISIBLE);
					} else {
						minus.setVisibility(View.GONE);
					}
					rl.setOnClickListener(new View.OnClickListener() {
						
						@Override
						public void onClick(View v) {
							showMenu(position);
						}
					});
				}
			} catch (Exception e) {
				Log.v(TAG, "" + e.toString());
				e.printStackTrace();
			}
			return view;
		}
	}

	public void onBackPressed() {
		if(isMenuVisible)
			hideMenu();
		else
			finish();
	}
	
	public void showMenu(int position) {
		currentSelection = position;
		LLbot.clearAnimation();
		LLbot.startAnimation(bottomUpAnimation);
		LLbot.setVisibility(View.VISIBLE);
		cancelHistoryDialog.setSelected(true);
		isMenuVisible = true;
	}

	public void hideMenu() {
		LLbot.clearAnimation();
		LLbot.startAnimation(bottomDownAnimation);
		LLbot.setVisibility(View.GONE);
		currentSelection = -1;
		isMenuVisible = false;
	}
	
	private void editClicked()
	{
		isEdit = !isEdit;
		if(isEdit) {
			edit.setText(getString(R.string.done));
			restoreAdapter.notifyDataSetChanged();
		} else {
			edit.setText(getString(R.string.edit));
			restoreAdapter.notifyDataSetChanged();
		}
	}

	@Override
	public void onClick(View v) {
		switch(v.getId()) {
			case R.id.back:
				onBackPressed();
				break;
			case R.id.cancel_photo_detail:
				hideMenu();
				break;
			case R.id.restorefamilymedicalhistory:
				String rev = restoreList.get(currentSelection).getRevision();
				hideMenu();
				back.setEnabled(false);
				edit.setEnabled(false);
				restoreListView.setEnabled(false);
				block.setVisibility(View.VISIBLE);
				bottom.setVisibility(View.VISIBLE);
				downloadTask = new DownloadZipFromDropbox(this, FamilyHealthApplication.getmDBApi(DropboxRestoreActivity.this),"/" + FamilyHealthApplication.DROPBOX_PATH_BACKUP + "/" + rev , rev, progressBar, bottom, block, back, edit, restoreListView);
				downloadTask.execute();
				break;
			case R.id.edit:
				if(restoreList.size() > 0) {
					editClicked();
				}
				break;
			case R.id.cancel:
				downloadTask.cancelRestore();
				break;
		}
	}
	
	@Override
	protected void onPause() {
		super.onPause();
		Utils.clearDialogs();
	}
	
	
}
