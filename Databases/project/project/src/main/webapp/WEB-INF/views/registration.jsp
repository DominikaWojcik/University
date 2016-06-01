<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel='stylesheet' href='webjars/bootstrap/3.3.6/css/bootstrap.min.css'>
<title>Rowery miejskie - rejestracja</title>
</head>
<body>

	<div class="container">
	
	<h2>Registration</h2>
	<form:form method="POST" action="/project/addUser">
	   <table class="table table-striped">
	   	<tr>
	        <td><form:label path="tel">Telephone number</form:label></td>
	        <td><form:input path="tel" /></td>
	    </tr>
	   	<tr>
	        <td><form:label path="pin">PIN</form:label></td>
	        <td><form:password path="pin" /></td>
	    </tr>
	   	<tr>
	        <td><form:label path="pinRep">Repeat PIN</form:label></td>
	        <td><form:password path="pinRep" /></td>
	    </tr>
	   	<tr>
	        <td><form:label path="email">E-mail</form:label></td>
	        <td><form:input path="email" /></td>
	    </tr>
	    <tr>
	        <td><form:label path="name">Name</form:label></td>
	        <td><form:input path="name" /></td>
	    </tr>
	    <tr>
	        <td><form:label path="lastName">Last name</form:label></td>
	        <td><form:input path="lastName" /></td>
	    </tr>
	    <tr>
	        <td><form:label path="address">Address</form:label></td>
	        <td><form:input path="address" /></td>
	    </tr>
	    <tr>
	        <td><form:label path="postalCode">Postal code</form:label></td>
	        <td><form:input path="postalCode" /></td>
	    </tr>
	    <tr>
	        <td><form:label path="city">City</form:label></td>
	        <td><form:input path="city" /></td>
	    </tr>
	    <tr>
	        <td><form:label path="country">Country</form:label></td>
	        <td><form:input path="country" /></td>
	    </tr>
	    <tr>
	        <td colspan="2">
	            <input class="btn btn-success" type="submit" value="Submit"/>
	        </td>
	    </tr>
	</table>  
	</form:form>
	
	</div>
	
	<script type="text/javascript" src="webjars/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="webjars/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</body>
</html>