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

		<h1>Places</h1>
		<form:form action="/project/addPlace" method="GET">
			<input class="btn btn-primary" type="submit" value="Add new place"/>
		</form:form>
		
		<h2>Stations</h2>
		<table class="table table-striped">
			<tr>
				<th>Id</th>
				<th>Address</th>
				<th>Postal code</th>
				<th>City</th>
				<th>Country</th>
				<th>Bike count</th>
				<th>Position count</th>
				<th></th>
				<th></th>
			</tr>
		
			<c:forEach var="station" items="${stations}">
				<tr>
					<td>${station.getId()}</td>
					<td>${station.getAddress()}</td>
					<td>${station.getPostalCode()}</td>
					<td>${station.getCity()}</td>
					<td>${station.getCountry()}</td>
					<td>${station.getBikes().size()}</td>
					<td>${station.getPositionCount()}</td>
					<td>
						<form:form action="/project/editPlace" method="GET">
							<input type="hidden" name="editPlace" value="${station.getId()}" />
							<input class="btn btn-info" type="submit" value="Edit"/>
						</form:form>
					</td>
					<td>
						<form:form action="/project/deletePlace" method="GET">
							<input type="hidden" name="chosenPlace" value="${station.getId()}" />
							<input class="btn btn-danger" type="submit" value="Delete"/>
						</form:form>
					</td>
				</tr>
			</c:forEach>
		</table>

		<h2>Services</h2>
		<table class="table table-striped">
			<tr>
				<th>Id</th>
				<th>Address</th>
				<th>Postal code</th>
				<th>City</th>
				<th>Country</th>
				<th>Bike count</th>
				<th>Phone number</th>
				<th></th>
				<th></th>
			</tr>
		
			<c:forEach var="service" items="${services}">
				<tr>
					<td>${service.getId()}</td>
					<td>${service.getAddress()}</td>
					<td>${service.getPostalCode()}</td>
					<td>${service.getCity()}</td>
					<td>${service.getCountry()}</td>
					<td>${service.getBikes().size()}</td>
					<td>${service.getTel()}</td>
					<td>
						<form:form action="/project/editPlace" method="GET">
							<input type="hidden" name="editPlace" value="${service.getId()}" />
							<input class="btn btn-info" type="submit" value="Edit"/>
						</form:form>
					</td>
					<td>
						<form:form action="/project/deletePlace" method="GET">
							<input type="hidden" name="chosenPlace" value="${service.getId()}" />
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