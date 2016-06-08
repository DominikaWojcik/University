package com.services;

import java.util.List;

import com.businessLogic.LoginData;
import com.businessLogic.RegistrationException;
import com.businessLogic.UserRegistration;
import com.entities.User;

public interface IUserService
{
	void registerUser(UserRegistration data) throws RegistrationException;

	boolean authentication(LoginData loginData);
	
	User getUserByTel(String tel);
	
	User getUser(int id);
	
	List<User> getAllUsers();
	
	void saveUser(User user);
}
