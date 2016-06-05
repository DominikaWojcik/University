package com.dao;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.entities.Bike;

@Repository
public class BikeDao implements IBikeDao
{
	@Autowired
	SessionFactory sessionFactory;
	
	public Bike getBike(int id)
	{
		return sessionFactory.getCurrentSession().get(Bike.class, id);
	}

	public void save(Bike bike)
	{
		sessionFactory.getCurrentSession().saveOrUpdate(bike);
	}

}
