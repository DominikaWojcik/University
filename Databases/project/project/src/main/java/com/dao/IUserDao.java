package com.dao;

import java.util.List;

import com.entities.User;

public interface IUserDao 
{
	User getUser();
	void registerUser(User user, String pin);
	List<User> getAllUsers();
	void saveUser(User user);
}
