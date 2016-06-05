package com.dao;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.entities.Place;
import com.entities.Service;
import com.entities.Station;

@Repository
public class PlaceDao implements IPlaceDao
{
	@Autowired
	SessionFactory sessionFactory;

	public List<Place> getPlaces()
	{
		Query query = sessionFactory.getCurrentSession().createQuery("FROM Place");
		return (List<Place>) query.list();
	}

	public List<Station> getStations()
	{
		Query query = sessionFactory.getCurrentSession().createQuery("FROM Station");
		return (List<Station>) query.list();
	}

	public List<Service> getServices()
	{
		Query query = sessionFactory.getCurrentSession().createQuery("FROM Service");
		return (List<Service>) query.list();
	}

	public Place getPlace(int id)
	{
		return sessionFactory.getCurrentSession().get(Place.class, id);
	}
}
