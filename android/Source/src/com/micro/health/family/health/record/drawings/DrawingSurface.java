package com.micro.health.family.health.record.drawings;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

/**
 * Created by IntelliJ IDEA.
 * User: almondmendoza
 * Date: 07/11/2010
 * Time: 2:15 AM
 * Link: http://www.tutorialforandroid.com/
 */
public class DrawingSurface extends SurfaceView implements SurfaceHolder.Callback {
    private Boolean _run;
    protected DrawThread thread;
    private Bitmap mBitmap;
    public boolean isDrawing = true;
    public DrawingPath previewPath;
    private boolean isEdit = false;
    private Bitmap bckBitmap;
    private int wid;
    private int hei;
    
    private CommandManager commandManager;

    public DrawingSurface(Context context, AttributeSet attrs) {
        super(context, attrs);

        getHolder().addCallback(this);

        commandManager = new CommandManager();
        thread = new DrawThread(getHolder());
    }


    class DrawThread extends  Thread{
        private SurfaceHolder mSurfaceHolder;


        public DrawThread(SurfaceHolder surfaceHolder){
            mSurfaceHolder = surfaceHolder;

        }

        public void setRunning(boolean run) {
            _run = run;
        }


        @Override
        public void run() {
            Canvas canvas = null;
            while (_run){
                if(isDrawing == true){
                    try{
                        canvas = mSurfaceHolder.lockCanvas(null);
                        if(mBitmap == null){
                            mBitmap =  Bitmap.createBitmap (1, 1, Bitmap.Config.ARGB_8888);
                        }
                        final Canvas c = new Canvas (mBitmap);

                        c.drawColor(Color.WHITE);
                        canvas.drawColor(Color.WHITE);
                        if(isEdit) {
                        	if(wid != 0 && hei != 0) {
                        		bckBitmap = Bitmap.createScaledBitmap(bckBitmap, wid, hei, true);
                        	}
                        	c.drawBitmap(bckBitmap, 0, 0, new Paint());
                        }
                        commandManager.executeAll(c);
                        previewPath.draw(c);
                        
                        canvas.drawBitmap (mBitmap, 0,  0,null);
                    } finally {
                        mSurfaceHolder.unlockCanvasAndPost(canvas);
                    }
                    isDrawing = false;
                } 
                
            }
        }
    }


    public void addDrawingPath (DrawingPath drawingPath){
        commandManager.addCommand(drawingPath);
    }

    public boolean hasMoreRedo(){
        return commandManager.hasMoreRedo();
    }

    public void redo(){
        isDrawing = true;
        commandManager.redo();


    }

    public void undo(){
        isDrawing = true;
        commandManager.undo();
    }

    public boolean hasMoreUndo(){
        return commandManager.hasMoreUndo();
    }

    public Bitmap getBitmap(){
        return mBitmap;
    }
    public boolean isEdit() {
  		return isEdit;
  	}

  	public void setEdit(boolean isEdit) {
  		this.isEdit = isEdit;
  	}
  	
  	public Bitmap getBckBitmap() {
  		return bckBitmap;
  	}

  	public void setBckBitmap(Bitmap bckBitmap) {
  		this.bckBitmap = bckBitmap;
  	}


    public void surfaceChanged(SurfaceHolder holder, int format, int width,  int height) {
    	mBitmap =  Bitmap.createBitmap (width, height, Bitmap.Config.ARGB_8888);;
        wid = width;
        hei = height;
        isDrawing = true;
    }


    public void surfaceCreated(SurfaceHolder holder) {
        thread.setRunning(true);
        thread.start();
    }

    public void surfaceDestroyed(SurfaceHolder holder) {
        boolean retry = true;
        thread.setRunning(false);
        while (retry) {
            try {
                thread.join();
                retry = false;
            } catch (InterruptedException e) {
                // we will try it again and again...
            }
        }
    }

}
