package com.services;

import java.util.List;

import com.entities.Place;
import com.entities.Service;
import com.entities.Station;

public interface IPlaceService
{
	List<Place> getPlaces();
	List<Station> getStations();
	List<Service> getServices();
}
