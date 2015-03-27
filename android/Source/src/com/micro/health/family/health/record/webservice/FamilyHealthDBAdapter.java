package com.micro.health.family.health.record.webservice;

import java.io.File;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.SQLException;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteStatement;
import android.util.Log;

import com.micro.health.family.health.record.FamilyHealthApplication;
import com.micro.health.family.health.record.Utils;
import com.micro.health.family.health.record.dto.BackupRestore;
import com.micro.health.family.health.record.dto.FamilyMember;
import com.micro.health.family.health.record.dto.MedicalHistory;
import com.micro.health.family.health.record.dto.ModuleData;

public class FamilyHealthDBAdapter {

	private static final String TAG = "FamilyHealthDBAdapter";
	public static DatabaseHelper mDbHelper;
	public SQLiteDatabase mDb;
	// make sure this matches the
	// package com.MyPackage;
	// at the top of this file
	//private static String DB_PATH = "/data/data/com.MyPackage/databases/";

	// make sure this matches your database name in your assets folder
	// my database file does not have an extension on it
	// if yours does
	// add the extention
	private static final String DATABASE_NAME = "FamilyHealthRecord.sqlite";

	// Im using an sqlite3 database, I have no clue if this makes a difference
	// or not
	private static final int DATABASE_VERSION = 1;

	private final Context adapterContext;

	public FamilyHealthDBAdapter(Context context) {
		//DB_PATH = "/data/data/" + context.getPackageName() + "/databases/";
		this.adapterContext = context;

	}

	public FamilyHealthDBAdapter open() throws SQLException {
		mDbHelper = new DatabaseHelper(adapterContext);
		mDb = mDbHelper.getWritableDatabase();
		return this;
	}

	public boolean upgrade(int version) throws SQLException {
		/*mDbHelper = new DatabaseHelper(adapterContext);
		mDb = mDbHelper.getWritableDatabase();
		dbtelevitalsHelper.onUpgrade(dbtelevitals, dbtelevitals.getVersion(),
				version);
		dbtelevitals.close();
		dbtelevitalsHelper.close();*/
		return true;
	}
	
	public SQLiteDatabase getDb() {
		return mDb;
	}

