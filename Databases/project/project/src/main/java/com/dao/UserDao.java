package com.dao;

import java.util.List;

import javax.persistence.ParameterMode;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.procedure.ProcedureCall;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.entities.User;
import com.entities.UserRegistration;

@Repository
public class UserDao implements IUserDao
{
	@Autowired
	SessionFactory sessionFactory;

	public User getUser()
	{
		// TODO Auto-generated method stub
		return null;
	}

	public void registerUser(UserRegistration data)
	{
		if(sessionFactory == null)
			System.out.println("SessionFactory null");
		
		Session session = sessionFactory.getCurrentSession();
		ProcedureCall call = session.createStoredProcedureCall("zarejestruj_uzytkownika");
		
		call.registerParameter(1, String.class, ParameterMode.IN).bindValue(data.getName());
		call.registerParameter(2, String.class, ParameterMode.IN).bindValue(data.getLastName());
		call.registerParameter(3, String.class, ParameterMode.IN).bindValue(data.getAddress());
		call.registerParameter(4, String.class, ParameterMode.IN).bindValue(data.getPostalCode());
		call.registerParameter(5, String.class, ParameterMode.IN).bindValue(data.getCity());
		call.registerParameter(6, String.class, ParameterMode.IN).bindValue(data.getCountry());
		call.registerParameter(7, String.class, ParameterMode.IN).bindValue(data.getEmail());
		call.registerParameter(8, String.class, ParameterMode.IN).bindValue(data.getTel());
		call.registerParameter(9, String.class, ParameterMode.IN).bindValue(data.getPin());
		
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
