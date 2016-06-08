<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel='stylesheet' href='webjars/bootstrap/3.3.6/css/bootstrap.min.css'>
	<title>City bikes - User dashboard</title>
</head>
<body>

<nav class="navbar navbar-default">
	<div class="container-fluid">
		<ul class="nav navbar-nav">
		<c:choose>
			<c:when test="${sessionScope.user.getType().equals(\"serwisant\") }">
				<li><a href="/project">Dashboard</a></li>
				<li><a href="/project/users">Users</a></li>
				<li><a href="/project/bikes">Bikes</a></li>
				<li><a href="/project/places">Places</a></li>
				<li><a href="/project/activeRentals">Active rentals</a>
	            <li class="active"><a href="/project/userRent">Get a bike</a></li>
			</c:when>
			<c:otherwise>
				<li><a href="/project">Dashboard</a></li>
				<li><a href="/project/account">Account</a></li>
				<li><a href="/project/userHistory">Rental history</a></li>
	            <li class="active"><a href="/project/userRent">Rent a bike</a></li>
			</c:otherwise>
		</c:choose>
		</ul>
		<ul class="nav navbar-nav navbar-right">
        	<li><a href="/project/logout">Logout</a></li>
        </ul>
	</div>
</nav>

<div class="container">

		<c:choose>
			<c:when test="${sessionScope.user.getType().equals(\"serwisant\")}">
				<h1>Get a bike</h1>
			</c:when>
			<c:otherwise>
				<h1>Rent a bike</h1>
			</c:otherwise>
		</c:choose>
		
		<c:choose>
			<c:when test="${sessionScope.user.getType().equals(\"serwisant\")}">
				<h2>Select place:</h2>
			</c:when>
			<c:otherwise>
				<h2>Select station:</h2>
			</c:otherwise>
		</c:choose>
		
		<form:form method="POST" modelAttribute	="chosenPlace">
			<table class="table">
				<tr>
					<td>
						<c:choose>
							<c:when test="${sessionScope.user.getType().equals(\"serwisant\")}">
								<h4>Select place:</h4>
							</c:when>
							<c:otherwise>
								<h4>Select station:</h4>
							</c:otherwise>
						</c:choose>
					</td>
					<td>
						<form:select class="form-control" path="id">
							<form:options items="${availablePlaces}" />
						</form:select>
					</td>
					<td><input class="btn btn-primary" type="submit" value="Next"/></td>
				</tr>
			</table>
		</form:form>
	</div> 
	
	<script type="text/javascript" src="webjars/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="webjars/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</body>
</html>