	public void close() {
		mDbHelper.close();
		mDb.close();
	}
	public ArrayList<FamilyMember> getAllFamilyMembers() {
		ArrayList<FamilyMember> retData = new ArrayList<FamilyMember>();
		String query = "select family_id, f_name, image, ordernum from tb_FamilyMember";
		Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
			for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor
					.isAfterLast()) {
				FamilyMember fm = new FamilyMember();
				fm.setFamilyMemid(mCursor.getInt(0));
				fm.setFamilyMemFName(mCursor.getString(1));
				fm.setFamilyMemImage(mCursor.getString(2));
				fm.setOrderNum(mCursor.getInt(3));
				retData.add(fm);
			}
			mCursor.close();
		}
		return retData;
	}
	
	public String getAllFamilyCSV(){
		String retData = "";
	    String query = "select family_id, f_name,l_name,image,ordernum from tb_FamilyMember";
	    Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
		    for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
                    retData += mCursor.getInt(0) + "," 
                    		+  mCursor.getString(1) + ","
                    		+ mCursor.getString(2) + "," 
                    		+ mCursor.getString(3) + ","
                    		+ mCursor.getInt(4) + "\n"; 
		    }
		    mCursor.close();
		}
	    return retData;
	}
	
	public boolean addFamilyMember(FamilyMember member) {
		String sql = "insert into tb_FamilyMember (f_name,l_name,image,ordernum) values (?,?,?,?)";
		SQLiteStatement insert = mDb.compileStatement(sql);
		insert.bindString(1, member.getFamilyMemFName());
		insert.bindString(2, member.getFamilyMemLName());
		insert.bindString(3, member.getFamilyMemImage());
		insert.bindLong(4, member.getOrderNum());
		boolean k = insert.executeInsert() > 0;
		if (!k) {
			Log.v(TAG, "Error while inserting family member");
		}
		insert.clearBindings();
		insert.close();
		return k;
	}
	
	public int getMaxOrderNumFamilyMember() {
		int retData = 0;
		String query = "select max(ordernum) from tb_FamilyMember";
		Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
			for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor
					.isAfterLast()) {
				retData = mCursor.getInt(0);
			}
			mCursor.close();
		}
		return retData;
	}
	
	public boolean updateFamilyMember(FamilyMember member) {
		ContentValues args = new ContentValues();
		args.put("f_name", member.getFamilyMemFName());
		args.put("l_name", member.getFamilyMemLName());
		args.put("image", member.getFamilyMemImage());
		boolean s = mDb.update("tb_FamilyMember", args,
				"family_id=" + member.getFamilyMemid(), null) > 0;
		if (!s) {
			Log.v(TAG,
					"Error while updating family member:"
							+ member.getFamilyMemid());
		}
		return s;
	}

	public FamilyMember getFamilyMemberById(int id) {
		FamilyMember retData = null;
		String query = "select f_name, l_name, image from tb_FamilyMember where family_id = '"
				+ id + "'";
		Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
			for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor
					.isAfterLast()) {
				retData = new FamilyMember();
				retData.setFamilyMemid(id);
				retData.setFamilyMemFName(mCursor.getString(0));
				retData.setFamilyMemLName(mCursor.getString(1));
				retData.setFamilyMemImage(mCursor.getString(2));
			}
			mCursor.close();
		}
		return retData;
	}
	
	public boolean deleteAllFamilyMembers() {
		String query = "select image from tb_FamilyMember";
	    Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
		    for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
	    	    Utils.deleteFile(mCursor.getString(0));
		    }
		    mCursor.close();
		}
	    boolean s = mDb.delete("tb_FamilyMember", "", null) > 0;
		if (!s) {
			Log.v(TAG, "Error while deleting all family members: ");
		}
		return s;
	}
	
	public int getFamilyMemberCount(){
		int retData = 0;
	    String query = "select count(*) from tb_FamilyMember";
	    Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
		    for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
                  retData = mCursor.getInt(0); 
		    }
		    mCursor.close();
		}
	    return retData;
	}
	
	public ArrayList<String> getAllFamilyMemberFileNames(){
		ArrayList<String> retData = new ArrayList<String>();
	    String query = "select image from tb_FamilyMember";
	    Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
		    for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
    			retData.add(FamilyHealthApplication.PATH + File.separator +mCursor.getString(0));
		    }
		    mCursor.close();
		}
	    return retData;
	}
	
	
	
	 
	public boolean deleteFamilyMember(int id) {
		String query = "select id from MedicalHistory where family_id = " + id;
		Cursor mCursor1 = mDb.rawQuery(query, null);
		if (mCursor1 != null) {
		    for (mCursor1.isBeforeFirst(); mCursor1.moveToNext(); mCursor1.isAfterLast()) {
	    	    deleteMedicalHistory(mCursor1.getInt(0));
		    }
		    mCursor1.close();
		}
	    
		String query1 = "select image from tb_FamilyMember where family_id = " + id;
	    Cursor mCursor = mDb.rawQuery(query1, null);
		if (mCursor != null) {
		    for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
	    	    Utils.deleteFile(mCursor.getString(0));
		    }
		    mCursor.close();
		}
	    
		boolean s = mDb.delete("tb_FamilyMember", "family_id=" + id, null) > 0;
		if (!s) {
			Log.v(TAG, "Error while deleting family member: " + id);
		}
		return s;
	}
	
	public boolean updateFamilyOrder(FamilyMember m1, FamilyMember m2) {
		ContentValues args = new ContentValues();
		args.put("ordernum", m1.getOrderNum());
		boolean s = mDb.update("tb_FamilyMember", args, "family_id=" + m1.getFamilyMemid(), null) > 0;
		if (!s) {
			Log.v(TAG, "Error while archiving medical history: " + m1.getFamilyMemid());
		}
		args = new ContentValues();
		args.put("ordernum", m2.getOrderNum());
		boolean s1 = mDb.update("tb_FamilyMember", args, "family_id=" + m2.getFamilyMemid(), null) > 0;
		if (!s1) {
			Log.v(TAG, "Error while archiving medical history: " + m2.getFamilyMemid());
		}
		return s && s1;
	}
	
	
	
	
	public int getMaxOrderNumMedicalHistory() {
		int retData = 0;
		String query = "select max(ordernum) from MedicalHistory";
		Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
			for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor
					.isAfterLast()) {
				retData = mCursor.getInt(0);
			}
			mCursor.close();
		}
		return retData;
	}
	
	public int getCountMedicalHistory(int type) {
		int retData = 0;
		String query = "select count(*) from MedicalHistory where medicaldatatype_id = '" + type + "'";
		Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
			for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor
					.isAfterLast()) {
				retData = mCursor.getInt(0);
			}
			mCursor.close();
		}
		return retData;
	}
	
	public boolean insertMedicalHistory(MedicalHistory mh) {
		String sql = "insert into MedicalHistory (family_id, data, module_id, medicaldatatype_id, archive, created_date, modify_date, title, ordernum)" +
				" values(?,?,?,?,?,?,?,?,?)";
		SQLiteStatement insert = mDb.compileStatement(sql);
		insert.bindLong(1, mh.getFamilyId());
		insert.bindString(2, mh.getData());
		insert.bindLong(3, mh.getModuleId());
		insert.bindLong(4, mh.getMedicaldatatypeId());
		insert.bindLong(5, mh.getArchive()?1:0);
		insert.bindString(6, mh.getCreatedDate());
		insert.bindString(7, mh.getModifyDate());
		insert.bindString(8, mh.getTitle());
		insert.bindLong(9, mh.getOrderNum());
		boolean k = insert.executeInsert() > 0;
		if (!k) {
			Log.v(TAG, "Error while inserting family member");
		}
		insert.clearBindings();
		insert.close();
		return k;
	}
	
	public ArrayList<MedicalHistory> getMedicalHistoryList(int memberid, int moduleId){
		ArrayList<MedicalHistory> retData = new ArrayList<MedicalHistory>();
	    String query = "select id, data , medicaldatatype_id , archive , title, ordernum  from MedicalHistory where family_id = '" + memberid + "' and module_id = '" +  moduleId +"'";
	    Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
		    for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
                    MedicalHistory me_data = new MedicalHistory();
                    me_data.setFamilyId(memberid);
                    me_data.setModuleId(moduleId);
                    me_data.setId(mCursor.getInt(0));
                    me_data.setData(mCursor.getString(1));
                    me_data.setMedicaldatatypeId(mCursor.getInt(2));
                    me_data.setArchive(mCursor.getInt(3) == 1?true:false);
                    me_data.setTitle(mCursor.getString(4));
                    me_data.setOrderNum(mCursor.getInt(5));
                    retData.add(me_data);
		    }
		    mCursor.close();
		}
	    return retData;
	}
	
	public String getAllFamilyHistories(){
		String retData = "";
	    String query = "select m.modify_date, t.f_name, mt.Module_data, m.title from MedicalHistory m, tb_FamilyMember t,Module_table mt where m.family_id = t.family_id and m.module_id = mt.module_id order by m.ordernum";
	    Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
		    for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
		    	DateFormat df = new SimpleDateFormat("EEE MMM dd HH:mm:ss zzz yyyy");
				DateFormat df1 = new SimpleDateFormat("MMMMM dd, yyyy HH:mm::ss aaa");
				try {
					Date dated = (Date)df.parse(mCursor.getString(0));
					retData += df1.format(dated) + "<br/>FH " +  mCursor.getString(1) + ": " 
                    		+ mCursor.getString(2) + "<br/>FH Title: " + mCursor.getString(3) + "<br/><br/>";
				} catch (ParseException e) {
					Log.e(TAG, e.toString());
					e.printStackTrace();
				}
		    }
		    mCursor.close();
		}
	    return retData;
	}
	
	public String getAllFamilyHistoriesCSV(){
		String retData = "";
	    String query = "select id, family_id, data, module_id, medicaldatatype_id, archive, created_date, modify_date, title, ordernum from MedicalHistory";
	    Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
		    for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
                    retData += mCursor.getInt(0) + "," 
                    		+  mCursor.getInt(1) + ","
                    		+ mCursor.getString(2) + "," 
                    		+ mCursor.getInt(3) + ","
                    		+ mCursor.getInt(4) + ","
                    		+ mCursor.getInt(5) + ","
                    		+ mCursor.getString(6) + ","
                    		+ mCursor.getString(7) + ","
                    		+ mCursor.getString(8) + ","
                    		+ mCursor.getInt(9) + "\n"; 
		    }
		    mCursor.close();
		}
	    return retData;
	}
	
	public ArrayList<String> getAllMedicalHistoryFileNames(){
		ArrayList<String> retData = new ArrayList<String>();
	    String query = "select data, medicaldatatype_id  from MedicalHistory";
	    Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
		    for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
		    	if(mCursor.getInt(1) == FamilyHealthApplication.AUDIO || mCursor.getInt(1) == FamilyHealthApplication.VIDEO) {
		    		String xsplit = mCursor.getString(0);
		    		String[] xt = xsplit.split("--OV--");
		    		for(int i=0;i<xt.length;i++){
						String[] ysplit = xt[i].split(":");
						retData.add(FamilyHealthApplication.PATH + File.separator + ysplit[0]);
					}
		    	} else {
		    		retData.add(FamilyHealthApplication.PATH + File.separator +mCursor.getString(0));
		    	}
		    }
		    mCursor.close();
		}
		retData.add(FamilyHealthApplication.PATH + File.separator + FamilyHealthApplication.FILENAMECSV);
		retData.add(FamilyHealthApplication.PATH + File.separator + FamilyHealthApplication.FAMILYFILENAMECSV);
	    return retData;
	}
	
	
	public boolean deleteMedicalHistory(int id) {
		String query = "select data, medicaldatatype_id from MedicalHistory where id = " + id;
	    Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
		    for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
		    	if(mCursor.getInt(1) == FamilyHealthApplication.AUDIO || mCursor.getInt(1) == FamilyHealthApplication.VIDEO) {
		    		String[] xsplit = mCursor.getString(0).split("--OV--");
					for(int i=0;i<xsplit.length;i++){
						String[] ysplit = xsplit[i].split(":");
						Utils.deleteFile(ysplit[0]);
					}
		    	} else {
		    	    Utils.deleteFile(mCursor.getString(0));
		    	}
		    }
		    mCursor.close();
		}
	    
		boolean s = mDb.delete("MedicalHistory", "id=" + id, null) > 0;
		if (!s) {
			Log.v(TAG, "Error while deleting medicalhistory: " + id);
		}
		return s;
	}
	
	
	
	public boolean deleteAllFamilyHistories() {
		String query = "select data,medicaldatatype_id  from MedicalHistory";
	    Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
		    for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor.isAfterLast()) {
		    	if(mCursor.getInt(1) == FamilyHealthApplication.AUDIO || mCursor.getInt(1) == FamilyHealthApplication.VIDEO) {
		    		String[] xsplit = mCursor.getString(0).split("--OV--");
					for(int i=0;i<xsplit.length;i++){
						String[] ysplit = xsplit[i].split(":");
						Utils.deleteFile(ysplit[0]);
					}
		    	} else {
		    	    Utils.deleteFile(mCursor.getString(0));
		    	}
		    }
		    mCursor.close();
		}
	    boolean s = mDb.delete("MedicalHistory", "", null) > 0;
		if (!s) {
			Log.v(TAG, "Error while deleting all medicalhistory: ");
		}
		return s;
	}
	
	
	
	public boolean archiveMedicalHistory(boolean archive, int id) {
		ContentValues args = new ContentValues();
		args.put("archive", archive?1:0);
		boolean s = mDb.update("MedicalHistory", args, "id=" + id, null) > 0;
		if (!s) {
			Log.v(TAG, "Error while archiving medical history: " + id);
		}
		return s;
	}
	
	public boolean updateMedicalHistory(int id, String title,String mdate) {
		ContentValues args = new ContentValues();
		args.put("title", title);
		args.put("modify_date", mdate);
		boolean s = mDb.update("MedicalHistory", args, "id=" + id, null) > 0;
		if (!s) {
			Log.v(TAG, "Error while archiving medical history: " + id);
		}
		return s;
	}
	
	public boolean updateMedicalHistoryAudio(int id, String title,String mdate, String data) {
		ContentValues args = new ContentValues();
		args.put("title", title);
		args.put("data", data);
		args.put("modify_date", mdate);
		boolean s = mDb.update("MedicalHistory", args, "id=" + id, null) > 0;
		if (!s) {
			Log.v(TAG, "Error while archiving medical history: " + id);
		}
		return s;
	}
	
	public boolean updateMedicalHistoryOrder(MedicalHistory m1, MedicalHistory m2) {
		ContentValues args = new ContentValues();
		args.put("ordernum", m1.getOrderNum());
		boolean s = mDb.update("MedicalHistory", args, "id=" + m1.getId(), null) > 0;
		if (!s) {
			Log.v(TAG, "Error while archiving medical history: " + m1.getId());
		}
		args = new ContentValues();
		args.put("ordernum", m2.getOrderNum());
		boolean s1 = mDb.update("MedicalHistory", args, "id=" + m2.getId(), null) > 0;
		if (!s1) {
			Log.v(TAG, "Error while archiving medical history: " + m2.getId());
		}
		return s && s1;
	}
	
	public boolean insertBackup(BackupRestore res) {
		String sql = "insert into backupmed (datemed, revisions, notes, pics, voice, files, videos, drawings) values (?,?,?,?,?,?,?,?)";
		SQLiteStatement insert = mDb.compileStatement(sql);
		insert.bindString(1, res.getDateMed());
		insert.bindString(2, res.getRevision());
		insert.bindLong(3, res.getNotes());
		insert.bindLong(4, res.getPics());
		insert.bindLong(5, res.getVoice());
		insert.bindLong(6, res.getFiles());
		insert.bindLong(7, res.getVideos());
		insert.bindLong(8, res.getDrawings());
		boolean k = insert.executeInsert() > 0;
		if (!k) {
			Log.v(TAG, "Error while inserting family member");
		}
		insert.clearBindings();
		insert.close();
		return k;
	}
	
	public ArrayList<BackupRestore> getRestoreList() {
		ArrayList<BackupRestore> retData = new ArrayList<BackupRestore>();
		String query = "select id, datemed, revisions, notes, pics, voice,files, videos, drawings  from backupmed";
		Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
			for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor
					.isAfterLast()) {
				BackupRestore res = new BackupRestore();
				res.setId(mCursor.getInt(0));
				res.setDateMed(mCursor.getString(1));
				res.setRevision(mCursor.getString(2));
				res.setNotes(mCursor.getInt(3));
				res.setPics(mCursor.getInt(4));
				res.setVoice(mCursor.getInt(5));
				res.setFiles(mCursor.getInt(6));
				res.setVideos(mCursor.getInt(7));
				res.setDrawings(mCursor.getInt(8));
				retData.add(res);
			}
			mCursor.close();
		}
		return retData;
	}
	
	public boolean deleteBackupRestore(int id) {
		boolean s = mDb.delete("backupmed", "id=" + id, null) > 0;
		if (!s) {
			Log.v(TAG, "Error while deleting backuphistory: " + id);
		}
		return s;
	}
	
	public ArrayList<ModuleData> getModuleList(int enabled) {
		ArrayList<ModuleData> retData = new ArrayList<ModuleData>();
		String query = "select Module_data, module_id, order_data, enable from Module_table";
		Cursor mCursor = mDb.rawQuery(query, null);
		if (mCursor != null) {
			for (mCursor.isBeforeFirst(); mCursor.moveToNext(); mCursor
					.isAfterLast()) {
				ModuleData module_dataname = new ModuleData();
				module_dataname.setName(mCursor.getString(0));
				module_dataname.setId(mCursor.getInt(1));
				module_dataname.setOrder(mCursor.getInt(2));
				module_dataname.setEnable(mCursor.getInt(3)==1?true:false);
				retData.add(module_dataname);
			}
			mCursor.close();
		}
		return retData;
	}

	public boolean updateModule(int id, int enable) {
		ContentValues args = new ContentValues();
		args.put("enable", enable);
		boolean s = mDb.update("Module_table", args, "module_id=" + id, null) > 0;
		if (!s) {
			Log.v(TAG, "Error while updating module: " + id);
		}
		return s;
	}
	
	public boolean updateModuleOrder(int id, int order) {
		ContentValues args = new ContentValues();
		args.put("order_data", order);
		boolean s = mDb.update("Module_table", args, "module_id=" + id, null) > 0;
		if (!s) {
			Log.v(TAG, "Error while updating module: " + id);
		}
		return s;
	}
	
	private static class DatabaseHelper extends SQLiteOpenHelper {

		DatabaseHelper(Context context) {
			super(context, DATABASE_NAME, null, DATABASE_VERSION);
		}

		@Override
		public void onCreate(SQLiteDatabase db) {
			db.execSQL("CREATE TABLE MedicalHistory (ordernum NUMERIC, id INTEGER PRIMARY KEY, family_id NUMERIC, data TEXT, module_id NUMERIC, medicaldatatype_id NUMERIC, archive NUMERIC, created_date TEXT, modify_date TEXT, title TEXT)");
			db.execSQL("CREATE TABLE Medical_Data (medicaldatatype_id NUMERIC, medicaldata_name TEXT)");
			db.execSQL("CREATE TABLE Module_table (Module_data TEXT, module_id INTEGER PRIMARY KEY, enable NUMERIC, order_data NUMERIC)");
			db.execSQL("CREATE TABLE backupmed (drawings NUMERIC, videos NUMERIC, files NUMERIC, voice NUMERIC, pics NUMERIC, notes NUMERIC, revisions TEXT, datemed TEXT, id INTEGER PRIMARY KEY)");
			db.execSQL("CREATE TABLE tb_FamilyMember (ordernum NUMERIC, family_id INTEGER PRIMARY KEY, f_name TEXT, l_name TEXT, image TEXT)");
			db.execSQL("INSERT INTO Medical_Data VALUES(1,'text')");
			db.execSQL("INSERT INTO Medical_Data VALUES(2,'audio')");
			db.execSQL("INSERT INTO Medical_Data VALUES(3,'image')");
			db.execSQL("INSERT INTO Medical_Data VALUES(4,'file')");
			db.execSQL("INSERT INTO Medical_Data VALUES(5,'video')");
			db.execSQL("INSERT INTO Medical_Data VALUES(6,'drawing')");
			db.execSQL("INSERT INTO Module_table VALUES('Demographics ,DOB ,etc',1,1,0)");
			db.execSQL("INSERT INTO Module_table VALUES('Insurance Cards',2,1,1)");
			db.execSQL("INSERT INTO Module_table VALUES('Doctor,Dentist,Clinics',3,1,2)");
			db.execSQL("INSERT INTO Module_table VALUES('Appointments',4,1,3)");
			db.execSQL("INSERT INTO Module_table VALUES('Medications',5,1,4)");
			db.execSQL("INSERT INTO Module_table VALUES('Immunization Records',6,1,5)");
			db.execSQL("INSERT INTO Module_table VALUES('Allergies',7,1,6)");
			db.execSQL("INSERT INTO Module_table VALUES('Problems / Diagnoses',8,1,7)");
			db.execSQL("INSERT INTO Module_table VALUES('Lab Results',9,1,8)");
			db.execSQL("INSERT INTO Module_table VALUES('Radiology Results',10,1,9)");
			db.execSQL("INSERT INTO Module_table VALUES('Clinical Notes',11,1,10)");
			db.execSQL("INSERT INTO Module_table VALUES('Consult Referrals',12,1,11)");
			db.execSQL("INSERT INTO Module_table VALUES('Other',13,1,12)");
		}
    	@Override
		public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
			Log.w(TAG, "Upgrading database from version " + oldVersion + " to "
					+ newVersion + ", which will destroy all old data");
			/*db.execSQL("DROP TABLE IF EXISTS " + DETAIL_TABLE);
			db.execSQL("DROP TABLE IF EXISTS " + TYPE_TABLE);
			db.execSQL("DROP TABLE IF EXISTS " + NOTE_TABLE);
			
			onCreate(db);*/
		}

	}

}
