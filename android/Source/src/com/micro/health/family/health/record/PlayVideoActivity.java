package com.micro.health.family.health.record;

import java.io.IOException;
import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;

public class PlayVideoActivity extends Activity implements SurfaceHolder.Callback {
	private static final String TAG = PlayVideoActivity.class.getCanonicalName();
    private String fileName;
    private int playingCounter=-1;
    private int totalCounter;
    private String extension;
    
    private TextView startTime;
	private TextView endTime;
	private SeekBar seekPlaying;
	private LinearLayout stopBtn;
    
    private SurfaceView videoView;
    private SurfaceHolder holder;
    
    private MediaPlayer mPlayer = null;
    
    private long totalDuration;
    
    private ArrayList<String> fileDurations = new ArrayList<String>();
	 
    @Override
    public void onCreate(Bundle savedInstanceState) {
          super.onCreate(savedInstanceState);

          Bundle bn = getIntent().getExtras();
	  	  if (bn != null) {
  			if (bn.containsKey(FamilyHealthApplication.FILENAME)) {
  				fileName = bn.getString(FamilyHealthApplication.FILENAME);
  			}
  			if (bn.containsKey(FamilyHealthApplication.COUNTER)) {
  				totalCounter = bn.getInt(FamilyHealthApplication.COUNTER);
  			}
  			if (bn.containsKey(FamilyHealthApplication.EXTENSION)) {
  				extension = bn.getString(FamilyHealthApplication.EXTENSION);
  			}
  			if (bn.containsKey(FamilyHealthApplication.TOTALDURATION)) {
  				totalDuration = bn.getLong(FamilyHealthApplication.TOTALDURATION);
  			}
  			if (bn.containsKey(FamilyHealthApplication.FILEDURATIONS)) {
  				fileDurations = bn.getStringArrayList(FamilyHealthApplication.FILEDURATIONS);
  			}
	  	  }
          setContentView(R.layout.play_video);
          
	      startTime = (TextView) findViewById(R.id.starttime);
		  endTime = (TextView) findViewById(R.id.endtime);
		  seekPlaying = (SeekBar) findViewById(R.id.seekplaying);
		
		  stopBtn = (LinearLayout) findViewById(R.id.stop);
	      videoView = (SurfaceView) findViewById(R.id.videoview);
	  		  
	      holder = videoView.getHolder();
	  	  holder.addCallback(this);
	  	  holder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
	          
	  	  stopBtn.setOnClickListener(new View.OnClickListener() {
				
				@Override
				public void onClick(View v) {
					onBackPressed();
				}
			});
	  	  
	  	  seekPlaying.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
			public void onProgressChanged(SeekBar seekBar, int progress,
					boolean fromUser) {
				if (fromUser && mPlayer.isPlaying()) {
					long s = 0;
					for(int i=0;i<playingCounter;i++){
						s = s + Long.parseLong(fileDurations.get(i));
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
          
	  	  
	  	  mPlayer = new MediaPlayer();
	      playingCounter = -1;
	  	  seekPlaying.setEnabled(false);
	  	  Utils.showActivityViewer(PlayVideoActivity.this, "", true);
	 }
    
    private void startPlaying(boolean x) {
		if (totalCounter >= 0) {
			
			if(!x)
				playingCounter++;
				
			
			startTime.setText("00:00");

			seekPlaying.setMax((int) totalDuration);

			int seconds = (int) (totalDuration / 1000);
			int minutes = seconds / 60;
			seconds = seconds % 60;
			if (seconds < 10) {
				endTime.setText("" + minutes + ":0" + seconds);
			} else {
				endTime.setText("" + minutes + ":" + seconds);
			}

			if (mPlayer == null) {
				mPlayer = new MediaPlayer();
			}
			try {
				mPlayer.setDataSource(fileName + playingCounter + extension);
				mPlayer.setDisplay(holder);
				mPlayer.setScreenOnWhilePlaying(true);
				   
				mPlayer.setOnPreparedListener(new OnPreparedListener() {

					@Override
					public void onPrepared(MediaPlayer mp) {
						seekPlaying.setEnabled(true);
						mPlayer.start();
						mHandler.removeCallbacks(mUpdateSeekBar);
						mHandler.postDelayed(mUpdateSeekBar, 100);
						handler.sendEmptyMessage(0);
					}
				});
				mPlayer.prepare();
				
				mPlayer.setOnCompletionListener(new OnCompletionListener() {

					@Override
					public void onCompletion(MediaPlayer mp) {
						if (playingCounter >= totalCounter) {
							stopPlaying();
						} else {
							mPlayer.release();
							mPlayer = null;
							startPlaying(false);
						}
					}
				});
			} catch (IOException e) {
				Log.e(TAG, "prepare() failed:" + e.toString());
			}
		}
	}
    
    private Handler handler = new Handler(){

		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			if(msg.what == 0) {
				Utils.hideActivityViewer();
			}
		}
    	
    };
    
    


	private void stopPlaying() {
		playingCounter = -1;
		mHandler.removeCallbacks(mUpdateSeekBar);

		mPlayer.release();
		mPlayer = null;

		onBackPressed();
	}
	
	private Handler mHandler = new Handler();

	private Runnable mUpdateSeekBar = new Runnable() {
		public void run() {
			long s = 0;
			for (int i = 0; i < playingCounter; i++) {
				s = s + Long.parseLong(fileDurations.get(i));
			}
			seekPlaying.setProgress((int) (s + mPlayer.getCurrentPosition()));
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
		Utils.clearDialogs();
		mHandler.removeCallbacks(mUpdateSeekBar);
		
		if(mPlayer != null) {
			if(mPlayer.isPlaying())
				mPlayer.stop();
			mPlayer.release();
			mPlayer = null;
		}
		Intent intent1 = new Intent();
		setResult(Activity.RESULT_OK, intent1);
		finish();
	}
	
	

	@Override
	protected void onPause() {
		super.onPause();
		onBackPressed();
					
	}

	@Override
	public void surfaceChanged(SurfaceHolder holder, int format, int width,
			int height) {
	}

	@Override
	public void surfaceCreated(SurfaceHolder holder) {
		 runOnUiThread(new Runnable(){
	            public void run(){
	                startPlaying(false);
	            }
	        });
	}

	@Override
	public void surfaceDestroyed(SurfaceHolder holder) {
	}
}