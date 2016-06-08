package com.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.interfaces.IBikeDao;
import com.entities.Bike;

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
}
