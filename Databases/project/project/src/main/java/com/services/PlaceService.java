package com.services;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.businessLogic.CannotDeletePlaceException;
import com.businessLogic.PlaceCreationData;
import com.dao.interfaces.IPlaceDao;
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

	public Place getPlace(int id)
	{
		return placeDao.getPlace(id);
	}
	
	public List<Place> getNonFullStations()
	{
		List<Place> nonFullStations = new ArrayList<Place>();
		List<Station> stations = getStations();
		
		for (Station station : stations)
		{
			if(station.getBikes().size() < station.getPositionCount())
				nonFullStations.add((Place) station);
		}
		
		return nonFullStations;
	}
	
	public List<Place> getNonFullPlaces()
	{
		List<Place> nonFullPlaces = getNonFullStations();
		List<Service> services = getServices();
		
		nonFullPlaces.addAll(services);
		return nonFullPlaces;
	}
	
	public void addNewPlace(PlaceCreationData data)
	{
		Place newPlace;
		
		if(data.getType().equals("stacja"))
			newPlace = new Station(data.getPositionCount());
		else newPlace = new Service(data.getTel());
		
		newPlace.setAddress(data.getAddress());
		newPlace.setPostalCode(data.getPostalCode());
		newPlace.setCity(data.getCity());
		newPlace.setCountry(data.getCountry());
		newPlace.setType(data.getType());
		newPlace.setActive(true);
		
		placeDao.save(newPlace);
	}
	
	public void save(Place place)
	{
		System.out.println("Zapisuje " + Integer.toString(place.getId()));
		placeDao.save(place);
	}
	
	public void delete(Place place) throws CannotDeletePlaceException
	{
		if(place == null) throw new CannotDeletePlaceException("No such place exists");
		if(place.getBikes() != null && place.getBikes().size() > 0) 
			throw new CannotDeletePlaceException("The place contains some bikes");
		placeDao.delete(place);
	}
}
