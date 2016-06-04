package com.services;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.IRentalDao;
import com.entities.Payment;
import com.entities.Rental;
import com.entities.User;

@Service
@Transactional
public class RentalService implements IRentalService
{
	private final int LATEST_RENTALS = 5;
	@Autowired
	IRentalDao rentalDao;
	
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
}
	