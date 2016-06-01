package com.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dao.IUserDao;
import com.entities.UserRegistration;

@Service
@Transactional
public class UserService implements IUserService
{
	@Autowired
	private IUserDao userDao;
	
	public void registerUser(UserRegistration data)
	{
		userDao.registerUser(data);
	}
	
}
