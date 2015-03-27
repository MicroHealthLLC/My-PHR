package com.micro.health.family.health.record.movescale;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Style;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;

import com.micro.health.family.health.record.movescale.MultiTouchController.MultiTouchObjectCanvas;
import com.micro.health.family.health.record.movescale.MultiTouchController.PointInfo;
import com.micro.health.family.health.record.movescale.MultiTouchController.PositionAndScale;

public class PhotoSortrView extends View implements MultiTouchObjectCanvas {

	private MultiTouchController multiTouchController = new MultiTouchController(this);

	private PointInfo currTouchPoints = new PointInfo();

	private Paint mLinePaintTouchPointCircle = new Paint();
	private Bitmap img;
	private float x = 0;
	private float y = 0;;
	private float scale = 1;
	
	private int stage = 4;
	
	
	// ---------------------------------------------------------------------------------------------------

	public PhotoSortrView(Context context, Bitmap bm) {
		super(context);
		img = bm;
		mLinePaintTouchPointCircle.setColor(Color.YELLOW);
		mLinePaintTouchPointCircle.setStrokeWidth(5);
		mLinePaintTouchPointCircle.setStyle(Style.STROKE);
		mLinePaintTouchPointCircle.setAntiAlias(true);
		setBackgroundColor(Color.TRANSPARENT);
		
	    
	}
	
	// ---------------------------------------------------------------------------------------------------

	public PhotoSortrView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		mLinePaintTouchPointCircle.setColor(Color.YELLOW);
		mLinePaintTouchPointCircle.setStrokeWidth(5);
		mLinePaintTouchPointCircle.setStyle(Style.STROKE);
		mLinePaintTouchPointCircle.setAntiAlias(true);
		setBackgroundColor(Color.TRANSPARENT);
	}



	public PhotoSortrView(Context context, AttributeSet attrs) {
		super(context, attrs);
		mLinePaintTouchPointCircle.setColor(Color.YELLOW);
		mLinePaintTouchPointCircle.setStrokeWidth(5);
		mLinePaintTouchPointCircle.setStyle(Style.STROKE);
		mLinePaintTouchPointCircle.setAntiAlias(true);
		setBackgroundColor(Color.TRANSPARENT);
	}



	public PhotoSortrView(Context context) {
		super(context);
		mLinePaintTouchPointCircle.setColor(Color.YELLOW);
		mLinePaintTouchPointCircle.setStrokeWidth(5);
		mLinePaintTouchPointCircle.setStyle(Style.STROKE);
		mLinePaintTouchPointCircle.setAntiAlias(true);
		setBackgroundColor(Color.TRANSPARENT);
	}



	@Override
	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);
		canvas.save();
		canvas.scale(scale, scale, x, y);
		canvas.drawBitmap(img, x, y, null);
		canvas.restore();
	}

	// ---------------------------------------------------------------------------------------------------

/*	private void drawMultitouchDebugMarks(Canvas canvas) {
		if (currTouchPoints.isDown()) {
			float[] xs = currTouchPoints.getXs();
			float[] ys = currTouchPoints.getYs();
			float[] pressures = currTouchPoints.getPressures();
			int numPoints = currTouchPoints.getNumTouchPoints();
			for (int i = 0; i < numPoints; i++)
				canvas.drawCircle(xs[i], ys[i], 50 + pressures[i] * 80,
						mLinePaintTouchPointCircle);
			if (numPoints == 2)
				canvas.drawLine(xs[0], ys[0], xs[1], ys[1],
						mLinePaintTouchPointCircle);
		}
	}
*/
	// ---------------------------------------------------------------------------------------------------

	/** Pass touch events to the MT controller */
	@Override
	public boolean onTouchEvent(MotionEvent event) {
		if (stage == 4) {
			return multiTouchController.onTouchEvent(event);
		} else {
			return false;
		}
	}

	/**
	 * Get the image that is under the single-touch point, or return null
	 * (canceling the drag op) if none
	 */
	public Object getDraggableObjectAtPoint(PointInfo pt) {
		return this;
	}

	/**
	 * Select an object for dragging. Called whenever an object is found to be
	 * under the point (non-null is returned by getDraggableObjectAtPoint()) and
	 * a drag operation is starting. Called with null when drag op ends.
	 */
	public void selectObject(Object obj, PointInfo touchPoint) {
		currTouchPoints.set(touchPoint);
		invalidate();
	}

	/**
	 * Get the current position and scale of the selected image. Called whenever
	 * a drag starts or is reset.
	 */
	public void getPositionAndScale(Object obj,
			PositionAndScale objPosAndScaleOut) {
		objPosAndScaleOut.set(x, y, true, scale, false, scale, scale, true,0);
	}

	/** Set the position and scale of the dragged/stretched image. */
	public boolean setPositionAndScale(Object obj,
			PositionAndScale newPosAndScale, PointInfo touchPoint) {
		currTouchPoints.set(touchPoint);
		x = newPosAndScale.getXOff();
		y = newPosAndScale.getYOff();
		scale = newPosAndScale.getScale();
		invalidate();
		return true;
	}

	public void setImage(Bitmap bm) {
		img = bm;
		invalidate();
	}

	public Bitmap getImage() {
		return img;
	}

	public float getX() {
		return x;
	}

	public float getY() {
		return y;
	}

	public float getScale() {
		return scale;
	}

	public void setStage(int stage) {
		this.stage = stage;
	}
	
	public void setScale(int screenWidth, int screenHeight) {
		int imgWidth = img.getWidth();
		int imgHeight = img.getHeight();
		if(imgWidth <= imgHeight) {
			scale = ((float)screenWidth)/imgWidth;
		} else {
			scale = ((float)screenHeight)/imgHeight;
		}
	}
}