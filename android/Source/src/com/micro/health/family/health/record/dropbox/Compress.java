package com.micro.health.family.health.record.dropbox;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import android.util.Log;

public class Compress {
	private static final int BUFFER = 2048;
	private static final String TAG = Compress.class.getCanonicalName();
	
	private ArrayList<String> _files;
	private String _zipFile;

	public Compress(ArrayList<String> files, String zipFile) {
		_files = files;
		_zipFile = zipFile;
	}

	public void zip() {
		try {
			BufferedInputStream origin = null;
			FileOutputStream dest = new FileOutputStream(_zipFile);

			ZipOutputStream out = new ZipOutputStream(new BufferedOutputStream(dest));

			byte data[] = new byte[BUFFER];

			for (int i = 0; i < _files.size(); i++) {
				FileInputStream fi = new FileInputStream(_files.get(i));
				origin = new BufferedInputStream(fi, BUFFER);
				ZipEntry entry = new ZipEntry(_files.get(i).substring(_files.get(i).lastIndexOf("/") + 1));
				out.putNextEntry(entry);
				int count;
				while ((count = origin.read(data, 0, BUFFER)) != -1) {
					out.write(data, 0, count);
				}
				origin.close();
			}

			out.close();
		} catch (Exception e) {
			Log.e(TAG, e.toString());
			e.printStackTrace();
		}

	}

}
