package com.services;

import java.util.List;

import com.businessLogic.CannotDeletePlaceException;
import com.businessLogic.PlaceCreationData;
import com.entities.Place;
import com.entities.Service;
import com.entities.Station;

public interface IPlaceService
{
	List<Place> getPlaces();
	List<Station> getStations();
	List<Service> getServices();
	Place getPlace(int id);
	List<Place> getNonFullPlaces();
	List<Place> getNonFullStations();
	void addNewPlace(PlaceCreationData data);
	void save(Place place);
	void delete(Place place) throws CannotDeletePlaceException;
}
