package com.micro.health.family.health.record;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.media.MediaRecorder;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore.Images;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;

import com.micro.health.family.health.record.dto.FamilyMember;
import com.micro.health.family.health.record.dto.MedicalHistory;
import com.micro.health.family.health.record.dto.ModuleData;
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

public class AddAudioActivity extends Activity implements View.OnClickListener {
	private static final String TAG = AddAudioActivity.class.getCanonicalName();
	private static String mFileName = null;

	private static final int NONE = 0;
	private static final int PLAYING = 2;
	private static final int RECORDING = 1;
	private Button back;
	private MediaRecorder mRecorder = null;
	private MediaPlayer mPlayer = null;
	private ImageView im_record, im_play, im_stop;
	private TextView recordingTime;
	private TextView notRecordingTime;
	private LinearLayout recordingLL;
	private LinearLayout playingLL;
	private TextView startTime;
	private TextView endTime;
	private SeekBar seekPlaying;
	private String extension = "";
	private Button donebtn;
	private EditText title;
	private LinearLayout shadowTitle;
	private LinearLayout stopShadow;
	private LinearLayout playShadow;
	private LinearLayout recordShadow;
	private ImageView cancel;
	private LinearLayout familyClick;

	private TextView userName;
	private ImageView userImg;
	
	private FamilyMember member;
	private int currentTask = NONE;
	
	private long startTimeRecording;
	
	private ModuleData currentModule;
	private MedicalHistory md;
	private boolean isEdit = false;
	private boolean isMenuVisible;
	
	private int sampleSize;
	
	private TextView archived;
	private ImageView forward;
	private ImageView delete;
	private RelativeLayout bottombrl;
	private LinearLayout LLbot;
	private Button email, message, removenottaking, cancelDialog;
	private Animation bottomUpAnimation, bottomDownAnimation;

	private int recordingCounter=-1;
	private int playingCounter=-1;
	private long totalDuration = 0;
	
	private HashMap<Integer, Long> fileDurations = new HashMap<Integer, Long>();
	private ArrayList<String> fileNamesEdit = new ArrayList<String>();
	private int existingCounter = 0;
	
	@Override
	public void onCreate(Bundle icicle) {
		super.onCreate(icicle);
		setContentView(R.layout.add_audio);
		
		if (getIntent().getExtras() != null) {
			if (getIntent().getExtras().containsKey(FamilyHealthApplication.MODULE)) {
				currentModule = (ModuleData) getIntent().getExtras().get(FamilyHealthApplication.MODULE);
			}
			if (getIntent().getExtras().containsKey(FamilyHealthApplication.MEDICALHISTORYOBJ)) {
				isEdit = true;
				md =  ((MedicalHistory)getIntent().getExtras().get(FamilyHealthApplication.MEDICALHISTORYOBJ));
			}
		}
		
		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);
		sampleSize = (int)(22*metrics.density);

		im_record = (ImageView) findViewById(R.id.recordImg);
		im_play = (ImageView) findViewById(R.id.playImg);
		im_stop = (ImageView) findViewById(R.id.stopImg);
		donebtn = (Button) findViewById(R.id.done);
		title = (EditText) findViewById(R.id.edtimg_title);
		recordingTime = (TextView) findViewById(R.id.recordingtime);
		recordingTime = (TextView) findViewById(R.id.recordingtime);
		notRecordingTime = (TextView) findViewById(R.id.notrecording);
		recordingLL = (LinearLayout) findViewById(R.id.recordingll);
		playingLL = (LinearLayout) findViewById(R.id.playingll);
		startTime = (TextView) findViewById(R.id.starttime);
		endTime = (TextView) findViewById(R.id.endtime);
		seekPlaying = (SeekBar) findViewById(R.id.seekplaying);
		shadowTitle = (LinearLayout) findViewById(R.id.shadowTitle);
		stopShadow = (LinearLayout) findViewById(R.id.stopShadow);
		recordShadow = (LinearLayout) findViewById(R.id.recordShadow);
		playShadow = (LinearLayout) findViewById(R.id.playShadow);
		userName = (TextView) findViewById(R.id.username_txt);
		userImg = (ImageView) findViewById(R.id.userImg);
		cancel = (ImageView) findViewById(R.id.cancels);
		
