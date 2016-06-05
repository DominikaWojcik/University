package com.businessLogic;

public class BikeAlreadyTakenException extends Exception
{
	public BikeAlreadyTakenException()
	{
		super();
	}
	
	public BikeAlreadyTakenException(String str)
	{
		super(str);
	}
}
