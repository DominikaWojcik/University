package com.dao;

import java.util.List;

import com.entities.LoginData;
import com.entities.User;
import com.entities.UserRegistration;

public interface IUserDao 
{
	User getUser();
	User getUserByTel(String tel);
	void registerUser(UserRegistration data);
	List<User> getAllUsers();
	void saveUser(User user);
	boolean authentication(LoginData data);
}
