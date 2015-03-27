package com.micro.health.family.health.record;

import java.io.File;
import java.util.Date;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.Html;
import android.text.TextWatcher;
import android.util.DisplayMetrics;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;

import com.micro.health.family.health.record.drawings.AmbilWarnaDialog;
import com.micro.health.family.health.record.drawings.AmbilWarnaDialog.OnAmbilWarnaListener;
import com.micro.health.family.health.record.drawings.Brush;
import com.micro.health.family.health.record.drawings.DrawingPath;
import com.micro.health.family.health.record.drawings.DrawingSurface;
import com.micro.health.family.health.record.drawings.PenBrush;
import com.micro.health.family.health.record.dto.FamilyMember;
import com.micro.health.family.health.record.dto.MedicalHistory;
import com.micro.health.family.health.record.dto.ModuleData;
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

public class AddDrawingActivity extends Activity implements View.OnClickListener, View.OnTouchListener {
	//private static final String TAG = AddDrawingActivity.class.getCanonicalName();
	private int ERASERSTROKEWIDTH = 25;
	private int BRUSHSTROKEWIDTH = 25;
	private int MAXSTROKEWIDTH = 70;
	private EditText title;
	private FamilyMember member;
	private TextView userName;
	private ImageView userImg;
	private Button done;
	private ImageView cancel;    
	private Button back;
	private LinearLayout familyClick;
	
	private DrawingSurface drawingSurface;
	private DrawingPath currentDrawingPath;
	private Paint currentPaint;
	
	private ImageButton redoBtn;
	private ImageButton undoBtn;
	private ImageButton colorBtn;
	private ImageButton eraserBtn;
	private ImageButton brushBtn;

	private Brush currentBrush;

	private TextView archived;
	private ImageView forward;
	private ImageView delete;
	private RelativeLayout bottombrl;
	private LinearLayout LLbot;
	private Button email, message, removenottaking, cancelDialog;
	private Animation bottomUpAnimation, bottomDownAnimation;
	private boolean isMenuVisible;
	
	private ModuleData currentModule;
	private boolean isEdit = false;
	private MedicalHistory md;
	
	private int screenWidth;
	
	private int sampleSize;
	private int sampleSizeImg;
	
	private SeekBar brushSB;
	private SeekBar eraserSB;
	
