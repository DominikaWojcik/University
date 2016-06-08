package com.businessLogic;

public class CannotDeletePlaceException extends Exception
{
	public CannotDeletePlaceException() 
	{
		super();
	}
	
	public CannotDeletePlaceException(String message)
	{
		super(message);
	}
}
