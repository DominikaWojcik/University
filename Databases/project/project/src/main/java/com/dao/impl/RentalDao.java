package com.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dao.interfaces.IRentalDao;
import com.entities.Payment;
import com.entities.Rental;
import com.entities.User;

@Repository
public class RentalDao implements IRentalDao
{
	@Autowired
	private SessionFactory sessionFactory;
	
	public Rental getRental(int id)
	{
		return sessionFactory.getCurrentSession().get(Rental.class, id);
	}
	
	@SuppressWarnings("unchecked")
	public List<Rental> getRentals()
	{
		Query query = sessionFactory.getCurrentSession().createQuery("FROM Rental");
		return (List<Rental>) query.list();
	}

	@SuppressWarnings("unchecked")
	public List<Rental> getRentalsByUser(User user)
	{
		Query query = sessionFactory.getCurrentSession().createQuery("FROM Rental WHERE user = :user");
		query.setParameter("user", user);
		return (List<Rental>) query.list();
	}
	
	@SuppressWarnings("unchecked")
	public List<Payment> getPayments()
	{
		Query query = sessionFactory.getCurrentSession().createQuery("FROM Payment");
		return (List<Payment>) query.list();
	}
	
	@SuppressWarnings("unchecked")
	public List<Payment> getPaymentsByUser(User user)
	{
		Query query = sessionFactory.getCurrentSession().createQuery("FROM Payment WHERE user = :user");
		query.setParameter("user", user);
		return (List<Payment>) query.list();
	}
	
	public void saveRental(Rental rental)
	{
		sessionFactory.getCurrentSession().saveOrUpdate(rental);
	}
	
	@SuppressWarnings("unchecked")
	public List<Rental> getActiveRentals(User user)
	{
		Query query = sessionFactory.getCurrentSession()
				.createQuery("FROM Rental WHERE user = :user AND returnDate IS NULL");
		query.setParameter("user", user);
		
		return (List<Rental>) query.list();
	}
	
	@SuppressWarnings("unchecked")
	public List<Rental> getLatestRentals(User user, int count)
	{
		Query query = sessionFactory.getCurrentSession()
				.createQuery("FROM Rental WHERE user = :user ORDER BY rentalDate DESC");
		query.setParameter("user", user);
		query.setMaxResults(count);
		
		return (List<Rental>) query.list();
	}
	
	@SuppressWarnings("unchecked")
	public List<Rental> getActiveRentals()
	{
		Query query = sessionFactory.getCurrentSession()
				.createQuery("FROM Rental WHERE returnDate IS NULL");
		
		return (List<Rental>) query.list();
	}
}
