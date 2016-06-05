package com.businessLogic;

import com.entities.Place;

public class PlaceSelection
{
	private Place place;
	private String placeName;
	
	public PlaceSelection() {	}
	public PlaceSelection(Place place)
	{
		this.place = place;
		this.placeName = place.toString();
	}
	
	public Place getPlace()
	{
		return place;
	}
	
	public void setPlace(Place place)
	{
		this.place = place;
	}
	
	public String getPlaceName()
	{
		return placeName;
	}
	
	public void setPlaceName(String placeName)
	{
		this.placeName = placeName;
	}
	
	public String toString()
	{
		return placeName;
	}
}
