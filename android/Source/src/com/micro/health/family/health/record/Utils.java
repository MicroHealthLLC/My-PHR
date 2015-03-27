package com.micro.health.family.health.record;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.net.ConnectivityManager;
import android.text.Html;
import android.util.Log;

import com.dropbox.client2.android.AndroidAuthSession;
import com.dropbox.client2.session.AccessTokenPair;
import com.dropbox.client2.session.AppKeyPair;

public class Utils {
	private static final String TAG = "Utils";
	private static ActivityIndicator activityIndicator;

	public static void hideActivityViewer() {
		if (activityIndicator != null) {
			activityIndicator.dismiss();
			activityIndicator.cancel();
		}
	}

	public static void showActivityViewer(Context context, String str,
			boolean inverse) {
		if (activityIndicator == null) {
			activityIndicator = new ActivityIndicator(context, str, inverse);
		}
		activityIndicator.show();
	}

	public static void alertDialogShow(Context context, String title,
			String message) {
		final AlertDialog alertDialog = new AlertDialog.Builder(context)
				.create();
		alertDialog.setTitle(title);
		alertDialog.setMessage(message);
		alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int which) {
				alertDialog.cancel();
			}
		});
		alertDialog.show();
	}

	public static void alertDialogShow(Context context, String title,
			String message, DialogInterface.OnClickListener okClickListener) {
		final AlertDialog alertDialog = new AlertDialog.Builder(context)
				.create();
		alertDialog.setTitle(title);
		alertDialog.setMessage(message);
		alertDialog.setButton("OK", okClickListener);
		alertDialog.show();
	}

	public static void alertDialogShow(Context context, String title,
			String message, String btn1String, String btn2String,
			DialogInterface.OnClickListener dialogListener) {
		final AlertDialog alertDialog = new AlertDialog.Builder(context)
				.create();
		alertDialog.setTitle(title);
		alertDialog.setMessage(Html.fromHtml(message));
		alertDialog.setButton(btn1String, dialogListener);
		alertDialog.setButton2(btn2String, dialogListener);
		alertDialog.show();
	}

	public static boolean checkInternetConnection(Context context) {
		ConnectivityManager conMgr = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		if (conMgr.getActiveNetworkInfo() != null
				&& conMgr.getActiveNetworkInfo().isAvailable()
				&& conMgr.getActiveNetworkInfo().isConnected()) {
			return true;
		} else {
			return false;
		}
	}

	public static void clearDialogs() {
		activityIndicator = null;
	}

	public static Bitmap getEncryptedImage(String image, int size) {
		Bitmap bitmap = null;
		BitmapFactory.Options options = new BitmapFactory.Options();
		File f = new File(FamilyHealthApplication.PATH, image);
		if (hasExternalStoragePrivatePicture(image)) {
			try {
				InputStream is = new FileInputStream(f);
				byte[] data = new byte[is.available()];
				is.read(data);
				byte[] data1 = SimpleCrypto.decrypt(
						FamilyHealthApplication.ENCRYPT_PASSWD, data);
				BitmapFactory.Options opts = new BitmapFactory.Options();
				opts.inJustDecodeBounds = true;
				BitmapFactory.decodeByteArray(data1, 0, data1.length, opts);
				int ss = (int) (opts.outWidth / size);
				options.inJustDecodeBounds = false;
				options.inSampleSize = ss;
				bitmap = BitmapFactory.decodeByteArray(data1, 0, data1.length,
						options);
			} catch (FileNotFoundException e) {
				Log.e(TAG, e.toString());
			} catch (IOException e) {
				Log.e(TAG, e.toString());
			} catch (Exception e) {
				Log.e(TAG, e.toString());
			}
			return bitmap;
		} else {
			return null;
		}
	}

	public static void saveImageFromFile(String fromFile, String toFile) {
		File file = new File(FamilyHealthApplication.PATH, toFile);
		try {
			InputStream is = new FileInputStream(new File(fromFile));
			OutputStream os = new FileOutputStream(file);
			byte[] data = new byte[is.available()];
			is.read(data);
			try {
				byte[] data1 = SimpleCrypto.encrypt(FamilyHealthApplication.ENCRYPT_PASSWD, data);
				os.write(data1);
			} catch (Exception e) {
				Log.e(TAG, e.toString());
				e.printStackTrace();
			}
			is.close();
			os.close();
		} catch (IOException e) {
			e.printStackTrace();
			Log.e(TAG, "Error writing image" + file, e);
		}
	}
	
	

	public static void saveImageFromBitmap(Bitmap bitmap, String toFile) {
		File file = new File(FamilyHealthApplication.PATH, toFile);
		try {
			ByteArrayOutputStream bos = new ByteArrayOutputStream();
			bitmap.compress(CompressFormat.PNG, 0 /* ignored for PNG */, bos);
			byte[] bitmapdata = bos.toByteArray();
			byte[] data1 = SimpleCrypto.encrypt( FamilyHealthApplication.ENCRYPT_PASSWD, bitmapdata);
			OutputStream os = new FileOutputStream(file);
			os.write(data1);
			os.close();
		} catch (IOException e) {
			e.printStackTrace();
			Log.e(TAG, "Error writing image" + file, e);
		} catch (Exception e) {
			Log.e(TAG, "Error writing image" + file, e);
			e.printStackTrace();
		}
	}
	
	public static void saveDrawingFromBitmap(Bitmap bitmap, String toFile) {
		File file = new File(FamilyHealthApplication.PATH, toFile);
		try {
			ByteArrayOutputStream bos = new ByteArrayOutputStream();
			bitmap.compress(CompressFormat.PNG, 100, bos);
			byte[] bitmapdata = bos.toByteArray();
			byte[] data1 = SimpleCrypto.encrypt( FamilyHealthApplication.ENCRYPT_PASSWD, bitmapdata);
			OutputStream os = new FileOutputStream(file);
			os.write(data1);
			os.close();
		} catch (IOException e) {
			e.printStackTrace();
			Log.e(TAG, "Error writing image" + file, e);
		} catch (Exception e) {
			Log.e(TAG, "Error writing image" + file, e);
			e.printStackTrace();
		}
	}


	public static String getEncryptedText(String fileName) {
		File f = new File(FamilyHealthApplication.PATH, fileName);
		String x = "";
		if (hasExternalStoragePrivatePicture(fileName)) {
			try {
				InputStream is = new FileInputStream(f);
				byte[] data = new byte[is.available()];
				is.read(data);
				byte[] temp1 = SimpleCrypto.decrypt(FamilyHealthApplication.ENCRYPT_PASSWD, data);
				x = new String(temp1);
			} catch (IOException e) {
				e.printStackTrace();
				Log.e(TAG, "Error reading " + f, e);
			} catch (Exception e) {
				Log.e(TAG, "Error reading " + f, e);
			}
			return x;
		} else {
			return x;
		}
	}
	
	public static void saveTextFromString(String fileName, String txt) {
		File file = new File(FamilyHealthApplication.PATH, fileName);
		try {
			OutputStream os = new FileOutputStream(file);
			byte[] data1 = SimpleCrypto.encrypt(FamilyHealthApplication.ENCRYPT_PASSWD, txt.getBytes());
			os.write(data1);
			os.close();
		} catch (IOException e) {
			Log.e(TAG, "Error writing " + file, e);
		} catch (Exception e) {
			Log.e(TAG, "Error writing " + file, e);
		}
	}
	
	public static void saveAudioFromFile(String fromFile, String toFile) {
		File file = new File(FamilyHealthApplication.PATH, toFile);
		try {
			InputStream is = new FileInputStream(new File(fromFile));
			OutputStream os = new FileOutputStream(file);
			byte[] data = new byte[is.available()];
			is.read(data);
			byte[] data1 = SimpleCrypto.encrypt(FamilyHealthApplication.ENCRYPT_PASSWD, data);
			os.write(data1);
			is.close();
			os.close();
		} catch (IOException e) {
			e.printStackTrace();
			Log.e(TAG, "Error writing audio " + file, e);
		} catch (Exception e) {
			Log.e(TAG, "Error writing audio " + file, e);
			e.printStackTrace();
		}
	}

	public static void getDataForEmailMessageFromFile(File fromFile, File toFile) {
		try {
			InputStream is = new FileInputStream(fromFile);
			OutputStream os = new FileOutputStream(toFile);
			byte[] data = new byte[is.available()];
			is.read(data);
			byte[] data1 = SimpleCrypto.decrypt(FamilyHealthApplication.ENCRYPT_PASSWD, data);
			os.write(data1);
			is.close();
			os.close();
		} catch (IOException e) {
			e.printStackTrace();
			Log.e(TAG, "Error writing image" + toFile, e);
		} catch (Exception e) {
			Log.e(TAG, "Error writing image" + toFile, e);
			e.printStackTrace();
		}
	}
	
	public static void moveFileToSecureArea(File fromFile, File toFile) {
		try {
			InputStream is = new FileInputStream(fromFile);
			OutputStream os = new FileOutputStream(toFile);
			byte[] data = new byte[is.available()];
			is.read(data);
			os.write(data);
			is.close();
			os.close();
		} catch (IOException e) {
			e.printStackTrace();
			Log.e(TAG, "Error writing image" + toFile, e);
		}
	}

	public static void saveCSVToFile(File file, String txt) {
		try {
			OutputStream os = new FileOutputStream(file);
			byte[] data1 = SimpleCrypto.encrypt(FamilyHealthApplication.ENCRYPT_PASSWD, txt.getBytes());
			os.write(data1);
			os.close();
		} catch (IOException e) {
			e.printStackTrace();
			Log.e(TAG, "Error writing " + file, e);
		} catch (Exception e) {
			Log.e(TAG, "Error writing " + file, e);
			e.printStackTrace();
		}
	}
	
	public static void getEncryptedCSV(File fileName, File toFile) {
		if (fileName.exists()) {
			try {
				InputStream is = new FileInputStream(fileName);
				OutputStream os = new FileOutputStream(toFile);
				byte[] data = new byte[is.available()];
				is.read(data);
				byte[] temp1 = SimpleCrypto.decrypt(FamilyHealthApplication.ENCRYPT_PASSWD, data);
				os.write(temp1);
				is.close();
				os.close();
			} catch (IOException e) {
				e.printStackTrace();
				Log.e(TAG, "Error reading " + fileName, e);
			} catch (Exception e) {
				Log.e(TAG, "Error reading " + fileName, e);
			}
		} 
	}

	void deleteExternalStoragePrivatePicture(String image) {
		if (FamilyHealthApplication.PATH != null) {
			File file = new File(FamilyHealthApplication.PATH, image);
			file.delete();
		}
	}

	public static boolean hasExternalStoragePrivatePicture(String image) {
		if (FamilyHealthApplication.PATH != null) {
			File file = new File(FamilyHealthApplication.PATH, image);
			return file.exists();
		}
		return false;
	}

	public static int deleteFile(String image) {
		int x = 0;
		if (FamilyHealthApplication.PATH != null) {
			File file = new File(FamilyHealthApplication.PATH, image);
			if (file.exists()) {
				file.delete();
				x = 1;
			} else {
				x = 0;
			}
		}
		return x;
	}

	public static int deleteFile(File file) {
		int x = 0;
		if (file.isDirectory()) {
			for (File child : file.listFiles())
				deleteFile(child);
		}
		if (file.exists()) {
			file.delete();
			x = 1;
		} else {
			x = 0;
		}
		return x;
	}

	public static AndroidAuthSession buildDropboxSession(Context context) {
		AppKeyPair appKeyPair = new AppKeyPair(FamilyHealthApplication.APP_KEY, FamilyHealthApplication.APP_SECRET);
		AndroidAuthSession session;

		String[] stored = getKeys(context);
		if (stored != null) {
			AccessTokenPair accessToken = new AccessTokenPair(stored[0], stored[1]);
			session = new AndroidAuthSession(appKeyPair,FamilyHealthApplication.ACCESS_TYPE, accessToken);
		} else {
			session = new AndroidAuthSession(appKeyPair, FamilyHealthApplication.ACCESS_TYPE);
		}
		return session;
	}

	private static String[] getKeys(Context context) {
		SharedPreferences prefs = context.getSharedPreferences(FamilyHealthApplication.ACCOUNT_PREFS_NAME, 0);
		String key = prefs.getString(FamilyHealthApplication.ACCESS_KEY_NAME,null);
		String secret = prefs.getString(FamilyHealthApplication.ACCESS_SECRET_NAME, null);
		if (key != null && secret != null) {
			String[] ret = new String[2];
			ret[0] = key;
			ret[1] = secret;
			return ret;
		} else {
			return null;
		}
	}

}