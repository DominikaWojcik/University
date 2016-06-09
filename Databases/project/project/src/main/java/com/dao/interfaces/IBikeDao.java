package com.dao.interfaces;

import com.entities.Bike;
import com.entities.BikePlace;

import java.util.List;

public interface IBikeDao
{
	Bike getBike(int id);
	void save(Bike bike);
	List<Bike> getAllBikes();
	void delete(Bike bike);
	void saveBikePlace(BikePlace bikePlace);
	void delete(BikePlace place);
}
