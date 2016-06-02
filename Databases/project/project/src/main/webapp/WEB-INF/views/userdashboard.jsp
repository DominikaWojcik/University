<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel='stylesheet' href='webjars/bootstrap/3.3.6/css/bootstrap.min.css'>
	<title>City bikes - User dashboard</title>
</head>
<body>

<div class="container">
	
	<h2>User dashboard</h2>

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
    	<form method="POST" action="/project/editUser">
    		<button class="btn btn-primary" type="submit">Edit personal information</button>
    	</form>
    	</td>
    </tr>
	</table>  
	
	</div>
	<script type="text/javascript" src="webjars/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="webjars/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</body>
</html>