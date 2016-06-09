package com.businessLogic;

import com.entities.Service;

public class BikeCreationData
{
	private String brand;
	private String model;
	private Integer serviceId;
	
	public BikeCreationData() {}
	public BikeCreationData(String brand, String model, Integer serviceId)
	{
		this.brand = brand;
		this.model = model;
		this.serviceId = serviceId;
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
	public Integer getServiceId()
	{
		return serviceId;
	}
	public void setServiceId(Integer service)
	{
		this.serviceId = service;
	}
}
