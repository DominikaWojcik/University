package com.entities;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Filter;
import org.hibernate.annotations.FilterDef;
import org.hibernate.annotations.FilterDefs;
import org.hibernate.annotations.Filters;

import java.util.Set;

@Entity
@Table(name = "miejsce")
@Inheritance(strategy=InheritanceType.JOINED)
@FilterDefs({@FilterDef(name = "notDeletedPlaces")})
@Filters({@Filter(name = "notDeletedPlaces", condition = "aktywny = true")})
public class Place
{
	@Id
	@SequenceGenerator(name="miejsce_id_seq", sequenceName="miejsce_id_seq", allocationSize=1)
	@GeneratedValue(strategy=GenerationType.SEQUENCE, generator="miejsce_id_seq")
	@Column(name = "id", nullable = false)
	private int id;
	
	@Column(name = "adres", nullable = false)
	private String address;
	
	@Column(name = "kod_pocztowy", length = 8)
	private String postalCode;
	
	@Column(name = "miejscowosc", nullable = false, length = 32)
	private String city;
	
	@Column(name = "kraj", nullable = false, length = 32)
	private String country;
	
	@Column(name = "rodzaj")
	private String type;
	
	@Column(name = "aktywny")
	private boolean active;
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "pk.place", cascade = CascadeType.ALL)
	private Set<BikePlace> bikes;

	@Override
	public String toString()
	{
		return address + ", " + city + ", " + country;
	}
	
	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
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

	public String getType()
	{
		return type;
	}

	public void setType(String type)
	{
		this.type = type;
	}

	public Set<BikePlace> getBikes()
	{
		return bikes;
	}

	public void setBikes(Set<BikePlace> bikes)
	{
		this.bikes = bikes;
	}

	public boolean isActive()
	{
		return active;
	}
	
	public void setActive(boolean b)
	{
		active = b;
	}
}
