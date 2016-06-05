<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel='stylesheet' href='webjars/bootstrap/3.3.6/css/bootstrap.min.css'>
	<title>City bikes - select a bike</title>
</head>
<body>

<nav class="navbar navbar-default">
	<div class="container-fluid">
		<ul class="nav navbar-nav">
			<li><a href="/project">Dashboard</a></li>
			<li><a href="/project/account">Account</a></li>
			<li><a href="/project/userHistory">Rental history</a></li>
            <li class="active"><a href="/project/userRent">Rent a bike</a></li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
        	<li><a href="/project/logout">Logout</a></li>
        </ul>
	</div>
</nav>

<div class="container">

		<h1>Rent a bike</h1>
		
		<h2>Station: <u><c:out value="${sessionScope.chosenPlace.toString()}"></c:out></u></h2>
		
		<h2>Select bike:</h2>
		<form:form method="POST" modelAttribute	="chosenBike">
			<table class="table">
				<tr>
					<td><h4>Select bike:</h4></td>
					<td>
						<form:select class="form-control" path="id">
							<form:options items="${availableBikes}" />
						</form:select>
					</td>
					<td><input class="btn btn-success" type="submit" value="Rent"/></td>
				</tr>
			</table>
		</form:form>
	</div> 
	
	<script type="text/javascript" src="webjars/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="webjars/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</body>
</html>