package com.services;

import java.math.BigDecimal;
import java.util.List;

import com.entities.Payment;
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
}
