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
import com.businessLogic.BikeCreationData;
import com.businessLogic.CannotDeleteBikeException;
import com.businessLogic.CannotDeletePlaceException;
import com.businessLogic.CannotDeleteUserException;
import com.businessLogic.LoginData;
import com.businessLogic.PlaceCreationData;
import com.businessLogic.PlaceSelection;
import com.businessLogic.RegistrationException;
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
import com.services.BikeService;
import com.services.IBikeService;
import com.services.IPlaceService;
import com.services.IRentalService;
import com.services.IUserService;

@Controller
@SessionAttributes("user")
public class AdministratorController 
{
	@Autowired
	private IUserService userService;
	
	@Autowired
	private IRentalService rentalService;
	
	@Autowired
	private IPlaceService placeService;
	
	@Autowired
	private IBikeService bikeService;
	
	@RequestMapping(value = "/bikes", method = RequestMethod.GET)
	public String bikes(HttpSession session, Model model)
	{
		User user = (User) session.getAttribute("user");
		if(user == null || !user.getType().equals("serwisant"))
			return "redirect:/";
		
		List<Bike> bikes = bikeService.getAllBikes();
		model.addAttribute("chosenBike", new Bike());
		model.addAttribute("bikes", bikes);
		
		return "bikes";
	}
	
	@RequestMapping(value = "/addBike", method = RequestMethod.GET)
	public String addBike(Model model, HttpSession session)
	{
		User user = (User) session.getAttribute("user");
		if(user == null || !user.getType().equals("serwisant"))
			return "redirect:/";
		
		HashMap<Integer, String> services = new HashMap<Integer, String>();
		for(Service service : placeService.getServices())
			services.put(service.getId(), service.toString());
		
		model.addAttribute("bikeCreationData", new BikeCreationData());
		model.addAttribute("services", services);
		return "addBike";
	}
	
	@RequestMapping(value = "/addBike", method = RequestMethod.POST)
	public String saveNewBike(@ModelAttribute("bikeCreationData") BikeCreationData data, 
			Model model, HttpSession session)
	{
		Service service = (Service) placeService.getPlace(data.getServiceId());
		bikeService.addBike(data, service);
		return "redirect:/bikes";
	}
	
	@RequestMapping(value = "/editBike", method = RequestMethod.GET)
	public String editBike(@ModelAttribute("chosenBike") Bike bike, Model model, HttpSession session)
	{
		User user = (User) session.getAttribute("user");
		if(user == null || !user.getType().equals("serwisant"))
			return "redirect:/";
		
		bike = bikeService.getBike(bike.getId());
		model.addAttribute("bike", bike);
		
		return "editBike";
	}
	
	@RequestMapping(value = "/editBike", method = RequestMethod.POST)
	public String saveEditedBike(@ModelAttribute("bike") Bike bike, Model model, HttpSession session)
	{	
		bikeService.editBike(bike);
		return "redirect:/bikes";
	}
	
	@RequestMapping(value = "/deleteBike", method = RequestMethod.POST)
	public String deleteBike(@ModelAttribute("chosenBike") Bike bike)
	{
		bike = bikeService.getBike(bike.getId());
		try
		{
			bikeService.delete(bike);
		}
		catch(CannotDeleteBikeException e)
		{
			System.out.println(e.getMessage());
		}
		
		return "redirect:/bikes";
	}
	
	@RequestMapping(value = "/users", method = RequestMethod.GET)
	public String users(HttpSession session, Model model)
	{
		User user = (User) session.getAttribute("user");
		if(user == null || !user.getType().equals("serwisant"))
			return "redirect:/";
		
		List<User> users = userService.getAllUsers();
		model.addAttribute("chosenUser", new User());
		model.addAttribute("users", users);
		
		return "users";
	}
	
	@RequestMapping(value = "/editUserType", method = RequestMethod.GET)
	public String editUserType(@ModelAttribute("chosenUser") User toChange, HttpSession session, Model model)
	{
		User user = (User) session.getAttribute("user");
		if(user == null || !user.getType().equals("serwisant"))
			return "redirect:/";
		
		toChange = userService.getUser(toChange.getId());	
		if(user.getId() != toChange.getId())
			userService.changeType(toChange);
		
		return "redirect:/users";
	}
	
