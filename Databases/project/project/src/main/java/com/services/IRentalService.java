package com.services;

import java.math.BigDecimal;
import java.util.List;

import com.businessLogic.BikeAlreadyTakenException;
import com.businessLogic.StationFullException;
import com.entities.Bike;
import com.entities.Payment;
import com.entities.Place;
import com.entities.Rental;
import com.entities.User;

public interface IRentalService
{
	List<Rental> getRentals();
	
	List<Rental> getRentalsByUser(User user);
	
	List<Rental> getLatestRentals(User user);

	List<Payment> getPaymentsByUser(User user);
	
	List<Payment> getPayments();

	BigDecimal countAmountDue(List<Payment> payments);

	void rentABike(User user, Bike chosenBike, Place chosenPlace) throws BikeAlreadyTakenException;

	Rental getRental(int rentalId);

	void returnBike(Rental rental, Place chosenPlace, Integer endPosition) throws StationFullException;

	List<Rental> getActiveRentals(User user);
}
