package com.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.entities.LoginData;
import com.entities.User;
import com.entities.UserRegistration;
import com.services.IUserService;

//import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Controller
@SessionAttributes("user")
public class TestController 
{
	@Autowired
	private IUserService userService;
	
	@RequestMapping(value="/", method = RequestMethod.GET)
	public ModelAndView getIndex(HttpSession session)
	{
		User user = (User) session.getAttribute("user");
		if(user != null && user.getTel() != null)
		{
			return new ModelAndView("userdashboard");
		}
		
		ModelAndView view = new ModelAndView("index", "command", new LoginData());
		return view;
	}
	
	@RequestMapping(value="/", method = RequestMethod.POST)
	public ModelAndView onLogin(@ModelAttribute("loginData") LoginData loginData, HttpSession session)
	{
		System.out.println("Przesłano nr: " + loginData.getTel() + " PIN: " + loginData.getPin());
		if(userService.authentication(loginData))
		{
			User user = userService.getUserByTel(loginData.getTel());
			session.setAttribute("user", user);
			
			return new ModelAndView("userdashboard");
		}
		else
		{
			ModelAndView view = new ModelAndView("index", "command", new LoginData());
			return view;
		}
	}
	
	@RequestMapping(value="/register", method = RequestMethod.GET)
	public ModelAndView getRegistraton()
	{
		ModelAndView view = new ModelAndView("registration", "command", new UserRegistration());
		return view;
	}
	
	@RequestMapping(value="/addUser", method=RequestMethod.POST)
	public String addUser(@ModelAttribute("data") UserRegistration data, ModelMap model)
	{
		model.addAttribute("name", data.getName());
		model.addAttribute("lastName", data.getLastName());
		model.addAttribute("tel", data.getTel());
		model.addAttribute("email", data.getEmail());
		model.addAttribute("pin", data.getPin());
		model.addAttribute("pinRep", data.getPinRep());
		model.addAttribute("address", data.getAddress());
		model.addAttribute("postalCode", data.getPostalCode());
		model.addAttribute("city", data.getCity());
		model.addAttribute("country", data.getCountry());
	
		userService.registerUser(data);
		
		return "result";
	}
	
	@RequestMapping(value="/editUser", method=RequestMethod.POST)
	public ModelAndView editUserInfo(@ModelAttribute("newUserInfo") User newUserInfo)
	{
		return new ModelAndView("editUser", "command", newUserInfo);
	}
	
	@RequestMapping(value="/savedUser", method=RequestMethod.POST)
	public ModelAndView saveUserInfo(@ModelAttribute("newUserInfo") User newUserInfo, HttpSession session)
	{
		User user = (User) session.getAttribute("user");
		user.update(newUserInfo);
		
		userService.saveUser(user);
		
		return new ModelAndView("userdashboard");
	}
}
