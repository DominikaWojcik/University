package com.services;

import java.util.List;

import com.businessLogic.BikeCreationData;
import com.businessLogic.CannotDeleteBikeException;
import com.entities.Bike;
import com.entities.Service;

public interface IBikeService
{
	Bike getBike(int id);
	void saveBike(Bike bike);
	List<Bike> getAllBikes();
	void delete(Bike bike) throws CannotDeleteBikeException;
	void addBike(BikeCreationData data, Service service);
	void editBike(Bike bike);
}
