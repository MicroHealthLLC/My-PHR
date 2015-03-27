package com.micro.health.family.health.record;

import android.app.Dialog;
import android.content.Context;
import android.view.Window;
import android.widget.TextView;

public class ActivityIndicator extends Dialog{
	protected static final String TAG = ActivityIndicator.class.getName();
	
	public ActivityIndicator(Context context, String str, boolean inverse) {
		super(context, android.R.style.Theme_Translucent_NoTitleBar);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		if(inverse)
			setContentView(R.layout.activityindicator_dialog_inverse);
		else
			setContentView(R.layout.activityindicator_dialog);
		
		((TextView)findViewById(R.id.text)).setText(str);
		
		setCancelable(true);
	}
}
