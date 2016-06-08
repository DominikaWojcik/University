package com.services;

import java.util.List;

import com.entities.Bike;

public interface IBikeService
{
	Bike getBike(int id);
	void saveBike(Bike bike);
	List<Bike> getAllBikes();
}
