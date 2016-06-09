package com.businessLogic;

public class CannotDeleteUserException extends Exception
{
	public CannotDeleteUserException()
	{
		super();
	}
	
	public CannotDeleteUserException(String message)
	{
		super(message);
	}
}
