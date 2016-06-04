package com.entities;

import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;
import javax.persistence.Column;
import javax.persistence.Entity;;

@Entity
@Table(name = "stacja")
@PrimaryKeyJoinColumn(name = "id", referencedColumnName = "id")
public class Station extends Place
{
	@Column(name = "liczba_stanowisk", nullable = false)
	private int positionCount;

	public int getPositionCount()
	{
		return positionCount;
	}

	public void setPositionCount(int positionCount)
	{
		this.positionCount = positionCount;
	}
}
