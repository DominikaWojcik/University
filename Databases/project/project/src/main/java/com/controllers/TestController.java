package com.controllers;

import org.springframework.beans.factory.annotation.Autowired;

import java.sql.Timestamp;
import java.util.List;

import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.businessLogic.LoginData;
import com.businessLogic.UserRegistration;
import com.entities.Bike;
import com.entities.Payment;
import com.entities.Rental;
import com.entities.Station;
import com.entities.User;
import com.services.IPlaceService;
import com.services.IRentalService;
import com.services.IUserService;

//import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Controller
@SessionAttributes("user")
public class TestController 
{
	@Autowired
	private IUserService userService;
	
	@Autowired
	private IRentalService rentalService;
	
	@Autowired
	private IPlaceService placeService;
	
	@RequestMapping(value="/", method = RequestMethod.GET)
	public ModelAndView getIndex(HttpSession session, Model model)
	{
		User user = (User) session.getAttribute("user");
		if(user != null && user.getTel() != null)
		{
			List<Rental> latestRentals = rentalService.getLatestRentals(user);
			Bike b = new Bike();
			b.setId(12345678);
			Rental r = new Rental();
			r.setBike(b);
			r.setUser(user);
			r.setRentalDate(new Timestamp(0));
			latestRentals.add(r);
			model.addAttribute("latestRentals", latestRentals);
			
			return new ModelAndView("userdashboard", model.asMap());
		}
		
		ModelAndView view = new ModelAndView("index", "command", new LoginData());
		return view;
	}
	
	@RequestMapping(value="/", method = RequestMethod.POST)
	public String onLogin(@ModelAttribute("loginData") LoginData loginData, 
			HttpSession session, Model model)
	{
		System.out.println("Przesłano nr: " + loginData.getTel() + " PIN: " + loginData.getPin());
		if(userService.authentication(loginData))
		{
			User user = userService.getUserByTel(loginData.getTel());
			session.setAttribute("user", user);
		}
		return "redirect:/";
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
	
	@RequestMapping(value="/account", method = RequestMethod.GET)
	public ModelAndView getAccount(HttpSession session)
	{
		if(session.getAttribute("user") == null)
			return new ModelAndView("redirect:/");
		
		return new ModelAndView("account");
	}
	
	@RequestMapping(value="/editUser", method=RequestMethod.GET)
	public ModelAndView editUserInfo(@ModelAttribute("newUserInfo") User newUserInfo, HttpSession session)
	{
		if(session.getAttribute("user") == null)
		{
			return new ModelAndView("/");
		}
		return new ModelAndView("editUser", "command", newUserInfo);
	}
	
	@RequestMapping(value="/savedUser", method=RequestMethod.POST)
	public String saveUserInfo(@ModelAttribute("newUserInfo") User newUserInfo, HttpSession session)
	{
		User user = (User) session.getAttribute("user");
		user.update(newUserInfo);
		
		userService.saveUser(user);
		
		return "redirect:/account";
	}
	
	@RequestMapping(value="/userHistory", method= RequestMethod.GET)
	public String getHistory(HttpSession session, Model model)
	{
		User user = (User) session.getAttribute("user");
		if(user == null) return "redirect:/";
		
		List<Rental> rentals = rentalService.getRentalsByUser(user);
		model.addAttribute("rentals", rentals);
		
		List<Payment> payments = rentalService.getPaymentsByUser(user);
		model.addAttribute("payments", payments);
		
		model.addAttribute("amountDue", rentalService.countAmountDue(payments));
		
		return "userHistory";
	}
	
	@RequestMapping(value="/userRent", method = RequestMethod.GET)
	public String rentABike_selectStation(HttpSession session, Model model)
	{
		List<Station> stations = placeService.getStations();
		model.addAttribute("stations", stations);
		model.addAttribute("chosenStation", new Station());
		
		return "userRent_Station";
	}
	
	@RequestMapping(value="/userRent", method = RequestMethod.POST)
	public String rentABike_SelectBike(@ModelAttribute("chosenStation") Station chosenStation, Model model)
	{
		return "userRent_Bike";
	}
}
