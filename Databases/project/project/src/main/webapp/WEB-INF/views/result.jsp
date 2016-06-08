<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel='stylesheet' href='webjars/bootstrap/3.3.6/css/bootstrap.min.css'>
<title>City bikes - User successfully registered</title>
</head>
<body>

<div class="container">

<div class="alert alert-success">
	<strong>Success!</strong> Registration successful
</div>

<h2>Submitted user information</h2>
   <table class="table table-striped">
   	<tr>
        <td>Telephone number</td>
        <td>${tel}</td>
    </tr>
    
    <tr>
        <td>E-mail</td>
        <td>${email}</td>
    </tr>
   
    <tr>
        <td>Name</td>
        <td>${name}</td>
    </tr>
    <tr>
        <td>Last Name</td>
        <td>${lastName}</td>
    </tr>
    <tr>
        <td>Address</td>
        <td>${address}</td>
    </tr>
    <tr>
        <td>Postal code</td>
        <td>${postalCode}</td>
    </tr>
	<tr>
        <td>City</td>
        <td>${city}</td>
    </tr>
    <tr>
        <td>Country</td>
        <td>${country}</td>
    </tr>
	</table>
	
	<button class="btn btn-primary" 
			onclick="window.location.href='/project/'">Return to homepage</button>
	
</div> 
	
	<script type="text/javascript" src="webjars/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="webjars/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</body>
</html>