		archived = (TextView) findViewById(R.id.archived);
		forward = (ImageView) findViewById(R.id.forward);
		delete = (ImageView) findViewById(R.id.delete);
		bottombrl = (RelativeLayout) findViewById(R.id.bottomb);
		LLbot = (LinearLayout) findViewById(R.id.bottom_up_detailpage);
		email = (Button) findViewById(R.id.email);
		message = (Button) findViewById(R.id.message);
		removenottaking = (Button) findViewById(R.id.rnottaking);
		cancelDialog = (Button) findViewById(R.id.cancel_photo_detail);

		back = (Button) findViewById(R.id.back);
		
		back.setOnClickListener(this);
		familyClick = (LinearLayout) findViewById(R.id.familyclick);
		familyClick.setOnClickListener(this);

		shadowTitle.setBackgroundColor(Color.argb(200, 0, 0, 0));
		recordShadow.setBackgroundColor(Color.argb(200, 0, 0, 0));
		stopShadow.setBackgroundColor(Color.argb(200, 0, 0, 0));
		playShadow.setBackgroundColor(Color.argb(200, 0, 0, 0));

		shadowTitle.setVisibility(View.GONE);
		recordShadow.setVisibility(View.GONE);
		stopShadow.setVisibility(View.GONE);
		playShadow.setVisibility(View.GONE);

		im_record.setOnClickListener(this);
		im_stop.setOnClickListener(this);
		im_play.setOnClickListener(this);
		donebtn.setOnClickListener(this);
		
		cancel.setOnClickListener(this);
		forward.setOnClickListener(this);
		delete.setOnClickListener(this);
		email.setOnClickListener(this);
		message.setOnClickListener(this);
		removenottaking.setOnClickListener(this);
		cancelDialog.setOnClickListener(this);
		title.addTextChangedListener(titleTextWatcher);

		member = FamilyHealthApplication.getFamilymember();
		if (member == null) {
			onBackPressed();
		} else {
			userName.setText(member.getFamilyMemFName());
			userImg.setImageBitmap(Utils.getEncryptedImage(member.getFamilyMemImage(), sampleSize));
		}

		seekPlaying.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
			public void onProgressChanged(SeekBar seekBar, int progress,
					boolean fromUser) {
				if (fromUser && mPlayer.isPlaying()) {
					long s = 0;
					for(int i=0;i<playingCounter;i++){
						s = s + fileDurations.get(i);
					}
					seekPlaying.setProgress(progress);
					mPlayer.seekTo((int)(progress-s));
				}
			}

			public void onStartTrackingTouch(SeekBar seekBar) {
			}

