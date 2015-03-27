package com.micro.health.family.health.record;

import java.io.File;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
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
import android.view.View.OnLongClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.micro.health.family.health.record.dragdropfamily.DragController;
import com.micro.health.family.health.record.dragdropfamily.DragLayer;
import com.micro.health.family.health.record.dragdropfamily.DragSource;
import com.micro.health.family.health.record.dragdropfamily.MedicalHistoryAdapter;
import com.micro.health.family.health.record.dto.FamilyMember;
import com.micro.health.family.health.record.dto.MedicalHistory;
import com.micro.health.family.health.record.dto.ModuleData;
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

public class ModuleDetailsActivity extends Activity implements OnClickListener, OnLongClickListener {
	
	private Button edit, back;
	private LinearLayout LLbot;
	private LinearLayout addPhotoLL;
	private LinearLayout addTextLL;
	private LinearLayout addAudioLL;
	private LinearLayout addFileLL;
	private LinearLayout addVideoLL;
	private LinearLayout addDrawingLL;
	private TextView user_name;
	private Button takephoto_det, choosephoto_det, cancel_photo;
	private ImageView userImg;
	private GridView grdItems;
	private LinearLayout bottom;
	private TextView moduleName;
	private LinearLayout familyClick;
	
	private String fileName = "testphoto";
	
	
	private DragController mDragController;  
	private DragLayer mDragLayer;           
	
	private Animation bottomUpAnimation, bottomDownAnimation;
	protected String _path;
	
	public static ArrayList<MedicalHistory> medicalHistoryData = new ArrayList<MedicalHistory>();
	public static MedicalHistoryAdapter medicalHistoryAdapter;
	
	public static ModuleData currentModule;
	private FamilyMember member;

	public static boolean isEdit = false;
	private boolean isMenuVisible;
	
	private int selImageType;
	private String selImagePath;  
	
	private int sampleSize;
	public static int sampleSizeImg;
	
