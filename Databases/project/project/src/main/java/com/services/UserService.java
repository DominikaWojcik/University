package com.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.businessLogic.LoginData;
import com.businessLogic.RegistrationException;
import com.businessLogic.UserRegistration;
import com.dao.interfaces.IUserDao;
import com.entities.User;

@Service
@Transactional
public class UserService implements IUserService
{
	@Autowired
	private IUserDao userDao;
	
	public List<User> getAllUsers()
	{
		return userDao.getAllUsers();
	}
	
	public User getUser(int id)
	{
		return userDao.getUser(id);
	}
	
	public void registerUser(UserRegistration data) throws RegistrationException
	{
		userDao.registerUser(data);
	}
	
	public boolean authentication(LoginData loginData)
	{
		return userDao.authentication(loginData);
	}
	
	public User getUserByTel(String tel)
	{
		return userDao.getUserByTel(tel);
	}
	
	public void saveUser(User user)
	{
		userDao.saveUser(user);
	}
}
