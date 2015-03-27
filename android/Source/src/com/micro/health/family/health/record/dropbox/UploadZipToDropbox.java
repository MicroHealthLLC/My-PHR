package com.micro.health.family.health.record.dropbox;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.os.AsyncTask;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.dropbox.client2.DropboxAPI;
import com.dropbox.client2.DropboxAPI.UploadRequest;
import com.dropbox.client2.ProgressListener;
import com.dropbox.client2.exception.DropboxException;
import com.dropbox.client2.exception.DropboxFileSizeException;
import com.dropbox.client2.exception.DropboxIOException;
import com.dropbox.client2.exception.DropboxParseException;
import com.dropbox.client2.exception.DropboxPartialFileException;
import com.dropbox.client2.exception.DropboxServerException;
import com.dropbox.client2.exception.DropboxUnlinkedException;
import com.micro.health.family.health.record.DropboxActivity;
import com.micro.health.family.health.record.FamilyHealthApplication;
import com.micro.health.family.health.record.R;
import com.micro.health.family.health.record.Utils;
import com.micro.health.family.health.record.dto.BackupRestore;
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

import de.idyl.winzipaes.AesZipFileEncrypter;
import de.idyl.winzipaes.impl.AESEncrypterBC;

public class UploadZipToDropbox extends AsyncTask<Void, Long, Boolean> {
//	private static final String TAG= UploadZipToDropbox.class.getCanonicalName();
    private DropboxAPI<?> mApi;
    private String mPath;
    private File mFile;
    private UploadRequest mRequest;
    private Context mContext;
    private final ProgressBar mDialog;

    private String mErrorMsg;
    private RelativeLayout rl;
    private RelativeLayout rl2;
    
    private Button back;
    private RelativeLayout link;
    private RelativeLayout backup;
    private RelativeLayout restore;
    File file;
    File familyCsvfile;
	FamilyHealthDBAdapter dbAdapter;
	SQLiteDatabase mDb;
	File mFile1;

    public UploadZipToDropbox(Context context, DropboxAPI<?> api, String dropboxPath, File file, ProgressBar pb, RelativeLayout rl1, RelativeLayout rl22, RelativeLayout rl31,RelativeLayout rl32, RelativeLayout rl33, Button back1) {
        mContext = context;

        mApi = api;
        mPath = dropboxPath;
        mFile = file;

        mDialog = pb;
        mDialog.setProgress(0);
        mDialog.setMax(100);
        rl = rl1;
        rl2 = rl22;
        back = back1;
        link = rl31;
        backup = rl32;
        restore = rl33;
    }

