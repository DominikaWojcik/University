package com.businessLogic;

public class CannotDeleteBikeException extends Exception
{
	public CannotDeleteBikeException() 
	{
		super();
	}
	
	public CannotDeleteBikeException(String message)
	{
		super(message);
	}
}
