package com.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.entities.LoginData;
import com.entities.UserRegistration;
import com.services.IUserService;

//import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Controller
public class TestController 
{
	@Autowired
	private IUserService userService;
	
	@RequestMapping(value="/", method = RequestMethod.GET)
	public ModelAndView getIndex()
	{
		ModelAndView view = new ModelAndView("index", "command", new LoginData());
		return view;
	}
	
	@RequestMapping(value="/", method = RequestMethod.POST)
	public ModelAndView onLogin()
	{
		ModelAndView view = new ModelAndView("index", "command", new LoginData());
		return view;
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
}
