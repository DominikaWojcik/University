package com.entities;

import java.io.Serializable;

import javax.persistence.Embeddable;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;

@Embeddable
public class BikePlaceId implements Serializable
{
	@OneToOne
	@JoinColumn
	private Bike bike;
	
	@ManyToOne
	@JoinColumn
	private Place place;
	
	public boolean equals(Object o) 
	{
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        BikePlaceId that = (BikePlaceId) o;

        if (bike != null ? !bike.equals(that.bike) : that.bike != null) return false;
        if (place != null ? !place.equals(that.place) : that.place != null)
            return false;

        return true;
    }
	
	public int hashCode() 
	{
        int result;
        result = (bike != null ? bike.hashCode() : 0);
        result = 31 * result + (place != null ? place.hashCode() : 0);
        return result;
    }

	public Bike getBike()
	{
		return bike;
	}

	public void setBike(Bike bike)
	{
		this.bike = bike;
	}

	public Place getPlace()
	{
		return place;
	}

	public void setPlace(Place place)
	{
		this.place = place;
	}
}
