package com.micro.health.family.health.record;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.provider.MediaStore.Images.Media;
import android.util.DisplayMetrics;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.micro.health.family.health.record.dto.FamilyMember;
import com.micro.health.family.health.record.movescale.PhotoSortrView;
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

public class AddFamilyMemberActivity extends Activity implements OnClickListener {
	private Animation bottomUpAnimation, bottomDownAnimation;
	private ImageView pic_i;
	private Button cancel_btn, choose_photo, take_photo;
	private LinearLayout LLbot;
	private EditText f_name, l_name;
	private Button done;
	private RelativeLayout mainView;
	private RelativeLayout imageMoveView;
	private Button choose;
	private Button cancel;
	private PhotoSortrView moveScaleImage;
	private LinearLayout buttonsbottom;
	private TextView moveScale;
	private Button cancelTop;
	
	private final int GALLERY = 1;
	private final int CAMERA = 2;
	
	private Bitmap m_bmOCRBitmap;
	private String fileName = "testphoto";
	
	private boolean isMenuVisible = false;
	private int id;
	private boolean isEditing = false;
	private FamilyMember member;
	
	private int screenWidth;
	private int screenHeight;
	
	private String selImagePath;
	private int sampleSize;
	
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.add_family_mem);
		
		Bundle bn = getIntent().getExtras();
		if(bn!=null) {
			if(bn.containsKey(FamilyHealthApplication.FAMILYMEMID)) {
				id = bn.getInt(FamilyHealthApplication.FAMILYMEMID);
				isEditing = true;
			}
		}
		
		LLbot = (LinearLayout) findViewById(R.id.bottom_up);
		pic_i = (ImageView) findViewById(R.id.pic_img);

		take_photo = (Button) findViewById(R.id.take_photo);
		cancel_btn = (Button) findViewById(R.id.cancel_photo);
		choose_photo = (Button) findViewById(R.id.choose_photo);
		cancelTop = (Button) findViewById(R.id.cancelbtn);

		done = (Button) findViewById(R.id.donebtn);
		choose = (Button) findViewById(R.id.choose);
		cancel = (Button) findViewById(R.id.cancels);
		
		f_name = (EditText) findViewById(R.id.edt_fname);
		l_name = (EditText) findViewById(R.id.edt_lname);
		
		mainView = (RelativeLayout) findViewById(R.id.mainview);
		imageMoveView = (RelativeLayout) findViewById(R.id.imageviewscale);
		moveScaleImage = (PhotoSortrView) findViewById(R.id.moveScaleImg);
	
		buttonsbottom = (LinearLayout) findViewById(R.id.buttonsbottom);
		moveScale = (TextView) findViewById(R.id.movescaletxt);
		
		done.setOnClickListener(this);
		choose_photo.setOnClickListener(this);
		cancel_btn.setOnClickListener(this);
		pic_i.setOnClickListener(this);
		take_photo.setOnClickListener(this);
		choose.setOnClickListener(this);
		cancel.setOnClickListener(this);
		cancelTop.setOnClickListener(this);

		AnimationInitialization();
		
		imageMoveView.setVisibility(View.GONE);
		
		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);
		sampleSize = (int)(70*metrics.density);

		
		if(isEditing) {
			Utils.showActivityViewer(AddFamilyMemberActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(AddFamilyMemberActivity.this);
					dbAdapter.open();
					member = dbAdapter.getFamilyMemberById(id);
					dbAdapter.close();
					handler.sendEmptyMessage(1);
				}
			}).start();
		}
		
		DisplayMetrics displaymetrics = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);
        screenHeight = displaymetrics.heightPixels;
        screenWidth = displaymetrics.widthPixels;
        
        fileName = System.currentTimeMillis() + "";
 	}

	public void AnimationInitialization() {
		bottomUpAnimation = AnimationUtils.loadAnimation(this, R.anim.bottom_up);
		bottomDownAnimation = AnimationUtils.loadAnimation(this,R.anim.bottom_down);
	}

	public void showMenu() {
		InputMethodManager mgr = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
		mgr.hideSoftInputFromWindow(f_name.getWindowToken(), 0);
		mgr.hideSoftInputFromWindow(l_name.getWindowToken(), 0);
		LLbot.clearAnimation();
		LLbot.startAnimation(bottomUpAnimation);
		LLbot.setVisibility(View.VISIBLE);
		cancel_btn.setSelected(true);
		isMenuVisible = true;
	}

	public void hideMenu() {
		LLbot.clearAnimation();
		LLbot.startAnimation(bottomDownAnimation);
		LLbot.setVisibility(View.GONE);
		isMenuVisible = false;
	}

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == GALLERY || requestCode == CAMERA) {
			if (resultCode == RESULT_OK) 
			{
				if(requestCode == CAMERA)
				{
					 final File file = getTempFile(this);  
				        try {  
				          selImagePath = file.getAbsolutePath();
				          m_bmOCRBitmap = Media.getBitmap(getContentResolver(), Uri.fromFile(file) );
				          setMoveScaleView();
				        } catch (FileNotFoundException e) {  
				          e.printStackTrace();  
				        } catch (IOException e) {  
				          e.printStackTrace();  
				        }  
				}
				else if(requestCode == GALLERY)
				{
					selImagePath = getPath(data.getData());
					m_bmOCRBitmap = BitmapFactory.decodeFile(selImagePath);
					setMoveScaleView();
				}
			}
		}
	}
	
	private void setMoveScaleView()
	{
		moveScaleImage.setDrawingCacheEnabled(true);
		moveScaleImage.setDrawingCacheBackgroundColor(Color.WHITE);
		imageMoveView.setVisibility(View.VISIBLE);
		mainView.setVisibility(View.GONE);
		moveScaleImage.setImage(m_bmOCRBitmap);
		moveScaleImage.setScale(screenWidth, screenHeight);
		cancel.setSelected(true);
		buttonsbottom.setVisibility(View.VISIBLE);
		moveScale.setVisibility(View.VISIBLE);
		
	}

	public String getPath(Uri uri) {
		String[] projection = { MediaStore.Images.Media.DATA };
		Cursor cursor = managedQuery(uri, projection, null, null, null);
		int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
		cursor.moveToFirst();
		return cursor.getString(column_index);
	}
	
	private DialogInterface.OnClickListener doneClickListener = new DialogInterface.OnClickListener() {
		
		@Override
		public void onClick(DialogInterface dialog, int which) {
			if(which == Dialog.BUTTON1)
			{
				onBackPressed();
			}
		}
	};
	
	private Handler handler = new Handler()
	{

		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			if(msg.what == 0)
			{
				Utils.hideActivityViewer();
				boolean x = Boolean.parseBoolean(msg.obj.toString());
				if(x) {
					Utils.alertDialogShow(AddFamilyMemberActivity.this, getString(R.string.app_name),getString(R.string.addsuccessFamilyMember), doneClickListener);
				} else {
					Utils.alertDialogShow(AddFamilyMemberActivity.this, getString(R.string.app_name), getString(R.string.errInsertFamilyMem));
				}
			}
			if(msg.what == 1)
			{
				if(member != null)
				{
					f_name.setText(member.getFamilyMemFName());
					l_name.setText(member.getFamilyMemLName());
					m_bmOCRBitmap = Utils.getEncryptedImage(member.getFamilyMemImage(), sampleSize);
					if(m_bmOCRBitmap != null) {
						pic_i.setImageBitmap(m_bmOCRBitmap);
						moveScaleImage.setDrawingCacheEnabled(true);
						moveScaleImage.setDrawingCacheBackgroundColor(Color.WHITE);
						moveScaleImage.setImage(m_bmOCRBitmap);
						moveScaleImage.setScale(screenWidth, screenHeight);
					}
				}
				Utils.hideActivityViewer();
			}
			if(msg.what == 2)
			{
				Utils.hideActivityViewer();
				boolean x = Boolean.parseBoolean(msg.obj.toString());
				if(x) {
					Utils.alertDialogShow(AddFamilyMemberActivity.this, getString(R.string.app_name),getString(R.string.updatesuccessFamilyMember), doneClickListener);
				} else {
					Utils.alertDialogShow(AddFamilyMemberActivity.this, getString(R.string.app_name), getString(R.string.errUpdateFamilyMem));
				}
			}
		}
	};
	
	

	@Override
	protected void onPause() {
		super.onPause();
		Utils.clearDialogs();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.donebtn:
			if(!f_name.getText().toString().equals(""))
			{
				if(isEditing) {
					Utils.showActivityViewer(AddFamilyMemberActivity.this, "", true);
					new Thread(new Runnable() {
						
						@Override
						public void run() {
							FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(AddFamilyMemberActivity.this);
							dbAdapter.open();
							String curImage = "";
							boolean x = false;
							if(m_bmOCRBitmap != null && !member.getFamilyMemImage().equals("")) {
								Utils.saveImageFromBitmap(m_bmOCRBitmap, member.getFamilyMemImage());
								x = dbAdapter.updateFamilyMember(new FamilyMember(id, f_name.getText().toString(), l_name.getText().toString(), member.getFamilyMemImage()));
							} else if(m_bmOCRBitmap != null && member.getFamilyMemImage().equals("")) {
								curImage = System.currentTimeMillis() + "";
								Utils.saveImageFromBitmap(m_bmOCRBitmap, curImage);
								x = dbAdapter.updateFamilyMember(new FamilyMember(id, f_name.getText().toString(), l_name.getText().toString(), curImage));
							}
							dbAdapter.close();
							Message msg = new Message();
							msg.what = 2;
							msg.obj = x;
							handler.sendMessage(msg);
						}
					}).start();
				} else {
					Utils.showActivityViewer(AddFamilyMemberActivity.this, "", true);
					new Thread(new Runnable() {
						
						@Override
						public void run() {
							FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(AddFamilyMemberActivity.this);
							dbAdapter.open();
							String curImage ="";
							if(m_bmOCRBitmap != null) {
								moveScaleImage.buildDrawingCache();
								m_bmOCRBitmap = moveScaleImage.getDrawingCache();
								curImage = System.currentTimeMillis() + "";
								Utils.saveImageFromBitmap(m_bmOCRBitmap, curImage);
							}
							boolean x = dbAdapter.addFamilyMember(new FamilyMember(f_name.getText().toString(), l_name.getText().toString(), curImage, dbAdapter.getMaxOrderNumFamilyMember() + 1));
							dbAdapter.close();
							Message msg = new Message();
							msg.what = 0;
							msg.obj = x;
							handler.sendMessage(msg);
						}
					}).start();
				}
			} else {
				Utils.alertDialogShow(AddFamilyMemberActivity.this, getString(R.string.app_name), getString(R.string.validateinsertfamilymember));
			}
			break;
		case R.id.choose_photo:
			Intent intent = new Intent(Intent.ACTION_PICK, Media.EXTERNAL_CONTENT_URI);
			startActivityForResult(intent, GALLERY);
			break;
		case R.id.cancel_photo:
			hideMenu();
			break;
		case R.id.pic_img:
			showMenu();
			break;
		case R.id.take_photo:
			Intent takePhotointent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);  
			takePhotointent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(getTempFile(AddFamilyMemberActivity.this)) );   
			startActivityForResult(takePhotointent, CAMERA);  
			break;
		case R.id.choose:
			mainView.setVisibility(View.VISIBLE);
			imageMoveView.setVisibility(View.GONE);
			buttonsbottom.setVisibility(View.GONE);
			moveScale.setVisibility(View.GONE);
			moveScaleImage.setDrawingCacheEnabled(true);
			moveScaleImage.buildDrawingCache();
			m_bmOCRBitmap = moveScaleImage.getDrawingCache();
			pic_i.setImageBitmap(m_bmOCRBitmap);
			hideMenu();
			break;
		case R.id.cancels:
			mainView.setVisibility(View.VISIBLE);
			imageMoveView.setVisibility(View.GONE);
			hideMenu();
			break;
		case R.id.cancelbtn:
			onBackPressed();
			break;
		}
	}
	
	private File getTempFile(Context context){  
		File f = new File(Environment.getExternalStorageDirectory(), fileName);
	  return f;  
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
		if(isMenuVisible) {
			hideMenu();
		} else {
			finish();
		}
	}
	
	
}
