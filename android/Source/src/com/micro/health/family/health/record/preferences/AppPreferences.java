package com.micro.health.family.health.record.preferences;

import com.micro.health.family.health.record.FamilyHealthApplication;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

public class AppPreferences {
	
	private static final String APP_SHARED_PREFS = "familyhealthprefs"; //  Name of the file -.xml
    private SharedPreferences appSharedPrefs;
    private Editor prefsEditor;
    
    public AppPreferences(Context context)
    {
    	this.appSharedPrefs = context.getSharedPreferences(APP_SHARED_PREFS, Activity.MODE_PRIVATE);
        this.prefsEditor = appSharedPrefs.edit();
    }

    public int getLaunchCount() {
		return appSharedPrefs.getInt(FamilyHealthApplication.LAUNCHCOUNT, 0);
	}

	public void setLaunchCount(int count) {
		prefsEditor.putInt(FamilyHealthApplication.LAUNCHCOUNT, count);
        prefsEditor.commit();
	}
	
	public int getPasscode() {
		return appSharedPrefs.getInt(FamilyHealthApplication.PASSCODE, 0000);
	}

	public void setPasscode(int passcode) {
		prefsEditor.putInt(FamilyHealthApplication.PASSCODE, passcode);
        prefsEditor.commit();
	}
	
	public boolean getDirectory() {
		return appSharedPrefs.getBoolean(FamilyHealthApplication.DIRECTORY, false);
	}

	public void setDirectory(boolean passcode) {
		prefsEditor.putBoolean(FamilyHealthApplication.DIRECTORY, passcode);
        prefsEditor.commit();
	}
	
	public boolean getPassCodeLocked() {
		return appSharedPrefs.getBoolean(FamilyHealthApplication.PASSCODELOCKED, true);
	}

	public void setPassCodeLocked(boolean passcode) {
		prefsEditor.putBoolean(FamilyHealthApplication.PASSCODELOCKED, passcode);
        prefsEditor.commit();
	}
	
	public boolean getDropBoxLinked() {
		return appSharedPrefs.getBoolean(FamilyHealthApplication.DROPBOXLINKED, false);
	}

	public void setDropBoxLinked(boolean passcode) {
		prefsEditor.putBoolean(FamilyHealthApplication.DROPBOXLINKED, passcode);
        prefsEditor.commit();
	}
	
	/*public String getDropBoxAccessKeyName() {
		return appSharedPrefs.getString(FamilyHealthApplication.ACCESS_KEY_NAME, null);
	}

	public void setDropBoxAccessKeyName(String passcode) {
		prefsEditor.putString(FamilyHealthApplication.ACCESS_KEY_NAME, passcode);
        prefsEditor.commit();
	}
	
	public String getDropBoxAccessSecretName() {
		return appSharedPrefs.getString(FamilyHealthApplication.ACCESS_SECRET_NAME, null);
	}

	public void setDropBoxAccessSecretName(String passcode) {
		prefsEditor.putString(FamilyHealthApplication.ACCESS_SECRET_NAME, passcode);
		prefsEditor.commit();
	}
	
	public void removeDropBoxAccessKeyName() {
		prefsEditor.remove(FamilyHealthApplication.ACCESS_KEY_NAME);
        prefsEditor.commit();
	}
	
	public void removeDropBoxAccessSecretName() {
		prefsEditor.remove(FamilyHealthApplication.ACCESS_SECRET_NAME);
		prefsEditor.commit();
	}*/
	
}
