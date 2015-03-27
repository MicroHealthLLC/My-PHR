package com.micro.health.family.health.record.dropbox;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.os.AsyncTask;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;

import com.dropbox.client2.DropboxAPI;
import com.dropbox.client2.ProgressListener;
import com.dropbox.client2.exception.DropboxException;
import com.dropbox.client2.exception.DropboxIOException;
import com.dropbox.client2.exception.DropboxParseException;
import com.dropbox.client2.exception.DropboxPartialFileException;
import com.dropbox.client2.exception.DropboxServerException;
import com.dropbox.client2.exception.DropboxUnlinkedException;
import com.micro.health.family.health.record.DropboxRestoreActivity;
import com.micro.health.family.health.record.FamilyHealthApplication;
import com.micro.health.family.health.record.R;
import com.micro.health.family.health.record.Utils;
import com.micro.health.family.health.record.dto.FamilyMember;
import com.micro.health.family.health.record.dto.MedicalHistory;
import com.micro.health.family.health.record.webservice.FamilyHealthDBAdapter;

import de.idyl.winzipaes.AesZipFileDecrypter;
import de.idyl.winzipaes.impl.AESDecrypterBC;
import de.idyl.winzipaes.impl.ExtZipEntry;

public class DownloadZipFromDropbox extends AsyncTask<Void, Long, Boolean> {

	private static final String TAG = DownloadZipFromDropbox.class.getCanonicalName();
    private Context mContext;
    private final ProgressBar mDialog;
    private DropboxAPI<?> mApi;
    private String mPath;

    private FileOutputStream mFos;

    private String mErrorMsg;

    private String revision;
    private RelativeLayout rl;
    private RelativeLayout rl2;
    
    private Button back;
    private Button edit;
    private ListView listview;
    SQLiteDatabase mDb;
    FamilyHealthDBAdapter dbAdapter;
    File f;
    String fpath;
    FileInputStream is;
    public DownloadZipFromDropbox(Context context, DropboxAPI<?> api, String dropboxPath, String rev,  ProgressBar pb, RelativeLayout rl1, RelativeLayout rl22, Button back1, Button edit1, ListView l1) {
        // We set the context this way so we don't accidentally leak activities
        mContext = context;

        mApi = api;
        mPath = dropboxPath;
        revision = rev;
        
        mDialog = pb;
        mDialog.setProgress(0);
        mDialog.setMax(100);
        rl = rl1;
        rl2 = rl22;
        back = back1;
        edit = edit1;
        listview = l1;
        
        dbAdapter = new FamilyHealthDBAdapter(mContext);
        dbAdapter.open();
        mDb =dbAdapter.getDb();
        String s = System.currentTimeMillis() +"";
        fpath = FamilyHealthApplication.PATH + File.separator + s;
        f = new File(FamilyHealthApplication.PATH, s);
    }

