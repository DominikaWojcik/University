package com.dao;

import java.util.List;

import javax.persistence.ParameterMode;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.procedure.ProcedureCall;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.businessLogic.LoginData;
import com.businessLogic.UserRegistration;
import com.entities.User;

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
	
	public User getUserByTel(String tel)
	{
		Query query = sessionFactory.getCurrentSession()
				.createQuery("FROM User WHERE tel = :tel");
		query.setParameter("tel", tel);
		
		User user = (User) query.list().get(0);
		return user;
	}

	public void registerUser(UserRegistration data)
	{
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
		sessionFactory.getCurrentSession().update(user);
	}
	
	public boolean authentication(LoginData data)
	{
		Boolean result = null;
		Session session = sessionFactory.getCurrentSession();
		ProcedureCall call = session.createStoredProcedureCall("sprawdz_pin");
		
		call.registerParameter(1, String.class, ParameterMode.IN).bindValue(data.getTel());
		call.registerParameter(2, String.class, ParameterMode.IN).bindValue(data.getPin());
		call.registerParameter(3, Boolean.class, ParameterMode.OUT);
		result = (Boolean) call.getOutputs().getOutputParameterValue(3);
		
		if(result == null) System.out.println("Nie udało się uzyskać wyniku");
		else System.out.println("Wynik = " + Boolean.toString(result));
		
		return result;
	}

}
