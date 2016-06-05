package com.services;

import java.math.BigDecimal;

import java.sql.Timestamp;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.businessLogic.BikeAlreadyTakenException;
import com.businessLogic.StationFullException;
import com.dao.IRentalDao;
import com.entities.Bike;
import com.entities.Payment;
import com.entities.Place;
import com.entities.Rental;
import com.entities.Station;
import com.entities.User;

@Service
@Transactional
public class RentalService implements IRentalService
{
	private final int LATEST_RENTALS = 5;
	@Autowired
	IRentalDao rentalDao;
	
	public Rental getRental(int id)
	{
		return rentalDao.getRental(id);
	}
	
	public List<Rental> getRentals()
	{
		return rentalDao.getRentals();
	}

	public List<Rental> getRentalsByUser(User user)
	{
		return rentalDao.getRentalsByUser(user);
	}
	
	public List<Rental> getLatestRentals(User user)
	{
		List<Rental> rentals = rentalDao.getRentalsByUser(user);
		
		Collections.sort(rentals, new Comparator<Rental>(){
			public int compare(Rental a, Rental b)
			{
				Timestamp aTime = a.getRentalDate();
				Timestamp bTime = b.getRentalDate();
				
				return aTime.compareTo(bTime);
			}
		});
		
		return rentals.subList(0, Math.min(LATEST_RENTALS, rentals.size()));
	}

	public List<Payment> getPaymentsByUser(User user)
	{
		return rentalDao.getPaymentsByUser(user);
	}

	public List<Payment> getPayments()
	{
		return rentalDao.getPayments();
	}
	
	public BigDecimal countAmountDue(List<Payment> payments)
	{
		BigDecimal amountDue = BigDecimal.ZERO;
		for(Payment payment  : payments)
		{
			if(payment.getPaymentDate() == null)
				amountDue = amountDue.add(payment.getAmount());
		}
		return amountDue;
	}
	
	public void rentABike(User user, Bike bike, Place place) throws BikeAlreadyTakenException
	{
		Place bikePlace = bike.getPlace().getPlace();
			
		if(bikePlace == null || bikePlace.getId() != place.getId()) 
			throw new BikeAlreadyTakenException("Wybrany rower został wcześniej wypożyczony");
		
		Rental rental = new Rental(user, bike, place, bike.getPlace().getPosition(), 
				new Timestamp(new Date().getTime()));
		
		rentalDao.saveRental(rental);
	}
	
	public void returnBike(Rental rental, Place chosenPlace, Integer endPosition) throws StationFullException
	{
		if(chosenPlace instanceof Station && 
				chosenPlace.getBikes().size() >= ((Station)chosenPlace).getPositionCount())
			throw new StationFullException("Wybrana stacja jest już pełna");
		
		System.out.println("uzytkownik_id = " + Integer.toString(rental.getUser().getId()));
		rental.setEndPlace(chosenPlace);
		rental.setEndPosition(endPosition);
		rental.setReturnDate(new Timestamp(new Date().getTime()));
		rentalDao.saveRental(rental);
	}
	
}
	