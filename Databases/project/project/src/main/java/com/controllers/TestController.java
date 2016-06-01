package com.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.entities.User;

//import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Controller
public class TestController 
{
	@RequestMapping(value="/hello", method = RequestMethod.GET)
	public ModelAndView getPage()
	{
		ModelAndView view = new ModelAndView("hello", "command", new User());
		return view;
	}
	
	@RequestMapping(value="/addUser", method=RequestMethod.POST)
	public ModelAndView addUser(@ModelAttribute(""))
	{
		return new ModelAndView("addUser");
	}
}
