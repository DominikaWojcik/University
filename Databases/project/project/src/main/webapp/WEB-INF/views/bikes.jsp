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
			<li class="active"><a href="/project/bikes">Bikes</a></li>
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

		<h1>Bikes</h1>
		<form:form action="/project/addBike" method="GET">
			<input class="btn btn-primary" type="submit" value="Add new bike"/>
		</form:form>
		
		<h2>Bikes</h2>
		<table class="table table-striped">
			<tr>
				<th>Id</th>
				<th>Brand</th>
				<th>Model</th>
				<th>Purchase date</th>
				<th>Current place</th>
				<th>Current position</th>
				<th></th>
				<th></th>
			</tr>
		
			<c:forEach var="bike" items="${bikes}">
				<tr>
					<td>${bike.getId()}</td>
					<td>${bike.getBrand()}</td>
					<td>${bike.getModel()}</td>
					<td>${bike.getPurchaseDate()}</td>
					<td>${bike.getPlace().getPlace().toString()}</td>
					<td>${bike.getPlace().getPosition()}</td>
					<td>
						<form:form action="/project/editBike" method="GET" modelAttribute="chosenBike">
							<input type="hidden" name="id" value="${bike.getId()}" />
							<input class="btn btn-info" type="submit" value="Edit"/>
						</form:form>
					</td>
					<td>
						<form:form action="/project/deleteBike" method="POST" modelAttribute="chosenBike">
							<input type="hidden" name="id" value="${bike.getId()}" />
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