package com.micro.health.family.health.record;

import java.io.File;

import android.app.Application;
import android.content.Context;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Environment;

import com.dropbox.client2.DropboxAPI;
import com.dropbox.client2.android.AndroidAuthSession;
import com.dropbox.client2.session.Session.AccessType;
import com.micro.health.family.health.record.dto.FamilyMember;
import com.micro.health.family.health.record.preferences.AppPreferences;

public class FamilyHealthApplication extends Application {
	final static public String ACCOUNT_PREFS_NAME = "prefs";
    final static public String ACCESS_KEY_NAME = "ACCESS_KEY";
    final static public String ACCESS_SECRET_NAME = "ACCESS_SECRET";

	//Preferences
	public static final String LAUNCHCOUNT = "launchcount";
	public static final String PASSCODE = "passcode";
	public static final String PASSCODELOCKED = "passcodelocked";
	public static final String DROPBOXLINKED = "dropboxlinked";
	
	//Intent extras
	public static final String IPASSCODE = "ipasscode";
	
	public static final String FAMILYMEMID = "familymemberid";
	
	public static final String TEMP_DIRECTORY = "microtempfamily";
	public static final String DIRECTORY = "microfamilyhealth";
	
	public static final String MODULE = "module";
	public static final String SELBITMAP = "selectedbitmap";
	public static final String SELBITMAPTYPE = "selectedbitmaptype";
	public static final String MEDICALHISTORYOBJ = "medicalhistoryobj";
	public static final String FILENAME = "filename";
	public static final String COUNTER = "counter";
	public static final String EXTENSION = "extension";
	public static final String TOTALDURATION ="totalduration";
	public static final String FILEDURATIONS ="filedurations";
	
	public static final String DIRECTORYNAME = "familyhealthrecord";
	public static File PATH;
	
	private static FamilyMember familyMember;
	
	public final static int GALLERY = 1;
	public final static int CAMERA = 2;
	public final static int IFILE = 3;

	final static public String APP_KEY = "5e5telzra788toz";//"aq39wmd3o5rvxs4";;
	final static public String APP_SECRET = "hj6lvtbmxppgida";//"ts3gjpok0u1wycq";
	final static public AccessType ACCESS_TYPE = AccessType.DROPBOX;
	
	public static AppPreferences prefs;
	
	public final static String ENCRYPT_PASSWD = "m!crohospitalsurvey";
	
	public static final int TEXT = 1;
	public static final int AUDIO = 2;
	public static final int IMAGE = 3;
	public static final int FILE = 4;
	public static final int VIDEO = 5;
	public static final int DRAWING = 6;
	
	private static DropboxAPI<AndroidAuthSession> mDBApi;
	
	public static final String FILENAMECSV= "FamilyHealthAndroidMedApp.csv";
	public static final String FAMILYFILENAMECSV= "FamilyMemberApp.csv";	
	public static final String FILENAMEARCHIVE= "FamilyHealthAndroidAppBackup";
	public static final String DROPBOX_PATH_BACKUP = "FamilyHealthAndroidApp";

	
	  @Override
	  public void onCreate() {
		  prefs = new AppPreferences(getApplicationContext());
		  if(VERSION.SDK_INT > VERSION_CODES.FROYO) {
			  PATH = new File(getApplicationContext().getExternalFilesDir(null), FamilyHealthApplication.DIRECTORYNAME);
		  } else {
			  PATH = new File(Environment.getExternalStorageDirectory(), FamilyHealthApplication.DIRECTORYNAME);
		  }
		  
		  if (PATH != null) {
			  if(!PATH.exists()) {
				  boolean x = PATH.mkdirs();
				  prefs.setDirectory(x);
			  }
		  }
	  }

	public static FamilyMember getFamilymember() {
		return familyMember;
	}

	public static void setFamilymember(FamilyMember familymemberid) {
		familyMember = familymemberid;
	}

	public static DropboxAPI<AndroidAuthSession> getmDBApi(Context context) {
		if(mDBApi == null) {
			AndroidAuthSession session = Utils.buildDropboxSession(context);
		    FamilyHealthApplication.setmDBApi(new DropboxAPI<AndroidAuthSession>(session));
		}
		return mDBApi;
	}

	public static void setmDBApi(DropboxAPI<AndroidAuthSession> mDBApi1) {
		mDBApi = mDBApi1;
	}
	
	
	
}
