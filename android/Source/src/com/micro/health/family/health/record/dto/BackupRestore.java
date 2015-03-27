package com.micro.health.family.health.record.dto;

public class BackupRestore implements Comparable<BackupRestore> {
	private int id;
	private String dateMed;
	private String revision;
	private int notes;
	private int pics;
	private int voice;
	private int files;
	private int videos;
	private int drawings;
	
	public BackupRestore() {
	}
	
		
	public BackupRestore(int id, String dateMed, String revision, int notes,
			int pics, int voice,int files) {
		super();
		this.id = id;
		this.dateMed = dateMed;
		this.revision = revision;
		this.notes = notes;
		this.pics = pics;
		this.voice = voice;
		this.files = files;
	}

	public int getId() {
		return id;
	}


	public String getDateMed() {
		return dateMed;
	}


	public String getRevision() {
		return revision;
	}


	public int getNotes() {
		return notes;
	}


	public int getPics() {
		return pics;
	}


	public int getVoice() {
		return voice;
	}


	public void setId(int id) {
		this.id = id;
	}


	public void setDateMed(String dateMed) {
		this.dateMed = dateMed;
	}


	public void setRevision(String revision) {
		this.revision = revision;
	}


	public void setNotes(int notes) {
		this.notes = notes;
	}


	public void setPics(int pics) {
		this.pics = pics;
	}


	public void setVoice(int voice) {
		this.voice = voice;
	}
	
	
	public int getFiles() {
		return files;
	}


	public void setFiles(int files) {
		this.files = files;
	}

	public int getVideos() {
		return videos;
	}


	public int getDrawings() {
		return drawings;
	}


	public void setVideos(int videos) {
		this.videos = videos;
	}


	public void setDrawings(int drawings) {
		this.drawings = drawings;
	}


	@Override
	public String toString() {
		return "BackupRestore [id=" + id + ", dateMed=" + dateMed
				+ ", revision=" + revision + ", notes=" + notes + ", pics="
				+ pics + ", voice=" + voice + ", files=" + files + ", videos="
				+ videos + ", drawings=" + drawings + "]";
	}


	@Override
	public int compareTo(BackupRestore another) {
		if (!(another instanceof BackupRestore)) {
			throw new ClassCastException("Invalid object");
		} else {
			int i1 = this.id;
			int i2 = ((BackupRestore) another).id;
			if (i1 == i2)
                return 0;
			else if (i1 > i2)
                return 1;
			else
                return -1;
		}
	}
	
	
	
	
}
