<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel='stylesheet' href='webjars/bootstrap/3.3.6/css/bootstrap.min.css'>
<title>Rowery miejskie</title>
</head>
<body>

	<div class="container">
	
	<h2>Strona główna rowerów miejskich</h2>
	
	<form:form method="POST" action="/project/">
	   <table class="table">
	   	<tr>
	        <td><form:label path="tel">Phone number</form:label></td>
	        <td><form:input path="tel" /></td>
	    </tr>
	   	<tr>
	        <td><form:label path="pin">PIN</form:label></td>
	        <td><form:password path="pin" /></td>
	    </tr>
	    <tr>
	        <td>
	            <input class="btn btn-primary" type="submit" value="Login"/>
	        </td>
	        <td>
	        	<input class="btn btn-default" type="button" value="Registration" 
	        		onclick="window.location.href='./register'"/>
	        </td>
	    </tr>
	</table>  
	</form:form>
	
	</div>
	
	<script type="text/javascript" src="webjars/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="webjars/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</body>
</html>