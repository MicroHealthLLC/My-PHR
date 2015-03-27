package com.micro.health.family.health.record;

import java.util.ArrayList;
import java.util.Collections;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.DisplayMetrics;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnLongClickListener;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.micro.health.family.health.record.dragdropfamily.DragController;
import com.micro.health.family.health.record.dragdropfamily.DragLayer;
import com.micro.health.family.health.record.dragdropfamily.DragSource;
import com.micro.health.family.health.record.dragdropfamily.FamilyMemberAdapter;
import com.micro.health.family.health.record.dto.FamilyMember;
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

public class MyFamilyActivity extends Activity implements OnClickListener, OnLongClickListener {
	
	private RelativeLayout emptyLL;
	private LinearLayout bottom;
	private Button edit;
	private ImageButton add;
	private ImageView settings;
	private GridView gridFamilyMembers;
	
	public static ArrayList<FamilyMember> mem_data = new ArrayList<FamilyMember>();
	public static FamilyMemberAdapter familyMemberAdapter;
	
	public static boolean isEdit = false;
	
	private int sampleSize;
	
	private DragController mDragController;   
	private DragLayer mDragLayer;             
	
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.myfamily);
		
		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);
		sampleSize = (int)(22*metrics.density);

		gridFamilyMembers = (GridView) findViewById(R.id.gridfamily);
		emptyLL = (RelativeLayout) findViewById(R.id.emptyll);
		edit = (Button) findViewById(R.id.edit_modulebtn);
		add = (ImageButton) findViewById(R.id.add_module_btn);
		settings = (ImageView) findViewById(R.id.settings);
		bottom = (LinearLayout) findViewById(R.id.bottom);
		
		add.setOnClickListener(this);
		edit.setOnClickListener(this);
		settings.setOnClickListener(this);
		
		mDragController = new DragController(this);
	    mDragLayer = (DragLayer) findViewById(R.id.drag_layer);
	    mDragLayer.setDragController(mDragController);
	    mDragLayer.setGridView(gridFamilyMembers);

	    mDragController.setDragListener(mDragLayer);
	    emptyLL.setVisibility(View.GONE);
	}
	
	@Override
	protected void onResume() {
		super.onResume();
		Utils.showActivityViewer(MyFamilyActivity.this, "", true);
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(MyFamilyActivity.this);
				dbAdapter.open();
				mem_data = dbAdapter.getAllFamilyMembers();
				Collections.sort(mem_data);
				dbAdapter.close();
				handler.sendEmptyMessage(0);
			}
		}).start();
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
			if(msg.what == 0) {
				if(mem_data.size() > 0) {
					gridFamilyMembers.setVisibility(View.VISIBLE);
					emptyLL.setVisibility(View.GONE);
					familyMemberAdapter = new FamilyMemberAdapter(MyFamilyActivity.this, mem_data, sampleSize);
					gridFamilyMembers.setAdapter(familyMemberAdapter);
				} else {
					gridFamilyMembers.setVisibility(View.GONE);
					emptyLL.setVisibility(View.VISIBLE);
				}
				Utils.hideActivityViewer();
			}
		}
		
	};

	@Override
	public void onClick(View v) {
		switch(v.getId())
		{
			case R.id.edit_modulebtn:
				editClicked();
				break;
			case R.id.add_module_btn:
				Intent addIntent = new Intent(MyFamilyActivity.this, AddFamilyMemberActivity.class);
				startActivity(addIntent);
				break;
			case R.id.settings:
				Intent settingsIntent = new Intent(MyFamilyActivity.this, SettingsActivity.class);
				startActivity(settingsIntent);
				break;
		}
	}
	
	private void editClicked()
	{
		isEdit = !isEdit;
		if(isEdit) {
			edit.setText(getString(R.string.done));
			if(mem_data.size() > 0) {
				familyMemberAdapter.notifyDataSetChanged();
			}
			add.setVisibility(View.GONE);
			settings.setEnabled(false);
			bottom.setBackgroundColor(Color.argb(200, 0, 0, 0));
			gridFamilyMembers.setBackgroundColor(Color.argb(200, 0, 0, 0));
		} else {
			edit.setText(getString(R.string.edit));
			if(mem_data.size() > 0) {
				familyMemberAdapter.notifyDataSetChanged();
			}
			add.setVisibility(View.VISIBLE);
			settings.setEnabled(true);
			bottom.setBackgroundColor(Color.argb(0, 0, 0, 0));
			gridFamilyMembers.setBackgroundColor(Color.argb(0, 0, 0, 0));
		}  
	}
	
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (!(android.os.Build.VERSION.SDK_INT > android.os.Build.VERSION_CODES.DONUT) && keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
			onBackPressed();
		}
		return super.onKeyDown(keyCode, event);
	}

	public void onBackPressed() {
		if(isEdit) {
			editClicked();
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
