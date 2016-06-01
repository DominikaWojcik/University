package com.dao;

import java.util.List;

import com.entities.User;
import com.entities.UserRegistration;

public interface IUserDao 
{
	User getUser();
	void registerUser(UserRegistration data);
	List<User> getAllUsers();
	void saveUser(User user);
}
