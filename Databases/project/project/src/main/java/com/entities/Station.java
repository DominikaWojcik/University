package com.entities;

import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import java.util.ArrayList;
import java.util.Collections;

import javax.persistence.Column;
import javax.persistence.Entity;;

@Entity
@Table(name = "stacja")
@PrimaryKeyJoinColumn(name = "id", referencedColumnName = "id")
public class Station extends Place
{
	@Column(name = "liczba_stanowisk", nullable = false)
	private int positionCount;

	public int getFreePosition()
	{
		ArrayList<Integer> takenPositions = new ArrayList<Integer>();
		for(BikePlace bp : getBikes())
			takenPositions.add(bp.getPosition());
		Collections.sort(takenPositions);
		
		int freePosition = 1;
		for(int i=0; i<takenPositions.size();i++)
			if(takenPositions.get(i) == freePosition)
				freePosition++;
			else break;
		
		return freePosition;
	}
	
	public int getPositionCount()
	{
		return positionCount;
	}

	public void setPositionCount(int positionCount)
	{
		this.positionCount = positionCount;
	}
}
