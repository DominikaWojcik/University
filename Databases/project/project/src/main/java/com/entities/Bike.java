package com.entities;

import java.sql.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinTable;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name="rower")
public class Bike
{
	@Id
	@SequenceGenerator(name="rower_id_seq", sequenceName="rower_id_seq", allocationSize=1)
	@GeneratedValue(strategy=GenerationType.SEQUENCE, generator="rower_id_seq")
	@Column(name="id", nullable=false)
	private int id;
	
	@Column(name="marka", nullable=false, length=16)
	private String brand;
	
	@Column(name="model", length=16)
	private String model;
	
	@Column(name="data_zakupu", nullable=false)
	private Date purchaseDate;
	
	@OneToOne(fetch = FetchType.LAZY, mappedBy = "pk.bike", cascade = CascadeType.ALL)
	private BikePlace place; 

	@Override
	public String toString()
	{
		return "#" + Integer.toString(id) + ": " + brand + (model == null ? "" : " " + model);
	}
	
	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getBrand()
	{
		return brand;
	}

	public void setBrand(String brand)
	{
		this.brand = brand;
	}

	public String getModel()
	{
		return model;
	}

	public void setModel(String model)
	{
		this.model = model;
	}

	public Date getPurchaseDate()
	{
		return purchaseDate;
	}

	public void setPurchaseDate(Date purchaseDate)
	{
		this.purchaseDate = purchaseDate;
	}

	public BikePlace getPlace()
	{
		return place;
	}

	public void setPlace(BikePlace place)
	{
		this.place = place;
	}

}
