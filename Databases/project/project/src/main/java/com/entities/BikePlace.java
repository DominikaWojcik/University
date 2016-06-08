package com.entities;

import java.sql.Date;
import java.sql.Timestamp;

import javax.persistence.AssociationOverride;
import javax.persistence.AssociationOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "rower_miejsce")
@AssociationOverrides({
		@AssociationOverride(name = "pk.bike", 
			joinColumns = @JoinColumn(name = "rower_id")),
		@AssociationOverride(name = "pk.place", 
			joinColumns = @JoinColumn(name = "miejsce_id")) })
public class BikePlace
{
	@EmbeddedId
	BikePlaceId pk = new BikePlaceId();
	 
	@Column(name = "stanowisko")
	private Integer position;
	
	@Column(name = "od_kiedy")
	private Timestamp sinceWhen;
	
	public Bike getBike()
	{
		return pk.getBike();
	}

	public void setBike(Bike bike)
	{
		pk.setBike(bike);
	}

	public Place getPlace()
	{
		return pk.getPlace();
	}

	public void setPlace(Place place)
	{
		pk.setPlace(place);
	}

	public Integer getPosition()
	{
		return position;
	}

	public void setPosition(Integer position)
	{
		this.position = position;
	}

	public Timestamp getSinceWhen()
	{
		return sinceWhen;
	}

	public void setSinceWhen(Timestamp sinceWhen)
	{
		this.sinceWhen = sinceWhen;
	}
}
