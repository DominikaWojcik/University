package com.dao;

import java.util.List;

import com.businessLogic.LoginData;
import com.businessLogic.UserRegistration;
import com.entities.User;

public interface IUserDao 
{
	User getUser();
	User getUserByTel(String tel);
	void registerUser(UserRegistration data);
	List<User> getAllUsers();
	void saveUser(User user);
	boolean authentication(LoginData data);
}
