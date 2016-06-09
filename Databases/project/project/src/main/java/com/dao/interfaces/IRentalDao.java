package com.dao.interfaces;

import java.util.List;

import com.entities.Payment;
import com.entities.Rental;
import com.entities.User;

public interface IRentalDao
{
	List<Rental> getRentals();
	List<Rental> getRentalsByUser(User user);
	Rental getRental(int id);
	
	List<Payment> getPayments();
	List<Payment> getPaymentsByUser(User user);
	void saveRental(Rental rental);
	List<Rental> getActiveRentals(User user);
	List<Rental> getLatestRentals(User user, int count);
	List<Rental> getActiveRentals();
}
