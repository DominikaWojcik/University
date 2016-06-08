package com.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.dao.interfaces.IPlaceDao;
import com.entities.Place;
import com.entities.Service;
import com.entities.Station;

@Repository
public class PlaceDao implements IPlaceDao
{
	@Autowired
	SessionFactory sessionFactory;

	Session session()
	{
		Session session = sessionFactory.getCurrentSession();
		session.enableFilter("notDeletedPlaces");
		return session;
	}
	
	public List<Place> getPlaces()
	{
		Query query = session().createQuery("FROM Place");
		return (List<Place>) query.list();
	}

	public List<Station> getStations()
	{
		Query query = session().createQuery("FROM Station");
		return (List<Station>) query.list();
	}

	public List<Service> getServices()
	{
		Query query = session().createQuery("FROM Service");
		return (List<Service>) query.list();
	}

	public Place getPlace(int id)
	{
		return session().get(Place.class, id);
	}
	
	public void save(Place place)
	{
		session().saveOrUpdate(place);
	}
	
	public void delete(Place place)
	{
		place.setActive(false);
		session().update(place);
	}
}
