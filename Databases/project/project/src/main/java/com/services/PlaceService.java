package com.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.dao.IPlaceDao;
import com.entities.Place;
import com.entities.Service;
import com.entities.Station;

@org.springframework.stereotype.Service
@Transactional
public class PlaceService implements IPlaceService
{
	@Autowired
	private IPlaceDao placeDao;
	
	public List<Place> getPlaces()
	{
		return placeDao.getPlaces();
	}

	public List<Station> getStations()
	{
		return placeDao.getStations();
	}

	public List<Service> getServices()
	{
		return placeDao.getServices();
	}

}
