package com.dao;

import java.util.List;

import com.entities.Payment;
import com.entities.Rental;
import com.entities.User;

public interface IRentalDao
{
	List<Rental> getRentals();
	List<Rental> getRentalsByUser(User user);
	
	List<Payment> getPayments();
	List<Payment> getPaymentsByUser(User user);
}
