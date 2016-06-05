package com.services;

import com.entities.Bike;

public interface IBikeService
{
	Bike getBike(int id);
	void saveBike(Bike bike);
}
