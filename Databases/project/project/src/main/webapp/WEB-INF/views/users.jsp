<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel='stylesheet' href='webjars/bootstrap/3.3.6/css/bootstrap.min.css'>
	<title>City bikes - User history</title>
</head>
<body>

<nav class="navbar navbar-default">
	<div class="container-fluid">
		<ul class="nav navbar-nav">
			<li><a href="/project">Dashboard</a></li>
			<li class="active"><a href="/project/users">Users</a></li>
			<li><a href="/project/bikes">Bikes</a></li>
			<li><a href="/project/places">Places</a></li>
			<li><a href="/project/activeRentals">Active rentals</a>
            <li><a href="/project/userRent">Get a bike</a></li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
        	<li><a href="/project/logout">Logout</a></li>
        </ul>
	</div>
</nav>

<div class="container">

		<h1>Users</h1>

		<table class="table table-striped">
			<tr>
				<th>Id</th>
				<th>Phone number</th>
				<th>E-mail</th>
				<th>Name</th>
				<th>Last name</th>
				<th>Address</th>
				<th>Postal code</th>
				<th>City</th>
				<th>Country</th>
				<th>Registered since</th>
				<th>Type</th>
				<th></th>
				<th></th>
			</tr>
		
			<c:forEach var="user" items="${users}">
				<tr>
					<td>${user.getId()}</td>
					<td>${user.getTel() }</td>
					<td>${user.getEmail() }</td>
					<td>${user.getName() }</td>
					<td>${user.getLastName() }</td>
					<td>${user.getAddress()}</td>
					<td>${user.getPostalCode()}</td>
					<td>${user.getCity()}</td>
					<td>${user.getCountry()}</td>
					<td>${user.getRegistrationDate()}</td>
					<td>${user.getType()}</td>
					<td>
						<form:form action="/project/editUserType" method="GET" modelAttribute="chosenUser">
							<input type="hidden" name="id" value="${user.getId()}" />
							<input class="btn btn-info" type="submit" value="Change type"/>
						</form:form>
					</td>
					<td>
						<form:form action="/project/deleteUser" method="GET" modelAttribute="chosenUser">
							<input type="hidden" name="id" value="${user.getId()}" />
							<input class="btn btn-danger" type="submit" value="Delete"/>
						</form:form>
					</td>
				</tr>
			</c:forEach>
		</table>
				
	</div> 
	
	<script type="text/javascript" src="webjars/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="webjars/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</body>
</html>