package com.entities;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name="wypozyczenie")
public class Rental
{
	@Id
	@SequenceGenerator(name="wypozyczenie_id_seq", sequenceName="wypozyczenie_id_seq", allocationSize=1)
	@GeneratedValue(strategy=GenerationType.SEQUENCE, generator="wypozyczenie_id_seq")
	@Column(nullable = false)
	private int id;	

	@ManyToOne(optional = false)
	@JoinColumn(name = "rower_id")
	private Bike bike;
	
	@ManyToOne(optional = false)
	@JoinColumn(name = "uzytkownik_id")
	private User user;
	
	@ManyToOne(optional = false)
	@JoinColumn(name = "skad")
	private Place startPlace;
	
	@Column(name = "skad_stanowisko")
	private int startPosition;
	
	@ManyToOne
	@JoinColumn(name = "dokad")
	private Place endPlace;
	
	@Column(name = "dokad_stanowisko")
	private int endPosition;
	
	@Column(name = "data_wypozyczenia", nullable = false)
	private Timestamp rentalDate;
	
	@Column(name = "data_zwrotu")
	private Timestamp returnDate;
	
	public Rental() { }
	
	public Rental(User user, Bike bike, Place place, int position, Timestamp timestamp)
	{
		this.user = user;
		this.bike = bike;
		this.startPlace = place;
		this.startPosition = position;
		this.rentalDate = timestamp;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public Bike getBike()
	{
		return bike;
	}

	public void setBike(Bike bike)
	{
		this.bike = bike;
	}

	public User getUser()
	{
		return user;
	}

	public void setUser(User user)
	{
		this.user = user;
	}

	public Place getStartPlace()
	{
		return startPlace;
	}

	public void setStartPlace(Place startPlace)
	{
		this.startPlace = startPlace;
	}

	public int getStartPosition()
	{
		return startPosition;
	}

	public void setStartPosition(int startPosition)
	{
		this.startPosition = startPosition;
	}

	public Place getEndPlace()
	{
		return endPlace;
	}

	public void setEndPlace(Place endPlace)
	{
		this.endPlace = endPlace;
	}

	public int getEndPosition()
	{
		return endPosition;
	}

	public void setEndPosition(int endPosition)
	{
		this.endPosition = endPosition;
	}

	public Timestamp getRentalDate()
	{
		return rentalDate;
	}

	public void setRentalDate(Timestamp rentalDate)
	{
		this.rentalDate = rentalDate;
	}

	public Timestamp getReturnDate()
	{
		return returnDate;
	}

	public void setReturnDate(Timestamp returnDate)
	{
		this.returnDate = returnDate;
	}
}
