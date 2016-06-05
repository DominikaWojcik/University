package com.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.businessLogic.BikeAlreadyTakenException;
import com.businessLogic.LoginData;
import com.businessLogic.PlaceSelection;
import com.businessLogic.StationFullException;
import com.businessLogic.UserRegistration;
import com.entities.Bike;
import com.entities.BikePlace;
import com.entities.Payment;
import com.entities.Place;
import com.entities.Rental;
import com.entities.Service;
import com.entities.Station;
import com.entities.User;
import com.services.IBikeService;
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
	
	@Autowired
	private IBikeService bikeService;
	
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
			model.addAttribute("chosenRental", new Rental());
			
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
	public String rentABike_selectPlace(HttpSession session, Model model)
	{
		session.removeAttribute("chosenPlace");
		session.removeAttribute("rentPhase");
		
		User user = (User) session.getAttribute("user");
		List<? extends Place> availablePlaces;
		
		if(user == null) return "redirect:/";

		if(user.getType().equals("klient"))
			availablePlaces = placeService.getStations();
		else
			availablePlaces = placeService.getPlaces();

		Map<Integer, String> idAddr = new HashMap<Integer, String>();
		for(Place place : availablePlaces)
			idAddr.put(place.getId(), place.toString()); 
		
		model.addAttribute("availablePlaces", idAddr);
		model.addAttribute("chosenPlace", new Place());
		session.setAttribute("rentPhase", "place");
		
		return "userRent_Place";
	}
	
	@RequestMapping(value="/userRent", method = RequestMethod.POST)
	public String rentABike_SelectBike(@ModelAttribute("chosenPlace") Place chosenPlace, 
			@ModelAttribute("chosenBike") Bike chosenBike, 
			Model model, HttpSession session)
	{
		String rentPhase = (String) session.getAttribute("rentPhase");
		
		if(rentPhase.equals("place"))
		{
			chosenPlace = placeService.getPlace(chosenPlace.getId());
			Set<BikePlace> availableBikes = chosenPlace.getBikes();
			Map<Integer, String> bikes = new HashMap<Integer, String>();
			
			for(BikePlace bikePlace : availableBikes)
			{
				bikes.put(bikePlace.getBike().getId(), bikePlace.getBike().toString());
			}
			
			model.addAttribute("chosenBike", new Bike());
			model.addAttribute("availableBikes", bikes);
			session.setAttribute("chosenPlace", chosenPlace);
			session.setAttribute("rentPhase", "bike");
			
			return "userRent_Bike";
		}
		
		if(rentPhase.equals("bike"))
		{
			User user = (User) session.getAttribute("user");
			chosenPlace = (Place) session.getAttribute("chosenPlace");
			chosenBike = bikeService.getBike(chosenBike.getId());
			try
			{
				rentalService.rentABike(user, chosenBike, chosenPlace);
			}
			catch (BikeAlreadyTakenException e)
			{
				System.err.println(e.getMessage());
			}
		}
		
		session.removeAttribute("chosenPlace");
		session.removeAttribute("rentPhase");
		return "redirect:/";
	}
	
	@RequestMapping(value = "/returnBike", method = RequestMethod.POST)
	public String returnBike(@RequestParam(value="chosenRental", required = false) Integer rentalId, 
			@RequestParam(value="phase", required = false) String phase,
			@ModelAttribute("chosenPlace") Place chosenPlace,
			HttpSession session, Model model)
	{
		User user = (User) session.getAttribute("user");
		if(phase != null)
		{
			session.removeAttribute("chosenRental");
			session.removeAttribute("chosenPlace");
			
			Rental rental = rentalService.getRental(rentalId);
			session.setAttribute("chosenRental", rental);
			model.addAttribute("chosenPlace", new Place());
			
			HashMap<Integer, String> availablePlaces = new HashMap<Integer, String>();
			List<Place> nonFullPlaces;
			if(user.getType().equals("serwisant"))
				nonFullPlaces = placeService.getNonFullPlaces();
			else nonFullPlaces = placeService.getNonFullStations();
			
			for(Place place : nonFullPlaces)
				availablePlaces.put(place.getId(), place.toString());
			model.addAttribute("availablePlaces", availablePlaces);
			
			return "returnBike";
		}
		else 
		{
			chosenPlace = placeService.getPlace(chosenPlace.getId());
			Integer endPosition = null;
			if(chosenPlace instanceof Station)
				endPosition = ((Station)chosenPlace).getFreePosition();
			
			Rental rental = (Rental) session.getAttribute("chosenRental");
			try
			{
				rentalService.returnBike(rental, chosenPlace, endPosition);
			}
			catch(StationFullException e)
			{
				System.err.println("Docelowa stacja jest juz pełna");
			}
			
			session.removeAttribute("chosenRental");
			session.removeAttribute("chosenPlace");
			return "redirect:/";
		}
	}
}
