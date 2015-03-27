package com.micro.health.family.health.record.dto;

import java.io.Serializable;


public class ModuleData implements Comparable<ModuleData>, Serializable{

	private static final long serialVersionUID = -1934546275286433122L;
	
	private int id;
	private String name;
	private int order;
	private boolean enable;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public boolean getEnable() {
		return enable;
	}

	public void setEnable(boolean enable) {
		this.enable = enable;
	}

	@Override
	public int compareTo(ModuleData another) {
		if (!(another instanceof ModuleData)) {
			throw new ClassCastException("Invalid object");
		} else {
			int i1 = this.order;
			int i2 = ((ModuleData) another).order;
			if (i1 == i2)
                return 0;
			else if (i1 > i2)
                return 1;
			else
                return -1;
		}
	}

}