			public void onStopTrackingTouch(SeekBar seekBar) {
			}
		});

		AnimationInitialization();
	}
	
	

	@Override
	protected void onResume() {
		super.onResume();
		mPlayer = null;
		recordingCounter=-1;
		playingCounter=-1;
		totalDuration = 0;
		
		currentTask = NONE;
		
		fileDurations = new HashMap<Integer, Long>();
		fileNamesEdit = new ArrayList<String>();
		existingCounter = 0;
		
		
		recordingLL.setVisibility(View.GONE);
		playingLL.setVisibility(View.GONE);

		mFileName = Environment.getExternalStorageDirectory().getAbsolutePath();
		mFileName += "/fhra" + System.currentTimeMillis(); 
		
		if(isEdit) {
			notRecordingTime.setVisibility(View.GONE);
			recordingLL.setVisibility(View.GONE);
			playingLL.setVisibility(View.VISIBLE);
			title.setText(md.getTitle());
			stopShadow.setVisibility(View.VISIBLE);
			playShadow.setVisibility(View.GONE);
			recordShadow.setVisibility(View.GONE);
			im_stop.setEnabled(false);
			im_play.setEnabled(true);
			im_record.setEnabled(true);
			
			String[] xsplit = md.getData().split("--OV--");
			recordingCounter = xsplit.length-1;
			fileDurations.clear();
			totalDuration = 0;
			for(int i=0;i<xsplit.length;i++){
				String[] ysplit = xsplit[i].split(":");
				long xt = Long.parseLong(ysplit[1]);
				fileDurations.put(i, xt);
				fileNamesEdit.add(ysplit[0]);
				Utils.getDataForEmailMessageFromFile(new File(FamilyHealthApplication.PATH, ysplit[0]), new File(mFileName+i));
				totalDuration += xt;
			}
			existingCounter = xsplit.length;
		} else {
			notRecordingTime.setVisibility(View.VISIBLE);
			recordingLL.setVisibility(View.GONE);
			playingLL.setVisibility(View.GONE);
			stopShadow.setVisibility(View.VISIBLE);
			playShadow.setVisibility(View.VISIBLE);
			recordShadow.setVisibility(View.GONE);
			im_stop.setEnabled(false);
			im_play.setEnabled(false);
			im_record.setEnabled(true);
		}
		
		if(isEdit){
			if(md.getArchive()) {
				if(currentModule.getId() == 5){
					removenottaking.setText(getString(R.string.removenottakinglabel));
					archived.setText(getString(R.string.nottaking));
				} else {
					removenottaking.setText(getString(R.string.removearchivelabel));
					archived.setText(getString(R.string.archived));
				}
				archived.setVisibility(View.VISIBLE);
			} else {
				if(currentModule.getId() == 5){
					removenottaking.setText(getString(R.string.markasnottaking));
				} else {
					removenottaking.setText(getString(R.string.markasarchived));
				}
				archived.setVisibility(View.GONE);
			}
			bottombrl.setVisibility(View.VISIBLE);
		} else {
			archived.setVisibility(View.GONE);
			bottombrl.setVisibility(View.GONE);
			
		}
	}



	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.familyclick:
			Intent in = new Intent(AddAudioActivity.this, MyFamilyActivity.class);
			in.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(in);
			break;
		case R.id.back:
			onBackPressed();
			break;
		case R.id.recordImg:
			startRecording();
			break;
		case R.id.playImg:
			startPlaying();
			break;
		case R.id.stopImg:
			if (currentTask == PLAYING)
				stopPlaying();
			else if (currentTask == RECORDING)
				stopRecording();
			break;
		case R.id.done:
			if(currentTask == NONE) {
				Utils.showActivityViewer(AddAudioActivity.this, "", true);
				new Thread(new Runnable() {
					@Override
					public void run() {
						if(!isEdit){
							String d = new Date().toString();
							FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(AddAudioActivity.this);
							dbAdapter.open();
							MedicalHistory m = new MedicalHistory();
							m.setFamilyId(member.getFamilyMemid());
							String currData = "";
							for(int i=0;i<=recordingCounter;i++){
								String curImage = System.currentTimeMillis() + extension;
								Utils.saveAudioFromFile(mFileName + i + extension, curImage);
								currData = currData + curImage + ":" + fileDurations.get(i) + "--OV--";
							}
							m.setData(currData.substring(0, currData.length()-6));
							m.setModuleId(currentModule.getId());
							m.setMedicaldatatypeId(FamilyHealthApplication.AUDIO);
							m.setArchive(false);
							m.setCreatedDate(d);
							m.setModifyDate(d);
							m.setTitle(title.getText().toString());
							m.setOrderNum(dbAdapter.getMaxOrderNumMedicalHistory() + 1);
							boolean x = dbAdapter.insertMedicalHistory(m);
							dbAdapter.close();
							Message msg = new Message();
							msg.what = 0;
							msg.obj = x;
							handler.sendMessage(msg);
						} else {
							String d = new Date().toString();
							FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(AddAudioActivity.this);
							dbAdapter.open();
							md.setModifyDate(d);
							String currData = "";
							for(int i=existingCounter;i<=recordingCounter;i++){
								String curImage = System.currentTimeMillis() + extension;
								Utils.saveAudioFromFile(mFileName + i + extension, curImage);
								currData = currData + curImage + ":" + fileDurations.get(i) + "--OV--";
							}
							if(currData.length() > 0) {
								md.setData(md.getData() + "--OV--" + currData.substring(0, currData.length()-6));
							} else {
								md.setData(md.getData()); 
							}
							boolean x = dbAdapter.updateMedicalHistoryAudio(md.getId(), title.getText().toString(), md.getModifyDate(), md.getData());
							dbAdapter.close();
							Message msg = new Message();
							msg.what = 1;
							msg.obj = x;
							handler.sendMessage(msg);
						}
					}
				}).start();	
			}
			break;
		case R.id.cancels:
			title.setText("");
			break;
		case R.id.forward:
			showMenu();
			break;
		case R.id.delete:
			Utils.showActivityViewer(AddAudioActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter =new FamilyHealthDBAdapter(AddAudioActivity.this);
					dbAdapter.open();
					boolean x = dbAdapter.deleteMedicalHistory(md.getId());
					dbAdapter.close();
					Message msg = new Message();
					msg.what = 2;
					msg.obj = x;
					handler.sendMessage(msg);
					
				}
			}).start();
			break;
		case R.id.email:
			hideMenu();
			Intent emailIntent = new Intent(Intent.ACTION_SEND_MULTIPLE);
			emailIntent.putExtra(Intent.EXTRA_CC, "");
			emailIntent.putExtra(Intent.EXTRA_BCC, "");
			emailIntent.putExtra(Intent.EXTRA_SUBJECT,getString(R.string.app_name));
			emailIntent.putExtra(Intent.EXTRA_TEXT,Html.fromHtml(currentModule.getName() + " for " + member.getFamilyMemFName() + " - " + md.getTitle()));
			ArrayList<Uri> uriList;
			try {
				uriList = getUriListForImages(md.getData());
				emailIntent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, uriList);
			} catch (Exception e) {
				Log.e(TAG, e.toString());
				e.printStackTrace();
			}
			emailIntent.setType("text/html");
			startActivityForResult(emailIntent, 0);
			break;
		case R.id.message:
			hideMenu();
			Intent messageIntent = new Intent(Intent.ACTION_SEND_MULTIPLE);
			messageIntent.putExtra("sms_body",getString(R.string.app_name) + "\n" +currentModule.getName() + " for " + member.getFamilyMemFName() + " - " + md.getTitle());
			ArrayList<Uri> uriList1;
			try {
				uriList1 = getUriListForImages(md.getData());
				messageIntent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, uriList1);
			} catch (Exception e) {
				Log.e(TAG, e.toString());
				e.printStackTrace();
			}
			messageIntent.setType("text/html");
			startActivityForResult(messageIntent, 0);
			break;
		case R.id.rnottaking:
			hideMenu();
			Utils.showActivityViewer(AddAudioActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter =new FamilyHealthDBAdapter(AddAudioActivity.this);
					dbAdapter.open();
					boolean x = dbAdapter.archiveMedicalHistory(!md.getArchive(), md.getId());
					dbAdapter.close();		
					Message msg = new Message();
					msg.what = 3;
					msg.obj = x;
					handler.sendMessage(msg);
				}
			}).start();
			break;
		case R.id.cancel_photo_detail:
			hideMenu();
			break;
		}
	}
	
	 private ArrayList<Uri> getUriListForImages(String fileString) throws Exception {
		 ArrayList<Uri> myList = new ArrayList<Uri>();
         String imageDirectoryPath = Environment.getExternalStorageDirectory().getAbsolutePath()+ File.separator;
         String[] xsplit = fileString.split("--OV--");
		 for(int i=0;i<xsplit.length;i++){
			 try{
				 
					String[] ysplit = xsplit[i].split(":");
					String fname = ysplit[0];
					String fname1 = ysplit[0] + ".wav";
					
					Utils.getDataForEmailMessageFromFile(new File(FamilyHealthApplication.PATH,fname), new File(Environment.getExternalStorageDirectory(), fname1));
					ContentValues values = new ContentValues(7);
                    values.put(Images.Media.TITLE, fname1);
                    values.put(Images.Media.DISPLAY_NAME,fname1);
                    values.put(Images.Media.DATE_TAKEN, new Date().getTime());
                    values.put(Images.Media.MIME_TYPE, "audio/wav");
                    values.put(Images.ImageColumns.BUCKET_ID, imageDirectoryPath.hashCode());
                    values.put(Images.ImageColumns.BUCKET_DISPLAY_NAME, fname1);
                    values.put("_data", imageDirectoryPath + fname1);
                    ContentResolver contentResolver = getApplicationContext().getContentResolver();
                    Uri uri = contentResolver.insert(Images.Media.EXTERNAL_CONTENT_URI, values);
                    myList.add(uri);
                 } catch (Exception e) {
                    e.printStackTrace();
                 }
             }
         return myList;
     } 


	private void startRecording() {
		recordingCounter++;
		currentTask = RECORDING;
		im_play.setEnabled(false);
		im_record.setEnabled(false);
		im_stop.setEnabled(true);
		im_stop.setImageResource(R.drawable.stopred);
		shadowTitle.setVisibility(View.VISIBLE);
		recordShadow.setVisibility(View.VISIBLE);
		playShadow.setVisibility(View.VISIBLE);
		stopShadow.setVisibility(View.GONE);

		notRecordingTime.setVisibility(View.GONE);
		playingLL.setVisibility(View.GONE);
		recordingLL.setVisibility(View.VISIBLE);
		recordingTime.setText("00:00");

		mRecorder = new MediaRecorder();
		mRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
		mRecorder.setOutputFormat(MediaRecorder.OutputFormat.RAW_AMR);
		mRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
		mRecorder.setOutputFile(mFileName + recordingCounter + extension);
		try {
			mRecorder.prepare();
		} catch (IllegalStateException e) {
			Log.e(TAG, e.toString());
			e.printStackTrace();
		} catch (IOException e) {
			Log.e(TAG, e.toString());
			e.printStackTrace();
		}
		mRecorder.start();
		startTimeRecording = System.currentTimeMillis();
		mHandler.removeCallbacks(mUpdateTimeTask);
		mHandler.postDelayed(mUpdateTimeTask, 100);
	}

	private void stopRecording() {
		long dur = (System.currentTimeMillis() - startTimeRecording);
		totalDuration = totalDuration + dur ;
		fileDurations.put(recordingCounter, dur);
		
		currentTask = NONE;
		mHandler.removeCallbacks(mUpdateTimeTask);

		im_play.setEnabled(true);
		im_record.setEnabled(true);
		im_stop.setEnabled(false);

		shadowTitle.setVisibility(View.GONE);
		recordShadow.setVisibility(View.GONE);
		playShadow.setVisibility(View.GONE);
		stopShadow.setVisibility(View.VISIBLE);

		im_stop.setImageResource(R.drawable.stopblue);

		notRecordingTime.setVisibility(View.GONE);
		recordingLL.setVisibility(View.VISIBLE);
		recordingTime.setText("00:00");
		playingLL.setVisibility(View.GONE);

		mRecorder.stop();
		mRecorder.release();
	}

	private void startPlaying() {
		if(recordingCounter >= 0) {
			playingCounter++;
			currentTask = PLAYING;
	
			im_play.setEnabled(false);
			im_record.setEnabled(false);
			im_stop.setEnabled(true);
			im_stop.setImageResource(R.drawable.stopblue);
	
			shadowTitle.setVisibility(View.VISIBLE);
			recordShadow.setVisibility(View.VISIBLE);
			playShadow.setVisibility(View.VISIBLE);
			stopShadow.setVisibility(View.GONE);
	
			notRecordingTime.setVisibility(View.GONE);
			recordingLL.setVisibility(View.GONE);
			recordingTime.setText("00:00");
			playingLL.setVisibility(View.VISIBLE);
			startTime.setText("00:00");
			
			seekPlaying.setMax((int)totalDuration);
			
			int seconds = (int) (totalDuration / 1000);
			int minutes = seconds / 60;
			seconds = seconds % 60;
			if (seconds < 10) {
				endTime.setText("" + minutes + ":0" + seconds);
			} else {
				endTime.setText("" + minutes + ":" + seconds);
			}
		
			
			if(mPlayer == null) {
				mPlayer = new MediaPlayer();
			}
			try {
				mPlayer.setDataSource(mFileName + playingCounter + extension);
				mPlayer.setOnPreparedListener(new OnPreparedListener() {
	
					@Override
					public void onPrepared(MediaPlayer mp) {
						mHandler.removeCallbacks(mUpdateSeekBar);
						mHandler.postDelayed(mUpdateSeekBar, 100);
					}
				});
				mPlayer.prepare();
				mPlayer.start();
				mPlayer.setOnCompletionListener(new OnCompletionListener() {
	
					@Override
					public void onCompletion(MediaPlayer mp) {
						if(playingCounter >= recordingCounter) {
							stopPlaying();
						} else {
							mPlayer.release();
							mPlayer = null;
							startPlaying();
						}
					}
				});
			} catch (IOException e) {
				Log.e(TAG, "prepare() failed:" + e.toString());
			}
		}
	}

	private void stopPlaying() {
			playingCounter = -1;
			currentTask = NONE;
			mHandler.removeCallbacks(mUpdateSeekBar);
	
			im_play.setEnabled(true);
			im_stop.setEnabled(false);
	
			shadowTitle.setVisibility(View.GONE);
			playShadow.setVisibility(View.GONE);
			stopShadow.setVisibility(View.VISIBLE);
	
			im_stop.setImageResource(R.drawable.stopblue);
	
			mPlayer.release();
			mPlayer = null;
			
			notRecordingTime.setVisibility(View.VISIBLE);
			playingLL.setVisibility(View.GONE);
			recordShadow.setVisibility(View.GONE);
			im_record.setEnabled(true);
			recordingLL.setVisibility(View.GONE);
			recordingTime.setText("00:00");
		

	}

	@Override
	public void onPause() {
		super.onPause();
		Utils.clearDialogs();
		mHandler.removeCallbacks(mUpdateSeekBar);
		mHandler.removeCallbacks(mUpdateTimeTask);
		if (mRecorder != null) {
			mRecorder.release();
			mRecorder = null;
		}

		if (mPlayer != null) {
			mPlayer.release();
			mPlayer = null;
		}
		
		if(isEdit) {
			String[] xsplit = md.getData().split("--OV--");
			for(int i=0;i<xsplit.length;i++){
					Utils.deleteFile(new File(mFileName+i));
			}
		}
		
		for(int i=existingCounter;i<=recordingCounter;i++){
			Utils.deleteFile(new File(mFileName + i +extension));
		}
		
		
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
	}



	private Handler mHandler = new Handler(); 

	private Runnable mUpdateTimeTask = new Runnable() {
		public void run() {
			long millis = System.currentTimeMillis() - startTimeRecording;
			int seconds = (int) (millis / 1000);
			int minutes = seconds / 60;
			seconds = seconds % 60;

			if (seconds < 10) {
				recordingTime.setText("" + minutes + ":0" + seconds);
			} else {
				recordingTime.setText("" + minutes + ":" + seconds);
			}
			mHandler.postDelayed(this, 100);
		}
	};

	private Runnable mUpdateSeekBar = new Runnable() {
		public void run() {
			long s = 0;
			for(int i=0;i<playingCounter;i++){
				s = s + fileDurations.get(i);
			}
			seekPlaying.setProgress((int)(s + mPlayer.getCurrentPosition()));
			mHandler.postDelayed(this, 1);
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

	public void onBackPressed() {
		if(isMenuVisible)
			hideMenu();
		else
			finish();
	}
	
	private TextWatcher titleTextWatcher = new TextWatcher() {
		
		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
			if(s.length() > 0) {
				cancel.setVisibility(View.VISIBLE);
			} else {
				cancel.setVisibility(View.GONE);
			}
		}
		
		@Override
		public void beforeTextChanged(CharSequence s, int start, int count,
				int after) {
			
		}
		
		@Override
		public void afterTextChanged(Editable s) {
			
		}
	};
	
	private Handler handler = new Handler() {

		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			if(msg.what == 0) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					Utils.alertDialogShow(AddAudioActivity.this, getString(R.string.app_name), getString(R.string.soundadded), new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else{ 
					Utils.alertDialogShow(AddAudioActivity.this, getString(R.string.app_name), getString(R.string.soundnotadded));	
				}
			}
			if(msg.what == 1) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					Utils.alertDialogShow(AddAudioActivity.this, getString(R.string.app_name), getString(R.string.soundupdated), new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else{ 
					Utils.alertDialogShow(AddAudioActivity.this, getString(R.string.app_name), getString(R.string.soundnotupdated));	
				}
			}
			if(msg.what == 2) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					Utils.alertDialogShow(AddAudioActivity.this, getString(R.string.app_name), getString(R.string.moduleitemdeleted), new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else {
					Utils.alertDialogShow(AddAudioActivity.this, getString(R.string.app_name), getString(R.string.moduleitemnotdeleted));
				}
			}
			
			if(msg.what == 3) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					String arch = "";
					if(currentModule.getId() == 5) {
						if(!md.getArchive()) {
							arch = getString(R.string.moduleitemnottaking);
						} else {
							arch = getString(R.string.moduleitemremovenottaking);
						}
					} else {
						if(!md.getArchive()) {
							arch = getString(R.string.moduleitemarchived);
						} else {
							arch = getString(R.string.moduleitemremovearchived);
						}	
					}
					
					Utils.alertDialogShow(AddAudioActivity.this, getString(R.string.app_name), arch, new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else {
					Utils.alertDialogShow(AddAudioActivity.this, getString(R.string.app_name), getString(R.string.moduleitemnotarchived));
				}
			}
		}
		
	};
	
	
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if(requestCode == 0)
		{
	         
		}
	}

	public void AnimationInitialization() {
		bottomUpAnimation = AnimationUtils.loadAnimation(this, R.anim.bottom_up);
		bottomDownAnimation = AnimationUtils.loadAnimation(this, R.anim.bottom_down);
	}

	public void showMenu() {
		LLbot.clearAnimation();
		LLbot.startAnimation(bottomUpAnimation);
		LLbot.setVisibility(View.VISIBLE);
		cancelDialog.setSelected(true);
		isMenuVisible = true;
	}

	public void hideMenu() {
		LLbot.clearAnimation();
		LLbot.startAnimation(bottomDownAnimation);
		LLbot.setVisibility(View.GONE);
		isMenuVisible = false;
	}

}