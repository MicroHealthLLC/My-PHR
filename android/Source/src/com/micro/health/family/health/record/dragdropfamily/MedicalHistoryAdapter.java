package com.micro.health.family.health.record.dragdropfamily;

import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.GridView;

import com.micro.health.family.health.record.AddAudioActivity;
import com.micro.health.family.health.record.AddDrawingActivity;
import com.micro.health.family.health.record.AddFileActivity;
import com.micro.health.family.health.record.AddImageActivity;
import com.micro.health.family.health.record.AddTextActivity;
import com.micro.health.family.health.record.AddVideoActivity;
import com.micro.health.family.health.record.FamilyHealthApplication;
import com.micro.health.family.health.record.ModuleDetailsActivity;
import com.micro.health.family.health.record.R;
import com.micro.health.family.health.record.dto.MedicalHistory;

/**
 * This class is used with a GridView object. It provides a set of ImageCell
 * objects that support dragging and dropping.
 * 
 */

public class MedicalHistoryAdapter extends ArrayAdapter<MedicalHistory> {
	public static final int DEFAULT_NUM_IMAGES = 5;
	
	public ViewGroup mParentView = null;
	private Context mContext;
	private ArrayList<MedicalHistory> arrTabs;
	private int sampleSize;
	
	public MedicalHistoryAdapter(Context context, ArrayList<MedicalHistory> objects, int sampleSizei) {
		super(context, R.layout.modulegriditem, objects);
		mContext = context;
		this.arrTabs = objects;
		this.sampleSize = sampleSizei;
        
	}

	public int getCount() {
		return arrTabs.size();
	}

	public MedicalHistory getItem(int position) {
		return null;
	}

	public long getItemId(int position) {
		return position;
	}

	public View getView(final int position, View convertView, ViewGroup parent) {
		mParentView = parent;
		MedicalHistoryGrid v = null;
		if(convertView == null)
		{
			v = new MedicalHistoryGrid(mContext);
		} else {
			v = (MedicalHistoryGrid) convertView;
		}
		v.setTag(arrTabs.get(position));
		v.setObjDetails(arrTabs.get(position), sampleSize, position);
		v.mCellNumber = position;
		v.mGrid = (GridView) mParentView;
		v.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent intent = null;
				if(!ModuleDetailsActivity.isEdit) {
					if(arrTabs.get(position).getMedicaldatatypeId() == FamilyHealthApplication.IMAGE) {
						intent = new Intent(mContext, AddImageActivity.class);
					} else if(arrTabs.get(position).getMedicaldatatypeId() == FamilyHealthApplication.TEXT) {
						intent = new Intent(mContext, AddTextActivity.class);
					} else if(arrTabs.get(position).getMedicaldatatypeId() == FamilyHealthApplication.AUDIO) {
						intent = new Intent(mContext, AddAudioActivity.class);
					} else if(arrTabs.get(position).getMedicaldatatypeId() == FamilyHealthApplication.FILE) {
						intent = new Intent(mContext, AddFileActivity.class);
					} else if(arrTabs.get(position).getMedicaldatatypeId() == FamilyHealthApplication.VIDEO) {
						intent = new Intent(mContext, AddVideoActivity.class);
					} else if(arrTabs.get(position).getMedicaldatatypeId() == FamilyHealthApplication.DRAWING) {
						intent = new Intent(mContext, AddDrawingActivity.class);
					}
					intent.putExtra(FamilyHealthApplication.MEDICALHISTORYOBJ, arrTabs.get(position));
					intent.putExtra(FamilyHealthApplication.MODULE,ModuleDetailsActivity.currentModule);
					mContext.startActivity(intent);
				}
			}
		});
		v.setOnLongClickListener((View.OnLongClickListener) mContext);
		return v;
	}

}
