package com.micro.health.family.health.record.dragdropfamily;

import java.io.File;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.media.ThumbnailUtils;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.provider.MediaStore;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.micro.health.family.health.record.FamilyHealthApplication;
import com.micro.health.family.health.record.ModuleDetailsActivity;
import com.micro.health.family.health.record.R;
import com.micro.health.family.health.record.Utils;
import com.micro.health.family.health.record.dto.MedicalHistory;
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

public class MedicalHistoryGrid extends LinearLayout implements DragSource, DropTarget
{
   // public boolean mEmpty = true;
    public int mCellNumber = -1;
    public GridView mGrid;
    private Context context;
    private ImageView img;
    private TextView txtdata;
	private TextView title;
	private ImageView minus;
	private Button mark;
	private TextView archived;
	private LinearLayout ll;

	
	public MedicalHistoryGrid (Context context) {
		super (context);
		this.context = context;
		init();
	}
	public MedicalHistoryGrid (Context context, AttributeSet attrs) {
		super (context, attrs);
		this.context = context;
		init();
	}
	
	private void init()
	{
		LayoutInflater li = LayoutInflater.from(context);
		ll = (LinearLayout) li.inflate(R.layout.modulegriditem, this);
		img = (ImageView) ll.findViewById(R.id.img);
		txtdata = (TextView) ll.findViewById(R.id.txt);
		title = (TextView) ll.findViewById(R.id.title);
		minus= (ImageView) ll.findViewById(R.id.minus);
		mark = (Button) ll.findViewById(R.id.mark);
		archived = (TextView) ll.findViewById(R.id.archive);
		
		if(ModuleDetailsActivity.currentModule.getId() == 5) {
			archived.setText(context.getString(R.string.nottaking));
		} else {
			archived.setText(context.getString(R.string.archived));
		}
	}
	
