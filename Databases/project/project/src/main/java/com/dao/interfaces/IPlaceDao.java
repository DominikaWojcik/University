package com.dao.interfaces;

import com.entities.*;
import java.util.List;

public interface IPlaceDao
{
	List<Place> getPlaces();
	List<Station> getStations();
	List<Service> getServices();
	Place getPlace(int id);
	void save(Place newPlace);
	void delete(Place place);
}
