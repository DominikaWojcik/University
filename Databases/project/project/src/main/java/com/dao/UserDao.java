package com.dao;

import java.util.List;

import javax.persistence.ParameterMode;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.procedure.ProcedureCall;
import org.springframework.beans.factory.annotation.Autowired;

import com.entities.User;

public class UserDao implements IUserDao
{
	@Autowired
	private SessionFactory sessionFactory;

	public User getUser()
	{
		// TODO Auto-generated method stub
		return null;
	}

	public void registerUser(User u, String pin)
	{
		// TODO Auto-generated method stub
		Session session = sessionFactory.getCurrentSession();
		ProcedureCall call = session.createStoredProcedureCall("zarejestruj_uzytkownika");
		
		call.registerParameter(1, String.class, ParameterMode.IN).bindValue(u.getName());
		call.registerParameter(2, String.class, ParameterMode.IN).bindValue(u.getLastName());
		call.registerParameter(3, String.class, ParameterMode.IN).bindValue(u.getAddress());
		call.registerParameter(4, String.class, ParameterMode.IN).bindValue(u.getPostalCode());
		call.registerParameter(5, String.class, ParameterMode.IN).bindValue(u.getCity());
		call.registerParameter(6, String.class, ParameterMode.IN).bindValue(u.getCountry());
		call.registerParameter(7, String.class, ParameterMode.IN).bindValue(u.getEmail());
		call.registerParameter(8, String.class, ParameterMode.IN).bindValue(u.getTel());
		call.registerParameter(9, String.class, ParameterMode.IN).bindValue(pin);
		
		call.getOutputs();
	}

	public List<User> getAllUsers()
	{
		// TODO Auto-generated method stub
		return null;
	}

	public void saveUser(User user)
	{
		// TODO Auto-generated method stub

	}

}
