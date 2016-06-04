<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel='stylesheet' href='webjars/bootstrap/3.3.6/css/bootstrap.min.css'>
	<title>City bikes - Account</title>
</head>
<body>

<nav class="navbar navbar-default">
	<div class="container-fluid">
		<ul class="nav navbar-nav">
			<li><a href="/project">Dashboard</a></li>
			<li class="active"><a href="/project/account">Account</a></li>
			<li><a href="/project/userHistory">Rental history</a></li>
            <li><a href="/project/userRent">Rent a bike</a></li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
        	<li><a href="/project/logout">Logout</a></li>
        </ul>
	</div>
</nav>

<div class="container">

		<h2>Account information</h2>
	
	   	<table class="table table-striped">
	   	  
	    <tr>
	        <td>Name</td>
	        <td>${user.getName()}</td>
	    </tr>
	    <tr>
	        <td>Last Name</td>
	        <td>${user.getLastName()}</td>
	    </tr>
	    <tr>
	        <td>Telephone number</td>
	        <td>${user.getTel()}</td>
	    </tr>
	    <tr>
	        <td>E-mail</td>
	        <td>${user.getEmail()}</td>
	    </tr>
	    <tr>
	        <td>Address</td>
	        <td>${user.getAddress()}</td>
	    </tr>
	    <tr>
	        <td>Postal code</td>
	        <td>${user.getPostalCode()}</td>
	    </tr>
		<tr>
	        <td>City</td>
	        <td>${user.getCity()}</td>
	    </tr>
	    <tr>
	        <td>Country</td>
	        <td>${user.getCountry()}</td>
	    </tr>
	    <tr>
	    	<td colspan=2>
	    	<!--  
	    	<form method="POST" action="/project/editUser">
	    		<button class="btn btn-primary" type="submit">Edit personal information</button>
	    	</form> -->
	    	<button class="btn btn-primary" 
	    		onclick="window.location.href='/project/editUser'">Edit personal information</button>
	    	</td>
	    </tr>
		</table> 
		
		
	</div> 
	
	<script type="text/javascript" src="webjars/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="webjars/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</body>
</html>