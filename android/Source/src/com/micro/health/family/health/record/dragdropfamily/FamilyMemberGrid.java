package com.micro.health.family.health.record.dragdropfamily;

import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.micro.health.family.health.record.MyFamilyActivity;
import com.micro.health.family.health.record.R;
import com.micro.health.family.health.record.Utils;
import com.micro.health.family.health.record.dto.FamilyMember;
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

public class FamilyMemberGrid extends LinearLayout implements DragSource, DropTarget
{
   // public boolean mEmpty = true;
    public int mCellNumber = -1;
    public GridView mGrid;
    private Context context;
    private ImageView img;
	private TextView title;
	private TextView editT;
	private ImageView minus;
	private LinearLayout ll;
	
	public FamilyMemberGrid (Context context) {
		super (context);
		this.context = context;
		init();
	}
	public FamilyMemberGrid (Context context, AttributeSet attrs) {
		super (context, attrs);
		this.context = context;
		init();
	}
	
	private void init()
	{
		LayoutInflater li = LayoutInflater.from(context);
		ll = (LinearLayout) li.inflate(R.layout.familymembergriditem, this);
		img = (ImageView) ll.findViewById(R.id.mem_img);
		title = (TextView) ll.findViewById(R.id.mem_name);
		editT= (TextView) ll.findViewById(R.id.editT);
		minus = (ImageView) ll.findViewById(R.id.minus);
	}
	
