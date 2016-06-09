package com.dao.impl;

import java.util.List;

import javax.persistence.ParameterMode;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.exception.ConstraintViolationException;
import org.hibernate.procedure.ProcedureCall;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.businessLogic.LoginData;
import com.businessLogic.RegistrationException;
import com.businessLogic.UserRegistration;
import com.dao.interfaces.IUserDao;
import com.entities.User;

@Repository
public class UserDao implements IUserDao
{
	@Autowired
	SessionFactory sessionFactory;
	
	Session session()
	{
		Session session = sessionFactory.getCurrentSession();
		session.enableFilter("notDeletedUsers");
		return session;
	}

	public User getUser(int id)
	{
		return session().get(User.class, id);
	}
	
	public User getUserByTel(String tel)
	{
		Query query = session()
				.createQuery("FROM User WHERE tel = :tel");
		query.setParameter("tel", tel);
		
		User user = (User) query.list().get(0);
		return user;
	}

	public void registerUser(UserRegistration data) throws RegistrationException
	{
		Session session = session();
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
		
		try
		{
			call.getOutputs();
		}
		catch(ConstraintViolationException e )
		{
			throw new RegistrationException("Phone number/e-mail address already taken");
		}
	}

	@SuppressWarnings("unchecked")
	public List<User> getAllUsers()
	{
		return session().createQuery("FROM User ORDER BY id ASC").list();
	}

	public void saveUser(User user)
	{
		session().update(user);
	}
	
	public boolean authentication(LoginData data)
	{
		Boolean result = null;
		Session session = session();
		ProcedureCall call = session.createStoredProcedureCall("sprawdz_pin");
		
		call.registerParameter(1, String.class, ParameterMode.IN).bindValue(data.getTel());
		call.registerParameter(2, String.class, ParameterMode.IN).bindValue(data.getPin());
		call.registerParameter(3, Boolean.class, ParameterMode.OUT);
		result = (Boolean) call.getOutputs().getOutputParameterValue(3);
		
		if(result == null) System.out.println("Nie udało się uzyskać wyniku");
		else System.out.println("Wynik = " + Boolean.toString(result));
		
		return result;
	}
	
	public void delete(User user)
	{
		user.setActive(false);
		session().update(user);
	}

}