	@RequestMapping(value="/deleteUser", method = RequestMethod.GET)
	public String deleteUser(@ModelAttribute("chosenUser") User toDelete, HttpSession session, Model model)
	{
		User user = (User) session.getAttribute("user");
		if(user == null || !user.getType().equals("serwisant"))
			return "redirect:/";
		
		toDelete = userService.getUser(toDelete.getId());
		if(user.getId() != toDelete.getId())
		{
			List<Rental> rentals = rentalService.getActiveRentals(toDelete);
			int activeRentals = 0;
			if(rentals != null && rentals.size()>0)
				activeRentals = rentals.size();
			
			try
			{
				userService.delete(toDelete, activeRentals);
			}
			catch(CannotDeleteUserException e)
			{
				System.out.println(e.getMessage());
			}
		}
		
		return "redirect:/users";
	}
	
	@RequestMapping(value = "/places", method = RequestMethod.GET)
	public String places(HttpSession session, Model model)
	{
		User user = (User) session.getAttribute("user");
		if(user == null || !user.getType().equals("serwisant"))
			return "redirect:/";
		
		List<Station> stations = placeService.getStations();
		List<Service> services = placeService.getServices();
		model.addAttribute("chosenPlace", new Place());
		model.addAttribute("stations", stations);
		model.addAttribute("services", services);
		
		return "places";
	}
	
	@RequestMapping(value = "/addPlace", method = RequestMethod.GET)
	public String addPlace(Model model, HttpSession session)
	{
		User user = (User) session.getAttribute("user");
		if(user == null || !user.getType().equals("serwisant"))
			return "redirect:/";
		
		model.addAttribute("placeCreationData", new PlaceCreationData());
		return "addPlace";
	}
	
	@RequestMapping(value = "/addPlace", method = RequestMethod.POST)
	public String saveNewPlace(@ModelAttribute("placeCreationData") PlaceCreationData data, 
			Model model, HttpSession session)
	{	
		placeService.addNewPlace(data);
		return "redirect:/places";
	}
	
	@RequestMapping(value = "/editPlace", method = RequestMethod.GET)
	public String editPlace(@ModelAttribute("editPlace") Integer placeId,
			Model model, HttpSession session)
	{
		User user = (User) session.getAttribute("user");
		if(user == null || !user.getType().equals("serwisant"))
			return "redirect:/";
		
		Place chosenPlace = placeService.getPlace(placeId);
		PlaceCreationData oldData = new PlaceCreationData(chosenPlace);
		
		model.addAttribute("oldData", oldData);
		return "editPlace";
	}
	
	@RequestMapping(value = "/editPlace", method = RequestMethod.POST)
	public String editPlaceNewData(@ModelAttribute("oldData") PlaceCreationData data, 
			Model model, HttpSession session)
	{
		placeService.save(data.toPlace());
		return "redirect:/places";
	}
	
	@RequestMapping(value="/deletePlace", method = RequestMethod.GET)
	public String deletePlace(@ModelAttribute("chosenPlace") Integer placeId, HttpSession session, Model model)
	{
		User user = (User) session.getAttribute("user");
		if(user == null || !user.getType().equals("serwisant"))
			return "redirect:/";
		
		Place place = placeService.getPlace(placeId);
		try
		{
			placeService.delete(place);
		}
		catch(CannotDeletePlaceException e)
		{
			System.out.println(e.getMessage());
		}
		
		return places(session,model);
	}
	
	@RequestMapping(value="/activeRentals", method = RequestMethod.GET)
	public String activeRentals(HttpSession session, Model model)
	{
		User user = (User) session.getAttribute("user");
		if(user == null || !user.getType().equals("serwisant"))
			return "redirect:/";
		
		List<Rental> rentals = rentalService.getActiveRentals();
		model.addAttribute("activeRentals", rentals);
		
		return "activeRentals";
	}
	
}
