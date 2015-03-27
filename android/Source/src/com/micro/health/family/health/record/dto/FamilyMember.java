package com.micro.health.family.health.record.dto;

public class FamilyMember implements Comparable<FamilyMember> {
	private int familyMemid;
	private String familyMemFName;
	private String familyMemLName;
	private String familyMemImage;
	private int orderNum;
	
	public FamilyMember() {
	}
	
	
	
	public FamilyMember(String familyMemFName,
			String familyMemLName, String familyMemImage) {
		super();
		this.familyMemFName = familyMemFName;
		this.familyMemLName = familyMemLName;
		this.familyMemImage = familyMemImage;
	}
	
	public FamilyMember(String familyMemFName,
			String familyMemLName) {
		super();
		this.familyMemFName = familyMemFName;
		this.familyMemLName = familyMemLName;
	}
	
	public FamilyMember(String familyMemFName,
			String familyMemLName, String familyMemImage, int orderNum) {
		super();
		this.familyMemFName = familyMemFName;
		this.familyMemLName = familyMemLName;
		this.familyMemImage = familyMemImage;
		this.orderNum = orderNum;
	}
	
	
	public FamilyMember(int familyMemid, String familyMemFName,
			String familyMemLName, String familyMemImage) {
		super();
		this.familyMemid = familyMemid;
		this.familyMemFName = familyMemFName;
		this.familyMemLName = familyMemLName;
		this.familyMemImage = familyMemImage;
	}
	
	public FamilyMember(int familyMemid, String familyMemFName,
			String familyMemLName) {
		super();
		this.familyMemid = familyMemid;
		this.familyMemFName = familyMemFName;
		this.familyMemLName = familyMemLName;
	}
	
	
	public FamilyMember(int familyMemid, String familyMemFName,
			String familyMemLName, String familyMemImage, int orderNum) {
		super();
		this.familyMemid = familyMemid;
		this.familyMemFName = familyMemFName;
		this.familyMemLName = familyMemLName;
		this.familyMemImage = familyMemImage;
		this.orderNum = orderNum;
	}

	public int getFamilyMemid() {
		return familyMemid;
	}
	public void setFamilyMemid(int familyMemid) {
		this.familyMemid = familyMemid;
	}
	public String getFamilyMemFName() {
		return familyMemFName;
	}
	public void setFamilyMemFName(String familyMemFName) {
		this.familyMemFName = familyMemFName;
	}
	public String getFamilyMemLName() {
		return familyMemLName;
	}
	public void setFamilyMemLName(String familyMemLName) {
		this.familyMemLName = familyMemLName;
	}
	public String getFamilyMemImage() {
		return familyMemImage;
	}
	public void setFamilyMemImage(String familyMemImage) {
		this.familyMemImage = familyMemImage;
	}
	
	public int getOrderNum() {
		return orderNum;
	}

	public void setOrderNum(int orderNum) {
		this.orderNum = orderNum;
	}

	@Override
	public String toString() {
		return "FamilyMember [familyMemid=" + familyMemid + ", familyMemFName="
				+ familyMemFName + ", familyMemLName=" + familyMemLName
				+ ", familyMemImage=" + familyMemImage + ", orderNum="
				+ orderNum + "]";
	}
	
	@Override
	public int compareTo(FamilyMember another) {
		if (!(another instanceof FamilyMember)) {
			throw new ClassCastException("Invalid object");
		} else {
			int i1 = this.orderNum;
			int i2 = ((FamilyMember) another).orderNum;
			if (i1 == i2)
                return 0;
			else if (i1 > i2)
                return 1;
			else
                return -1;
		}
	}
	
	
	
	
}
