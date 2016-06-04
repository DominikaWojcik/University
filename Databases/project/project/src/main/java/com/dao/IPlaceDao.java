package com.dao;

import com.entities.*;
import java.util.List;

public interface IPlaceDao
{
	List<Place> getPlaces();
	List<Station> getStations();
	List<Service> getServices();
}
