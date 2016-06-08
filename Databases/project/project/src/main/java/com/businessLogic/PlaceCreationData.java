package com.businessLogic;

import com.entities.Place;
import com.entities.Station;
import com.entities.Service;

public class PlaceCreationData
{
	private int id;
	
	private String address;
	
	private String postalCode;
	
	private String city;
	
	private String country;
	
	private String type;
	
	private String tel;
	
	private Integer positionCount;
	
	private boolean active;

	public PlaceCreationData() {	}
	
	public PlaceCreationData(Place p)
	{
		id = p.getId();
		address = p.getAddress();
		postalCode = p.getPostalCode();
		city = p.getCity();
		country = p.getCountry();
		type = p.getType();
		active = p.isActive();
		if(p instanceof Station)
			positionCount = ((Station)p).getPositionCount();
		else tel = ((Service)p).getTel();
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

	public String getTel()
	{
		return tel;
	}

	public void setTel(String tel)
	{
		this.tel = tel;
	}

	public Integer getPositionCount()
	{
		return positionCount;
	}

	public void setPositionCount(Integer positionCount)
	{
		this.positionCount = positionCount;
	}

	public Place toPlace()
	{
		Place toReturn;
		if(type.equals("serwis"))
		{
			toReturn = new Service();
			((Service)toReturn).setTel(tel);
		}
		else 
		{
			toReturn = new Station();
			((Station)toReturn).setPositionCount(positionCount);
		}
		
		toReturn.setId(id);
		toReturn.setAddress(address);
		toReturn.setPostalCode(postalCode);
		toReturn.setCity(city);
		toReturn.setCountry(country);
		toReturn.setType(type);
		
		toReturn.setActive(true);
		return toReturn;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public boolean isActive()
	{
		return active;
	}

	public void setActive(boolean active)
	{
		this.active = active;
	}
}
