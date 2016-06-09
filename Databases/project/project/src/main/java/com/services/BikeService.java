package com.services;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.businessLogic.BikeCreationData;
import com.businessLogic.CannotDeleteBikeException;
import com.dao.interfaces.IBikeDao;
import com.entities.Bike;
import com.entities.BikePlace;
import com.entities.Place;
import com.entities.Station;

@Service
@Transactional
public class BikeService implements IBikeService
{
	@Autowired
	private IBikeDao bikeDao;
	
	public Bike getBike(int id)
	{
		return bikeDao.getBike(id);
	}
	
	public void saveBike(Bike bike)
	{
		bikeDao.save(bike);
	}
	
	public List<Bike> getAllBikes()
	{
		return bikeDao.getAllBikes();
	}
	
	public void delete(Bike bike) throws CannotDeleteBikeException
	{
		BikePlace bikePlace = bike.getPlace();
		if(bikePlace != null)
		{
			if(bikePlace.getPlace() == null)
				throw new CannotDeleteBikeException("Bike already rented");
			else if(bikePlace.getPlace() instanceof Station)
				throw new CannotDeleteBikeException("Bike is at a station");	
		}
		bike.setPlace(null);
		bikeDao.delete(bikePlace);
		bikeDao.delete(bike);
	}
	
	public void addBike(BikeCreationData data, com.entities.Service service)
	{
		Bike bike = new Bike();
		bike.setBrand(data.getBrand());
		bike.setModel(data.getModel());
		bike.setActive(true);
		bike.setPurchaseDate(new java.sql.Date(new Date().getTime()));
		
		bikeDao.save(bike);

		BikePlace bikePlace = new BikePlace();
		bikePlace.setBike(bike);
		bikePlace.setPlace((Place) service);
		bikePlace.setPosition(null);
		bikePlace.setSinceWhen(new Timestamp(new Date().getTime()));
		
		bikeDao.saveBikePlace(bikePlace);
	}
	
	public void editBike(Bike bike)
	{
		Bike original = bikeDao.getBike(bike.getId());
		original.setBrand(bike.getBrand());
		original.setModel(bike.getModel());
		bikeDao.save(original);
	}
}