	private boolean fromActivityResult = false;
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.moduledetails);
		
		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);
		sampleSize = (int)(22*metrics.density);
		sampleSizeImg = (int)(75*metrics.density);

		if (getIntent().getExtras() != null) {
			if (getIntent().getExtras().containsKey(FamilyHealthApplication.MODULE)) {
				currentModule = (ModuleData) getIntent().getExtras().get(FamilyHealthApplication.MODULE);
			}
		}

		LLbot = (LinearLayout) findViewById(R.id.bottom_up_detailpage);
		addPhotoLL = (LinearLayout) findViewById(R.id.add_photo);
		addTextLL = (LinearLayout) findViewById(R.id.add_text);
		addAudioLL = (LinearLayout) findViewById(R.id.add_audio);
		addFileLL = (LinearLayout) findViewById(R.id.add_file);
		addVideoLL = (LinearLayout) findViewById(R.id.add_video);
		addDrawingLL = (LinearLayout) findViewById(R.id.add_drawing);
		
		takephoto_det = (Button) findViewById(R.id.take_photo_detail);
		choosephoto_det = (Button) findViewById(R.id.choose_photo_detail);
		cancel_photo = (Button) findViewById(R.id.cancel_photo_detail);

		edit = (Button) findViewById(R.id.edit_module_detail);
		back = (Button) findViewById(R.id.backbtn_module_detail);

		user_name = (TextView) findViewById(R.id.username_txt);
		userImg = (ImageView) findViewById(R.id.userImg);
		grdItems = (GridView) findViewById(R.id.gridmoduleitems);
		bottom = (LinearLayout) findViewById(R.id.bottom);
		moduleName = (TextView) findViewById(R.id.moduleName);
		familyClick = (LinearLayout) findViewById(R.id.familyclick);
		familyClick.setOnClickListener(this);

		addTextLL.setOnClickListener(this);
		addPhotoLL.setOnClickListener(this);
		addAudioLL.setOnClickListener(this);
		addFileLL.setOnClickListener(this);
		addVideoLL.setOnClickListener(this);
		addDrawingLL.setOnClickListener(this);
		
		cancel_photo.setOnClickListener(this);
		choosephoto_det.setOnClickListener(this);
		takephoto_det.setOnClickListener(this);

		edit.setOnClickListener(this);
		back.setOnClickListener(this);
		
		cancel_photo.setSelected(true);

		member = FamilyHealthApplication.getFamilymember();
		if (member == null) {
			onBackPressed();
		} else {
			user_name.setText(member.getFamilyMemFName());
			userImg.setImageBitmap(Utils.getEncryptedImage(member.getFamilyMemImage(), sampleSize));
		}
		
		moduleName.setText(currentModule.getName());

		_path = Environment.getExternalStorageDirectory() + "/images/" + Calendar.getInstance().getTimeInMillis();
		AnimationInitialization();
		
		mDragController = new DragController(this);
	    mDragLayer = (DragLayer) findViewById(R.id.drag_layer);
	    mDragLayer.setDragController(mDragController);
	    mDragLayer.setGridView(grdItems);

	    mDragController.setDragListener(mDragLayer);
	    
	    
        fileName = System.currentTimeMillis() + "";
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		if(!fromActivityResult) {
			Utils.showActivityViewer(ModuleDetailsActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(ModuleDetailsActivity.this);
					dbAdapter.open();
					medicalHistoryData = dbAdapter.getMedicalHistoryList(FamilyHealthApplication.getFamilymember().getFamilyMemid(), currentModule.getId());
					Collections.sort(medicalHistoryData);
					dbAdapter.close();  
					Message msg = new Message();
					msg.what = 5;
					handler.sendMessage(msg);
				}
			}).start();
		} else {
			fromActivityResult = false;
		}
			
	}
	
	@Override
	protected void onPause() {
		super.onPause();
		Utils.clearDialogs();
	}



	private Handler handler = new Handler()
	{
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			if(msg.what == 5) {
				if(medicalHistoryData.size() > 0) {
					grdItems.setVisibility(View.VISIBLE);
					medicalHistoryAdapter = new MedicalHistoryAdapter(ModuleDetailsActivity.this, medicalHistoryData, sampleSizeImg);
					grdItems.setAdapter(medicalHistoryAdapter);
				}
				Utils.hideActivityViewer();
			}
			if(msg.what == 1) {
				if(Boolean.parseBoolean(msg.obj.toString())) {
					medicalHistoryAdapter.notifyDataSetChanged();
				} else {
					Utils.alertDialogShow(ModuleDetailsActivity.this, getString(R.string.app_name), getString(R.string.moduleitemnotdeleted));
				}
				Utils.hideActivityViewer();
			}
			if(msg.what == 2) {
				if(Boolean.parseBoolean(msg.obj.toString())) {
					medicalHistoryAdapter.notifyDataSetChanged();
				} else {
					Utils.alertDialogShow(ModuleDetailsActivity.this, getString(R.string.app_name), getString(R.string.moduleitemnotarchived));
				}
				Utils.hideActivityViewer();
			}
		}
		
	};

	public void onClick(View v) {
		switch (v.getId()) {
			case R.id.familyclick:
				Intent in = new Intent(ModuleDetailsActivity.this, MyFamilyActivity.class);
				in.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
				startActivity(in);
				break;
			case R.id.add_photo:
				showMenu();
				break;
			case R.id.cancel_photo_detail:
				hideMenu();
				break;
			case R.id.choose_photo_detail:
				hideMenu();
				Intent intent = new Intent(Intent.ACTION_PICK, Media.EXTERNAL_CONTENT_URI);
				startActivityForResult(intent, FamilyHealthApplication.GALLERY);
				break;
			case R.id.take_photo_detail:
				hideMenu();
				Intent takePhotointent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
				takePhotointent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(getTempFile(ModuleDetailsActivity.this)) );
				startActivityForResult(takePhotointent, FamilyHealthApplication.CAMERA);
				break;
			case R.id.add_text:
				Intent adTextIntent = new Intent(ModuleDetailsActivity.this, AddTextActivity.class);
				adTextIntent.putExtra(FamilyHealthApplication.MODULE,currentModule);
				startActivity(adTextIntent);
				break;
			case R.id.add_audio:
				Intent adAudioIntent = new Intent(ModuleDetailsActivity.this, AddAudioActivity.class);
				adAudioIntent.putExtra(FamilyHealthApplication.MODULE,currentModule);
				startActivity(adAudioIntent);
				break;
			case R.id.edit_module_detail:
				if(medicalHistoryData.size() > 0) {
					editClicked();
				}
				break;
			case R.id.backbtn_module_detail:
				onBackPressed();
				break;
			case R.id.add_file:
				Intent intent1 = new Intent(getBaseContext(), FileDialog.class);
				intent1.putExtra(FileDialog.START_PATH, Environment.getExternalStorageDirectory().getAbsolutePath());
				intent1.putExtra(FileDialog.CAN_SELECT_DIR, false);
               // intent1.putExtra(FileDialog.FORMAT_FILTER, new String[] {"txt","doc", "pdf", "docx", "xlsx", "pptx","xls","ppt", "gif", "jpg", "png",  "wav", "mp3", "rtf", "pps", "zip", "rar"});
                startActivityForResult(intent1, FamilyHealthApplication.IFILE);
				break;
			case R.id.add_video:
				Intent adVideoIntent = new Intent(ModuleDetailsActivity.this, AddVideoActivity.class);
				adVideoIntent.putExtra(FamilyHealthApplication.MODULE,currentModule);
				startActivity(adVideoIntent);
				break;
			case R.id.add_drawing:
				Intent adDrawingIntent = new Intent(ModuleDetailsActivity.this, AddDrawingActivity.class);
				adDrawingIntent.putExtra(FamilyHealthApplication.MODULE,currentModule);
				startActivity(adDrawingIntent);
				break;
		}
	}
	
	private File getTempFile(Context context){  
		File f = new File(Environment.getExternalStorageDirectory(), fileName);
	  return f;  
	}
	
	private void editClicked()
	{
		isEdit = !isEdit;
		if(isEdit) {
			edit.setText(getString(R.string.done));
			medicalHistoryAdapter.notifyDataSetChanged();
			bottom.setBackgroundColor(Color.argb(200, 0, 0, 0));
			bottom.setEnabled(false);
			grdItems.setBackgroundColor(Color.argb(200, 0, 0, 0));
			back.setVisibility(View.GONE);
			addTextLL.setEnabled(false);
			addAudioLL.setEnabled(false);
			addPhotoLL.setEnabled(false);
		} else {
			edit.setText(getString(R.string.edit));
			medicalHistoryAdapter.notifyDataSetChanged();
			bottom.setBackgroundResource(R.drawable.bottom);
			grdItems.setBackgroundColor(Color.argb(0, 0, 0, 0));
			bottom.setEnabled(true);
			back.setVisibility(View.VISIBLE);
			addTextLL.setEnabled(true);
			addAudioLL.setEnabled(true);
			addPhotoLL.setEnabled(true);
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
		isMenuVisible = true;
	}

	public void hideMenu() {
		LLbot.clearAnimation();
		LLbot.startAnimation(bottomDownAnimation);
		LLbot.setVisibility(View.GONE);
		isMenuVisible = false;
	}

	protected void startCameraActivity() {
		File file = new File(_path);
		Uri outputFileUri = Uri.fromFile(file);
		Intent intent = new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
		intent.putExtra(MediaStore.EXTRA_OUTPUT, outputFileUri);
		startActivityForResult(intent, 0);
	}

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == FamilyHealthApplication.GALLERY || requestCode == FamilyHealthApplication.CAMERA) {
			fromActivityResult = true;
			if (resultCode == RESULT_OK) {
				if (requestCode == FamilyHealthApplication.CAMERA) {
					selImageType = FamilyHealthApplication.CAMERA;
					final File file = getTempFile(this);  
					selImagePath = file.getAbsolutePath();
					goToImageTitleActivity();
				} else if (requestCode == FamilyHealthApplication.GALLERY) {
					selImageType = FamilyHealthApplication.GALLERY;
					selImagePath = getPath(data.getData());
					goToImageTitleActivity();
				}
			}
		}
		else if (requestCode == FamilyHealthApplication.IFILE) {
			fromActivityResult = true;
			if (resultCode == RESULT_OK) {
				selImagePath = data.getStringExtra(FileDialog.RESULT_PATH);
				Intent in = new Intent(ModuleDetailsActivity.this, AddFileActivity.class);
				in.putExtra(FamilyHealthApplication.SELBITMAP, selImagePath);
				in.putExtra(FamilyHealthApplication.MODULE,currentModule);
				startActivity(in);
			}
		}
	}
	
	private void goToImageTitleActivity() {
		Intent in = new Intent(ModuleDetailsActivity.this, AddImageActivity.class);
		in.putExtra(FamilyHealthApplication.SELBITMAP, selImagePath);
		in.putExtra(FamilyHealthApplication.SELBITMAPTYPE, selImageType);
		in.putExtra(FamilyHealthApplication.MODULE,currentModule);
		startActivity(in);
	}
	
	public String getPath(Uri uri) {
		String[] projection = { MediaStore.Images.Media.DATA };
		Cursor cursor = managedQuery(uri, projection, null, null, null);
		if (cursor != null) {
			// HERE YOU WILL GET A NULLPOINTER IF CURSOR IS NULL
			// THIS CAN BE, IF YOU USED OI FILE MANAGER FOR PICKING THE MEDIA
			int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
			cursor.moveToFirst();
			return cursor.getString(column_index);
		} else
			return null;
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
	
	@Override
	public boolean onLongClick(View v) {
		if (!v.isInTouchMode() || isEdit) {
			return false;
		} else {
			return startDrag (v);
		}
	}
	
	public boolean startDrag(View v)
	{
	    DragSource dragSource = (DragSource) v;
	    mDragController.startDrag (v, dragSource, dragSource, DragController.DRAG_ACTION_MOVE);
	    return true;
	}
	
}
