package com.dao;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.entities.Payment;
import com.entities.Rental;
import com.entities.User;

@Repository
public class RentalDao implements IRentalDao
{
	@Autowired
	private SessionFactory sessionFactory;
	
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

}
