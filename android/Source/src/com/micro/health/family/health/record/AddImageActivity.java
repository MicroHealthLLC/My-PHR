package com.micro.health.family.health.record;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Date;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore.Images.Media;
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
import android.widget.TextView;

import com.micro.health.family.health.record.dto.FamilyMember;
import com.micro.health.family.health.record.dto.MedicalHistory;
import com.micro.health.family.health.record.dto.ModuleData;
import com.micro.health.family.health.record.movescale.PhotoSortrView;
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

public class AddImageActivity extends Activity implements View.OnClickListener {
	private static final String TAG = AddImageActivity.class.getCanonicalName();
	private ImageView img;
	private EditText title;
	private FamilyMember member;
	private TextView userName;
	private ImageView userImg;
	private Button done;
	private ImageView cancel;    
	private PhotoSortrView moveScaleImage;
	private Button back;
	private LinearLayout familyClick;
	
	private TextView archived;
	private ImageView forward;
	private ImageView delete;
	private RelativeLayout bottombrl;
	private LinearLayout LLbot;
	private Button email, message, removenottaking, cancelDialog;
	private Animation bottomUpAnimation, bottomDownAnimation;
	private boolean isMenuVisible;
	
	private ModuleData currentModule;
	private String selpath;
	private int seltype;
	private Bitmap mBitmap;
	private boolean isEdit = false;
	private MedicalHistory md;
	
	private int screenWidth;
	private int screenHeight;
	
	private int sampleSize;
	private int sampleSizeImg;
	
	private Bitmap m_bmOCRBitmap;
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.addimage);
		
		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);
		sampleSize = (int)(22*metrics.density);
		

		if (getIntent().getExtras() != null) {
			if (getIntent().getExtras().containsKey(FamilyHealthApplication.MODULE)) {
				currentModule = (ModuleData) getIntent().getExtras().get(FamilyHealthApplication.MODULE);
			}
			if (getIntent().getExtras().containsKey(FamilyHealthApplication.SELBITMAP)) {
				selpath = getIntent().getExtras().getString(FamilyHealthApplication.SELBITMAP);
			}
			if (getIntent().getExtras().containsKey(FamilyHealthApplication.SELBITMAPTYPE)) {
				seltype = getIntent().getExtras().getInt(FamilyHealthApplication.SELBITMAPTYPE);
			}
			if (getIntent().getExtras().containsKey(FamilyHealthApplication.MEDICALHISTORYOBJ)) {
				isEdit = true;
				md = ((MedicalHistory)getIntent().getExtras().get(FamilyHealthApplication.MEDICALHISTORYOBJ));
				
			}
		}

		img = (ImageView) findViewById(R.id.imgbitmap);
		moveScaleImage = (PhotoSortrView) findViewById(R.id.moveScaleImg);
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
        screenHeight = displaymetrics.heightPixels;
        screenWidth = displaymetrics.widthPixels;
        
        sampleSizeImg = (int)(screenWidth*metrics.density);

		if(!isEdit) {
			if(seltype == FamilyHealthApplication.CAMERA){
				try {
					mBitmap = Media.getBitmap(getContentResolver(), Uri.fromFile(new File(selpath)));
				} catch (FileNotFoundException e) {
					Log.e(TAG, e.toString());
					e.printStackTrace();
				} catch (IOException e) {
					Log.e(TAG, e.toString());
					e.printStackTrace();
				}
			} else if(seltype == FamilyHealthApplication.GALLERY) {
				mBitmap = BitmapFactory.decodeFile(selpath);
			}
			img.setImageBitmap(mBitmap);
			img.setVisibility(View.VISIBLE);
			moveScaleImage.setVisibility(View.GONE);
		} else {
			mBitmap = Utils.getEncryptedImage(md.getData(), sampleSizeImg);
			title.setText(md.getTitle());
			moveScaleImage.setImage(mBitmap);
			img.setVisibility(View.GONE);
			moveScaleImage.setVisibility(View.VISIBLE);
			moveScaleImage.setScale(screenWidth, screenHeight);
			moveScaleImage.setDrawingCacheEnabled(true);
			moveScaleImage.setDrawingCacheBackgroundColor(Color.WHITE);
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
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.familyclick:
			Intent in = new Intent(AddImageActivity.this, MyFamilyActivity.class);
			in.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(in);
			break;
		
		case R.id.done:
			Utils.showActivityViewer(AddImageActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					if(!isEdit) {
						String d = new Date().toString();
						FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(AddImageActivity.this);
						dbAdapter.open();
						MedicalHistory m = new MedicalHistory();
						m.setFamilyId(member.getFamilyMemid());
						String curImage = System.currentTimeMillis()+"";
						Utils.saveImageFromFile(selpath, curImage);
						m.setData(curImage);
						m.setModuleId(currentModule.getId());
						m.setMedicaldatatypeId(FamilyHealthApplication.IMAGE);
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
						FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(AddImageActivity.this);
						dbAdapter.open();
						md.setModifyDate(d);
						moveScaleImage.buildDrawingCache();
						m_bmOCRBitmap = moveScaleImage.getDrawingCache();
						Utils.saveImageFromBitmap(m_bmOCRBitmap, md.getData());
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
			Utils.showActivityViewer(AddImageActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter =new FamilyHealthDBAdapter(AddImageActivity.this);
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
			emailIntent.setType("image/jpg");
			startActivityForResult(emailIntent, 0);
			break;
		case R.id.message:
			hideMenu();
			File f1 = new File(Environment.getExternalStorageDirectory(), System.currentTimeMillis() + ".png");
			Utils.getDataForEmailMessageFromFile(new File(FamilyHealthApplication.PATH, md.getData()), f1);
			Intent messageIntent = new Intent(Intent.ACTION_SEND);
			messageIntent.putExtra("sms_body",getString(R.string.app_name) + "\n" +currentModule.getName() + " for " + member.getFamilyMemFName() + " - " + md.getTitle());
			messageIntent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(f1));
			messageIntent.setType("image/jpeg");
			startActivityForResult(messageIntent, 0);
			break;
		case R.id.rnottaking:
			hideMenu();
			Utils.showActivityViewer(AddImageActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter =new FamilyHealthDBAdapter(AddImageActivity.this);
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
					Utils.alertDialogShow(AddImageActivity.this, getString(R.string.app_name), getString(R.string.imageadded), new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else{ 
					Utils.alertDialogShow(AddImageActivity.this, getString(R.string.app_name), getString(R.string.imagenotadded));	
				}
			}
			else if(msg.what == 1) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					Utils.alertDialogShow(AddImageActivity.this, getString(R.string.app_name), getString(R.string.imageupdated), new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}}); 
				} else{ 
					Utils.alertDialogShow(AddImageActivity.this, getString(R.string.app_name), getString(R.string.imagenotupdated));	
				}
				
			}
			else if(msg.what == 2) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					Utils.alertDialogShow(AddImageActivity.this, getString(R.string.app_name), getString(R.string.moduleitemdeleted), new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else {
					Utils.alertDialogShow(AddImageActivity.this, getString(R.string.app_name), getString(R.string.moduleitemnotdeleted));
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
					
					Utils.alertDialogShow(AddImageActivity.this, getString(R.string.app_name),arch, new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else {
					Utils.alertDialogShow(AddImageActivity.this, getString(R.string.app_name), getString(R.string.moduleitemnotarchived));
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

	@Override
	protected void onDestroy() {
		super.onDestroy();
		if(seltype == FamilyHealthApplication.CAMERA) {
			Utils.deleteFile(new File(selpath));
		}
	}
	
	

}