    @Override
    protected Boolean doInBackground(Void... params) {
		file = new File(FamilyHealthApplication.PATH, FamilyHealthApplication.FILENAMECSV);
		familyCsvfile = new File(FamilyHealthApplication.PATH, FamilyHealthApplication.FAMILYFILENAMECSV);
		dbAdapter = new FamilyHealthDBAdapter(mContext);
    	dbAdapter.open();
    	mDb = dbAdapter.getDb();
    	String ZIP_FINAL = "fhra" +System.currentTimeMillis()+ ".zip";
    	mFile1 = new File(FamilyHealthApplication.PATH + File.separator + ZIP_FINAL);
        try {
        	mDb.beginTransaction();
        	Utils.saveCSVToFile(file ,dbAdapter.getAllFamilyHistoriesCSV());
        	Utils.saveCSVToFile(familyCsvfile ,dbAdapter.getAllFamilyCSV());
        	ArrayList<String> s = dbAdapter.getAllMedicalHistoryFileNames();
        	s.addAll(dbAdapter.getAllFamilyMemberFileNames());
			Compress comp = new Compress(s, FamilyHealthApplication.PATH + File.separator + mFile.getName());
			comp.zip();
			
			AESEncrypterBC aesbc = new AESEncrypterBC();
			try {
				AesZipFileEncrypter.zipAndEncryptAll(new File(FamilyHealthApplication.PATH + File.separator + mFile.getName()), new File(FamilyHealthApplication.PATH + File.separator + ZIP_FINAL), "m!crohospitalsurvey", aesbc);
			} catch (IOException e) {
				e.printStackTrace();
			}
			// so we can cancel it later if we want to
			FileInputStream fis = new FileInputStream(mFile1);
            String path = mPath + mFile1.getName();
            
            mRequest = mApi.putFileOverwriteRequest(path, fis, mFile1.length(), new ProgressListener() {
                @Override
                public long progressInterval() {
                    return 500;
                }

                @Override
                public void onProgress(long bytes, long total) {
                    publishProgress(bytes, total);
                }
            });
            if (mRequest != null) {
            	mRequest.upload();
                BackupRestore br = new BackupRestore();
            	br.setDateMed(new Date().toString());
            	br.setRevision(mFile1.getName());
            	br.setNotes(dbAdapter.getCountMedicalHistory(FamilyHealthApplication.TEXT));
            	br.setPics(dbAdapter.getCountMedicalHistory(FamilyHealthApplication.IMAGE));
            	br.setVoice(dbAdapter.getCountMedicalHistory(FamilyHealthApplication.AUDIO));
            	br.setFiles(dbAdapter.getCountMedicalHistory(FamilyHealthApplication.FILE));
            	br.setVideos(dbAdapter.getCountMedicalHistory(FamilyHealthApplication.VIDEO));
            	br.setDrawings(dbAdapter.getCountMedicalHistory(FamilyHealthApplication.DRAWING));
            	boolean x = dbAdapter.insertBackup(br);
            	if(x) {
            		
            	}
            	mDb.setTransactionSuccessful();
                return true;
            } else {
            	return false;
            }
            	
        } catch (DropboxUnlinkedException e) {
            // This session wasn't authenticated properly or user unlinked
            mErrorMsg = "This app wasn't authenticated properly.";
        } catch (DropboxFileSizeException e) {
            // File size too big to upload via the API
            mErrorMsg = "This file is too big to upload";
        } catch (DropboxPartialFileException e) {
            // We canceled the operation
            mErrorMsg = "Upload canceled";
        } catch (DropboxServerException e) {
            // Server-side exception.  These are examples of what could happen,
            // but we don't do anything special with them here.
            if (e.error == DropboxServerException._401_UNAUTHORIZED) {
                // Unauthorized, so we should unlink them.  You may want to
                // automatically log the user out in this case.
            } else if (e.error == DropboxServerException._403_FORBIDDEN) {
                // Not allowed to access this
            } else if (e.error == DropboxServerException._404_NOT_FOUND) {
                // path not found (or if it was the thumbnail, can't be
                // thumbnailed)
            } else if (e.error == DropboxServerException._507_INSUFFICIENT_STORAGE) {
                // user is over quota
            } else {
                // Something else
            }
            // This gets the Dropbox error, translated into the user's language
            mErrorMsg = e.body.userError;
            if (mErrorMsg == null) {
                mErrorMsg = e.body.error;
            }
        } catch (DropboxIOException e) {
            // Happens all the time, probably want to retry automatically.
            mErrorMsg = "Network error.  Try again.";
        } catch (DropboxParseException e) {
            // Probably due to Dropbox server restarting, should retry
            mErrorMsg = "Dropbox error.  Try again.";
        } catch (DropboxException e) {
            // Unknown error
            mErrorMsg = "Unknown error.  Try again.";
        } catch (FileNotFoundException e) {
        } finally {
        	Utils.deleteFile(file);
        	Utils.deleteFile(familyCsvfile);
        	Utils.deleteFile(mFile);
        	Utils.deleteFile(mFile1);
            mDb.endTransaction();
			dbAdapter.close();
		}
        
        return false;
    }

    @Override
    protected void onProgressUpdate(Long... progress) {
        int percent = (int)(100.0*(double)progress[0]/progress[1]);
        mDialog.setProgress(percent);
    }

    @Override
    protected void onPostExecute(Boolean result) {
    	rl.setVisibility(View.GONE);
    	rl2.setVisibility(View.GONE);
    	back.setEnabled(true);
        link.setEnabled(true);
        backup.setEnabled(true);
        restore.setEnabled(true);
        if (result) {
        	Utils.alertDialogShow(mContext, mContext.getString(R.string.app_name), mContext.getString(R.string.backupsuccessful));
        } else {
        	Utils.alertDialogShow(mContext, mContext.getString(R.string.app_name), mContext.getString(R.string.backupunsuccessful) + "  " + mErrorMsg);
        }
    }
    
    public void cancelBackup() {
		if (DropboxActivity.uploadTask != null && DropboxActivity.uploadTask.getStatus() != AsyncTask.Status.FINISHED) {
			Utils.deleteFile(file);
			Utils.deleteFile(familyCsvfile);
        	Utils.deleteFile(mFile);
        	Utils.deleteFile(mFile1);
        	if(mDb.inTransaction()) {
        		mDb.endTransaction();
        	}
        	dbAdapter.close();
			DropboxActivity.uploadTask.cancel(true);
			rl.setVisibility(View.GONE);
	    	rl2.setVisibility(View.GONE);
	    	back.setEnabled(true);
			link.setEnabled(true);
			backup.setEnabled(true);
	        restore.setEnabled(true);
       	}
	}
}
