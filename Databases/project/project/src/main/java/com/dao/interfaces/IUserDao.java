package com.dao.interfaces;

import java.util.List;

import com.businessLogic.LoginData;
import com.businessLogic.RegistrationException;
import com.businessLogic.UserRegistration;
import com.entities.User;

public interface IUserDao 
{
	User getUser(int id);
	User getUserByTel(String tel);
	void registerUser(UserRegistration data) throws RegistrationException;
	List<User> getAllUsers();
	void saveUser(User user);
	boolean authentication(LoginData data);
	void delete(User user);
}
