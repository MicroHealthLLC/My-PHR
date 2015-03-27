package com.micro.health.family.health.record;

import java.io.File;
import java.util.Date;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.text.Html;
import android.util.DisplayMetrics;
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
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

public class AddTextActivity extends Activity implements View.OnClickListener {
	private EditText title;
	private EditText txtData;
	private FamilyMember member;
	private TextView userName;
	private ImageView userImg;
	private Button done;
	private Button back;
	private LinearLayout familyClick;
	
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
	
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.addtext);
		
		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);
		sampleSize = (int)(22*metrics.density);


		if (getIntent().getExtras() != null) {
			if (getIntent().getExtras().containsKey(FamilyHealthApplication.MODULE)) {
				currentModule = (ModuleData) getIntent().getExtras().get(FamilyHealthApplication.MODULE);
			}
			if (getIntent().getExtras().containsKey(FamilyHealthApplication.MEDICALHISTORYOBJ)) {
				isEdit = true;
				md =  ((MedicalHistory)getIntent().getExtras().get(FamilyHealthApplication.MEDICALHISTORYOBJ));
			}
		}

		title = (EditText) findViewById(R.id.title);
		txtData = (EditText) findViewById(R.id.txtdata);
		done = (Button) findViewById(R.id.done);
		userName = (TextView) findViewById(R.id.username_txt);
		userImg = (ImageView) findViewById(R.id.userImg);
		
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
		forward.setOnClickListener(this);
		delete.setOnClickListener(this);
		email.setOnClickListener(this);
		message.setOnClickListener(this);
		removenottaking.setOnClickListener(this);
		cancelDialog.setOnClickListener(this);
		
		member = FamilyHealthApplication.getFamilymember();
		if (member == null) {
			onBackPressed();
		} else {
			userName.setText(member.getFamilyMemFName());
			userImg.setImageBitmap(Utils.getEncryptedImage(member.getFamilyMemImage(), sampleSize));
		}
		
		if(isEdit) {
			txtData.setText(Utils.getEncryptedText(md.getData()));
			title.setText(md.getTitle());
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
			Intent in = new Intent(AddTextActivity.this, MyFamilyActivity.class);
			in.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(in);
			break;
		case R.id.done:
			if(txtData.getText().toString().length() > 0) {
				Utils.showActivityViewer(AddTextActivity.this, "", true);
				new Thread(new Runnable() {
					
					@Override
					public void run() {
						if(!isEdit) {
							String d = new Date().toString();
							FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(AddTextActivity.this);
							dbAdapter.open();
							MedicalHistory m = new MedicalHistory();
							m.setFamilyId(member.getFamilyMemid());
							String xt = txtData.getText().toString();
							String curImage = System.currentTimeMillis() + "";
							Utils.saveTextFromString(curImage, xt);
							m.setData(curImage);
							m.setModuleId(currentModule.getId());
							m.setMedicaldatatypeId(FamilyHealthApplication.TEXT);
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
							FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(AddTextActivity.this);
							dbAdapter.open();
							md.setModifyDate(d);
							Utils.saveTextFromString(md.getData(), txtData.getText().toString());
							boolean x = dbAdapter.updateMedicalHistory(md.getId(), title.getText().toString(), md.getModifyDate());
							dbAdapter.close();
							Message msg = new Message();
							msg.what = 1;
							msg.obj = x;
							handler.sendMessage(msg);
						}
					}
				}).start();
			} else {
				Utils.alertDialogShow(AddTextActivity.this, getString(R.string.app_name), getString(R.string.pleaseentertext));
			}
			break;
		case R.id.cancels:
			title.setText("");
			break;
		case R.id.forward:
			showMenu();
			break;
		case R.id.delete:
			Utils.showActivityViewer(AddTextActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter =new FamilyHealthDBAdapter(AddTextActivity.this);
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
			File f = new File(Environment.getExternalStorageDirectory(), System.currentTimeMillis() + ".txt");
			Utils.getDataForEmailMessageFromFile(new File(FamilyHealthApplication.PATH, md.getData()), f);
			Intent emailIntent = new Intent(Intent.ACTION_SEND);
			emailIntent.putExtra(Intent.EXTRA_CC, "");
			emailIntent.putExtra(Intent.EXTRA_BCC, "");
			emailIntent.putExtra(Intent.EXTRA_SUBJECT,getString(R.string.app_name));
			emailIntent.putExtra(Intent.EXTRA_TEXT,Html.fromHtml(currentModule.getName() + " for " + member.getFamilyMemFName() + " - " + md.getTitle()));
			emailIntent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(f));
			emailIntent.setType("text/plain");
			startActivityForResult(emailIntent, 0);
			break;
		case R.id.message:
			hideMenu();
			File f1 = new File(Environment.getExternalStorageDirectory(), System.currentTimeMillis() + ".txt");
			Utils.getDataForEmailMessageFromFile(new File(FamilyHealthApplication.PATH, md.getData()), f1);
			Intent messageIntent = new Intent(Intent.ACTION_SEND);
			messageIntent.putExtra("sms_body",getString(R.string.app_name) + "\n" +currentModule.getName() + " for " + member.getFamilyMemFName() + " - " + md.getTitle());
			messageIntent.putExtra(Intent.EXTRA_STREAM, Uri.fromFile(f1));
			messageIntent.setType("text/plain");
			startActivityForResult(messageIntent, 0);
			break; 
		case R.id.rnottaking:
			hideMenu();
			Utils.showActivityViewer(AddTextActivity.this, "", true);
			new Thread(new Runnable() {
				
				@Override
				public void run() {
					FamilyHealthDBAdapter dbAdapter =new FamilyHealthDBAdapter(AddTextActivity.this);
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
			if(msg.what == 0) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					Utils.alertDialogShow(AddTextActivity.this, getString(R.string.app_name), getString(R.string.textadded), new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else{ 
					Utils.alertDialogShow(AddTextActivity.this, getString(R.string.app_name), getString(R.string.textnotadded));	
				}
			}
			
			if(msg.what == 1) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					Utils.alertDialogShow(AddTextActivity.this, getString(R.string.app_name), getString(R.string.textupdated), new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else{ 
					Utils.alertDialogShow(AddTextActivity.this, getString(R.string.app_name), getString(R.string.textnotupdated));	
				}
			}
			if(msg.what == 2) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					Utils.alertDialogShow(AddTextActivity.this, getString(R.string.app_name), getString(R.string.moduleitemdeleted), new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else {
					Utils.alertDialogShow(AddTextActivity.this, getString(R.string.app_name), getString(R.string.moduleitemnotdeleted));
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
					
					Utils.alertDialogShow(AddTextActivity.this, getString(R.string.app_name), arch, new DialogInterface.OnClickListener(){

						@Override
						public void onClick(DialogInterface dialog, int which) {
							dialog.dismiss();
							dialog.cancel();
							finish();
						}});
				} else {
					Utils.alertDialogShow(AddTextActivity.this, getString(R.string.app_name), getString(R.string.moduleitemnotarchived));
				}
			}
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

}