    @Override
    protected Boolean doInBackground(Void... params) {
    	try {
    		 String cachePath = mContext.getCacheDir().getAbsolutePath() + "/" + revision;
            try {
                mFos = new FileOutputStream(cachePath);
            } catch (FileNotFoundException e) {
                mErrorMsg = "Couldn't create a local file to store the image";
                return false;
            }

            mApi.getFile(mPath, revision, mFos, new ProgressListener() {
                @Override
                public long progressInterval() {
                    return 500;
                }

                @Override
                public void onProgress(long bytes, long total) {
                    publishProgress(bytes, total);
                }
            });
           
           	f.mkdirs();
           	Unzip(cachePath, fpath + File.separator,"m!crohospitalsurvey");
           	
            Decompress decompress = new Decompress(cachePath, fpath + File.separator);
            decompress.unzip();
            mDb.beginTransaction();
            dbAdapter.deleteAllFamilyMembers();
            dbAdapter.deleteAllFamilyHistories();
            try {
            	Utils.getEncryptedCSV(new File(fpath, FamilyHealthApplication.FILENAMECSV), new File(fpath, FamilyHealthApplication.FILENAMECSV +"d"));
				is = new FileInputStream(new File(fpath, FamilyHealthApplication.FILENAMECSV +"d"));
				BufferedReader reader = new BufferedReader(new InputStreamReader(is));
                String line;
                while ((line = reader.readLine()) != null) {
                	 String[] rowData = line.split(",");
                     dbAdapter.insertMedicalHistory(new MedicalHistory(Integer.parseInt(rowData[0]), Integer.parseInt(rowData[1]), rowData[2], Integer.parseInt(rowData[3]), Integer.parseInt(rowData[4]), Integer.parseInt(rowData[5])==1?true:false, rowData[6], rowData[7], rowData[8], Integer.parseInt(rowData[9])));
                     if(Integer.parseInt(rowData[4]) == FamilyHealthApplication.AUDIO || Integer.parseInt(rowData[4]) == FamilyHealthApplication.VIDEO) {
                    	String[] xsplit = rowData[2].split("--OV--");
     					for(int i=0;i<xsplit.length;i++){
     						String[] ysplit = xsplit[i].split(":");
     						Utils.moveFileToSecureArea(new File(fpath, ysplit[0]), new File(FamilyHealthApplication.PATH, ysplit[0]));
     					}
                     }
                     else {
                    		Utils.moveFileToSecureArea(new File(fpath, rowData[2]), new File(FamilyHealthApplication.PATH, rowData[2]));
                     }
                }
                
                Utils.getEncryptedCSV(new File(fpath, FamilyHealthApplication.FAMILYFILENAMECSV), new File(fpath, FamilyHealthApplication.FAMILYFILENAMECSV +"d"));
				is = new FileInputStream(new File(fpath, FamilyHealthApplication.FAMILYFILENAMECSV +"d"));
				reader = new BufferedReader(new InputStreamReader(is));
                line = "";
                while ((line = reader.readLine()) != null) {
                	 String[] rowData = line.split(",");
                     dbAdapter.addFamilyMember(new FamilyMember(Integer.parseInt(rowData[0]), rowData[1], rowData[2], rowData[3], Integer.parseInt(rowData[4])));
                     Utils.moveFileToSecureArea(new File(fpath, rowData[3]), new File(FamilyHealthApplication.PATH, rowData[3]));
                }
            } catch (FileNotFoundException e1) {
				Log.e(TAG, e1.toString());
				e1.printStackTrace();
			}
            catch (IOException ex) {
            	Log.e(TAG, ex.toString());
            }
            finally {
                try {
                	Utils.deleteFile(f);
                    is.close();
                } catch (IOException e) {
                	Log.e(TAG, e.toString());
                }
            }
            mDb.setTransactionSuccessful();
            return true;

        } catch (DropboxUnlinkedException e) {
            // The AuthSession wasn't properly authenticated or user unlinked.
        } catch (DropboxPartialFileException e) {
            // We canceled the operation
            mErrorMsg = "Download canceled";
        } catch (DropboxServerException e) {
            // Server-side exception.  These are examples of what could happen,
            // but we don't do anything special with them here.
            if (e.error == DropboxServerException._304_NOT_MODIFIED) {
                // won't happen since we don't pass in revision with metadata
            } else if (e.error == DropboxServerException._401_UNAUTHORIZED) {
                // Unauthorized, so we should unlink them.  You may want to
                // automatically log the user out in this case.
            } else if (e.error == DropboxServerException._403_FORBIDDEN) {
                // Not allowed to access this
            } else if (e.error == DropboxServerException._404_NOT_FOUND) {
                // path not found (or if it was the thumbnail, can't be
                // thumbnailed)
            } else if (e.error == DropboxServerException._406_NOT_ACCEPTABLE) {
                // too many entries to return
            } else if (e.error == DropboxServerException._415_UNSUPPORTED_MEDIA) {
                // can't be thumbnailed
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
        } finally {
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
    	edit.setEnabled(true);
    	listview.setEnabled(true);
        if (result) {
        	Utils.alertDialogShow(mContext, mContext.getString(R.string.app_name), mContext.getString(R.string.restoresuccessful));
        } else {
        	Utils.alertDialogShow(mContext, mContext.getString(R.string.app_name), mContext.getString(R.string.restoreunsuccessful) + "  " + mErrorMsg);
        }
    }
    
    public void cancelRestore() {
		if (DropboxRestoreActivity.downloadTask != null && DropboxRestoreActivity.downloadTask.getStatus() != AsyncTask.Status.FINISHED) {
			Utils.deleteFile(f);
			if(is!=null) {
				try {
					is.close();
				} catch (IOException e) {
					Log.e(TAG, e.toString());
					e.printStackTrace();
				}
			}
			if(mDb.inTransaction()) {
	        	mDb.endTransaction();
			}
			dbAdapter.close();
			DropboxRestoreActivity.downloadTask.cancel(true);
			rl.setVisibility(View.GONE);
	    	rl2.setVisibility(View.GONE);
	    	back.setEnabled(true);
	    	edit.setEnabled(true);
	    	listview.setEnabled(true);
       	}
	}
    
    public static void Unzip(String zipFile, String targetDir, String pass) {
        try {
	        AesZipFileDecrypter zipFile1;
	        AESDecrypterBC aesd = new AESDecrypterBC();
	        zipFile1 = new AesZipFileDecrypter(new File(zipFile), aesd);
	        File foldertemp = new File(targetDir);
	        if(foldertemp.exists()){
                emptyFolder(foldertemp);
                foldertemp.delete();
	        }
	        
	        for (ExtZipEntry entry : zipFile1.getEntryList()) {
		        File file = new File(targetDir + "/" + entry.getName());
		        if (!file.exists()) {
	                if (entry.isDirectory()) {
                        file.mkdirs();
	                } else {
                        File folder = new File(file.getAbsolutePath().substring(0,file.getAbsolutePath().lastIndexOf("/")));
                        if (!folder.exists()) {
                        	folder.mkdirs();
                        }
                        file.createNewFile();
                        zipFile1.extractEntry(entry, file, pass);
	                }
		        }
	        }
        } catch (Exception cwj) {
            cwj.printStackTrace();
            File file = new File(targetDir);
            if(emptyFolder(file)){
                    file.delete();
            }
        }
    }
    
    public static boolean emptyFolder(File file){
        
        for(File temp : file.listFiles()){
                if(temp.isDirectory()){
                        emptyFolder(temp);
                        temp.delete();
                }else{
                        temp.delete();
                }
        }
        
        return true;
    }
}
