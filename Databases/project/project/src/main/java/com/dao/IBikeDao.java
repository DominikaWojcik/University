package com.dao;

import com.entities.Bike;

public interface IBikeDao
{
	Bike getBike(int id);
	void save(Bike bike);
}
