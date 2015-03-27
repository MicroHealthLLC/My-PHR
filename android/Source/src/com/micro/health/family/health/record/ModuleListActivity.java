package com.micro.health.family.health.record;

import java.util.ArrayList;
import java.util.Collections;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.micro.health.family.health.record.dto.FamilyMember;
import com.micro.health.family.health.record.dto.ModuleData;
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

public class ModuleListActivity extends ListActivity implements View.OnClickListener {
	private static final String TAG = ModuleListActivity.class.getCanonicalName();
	private ArrayList<ModuleData> moduleListEnabled = new ArrayList<ModuleData>();
	private ArrayList<ModuleData> moduleListDisabled = new ArrayList<ModuleData>();
	private DDListView moduleListView;
	
	private Button edit_btn;
	private ImageButton add_btn;
	private Button back;
	private TextView userName;
	private ImageView userImg;
	private ImageView userImgBack;
	private TextView subheader;
	
	private boolean isEdit = false;
	private boolean isAdd = false;
	
	private FamilyMember member;
	
	private ModuleListAdapter moduleListAdapter;
	private boolean isEnabled = true;
	
	private int sampleSize;
	
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.modulelist);
		
		DisplayMetrics metrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(metrics);
		sampleSize = (int)(22*metrics.density);


		moduleListView = (DDListView)getListView();
		
		edit_btn = (Button) findViewById(R.id.edit_modulebtn);
		add_btn = (ImageButton) findViewById(R.id.add_module_btn);
		back = (Button) findViewById(R.id.backbtn);
		
		userName = (TextView) findViewById(R.id.header);
		subheader = (TextView) findViewById(R.id.subheader);
		userImg = (ImageView) findViewById(R.id.userImg);
		userImgBack = (ImageView) findViewById(R.id.userimgback);
		
		edit_btn.setOnClickListener(this);
		add_btn.setOnClickListener(this);
		back.setOnClickListener(this);
		
		add_btn.setVisibility(View.GONE);
		moduleListView.setOnCreateContextMenuListener(this);
		((DDListView) moduleListView).setDropListener(mDropListener);
		
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(ModuleListActivity.this);
				dbAdapter.open();
				ArrayList<ModuleData> moduleListAll = dbAdapter.getModuleList(1);
				dbAdapter.close();
				
				for(int i =0;i<moduleListAll.size();i++)
				{
					if(moduleListAll.get(i).getEnable()) {
						moduleListEnabled.add(moduleListAll.get(i));
					} else {
						moduleListDisabled.add(moduleListAll.get(i));
					}
				}
				Collections.sort(moduleListEnabled);
				Collections.sort(moduleListDisabled);
				handler.sendEmptyMessage(0);
			}
		}).start();
		
		member = FamilyHealthApplication.getFamilymember();
		if(member == null) {
			onBackPressed();
		} else {
			userName.setText(member.getFamilyMemFName());
			userImg.setImageBitmap(Utils.getEncryptedImage(member.getFamilyMemImage(), sampleSize));
		}
	}
	
	private Handler handler = new Handler(){

		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			if(msg.what == 0) {
				if(moduleListEnabled.size() > 0) {
					moduleListAdapter = new ModuleListAdapter(ModuleListActivity.this, R.layout.modulelistitem, moduleListEnabled);
					moduleListView.setAdapter(moduleListAdapter);
				}
				Utils.hideActivityViewer();
			}
		}
		
	};
	
	

	@Override
	protected void onPause() {
		super.onPause();
		Utils.clearDialogs();
	}

	private class ModuleListAdapter extends ArrayAdapter<ModuleData> {
		TextView moduleName;
		ImageView arrow;
		ImageView minus;
		ImageView reorder;
		ImageView plus;
		RelativeLayout rl;
		
		public ModuleListAdapter(Context context, int textViewResourceId,
				ArrayList<ModuleData> dList) {
			super(context, textViewResourceId, dList);
		}

		@Override
		public View getView(final int position, View convertView, ViewGroup parent) {
			View view = convertView;
			try {
				LayoutInflater vi = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
				view = vi.inflate(R.layout.modulelistitem, null); // --CloneChangeRequired(list_item)

				moduleName = (TextView) view.findViewById(R.id.text_moduledata);
				arrow = (ImageView) view.findViewById(R.id.arrow);
				minus = (ImageView) view.findViewById(R.id.minus);
				plus = (ImageView) view.findViewById(R.id.plus);
				reorder = (ImageView) view.findViewById(R.id.reorder);
				rl = (RelativeLayout) view.findViewById(R.id.re_module);
				
				if(isEdit) {
					minus.setVisibility(View.VISIBLE);
					reorder.setVisibility(View.VISIBLE);
					arrow.setVisibility(View.GONE);
					plus.setVisibility(View.GONE);
				} else if(isAdd){
					minus.setVisibility(View.GONE);
					reorder.setVisibility(View.GONE);
					arrow.setVisibility(View.GONE);
					plus.setVisibility(View.VISIBLE);
				} else {
					minus.setVisibility(View.GONE);
					reorder.setVisibility(View.GONE);
					plus.setVisibility(View.GONE);
					arrow.setVisibility(View.VISIBLE);
				}
				
				minus.setOnClickListener(new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(ModuleListActivity.this);
						dbAdapter.open();
						boolean x = dbAdapter.updateModule(moduleListEnabled.get(position).getId(),0);
						if(x) {
							moduleListDisabled.add(moduleListEnabled.get(position));
							moduleListEnabled.remove(position);
							Collections.sort(moduleListEnabled);
							Collections.sort(moduleListDisabled);
							moduleListAdapter.notifyDataSetChanged();
						}
						dbAdapter.close();
					}
				});
				plus.setOnClickListener(new View.OnClickListener() {
					
					@Override
					public void onClick(View v) {
						FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(ModuleListActivity.this);
						dbAdapter.open();
						boolean x = dbAdapter.updateModule(moduleListDisabled.get(position).getId(),1);
						if(x) {
							moduleListEnabled.add(moduleListDisabled.get(position));
							moduleListDisabled.remove(position);
							Collections.sort(moduleListEnabled);
							Collections.sort(moduleListDisabled);
							moduleListAdapter.notifyDataSetChanged();
						}
						dbAdapter.close();
					}
				});
				if(!isAdd && !isEdit){
						
					rl.setOnClickListener(new View.OnClickListener() {
						
						@Override
						public void onClick(View v) {
								Intent i = new Intent(ModuleListActivity.this , ModuleDetailsActivity.class);
								i.putExtra(FamilyHealthApplication.MODULE, moduleListEnabled.get(position));
								startActivity(i);
						}
					});
				}
				
				arrow.setOnClickListener(new View.OnClickListener() {
					
					@Override
					public void onClick(View v) {
					    Intent i = new Intent(ModuleListActivity.this , ModuleDetailsActivity.class);
						i.putExtra(FamilyHealthApplication.MODULE, moduleListEnabled.get(position));
						startActivity(i);
					}
				});
				
				if(isEnabled) {
					moduleName.setText(moduleListEnabled.get(position).getName());
				} else {
					moduleName.setText(moduleListDisabled.get(position).getName());
				}
			} catch (Exception e) {
				Log.v(TAG, e.toString());
			}
			return view;
		}
	}

	// Drop Listener
	private DDListView.DropListener mDropListener = new DDListView.DropListener() {
		public void drop(int from, int to) {
			FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(ModuleListActivity.this);
			dbAdapter.open();
			if (from < to) { // for up to down
				for (int i=from+1; i<=to; i++) {
					boolean x = dbAdapter.updateModuleOrder(moduleListEnabled.get(i).getId(), i-1);
					if(x) {
						moduleListEnabled.get(i).setOrder(i-1);
					}
				}
			} else if (from > to) { // for down to up
				for (int j = to; j>=from-1; j++) {
					boolean x = dbAdapter.updateModuleOrder(moduleListEnabled.get(j).getId(), j+1);
					if(x) {
						moduleListEnabled.get(j).setOrder(j+1);
					}
				}
			}
			boolean x = dbAdapter.updateModuleOrder(moduleListEnabled.get(from).getId(), to);
			if(x) {
				moduleListEnabled.get(from).setOrder(to);
			}
			dbAdapter.close();
			Collections.sort(moduleListEnabled);
			moduleListAdapter.notifyDataSetChanged();
		}
	};

	@Override
	public void onClick(View v) {
		switch(v.getId()){
		case R.id.edit_modulebtn:
			if(moduleListEnabled.size() > 0) {
				editClicked();
			}
			break;
		case R.id.add_module_btn:
			editClicked();
			isEnabled = false;
			moduleListAdapter = new ModuleListAdapter(ModuleListActivity.this, R.layout.modulelistitem, moduleListDisabled);
			moduleListView.setAdapter(moduleListAdapter);
			isAdd = true;
			edit_btn.setVisibility(View.GONE);
			back.setVisibility(View.VISIBLE);
			moduleListAdapter.notifyDataSetChanged();
			add_btn.setVisibility(View.INVISIBLE);
			userName.setText(getString(R.string.modules));
			subheader.setText(getString(R.string.chooseamodule));
			userImg.setVisibility(View.GONE);
			userImgBack.setVisibility(View.GONE);
			break;
		case R.id.backbtn:
			if(isAdd) {
				backClicked();
			} else { 
				onBackPressed();
			}
			break;
		}
	}
	
	
	private void backClicked()
	{
		isEnabled = true;
		moduleListAdapter = new ModuleListAdapter(ModuleListActivity.this, R.layout.modulelistitem, moduleListEnabled);
		moduleListView.setAdapter(moduleListAdapter);
		isAdd = false;
		edit_btn.setVisibility(View.VISIBLE);
		back.setVisibility(View.VISIBLE);
		moduleListAdapter.notifyDataSetChanged();
		add_btn.setVisibility(View.GONE);
		userName.setText(member.getFamilyMemFName());
		subheader.setText(getString(R.string.medicalhistory));
		userImg.setVisibility(View.VISIBLE);
		userImgBack.setVisibility(View.VISIBLE);
	}
	
	private void editClicked()
	{
		isEdit = !isEdit;
		if(isEdit) {
			moduleListView.setOrderable(true);
			edit_btn.setText(getString(R.string.done));
			moduleListAdapter.notifyDataSetChanged();
			add_btn.setVisibility(View.VISIBLE);
			back.setVisibility(View.GONE);
		} else {
			moduleListView.setOrderable(false);
			edit_btn.setText(getString(R.string.edit));
			moduleListAdapter.notifyDataSetChanged();
			add_btn.setVisibility(View.GONE);
			back.setVisibility(View.VISIBLE);
		}
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
		if(isEdit) {
			editClicked();
		} else if(isAdd) {
			backClicked();
		} else {
			Intent in = new Intent(ModuleListActivity.this, MyFamilyActivity.class);
			in.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			startActivity(in);
		}
	}

}