package com.entities;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Filter;
import org.hibernate.annotations.FilterDef;
import org.hibernate.annotations.FilterDefs;
import org.hibernate.annotations.Filters;

@Entity
@Table(name="uzytkownik")
@FilterDefs({@FilterDef(name = "notDeletedUsers")})
@Filters({@Filter(name = "notDeletedUsers", condition = "aktywny = true")})
public class User 
{
	@Id
	@SequenceGenerator(name="uzytkownik_id_seq", sequenceName="uzytkownik_id_seq", allocationSize=1)
	@GeneratedValue(strategy=GenerationType.SEQUENCE, generator="uzytkownik_id_seq")
	@Column(name="id", nullable=false)
	private int id;

	@Column(name="imie", nullable=false, length=16)
	private String name;
	
	@Column(name="nazwisko", nullable=false, length=32)
	private String lastName;
	
	@Column(name="adres", nullable=false)
	private String address;
	
	@Column(name="kod_pocztowy", length=8)
	private String postalCode;
	
	@Column(name="miejscowosc", nullable=false, length=32)
	private String city;
	
	@Column(name="kraj", nullable=false, length=32)
	private String country;
	
	@Column(name="email", nullable=false, unique=true)
	private String email;
	
	@Column(name="telefon", nullable=false, length=16, unique=true)
	private String tel;
	
	@Column(name="aktywny", nullable=false)
	private boolean active;
	
	@Column(name="rodzaj")
	private String type;
	
	@Column(name="data_rejestracji", nullable=false)
	private Timestamp registrationDate;

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public String getLastName()
	{
		return lastName;
	}

	public void setLastName(String lastName)
	{
		this.lastName = lastName;
	}

	public String getAddress()
	{
		return address;
	}

	public void setAddress(String address)
	{
		this.address = address;
	}

	public String getPostalCode()
	{
		return postalCode;
	}

	public void setPostalCode(String postalCode)
	{
		this.postalCode = postalCode;
	}

	public String getCity()
	{
		return city;
	}

	public void setCity(String city)
	{
		this.city = city;
	}

	public String getCountry()
	{
		return country;
	}

	public void setCountry(String country)
	{
		this.country = country;
	}

	public String getEmail()
	{
		return email;
	}

	public void setEmail(String email)
	{
		this.email = email;
	}

	public String getTel()
	{
		return tel;
	}

	public void setTel(String tel)
	{
		this.tel = tel;
	}

	public boolean isActive()
	{
		return active;
	}
	
	public void setActive(boolean b)
	{
		active = b;
	}

	public String getType()
	{
		return type;
	}

	public void setType(String type)
	{
		this.type = type;
	}

	public Timestamp getRegistrationDate()
	{
		return registrationDate;
	}

	public void setRegistrationDate(Timestamp registrationDate)
	{
		this.registrationDate = registrationDate;
	}

	public void update(User newInfo)
	{
		name = newInfo.getName();
		lastName = newInfo.getLastName();
		address = newInfo.getAddress();
		postalCode = newInfo.getPostalCode();
		city = newInfo.getCity();
		country = newInfo.getCountry();
		email = newInfo.getEmail();
	}
}
