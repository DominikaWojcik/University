package com.services;

import com.businessLogic.LoginData;
import com.businessLogic.UserRegistration;
import com.entities.User;

public interface IUserService
{
	void registerUser(UserRegistration data);

	boolean authentication(LoginData loginData);
	
	User getUserByTel(String tel);
	
	void saveUser(User user);
}