	private int initialColor = Color.BLACK;
	private int currentColor = Color.BLACK;
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.add_drawing);
		
		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);
		sampleSize = (int)(22*metrics.density);
		

		if (getIntent().getExtras() != null) {
			if (getIntent().getExtras().containsKey(FamilyHealthApplication.MODULE)) {
				currentModule = (ModuleData) getIntent().getExtras().get(FamilyHealthApplication.MODULE);
			}
			if (getIntent().getExtras().containsKey(FamilyHealthApplication.MEDICALHISTORYOBJ)) {
				isEdit = true;
				md = ((MedicalHistory)getIntent().getExtras().get(FamilyHealthApplication.MEDICALHISTORYOBJ));
				
			}
		}

		title = (EditText) findViewById(R.id.edtimg_title);
		done = (Button) findViewById(R.id.done);
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
		familyClick = (LinearLayout) findViewById(R.id.familyclick);
		drawingSurface = (DrawingSurface) findViewById(R.id.drawingSurface);
        redoBtn = (ImageButton) findViewById(R.id.redo);
        undoBtn = (ImageButton) findViewById(R.id.undo);
        brushBtn = (ImageButton) findViewById(R.id.brush);
        eraserBtn = (ImageButton) findViewById(R.id.eraser);
        colorBtn = (ImageButton) findViewById(R.id.color);
        eraserSB = (SeekBar) findViewById(R.id.seekeraser);
        brushSB = (SeekBar) findViewById(R.id.seekbrush);
        
        

		
		familyClick.setOnClickListener(this);

		back.setOnClickListener(this);
		done.setOnClickListener(this);
		cancel.setOnClickListener(this);
		forward.setOnClickListener(this);
		delete.setOnClickListener(this);
		email.setOnClickListener(this);
		message.setOnClickListener(this);
		removenottaking.setOnClickListener(this);
		cancelDialog.setOnClickListener(this);
		
		title.addTextChangedListener(titleTextWatcher);
		
		DisplayMetrics displaymetrics = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);
        screenWidth = displaymetrics.widthPixels;
        
        sampleSizeImg = (int)(screenWidth*metrics.density);

		if(!isEdit) {
		} else {
			drawingSurface.setBckBitmap(Utils.getEncryptedImage(md.getData(), sampleSizeImg));
			drawingSurface.setEdit(true);
			title.setText(md.getTitle());
		}
		
        member = FamilyHealthApplication.getFamilymember();
		if (member == null) {
			onBackPressed();
		} else {
			userName.setText(member.getFamilyMemFName());
			userImg.setImageBitmap(Utils.getEncryptedImage(member.getFamilyMemImage(), sampleSize));
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
		
		AnimationInitialization();
		
        setCurrentPaint();
        currentBrush = new PenBrush();
        drawingSurface.isDrawing = true;
        drawingSurface.previewPath = new DrawingPath();
        drawingSurface.previewPath.path = new Path();
        drawingSurface.previewPath.paint = getPreviewPaint();

        drawingSurface.setOnTouchListener(this);
        
        
        redoBtn.setOnClickListener(this);
        undoBtn.setOnClickListener(this);
        brushBtn.setOnClickListener(this);
        eraserBtn.setOnClickListener(this);
        colorBtn.setOnClickListener(this);
        
        redoBtn.setEnabled(false);
        undoBtn.setEnabled(false);
        
    	brushSB.setMax(MAXSTROKEWIDTH);
    	eraserSB.setMax(MAXSTROKEWIDTH);
    	brushSB.setProgress(BRUSHSTROKEWIDTH);
    	eraserSB.setProgress(ERASERSTROKEWIDTH);

        
    	eraserSB.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
			public void onProgressChanged(SeekBar seekBar, int progress,
					boolean fromUser) {
				setInitialPaint();
				ERASERSTROKEWIDTH = progress;
				currentPaint.setStrokeWidth(ERASERSTROKEWIDTH);
				currentPaint.setColor(Color.WHITE);
				drawingSurface.previewPath.paint.setStrokeWidth(ERASERSTROKEWIDTH);
				drawingSurface.previewPath.paint.setColor(Color.WHITE);
				seekBar.setVisibility(View.GONE);
			}

			public void onStartTrackingTouch(SeekBar seekBar) {
			}

			public void onStopTrackingTouch(SeekBar seekBar) {
			}
		});
    	
    	brushSB.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
			public void onProgressChanged(SeekBar seekBar, int progress,
					boolean fromUser) {
				setInitialPaint();
				BRUSHSTROKEWIDTH = progress;
				currentPaint.setStrokeWidth(BRUSHSTROKEWIDTH);
				currentPaint.setColor(currentColor);
				drawingSurface.previewPath.paint.setStrokeWidth(BRUSHSTROKEWIDTH);
				drawingSurface.previewPath.paint.setColor(currentColor);
				seekBar.setVisibility(View.GONE);
			}

			public void onStartTrackingTouch(SeekBar seekBar) {
			}

			public void onStopTrackingTouch(SeekBar seekBar) {
			}
		});
    	
    	
    	brushSB.setVisibility(View.GONE);
    	eraserSB.setVisibility(View.GONE);

	}
	
	private void setCurrentPaint(){
	        currentPaint = new Paint();
	        currentPaint.setColor(initialColor);
	        currentPaint.setStyle(Paint.Style.STROKE);
	        currentPaint.setStrokeWidth(BRUSHSTROKEWIDTH);
	        currentPaint.setStrokeJoin(Paint.Join.ROUND);
	        currentPaint.setStrokeCap(Paint.Cap.ROUND);
	      
	    }
	
	private void setInitialPaint(){
        currentPaint = new Paint();
        currentPaint.setStyle(Paint.Style.STROKE);
        currentPaint.setStrokeJoin(Paint.Join.ROUND);
        currentPaint.setStrokeCap(Paint.Cap.ROUND);
    }
	
	
	 private Paint getPreviewPaint(){
	       Paint previewPaint = new Paint();
	       previewPaint.setColor(initialColor);
	       previewPaint.setStyle(Paint.Style.STROKE);
	       previewPaint.setStrokeWidth(BRUSHSTROKEWIDTH);
	       previewPaint.setStrokeJoin(Paint.Join.ROUND);
	       previewPaint.setStrokeCap(Paint.Cap.ROUND);
	       return previewPaint;
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
		if(isMenuVisible)
			hideMenu();
		else
			finish();
	}
	
	
	
	@Override
	protected void onResume() {
		super.onResume();
		callinitialPaint();
	}

	private void callinitialPaint(){
		if(isEdit) {
			drawingSurface.setBckBitmap(Utils.getEncryptedImage(md.getData(), sampleSizeImg));
			drawingSurface.setEdit(true);
		}
		drawingSurface.isDrawing = true;
        currentDrawingPath = new DrawingPath();
        currentDrawingPath.paint = currentPaint;
        currentDrawingPath.paint.setColor(Color.WHITE);
        currentDrawingPath.path = new Path();
        drawingSurface.addDrawingPath(currentDrawingPath);
        currentBrush.mouseUp(currentDrawingPath.path, 0,0);
		currentDrawingPath.paint.setColor(currentColor);
		drawingSurface.invalidate();
		
	}

	@Override
	public void onClick(View v) {
		 brushSB.setVisibility(View.GONE);
		 eraserSB.setVisibility(View.GONE);
		switch (v.getId()) {
		case R.id.familyclick:
			Intent in = new Intent(AddDrawingActivity.this, MyFamilyActivity.class);
			in.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(in);
			break;
		
		case R.id.done:
				Utils.showActivityViewer(AddDrawingActivity.this, "", true);
				new Thread(new Runnable() {
					
					@Override
					public void run() {
						if(!isEdit) {
							String d = new Date().toString();
							FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(AddDrawingActivity.this);
							dbAdapter.open();
							MedicalHistory m = new MedicalHistory();
							m.setFamilyId(member.getFamilyMemid());
							Bitmap bv = drawingSurface.getBitmap();
							String curImage = System.currentTimeMillis()+".png";
							Utils.saveDrawingFromBitmap(bv,curImage);
							m.setData(curImage);
							m.setModuleId(currentModule.getId());
							m.setMedicaldatatypeId(FamilyHealthApplication.DRAWING);
							m.setArchive(false);
							m.setCreatedDate(d);
							m.setModifyDate(d);
							m.setTitle(title.getText().toString());
							m.setOrderNum(dbAdapter.getMaxOrderNumMedicalHistory() + 1);
							boolean x = dbAdapter.insertMedicalHistory(m);
							dbAdapter.close();
							Message msg = new Message();
							msg.what = 5;
							msg.obj = x;
							handler.sendMessage(msg);
						} else {
							String d = new Date().toString();
							FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(AddDrawingActivity.this);
							dbAdapter.open();
							md.setModifyDate(d);
							Utils.saveDrawingFromBitmap(drawingSurface.getBitmap(), md.getData());
							boolean x = dbAdapter.updateMedicalHistory(md.getId(), title.getText().toString(),  md.getModifyDate());
							dbAdapter.close();
							Message msg = new Message();
							msg.what = 1;
							msg.obj = x;
							handler.sendMessage(msg);
						}
					}
				}).start();
			break;
		case R.id.cancels:
			title.setText("");
			break;
		case R.id.forward:
			showMenu();
			break;
		case R.id.delete:
			Utils.showActivityViewer(AddDrawingActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter =new FamilyHealthDBAdapter(AddDrawingActivity.this);
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
			File f = new File(Environment.getExternalStorageDirectory(), System.currentTimeMillis()+".png");
			Utils.getDataForEmailMessageFromFile(new File(FamilyHealthApplication.PATH, md.getData()), f);
			Intent emailIntent = new Intent(Intent.ACTION_SEND);
			emailIntent.putExtra(Intent.EXTRA_CC, "");
			emailIntent.putExtra(Intent.EXTRA_BCC, "");
			emailIntent.putExtra(Intent.EXTRA_SUBJECT,getString(R.string.app_name));
			emailIntent.putExtra(Intent.EXTRA_TEXT,Html.fromHtml(currentModule.getName() + " for " + member.getFamilyMemFName() + " - " + md.getTitle()));
			emailIntent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(f));
			emailIntent.setType("image/png");
			startActivityForResult(emailIntent, 0);
			break;
		case R.id.message:
			hideMenu();
			File f1 = new File(Environment.getExternalStorageDirectory(), System.currentTimeMillis() + ".png");
			Utils.getDataForEmailMessageFromFile(new File(FamilyHealthApplication.PATH, md.getData()), f1);
			Intent messageIntent = new Intent(Intent.ACTION_SEND);
			messageIntent.putExtra("sms_body",getString(R.string.app_name) + "\n" +currentModule.getName() + " for " + member.getFamilyMemFName() + " - " + md.getTitle());
			messageIntent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(f1));
			messageIntent.setType("image/png");
			startActivityForResult(messageIntent, 0);
			break;
		case R.id.rnottaking:
			hideMenu();
			Utils.showActivityViewer(AddDrawingActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter =new FamilyHealthDBAdapter(AddDrawingActivity.this);
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
		case R.id.back:
			onBackPressed();
			break;
		case R.id.color:
			AmbilWarnaDialog dialog = new AmbilWarnaDialog(this, currentColor, new OnAmbilWarnaListener() {
		        @Override
		        public void onOk(AmbilWarnaDialog dialog, int color) {
		        	currentColor = color;
		        	setInitialPaint();
		        	currentPaint.setColor(currentColor);
		        	currentPaint.setStrokeWidth(BRUSHSTROKEWIDTH);
		        	drawingSurface.previewPath.paint.setColor(currentColor);
		        	drawingSurface.previewPath.paint.setStrokeWidth(BRUSHSTROKEWIDTH);
		        }
		                
		        @Override
		        public void onCancel(AmbilWarnaDialog dialog) {
		        	dialog.getDialog().dismiss();
		        	dialog.getDialog().cancel();
		        }
			});
			dialog.show();
			break;
		case R.id.undo:
			 drawingSurface.undo();
             if( drawingSurface.hasMoreUndo() == false ){
                 undoBtn.setEnabled( false );
             }
             redoBtn.setEnabled( true );
             break;
		 case R.id.redo:
			drawingSurface.redo();
            if( drawingSurface.hasMoreRedo() == false ){
                redoBtn.setEnabled( false );
            }
            undoBtn.setEnabled( true );
			break;
		 case R.id.brush:
			 setInitialPaint();
			 currentPaint.setColor(currentColor);
			 currentPaint.setStrokeWidth(BRUSHSTROKEWIDTH);
			 drawingSurface.previewPath.paint.setColor(currentColor);
			 drawingSurface.previewPath.paint.setStrokeWidth(BRUSHSTROKEWIDTH);
			 if(brushSB.getVisibility() == View.VISIBLE) {
				 brushSB.setVisibility(View.GONE);
			 } else {
				 brushSB.setVisibility(View.VISIBLE);	 
			 }
			 break;
		 case R.id.eraser:
			 setInitialPaint();
			 currentPaint.setColor(Color.WHITE);
			 currentPaint.setStrokeWidth(ERASERSTROKEWIDTH);
			 drawingSurface.previewPath.paint.setColor(Color.WHITE);
			 drawingSurface.previewPath.paint.setStrokeWidth(ERASERSTROKEWIDTH);
			 if(eraserSB.getVisibility() == View.VISIBLE) {
				 eraserSB.setVisibility(View.GONE);
			 } else {
				 eraserSB.setVisibility(View.VISIBLE);	 
			 }
			 break;
		}
	}
	
	
	
	@Override
	protected void onPause() {
		super.onPause();
		Utils.clearDialogs();
	}
	
	private Handler handler = new Handler() {

		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			if(msg.what == 5) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					Utils.alertDialogShow(AddDrawingActivity.this, getString(R.string.app_name), getString(R.string.drawingadded), new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							onBackPressed();
						}});
				} else{ 
					Utils.alertDialogShow(AddDrawingActivity.this, getString(R.string.app_name), getString(R.string.drawingnotadded));	
				}
			}
			else if(msg.what == 1) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					Utils.alertDialogShow(AddDrawingActivity.this, getString(R.string.app_name), getString(R.string.drawingupdated), new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}}); 
				} else{ 
					Utils.alertDialogShow(AddDrawingActivity.this, getString(R.string.app_name), getString(R.string.drawingnotupdated));	
				}
				
			}
			else if(msg.what == 2) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					Utils.alertDialogShow(AddDrawingActivity.this, getString(R.string.app_name), getString(R.string.moduleitemdeleted), new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else {
					Utils.alertDialogShow(AddDrawingActivity.this, getString(R.string.app_name), getString(R.string.moduleitemnotdeleted));
				}
			}
			else if(msg.what == 3) {
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
					
					Utils.alertDialogShow(AddDrawingActivity.this, getString(R.string.app_name),arch, new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else {
					Utils.alertDialogShow(AddDrawingActivity.this, getString(R.string.app_name), getString(R.string.moduleitemnotarchived));
				}
			}
		}
		
	};
	
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
	

    public boolean onTouch(View view, MotionEvent motionEvent) {
        if(motionEvent.getAction() == MotionEvent.ACTION_DOWN){
        	drawingSurface.isDrawing = true;
            currentDrawingPath = new DrawingPath();
            currentDrawingPath.paint = currentPaint;
            currentDrawingPath.path = new Path();
			currentBrush.mouseDown(currentDrawingPath.path, motionEvent.getX(), motionEvent.getY());
			currentBrush.mouseDown(drawingSurface.previewPath.path, motionEvent.getX(), motionEvent.getY());
            
        }else if(motionEvent.getAction() == MotionEvent.ACTION_MOVE){
			drawingSurface.isDrawing = true;
            currentBrush.mouseMove( currentDrawingPath.path, motionEvent.getX(), motionEvent.getY() );
            currentBrush.mouseMove(drawingSurface.previewPath.path, motionEvent.getX(), motionEvent.getY());
		}else if(motionEvent.getAction() == MotionEvent.ACTION_UP){
            currentBrush.mouseUp(drawingSurface.previewPath.path, motionEvent.getX(), motionEvent.getY());
            drawingSurface.previewPath.path = new Path();
            drawingSurface.addDrawingPath(currentDrawingPath);
            currentBrush.mouseUp(currentDrawingPath.path, motionEvent.getX(), motionEvent.getY() );
            undoBtn.setEnabled(true);
            redoBtn.setEnabled(false);
        }

        return true;
    }


}
