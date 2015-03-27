package com.micro.health.family.health.record.dto;

import java.io.Serializable;


public class MedicalHistory implements Comparable<MedicalHistory>, Serializable {

	private static final long serialVersionUID = -5697524067168290429L;
	private int id;
    private int familyId;
    private String data;
    private int moduleId;
    private int medicaldatatypeId;
    private boolean archive;
    private String createdDate;
    private String modifyDate;
    private String title;
    private int orderNum;
    
    public MedicalHistory() {
	}
	
	public MedicalHistory(int id, int familyId, String data, int moduleId,
			int medicaldatatypeId, boolean archive, String createdDate,
			String modifyDate, String title, int orderNum) {
		super();
		this.id = id;
		this.familyId = familyId;
		this.data = data;
		this.moduleId = moduleId;
		this.medicaldatatypeId = medicaldatatypeId;
		this.archive = archive;
		this.createdDate = createdDate;
		this.modifyDate = modifyDate;
		this.title = title;
		this.orderNum = orderNum;
	}




	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getFamilyId() {
		return familyId;
	}
	public void setFamilyId(int familyId) {
		this.familyId = familyId;
	}
	public String getData() {
		return data;
	}
	public void setData(String data) {
		this.data = data;
	}
	public int getModuleId() {
		return moduleId;
	}
	public void setModuleId(int moduleId) {
		this.moduleId = moduleId;
	}
	public int getMedicaldatatypeId() {
		return medicaldatatypeId;
	}
	public void setMedicaldatatypeId(int medicaldatatypeId) {
		this.medicaldatatypeId = medicaldatatypeId;
	}
	public boolean getArchive() {
		return archive;
	}
	public void setArchive(boolean archive) {
		this.archive = archive;
	}
	public String getCreatedDate() {
		return createdDate;
	}
	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}
	public String getModifyDate() {
		return modifyDate;
	}
	public void setModifyDate(String modifyDate) {
		this.modifyDate = modifyDate;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	
	public int getOrderNum() {
		return orderNum;
	}

	public void setOrderNum(int orderNum) {
		this.orderNum = orderNum;
	}

	@Override
	public int compareTo(MedicalHistory another) {
		if (!(another instanceof MedicalHistory)) {
			throw new ClassCastException("Invalid object");
		} else {
			int i1 = this.orderNum;
			int i2 = ((MedicalHistory) another).orderNum;
			if (i1 == i2)
                return 0;
			else if (i1 > i2)
                return 1;
			else
                return -1;
		}
	}
	
	@Override
	public String toString() {
		return "MedicalHistory [id=" + id + ", familyId=" + familyId
				+ ", data=" + data + ", moduleId=" + moduleId
				+ ", medicaldatatypeId=" + medicaldatatypeId + ", archive="
				+ archive + ", createdDate=" + createdDate + ", modifyDate="
				+ modifyDate + ", title=" + title + ", orderNum=" + orderNum
				+ "]";
	}
   
    
    
}
