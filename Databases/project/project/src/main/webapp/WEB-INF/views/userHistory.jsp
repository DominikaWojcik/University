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
			<li><a href="/project/account">Account</a></li>
			<li class="active"><a href="/project/userHistory">Rental history</a></li>
            <li><a href="/project/userRent">Rent a bike</a></li>
		</ul>
		<ul class="nav navbar-nav navbar-right">
        	<li><a href="/project/logout">Logout</a></li>
        </ul>
	</div>
</nav>

<div class="container">

		<h1>User history</h1>
		
		<h2>Rentals</h2>
		<table class="table table-striped">
			<tr>
				<th>Rental id</th>
				<th>Bike id</th>
				<th>Start station</th>
				<th>Start position</th>
				<th>Start date</th>
				<th>End station</th>
				<th>End station position</th>
				<th>End date</th>
			</tr>
		
			<c:forEach var="rental" items="${rentals}">
				<tr>
					<td>${rental.getId()}</td>
					<td>${rental.getBike().getId()}</td>
					<td>${rental.getStartPlace().getAddress()}</td>
					<td>${rental.getStartPosition()}</td>
					<td>${rental.getRentalDate().toString()}</td>
					<td>${rental.getEndPlace().getAddress()}</td>
					<td>${rental.getEndPosition()}</td>
					<td>
						<c:choose>
							<c:when test="${rental.getReturnDate() == null}">
								<form:form action="/project/returnBike" method="POST">
								<input type="hidden" name="chosenRental" value="${rental.getId()}" />
								<input class="btn btn-warning" type="submit" value="Return the bike"/>
							</form:form>
							</c:when>
							<c:otherwise>
								${rental.getReturnDate().toString()}
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</c:forEach>
		</table>
		
		<h2>Payments</h2>
		
		<h3>Amount due: ${amountDue.toString()}</h3>
		<table class="table table-striped">
			<tr>
				<th>Payment id</th>
				<th>Type</th>
				<th>Rental id</th>
				<th>Amount</th>
				<th>Issue date</th>
				<th>Payment date</th>
			</tr>
		
			<c:forEach var="payment" items="${payments}">
				<tr>
					<td>${payment.getId()}</td>
					<td>${payment.getType()}</td>
					<td>${payment.getRental().getId()}</td>
					<td>${payment.getAmount()}</td>
					<td>${payment.getIssueDate().toString()}</td>
					<td>${payment.getPaymentDate().toString()}</td>
				</tr>
			</c:forEach>
		</table>
	
	</div> 
	
	<script type="text/javascript" src="webjars/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="webjars/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</body>
</html>