	public void setObjDetails(final MedicalHistory md, int sampleSizeImg, final int position)
	{
		if(md.getArchive()) {
			archived.setVisibility(View.VISIBLE);
		} else {
			archived.setVisibility(View.GONE);
		}
		
		if(ModuleDetailsActivity.isEdit) {
			archived.setVisibility(View.GONE);
			minus.setVisibility(View.VISIBLE);
			mark.setVisibility(View.VISIBLE);
			
			if(md.getArchive()){
				mark.setBackgroundResource(R.drawable.greenbtn);
				if(ModuleDetailsActivity.currentModule.getId() == 5) {
					mark.setText(context.getString(R.string.removenottakinglabel));
				} else {
					mark.setText(context.getString(R.string.removearchivelabel));
				}
			} else {
				mark.setBackgroundResource(R.drawable.blackbtn);
				if(ModuleDetailsActivity.currentModule.getId() == 5) {
					mark.setText(context.getString(R.string.markasnottaking));
				} else {
					mark.setText(context.getString(R.string.markasarchived));
				}
			}
		} else {
			minus.setVisibility(View.GONE);
			mark.setVisibility(View.GONE);
		}
		minus.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Utils.showActivityViewer(context, "", false);
				new Thread(new Runnable() {
					
					@Override
					public void run() {
						FamilyHealthDBAdapter dbAdapter =new FamilyHealthDBAdapter(context);
						dbAdapter.open();
						boolean x = dbAdapter.deleteMedicalHistory(md.getId());
						dbAdapter.close();
						if(x) {
							ModuleDetailsActivity.medicalHistoryData.remove(md);
						}
						Message msg = new Message();
						msg.what = 1;
						msg.obj = x;
						handler.sendMessage(msg);
						
					}
				}).start();
				
			}
		});
		
		mark.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Utils.showActivityViewer(context, "", false);
				new Thread(new Runnable() {
					
					@Override
					public void run() {
						FamilyHealthDBAdapter dbAdapter =new FamilyHealthDBAdapter(context);
						dbAdapter.open();
						boolean x = dbAdapter.archiveMedicalHistory(!md.getArchive(), md.getId());
						dbAdapter.close();		
						if(x) {
							ModuleDetailsActivity.medicalHistoryData.get(position).setArchive(!md.getArchive());
						}
						
						Message msg = new Message();
						msg.what = 2;
						msg.obj = x;
						handler.sendMessage(msg);
					}
				}).start();
				
			}
		});
		
		title.setText(md.getTitle());
		if(md.getMedicaldatatypeId() == FamilyHealthApplication.IMAGE) {
			img.setImageBitmap(Utils.getEncryptedImage(md.getData(), sampleSizeImg));
			txtdata.setVisibility(View.GONE);
		} else if(md.getMedicaldatatypeId() == FamilyHealthApplication.TEXT) {
			img.setImageResource(R.drawable.defaulttxtbck1);
			txtdata.setVisibility(View.VISIBLE);
			txtdata.setText(Utils.getEncryptedText(md.getData()));
		} else if(md.getMedicaldatatypeId() == FamilyHealthApplication.AUDIO) {
			img.setImageResource(R.drawable.defaultaudioimg);
			txtdata.setVisibility(View.GONE);
		} else if(md.getMedicaldatatypeId() == FamilyHealthApplication.FILE) {
			String ext = md.getData().substring(md.getData().lastIndexOf("."));
			int x = getExtensionImage(ext);
			img.setImageResource(x);
			txtdata.setVisibility(View.GONE);
		} else if(md.getMedicaldatatypeId() == FamilyHealthApplication.VIDEO) {
			String fname = md.getData().split("--OV--")[0].split(":")[0];
			File x =  new File(Environment.getExternalStorageDirectory().getAbsolutePath(),fname);
			Utils.getDataForEmailMessageFromFile(new File(FamilyHealthApplication.PATH, fname), x);
			Bitmap bnthumb = ThumbnailUtils.createVideoThumbnail(x.getAbsolutePath(), MediaStore.Video.Thumbnails.MICRO_KIND);
			if(bnthumb != null) {
				img.setImageBitmap(bnthumb);
			} else {
				img.setImageResource(R.drawable.defaultvideoimg);
			}
			Utils.deleteFile(x);
			txtdata.setVisibility(View.GONE);
		} else if(md.getMedicaldatatypeId() == FamilyHealthApplication.DRAWING) {
			img.setImageBitmap(Utils.getEncryptedImage(md.getData(), sampleSizeImg));
			txtdata.setVisibility(View.GONE);
		}
		
		ll.setTag(position);
		mCellNumber = -1;
  	}
	
	private int getExtensionImage(String extension) {
		if(extension.equals(".accdb")) {
			return R.drawable.accdbico;
		} else if(extension.equals(".avi")) {
			return R.drawable.aviico;
		} else if(extension.equals(".bmp")) {
			return R.drawable.bmpico;
		} else if(extension.equals(".css")) {
			return R.drawable.cssico;
		} else if(extension.equals(".docx") || extension.equals(".doc")) {
			return R.drawable.docxico;
		} else if(extension.equals(".eml")) {
			return R.drawable.emlico;
		} else if(extension.equals(".eps")) {
			return R.drawable.epsico;
		} else if(extension.equals(".fla") || extension.equals(".flv")) {
			return R.drawable.flaico;
		} else if(extension.equals(".gif")) {
			return R.drawable.gifico;
		} else if(extension.equals(".html")) {
			return R.drawable.htmlico;
		} else if(extension.equals(".ind")) {
			return R.drawable.indico;
		} else if(extension.equals(".ini")) {
			return R.drawable.iniico;
		} else if(extension.equals(".jpeg") || extension.equals(".jpg")) {
			return R.drawable.jpegico;
		} else if(extension.equals(".jsf")) {
			return R.drawable.jsfico;
		} else if(extension.equals(".midi")) {
			return R.drawable.midiico;
		} else if(extension.equals(".mov")) {
			return R.drawable.movico;
		} else if(extension.equals(".mp3")) {
			return R.drawable.mp3ico;
		} else if(extension.equals(".mpeg")) {
			return R.drawable.mpegico;
		} else if(extension.equals(".pdf")) {
			return R.drawable.pdfico;
		} else if(extension.equals(".png")) {
			return R.drawable.pngico;
		} else if(extension.equals(".pptx") || extension.equals(".ppt") || extension.equals(".pps")) {
			return R.drawable.pptxico;
		} else if(extension.equals(".pst")) {
			return R.drawable.pstico;
		} else if(extension.equals(".proj")) {
			return R.drawable.projico;
		} else if(extension.equals(".psd")) {
			return R.drawable.psdico;
		} else if(extension.equals(".pub")) {
			return R.drawable.pubico;
		} else if(extension.equals(".rar")) {
			return R.drawable.rarico;
		} else if(extension.equals(".set")) {
			return R.drawable.settingsico;
		} else if(extension.equals(".txt")) {
			return R.drawable.textico;
		} else if(extension.equals(".tiff")) {
			return R.drawable.tiffico;
		} else if(extension.equals(".url")) {
			return R.drawable.urlico;
		} else if(extension.equals(".vsd")) {
			return R.drawable.vsdico;
		} else if(extension.equals(".wav")) {
			return R.drawable.wavico;
		} else if(extension.equals(".wma")) {
			return R.drawable.wmaico;
		} else if(extension.equals(".wmv")) {
			return R.drawable.wmvico;
		} else if(extension.equals(".xlsx") || extension.equals(".xls")) {
			return R.drawable.xlsxico;
		} else if(extension.equals(".zio")) {
			return R.drawable.zipico;
		} else {
			return R.drawable.defaultfileimg;
		}
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
		int destPosition = Integer.parseInt(this.ll.getTag().toString());
		int sourcePosition = Integer.parseInt(sourceView.getTag().toString());
		
		
		String destTitle = this.title.getText().toString();
		Drawable destDrawable = this.img.getDrawable();
		int destArchiveVis = this.archived.getVisibility();
		int desttxtdataVis = this.txtdata.getVisibility();
		String desttxtdata = this.txtdata.getText().toString();
		
		String sourceTitle = ((TextView)sourceView.findViewById(R.id.title)).getText().toString();
		Drawable sourceDrawable = ((ImageView)sourceView.findViewById(R.id.img)).getDrawable();
		int sourceArchiveVis = ((TextView)sourceView.findViewById(R.id.archive)).getVisibility();
		int sourcetxtdataVis = ((TextView)sourceView.findViewById(R.id.txt)).getVisibility();
		String sourcetxtdata = ((TextView)sourceView.findViewById(R.id.txt)).getText().toString();
		
		this.title.setText(sourceTitle);
		this.txtdata.setText(sourcetxtdata);
		this.img.setImageDrawable(sourceDrawable);
		this.ll.setTag(sourcePosition);
		if(sourceArchiveVis == View.VISIBLE) {
			this.archived.setVisibility(View.VISIBLE);
		} else {
			this.archived.setVisibility(View.GONE);
		}
		if(sourcetxtdataVis == View.VISIBLE) {
			this.txtdata.setVisibility(View.VISIBLE);
		} else {
			this.txtdata.setVisibility(View.GONE);
		}
		
		((TextView)sourceView.findViewById(R.id.title)).setText(destTitle);
		((TextView)sourceView.findViewById(R.id.txt)).setText(desttxtdata);
		((ImageView)sourceView.findViewById(R.id.img)).setImageDrawable(destDrawable);
		sourceView.setTag(destPosition);
		if(destArchiveVis == View.VISIBLE) {
			((TextView)sourceView.findViewById(R.id.archive)).setVisibility(View.VISIBLE);
		} else {
			((TextView)sourceView.findViewById(R.id.archive)).setVisibility(View.GONE);
		}
		
		if(desttxtdataVis == View.VISIBLE) {
			((TextView)sourceView.findViewById(R.id.txt)).setVisibility(View.VISIBLE);
		} else {
			((TextView)sourceView.findViewById(R.id.txt)).setVisibility(View.GONE);
		}
		
		
		ModuleDetailsActivity.medicalHistoryData.get(sourcePosition).setOrderNum(destPosition);
		ModuleDetailsActivity.medicalHistoryData.get(destPosition).setOrderNum(sourcePosition);
		
		FamilyHealthDBAdapter dbAdapter = new FamilyHealthDBAdapter(context);
		dbAdapter.open();
		dbAdapter.updateMedicalHistoryOrder(ModuleDetailsActivity.medicalHistoryData.get(sourcePosition),ModuleDetailsActivity.medicalHistoryData.get(destPosition));
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
					ModuleDetailsActivity.medicalHistoryAdapter.notifyDataSetChanged();
				} else {
					Utils.alertDialogShow(context, context.getString(R.string.app_name), context.getString(R.string.moduleitemnotdeleted));
				}
				
			}
			if(msg.what == 2) {
				Utils.hideActivityViewer();
				if(Boolean.parseBoolean(msg.obj.toString())) {
					ModuleDetailsActivity.medicalHistoryAdapter.notifyDataSetChanged();
				} else {
					Utils.alertDialogShow(context, context.getString(R.string.app_name), context.getString(R.string.moduleitemnotarchived));
				}
			}
		}
		
	};
} // end ImageCell
