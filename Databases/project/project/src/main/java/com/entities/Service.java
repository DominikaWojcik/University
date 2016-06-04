package com.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

@Entity
@Table(name = "serwis")
@PrimaryKeyJoinColumn(name = "id", referencedColumnName = "id")
public class Service extends Place
{
	@Column(name = "telefon", nullable = false)
	public String tel;

	public String getTel()
	{
		return tel;
	}

	public void setTel(String tel)
	{
		this.tel = tel;
	}
}
