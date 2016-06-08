package com.dao.interfaces;

import com.entities.Bike;
import java.util.List;

public interface IBikeDao
{
	Bike getBike(int id);
	void save(Bike bike);
	List<Bike> getAllBikes();
}
