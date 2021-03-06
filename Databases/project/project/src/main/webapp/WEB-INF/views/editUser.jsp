<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel='stylesheet' href='webjars/bootstrap/3.3.6/css/bootstrap.min.css'>
	<title>City bikes - Edit place</title>
</head>
<body>

<nav class="navbar navbar-default">
	<div class="container-fluid">
		<ul class="nav navbar-nav">
			<li><a href="/project">Dashboard</a></li>
			<li><a href="/project/users">Users</a></li>
			<li><a href="/project/bikes">Bikes</a></li>
			<li class="active"><a href="/project/places">Places</a></li>
			<li><a href="/project/activeRentals">Active rentals</a>
            <li><a href="/project/userRent">Get a bike</a></li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
        	<li><a href="/project/logout">Logout</a></li>
        </ul>
	</div>
</nav>


<div class="container">
	
	<h2>Edit personal information</h2>

	<form:form metod="POST" action="/project/savedUser" modelAttribute="newUserInfo">
	   <table class="table table-striped">
	    <tr>
	        <td><form:label path="name">Name</form:label></td>
	        <td><form:input path="name" value="${user.getName()}"/></td>
	    </tr>
	    <tr>
	        <td><form:label path="lastName">Last name</form:label></td>
	        <td><form:input path="lastName" value="${user.getLastName()}"/></td>
	    </tr>
	    <tr>
	        <td><form:label path="address">Address</form:label></td>
	        <td><form:input path="address" value="${user.getAddress()}"/></td>
	    </tr>
	    <tr>
	        <td><form:label path="postalCode">Postal code</form:label></td>
	        <td><form:input path="postalCode" value="${user.getPostalCode()}"/></td>
	    </tr>
	    <tr>
	        <td><form:label path="city">City</form:label></td>
	        <td><form:input path="city" value="${user.getCity()}"/></td>
	    </tr>
	    <tr>
	        <td><form:label path="country">Country</form:label></td>
	        <td><form:input path="country" value="${user.getCountry()}"/></td>
	    </tr>
	   	<tr>
	        <td><form:label path="email">E-mail</form:label></td>
	        <td><form:input path="email" value="${user.getEmail()}"/></td>
	    </tr>
	    <tr>
	        <td colspan="2">
	            <input class="btn btn-success" type="submit" value="Save"/>
	        </td>
	    </tr>
	</table>  
	</form:form>

	</div>
	<script type="text/javascript" src="webjars/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="webjars/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</body>
</html>