	public void setObjDetails(final FamilyMember md, int sampleSize, int position)
	{
		title.setText(md.getFamilyMemFName());
		img.setImageBitmap(Utils.getEncryptedImage(md.getFamilyMemImage(),sampleSize));
		if(MyFamilyActivity.isEdit) {
			editT.setVisibility(View.VISIBLE);
			minus.setVisibility(View.VISIBLE);
		} else {
			editT.setVisibility(View.GONE);
			minus.setVisibility(View.GONE);
		}
		minus.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Utils.alertDialogShow(context, context.getString(R.string.app_name), context.getString(R.string.areyousuredeletefamily), context.getString(R.string.ok), context.getString(R.string.cancel), new DialogInterface.OnClickListener(){

					@Override
					public void onClick(DialogInterface dialog, int which) {
						if(which==Dialog.BUTTON1) {
							FamilyHealthDBAdapter dbAdapter =new FamilyHealthDBAdapter(context);
							dbAdapter.open();
							boolean x = dbAdapter.deleteFamilyMember(md.getFamilyMemid());
							dbAdapter.close();
							if(x) {
								MyFamilyActivity.familyMemberAdapter.remove(md);
							}
							Message msg = new Message();
							msg.what = 1;
							msg.obj = x;
							handler.sendMessage(msg);
						} else {
							dialog.dismiss();
						}
							
					}
				});
			}
		});
		ll.setTag(position);
		mCellNumber = -1;
  	}
	
	
	public void setObjSelected()
	{
		img.setSelected(true);
		ll.setBackgroundResource(R.drawable.hover);
  	}
	

	
	public void setDragController (DragController dragger)
	{
	}

	
	public void onDropCompleted (View target, boolean success)
	{
	    // If the drop succeeds, the image has moved elsewhere. 
	    // So clear the image cell.
	  /*  if (success) {
	  //     mEmpty = true;
	       if (mCellNumber >= 0) {
	    //      int bg = mEmpty ? R.color.cell_empty : R.color.cell_filled;
	     //     setBackgroundResource (bg);
	          setImageDrawable (null);
	       } else {
	         // For convenience, we use a free-standing ImageCell to
	         // take the image added when the Add Image button is clicked.
	         setImageResource (0);
	       }
	    }*/
	}

	/**
	 */
	// DropTarget interface implementation
	
	/**
	 * Handle an object being dropped on the DropTarget.
	 * This is the where the drawable of the dragged view gets copied into the ImageCell.
	 * 
	 * @param source DragSource where the drag started
	 * @param x X coordinate of the drop location
	 * @param y Y coordinate of the drop location
	 * @param xOffset Horizontal offset with the object being dragged where the original
	 *          touch happened
	 * @param yOffset Vertical offset with the object being dragged where the original
	 *          touch happened
	 * @param dragView The DragView that's being dragged around on screen.
	 * @param dragInfo Data associated with the object being dragged
	 * 
	 */
	public void onDrop(DragSource source, int x, int y, int xOffset, int yOffset,
	        DragView dragView, Object dragInfo)
	{
		LinearLayout sourceView = (LinearLayout) source;

	    String destTitle = this.title.getText().toString();
		Drawable destDrawable = this.img.getDrawable();
		int destPosition = Integer.parseInt(this.ll.getTag().toString());
		
		int sourcePosition = Integer.parseInt(sourceView.getTag().toString());
		String sourceTitle = ((TextView)sourceView.findViewById(R.id.mem_name)).getText().toString();
		Drawable sourceDrawable = ((ImageView)sourceView.findViewById(R.id.mem_img)).getDrawable();
		
		this.title.setText(sourceTitle);
		this.img.setImageDrawable(sourceDrawable);
		this.ll.setTag(sourcePosition);
		
		((TextView)sourceView.findViewById(R.id.mem_name)).setText(destTitle);
		((ImageView)sourceView.findViewById(R.id.mem_img)).setImageDrawable(destDrawable);
		sourceView.setTag(destPosition);
		
		MyFamilyActivity.mem_data.get(sourcePosition).setOrderNum(destPosition);
		MyFamilyActivity.mem_data.get(destPosition).setOrderNum(sourcePosition);
		
		FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(context);
		dbAdapter.open();
		dbAdapter.updateFamilyOrder(MyFamilyActivity.mem_data.get(sourcePosition), MyFamilyActivity.mem_data.get(destPosition));
		dbAdapter.close();
		
	}

	/**
	 * React to a dragged object entering the area of this DropSpot.
	 * Provide the user with some visual feedback.
	 */    
	public void onDragEnter(DragSource source, int x, int y, int xOffset, int yOffset,
	        DragView dragView, Object dragInfo)
	{
	 //   int bg = mEmpty ? R.color.cell_empty_hover : R.color.cell_filled_hover;
	  //  setBackgroundResource (bg);
	}
	
	/**
	 * React to something being dragged over the drop target.
	 */    
	public void onDragOver(DragSource source, int x, int y, int xOffset, int yOffset,
	        DragView dragView, Object dragInfo)
	{
	}
	
	/**
	 * React to a drag 
	 */    
	public void onDragExit(DragSource source, int x, int y, int xOffset, int yOffset,
	        DragView dragView, Object dragInfo)
	{
	    //int bg = mEmpty ? R.color.cell_empty : R.color.cell_filled;
	    //setBackgroundResource (bg);
	}
	
	/**
	 * Check if a drop action can occur at, or near, the requested location.
	 * This may be called repeatedly during a drag, so any calls should return
	 * quickly.
	 * 
	 * @param source DragSource where the drag started
	 * @param x X coordinate of the drop location
	 * @param y Y coordinate of the drop location
	 * @param xOffset Horizontal offset with the object being dragged where the
	 *            original touch happened
	 * @param yOffset Vertical offset with the object being dragged where the
	 *            original touch happened
	 * @param dragView The DragView that's being dragged around on screen.
	 * @param dragInfo Data associated with the object being dragged
	 * @return True if the drop will be accepted, false otherwise.
	 */
	public boolean acceptDrop(DragSource source, int x, int y, int xOffset, int yOffset,
	        DragView dragView, Object dragInfo)
	{
	    // An ImageCell accepts a drop if it is empty and if it is part of a grid.
	    // A free-standing ImageCell does not accept drops.
	    return (mCellNumber >= 0);
	}
	
	/**
	 * Estimate the surface area where this object would land if dropped at the
	 * given location.
	 * 
	 * @param source DragSource where the drag started
	 * @param x X coordinate of the drop location
	 * @param y Y coordinate of the drop location
	 * @param xOffset Horizontal offset with the object being dragged where the
	 *            original touch happened
	 * @param yOffset Vertical offset with the object being dragged where the
	 *            original touch happened
	 * @param dragView The DragView that's being dragged around on screen.
	 * @param dragInfo Data associated with the object being dragged
	 * @param recycle {@link Rect} object to be possibly recycled.
	 * @return Estimated area that would be occupied if object was dropped at
	 *         the given location. Should return null if no estimate is found,
	 *         or if this target doesn't provide estimations.
	 */
	public Rect estimateDropLocation(DragSource source, int x, int y, int xOffset, int yOffset,
	            DragView dragView, Object dragInfo, Rect recycle)
	{
	    return null;
	}
	
	/**
	 */
	// Other Methods
	
	/**
	 * Call this view's onClick listener. Return true if it was called.
	 * Clicks are ignored if the cell is empty.
	 * 
	 * @return boolean
	 */
	
	public boolean performClick ()
	{
	    return super.performClick ();
	}
	
	/**
	 * Call this view's onLongClick listener. Return true if it was called.
	 * Clicks are ignored if the cell is empty.
	 * 
	 * @return boolean
	 */
	
	public boolean performLongClick ()
	{
	    return super.performLongClick ();
	}
	
	/**
	 * Show a string on the screen via Toast if DragActivity.Debugging is true.
	 * 
	 * @param msg String
	 * @return void
	 */
	
	private Handler handler = new Handler()
	{
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			if(msg.what == 1) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					MyFamilyActivity.familyMemberAdapter.notifyDataSetChanged();
				} else {
					Utils.alertDialogShow(context, context.getString(R.string.app_name), context.getString(R.string.familymembernotdeleted));
				}
				
			}
		}
		
	};
} // end ImageCell
