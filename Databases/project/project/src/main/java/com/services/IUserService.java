package com.services;

import com.entities.LoginData;
import com.entities.User;
import com.entities.UserRegistration;

public interface IUserService
{
	void registerUser(UserRegistration data);

	boolean authentication(LoginData loginData);
	
	User getUserByTel(String tel);
	
	void saveUser(User user);
}
