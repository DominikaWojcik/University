package com.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dao.interfaces.IBikeDao;
import com.entities.Bike;
import com.entities.BikePlace;

@Repository
public class BikeDao implements IBikeDao
{
	@Autowired
	SessionFactory sessionFactory;
	
	Session session()
	{
		Session session = sessionFactory.getCurrentSession();
		session.enableFilter("notDeletedBikes");
		return session;
	}
	
	public Bike getBike(int id)
	{
		return session().get(Bike.class, id);
	}

	public void save(Bike bike)
	{
		session().saveOrUpdate(bike);
	}

	public List<Bike> getAllBikes()
	{
		return session().createQuery("FROM Bike").list();
	}
	
	public void delete(Bike bike)
	{
		bike.setActive(false);
		session().update(bike);
	}
	
	public void saveBikePlace(BikePlace bikePlace)
	{
		session().saveOrUpdate(bikePlace);
	}
	
	public void delete(BikePlace bikePlace)
	{
		session().delete(bikePlace);
	}
}
