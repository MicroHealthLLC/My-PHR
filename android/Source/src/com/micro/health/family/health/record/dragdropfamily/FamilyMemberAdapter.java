package com.micro.health.family.health.record.dragdropfamily;

import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.GridView;

import com.micro.health.family.health.record.AddFamilyMemberActivity;
import com.micro.health.family.health.record.FamilyHealthApplication;
import com.micro.health.family.health.record.ModuleListActivity;
import com.micro.health.family.health.record.MyFamilyActivity;
import com.micro.health.family.health.record.R;
import com.micro.health.family.health.record.dto.FamilyMember;

/**
 * This class is used with a GridView object. It provides a set of ImageCell
 * objects that support dragging and dropping.
 * 
 */

public class FamilyMemberAdapter extends ArrayAdapter<FamilyMember> {
	public static final int DEFAULT_NUM_IMAGES = 5;
	
	public ViewGroup mParentView = null;
	private Context mContext;
	private ArrayList<FamilyMember> arrTabs;
	private int sampleSize;
	
	public FamilyMemberAdapter(Context context, ArrayList<FamilyMember> objects, int sampleSize) {
		super(context, R.layout.familymembergriditem, objects);
		mContext = context;
		this.arrTabs = objects;
		this.sampleSize = sampleSize;
        
	}

	public int getCount() {
		return arrTabs.size();
	}

	public FamilyMember getItem(int position) {
		return null;
	}

	public long getItemId(int position) {
		return position;
	}

	public View getView(final int position, View convertView, ViewGroup parent) {
		mParentView = parent;
		FamilyMemberGrid v = null;
		if(convertView == null)
		{
			v = new FamilyMemberGrid(mContext);
		} else {
			v = (FamilyMemberGrid) convertView;
		}
		v.setTag(arrTabs.get(position));
		v.setObjDetails(arrTabs.get(position), sampleSize, position);
		v.mCellNumber = position;
		v.mGrid = (GridView) mParentView;
		v.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if(MyFamilyActivity.isEdit) {
					Intent intent = new Intent(mContext, AddFamilyMemberActivity.class);
					intent.putExtra(FamilyHealthApplication.FAMILYMEMID, arrTabs.get(position).getFamilyMemid());
					mContext.startActivity(intent);
				} else {
					FamilyHealthApplication.setFamilymember(arrTabs.get(position));
					Intent intent = new Intent(mContext, ModuleListActivity.class);
					mContext.startActivity(intent);
				}
			}
		});
		v.setOnLongClickListener((View.OnLongClickListener) mContext);
		return v;
	}

}
