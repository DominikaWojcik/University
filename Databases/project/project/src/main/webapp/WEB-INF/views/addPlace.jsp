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

	<h1>Enter place information</h1>
		
	<form:form id="newPlaceForm" method="POST" action="/project/addPlace" 
		modelAttribute="placeCreationData">
   	<table class="table table-striped">
	  
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
	     	<td><form:label path="type">Type</form:label></td>
	     	<td><form:select class="form-control" id="selectType" path="type" onchange="onSelect(this);">
	     			<form:option value="stacja">Station</form:option>
	     			<form:option value="serwis">Service</form:option>
	     		</form:select>
	     	</td>
	    </tr>
	    <tr>
	    	<td><form:label path="positionCount">Position count</form:label></td>
	    	<td><form:input id="positionCount" path="positionCount"/></td>
	    </tr>
	    <tr>
	    	<td><form:label path="tel">Phone number</form:label></td>
	    	<td><form:input id="tel" path="tel"/></td>
	    </tr>
	</table>  
	
		<input class="btn btn-success" type="submit" value="Submit"/>
		
	</form:form>

		
	</div> 
	<script type="text/javascript">
	    function onSelect(selected) {
			var pc = document.getElementById("positionCount");
			var tel = document.getElementById("tel");
	       if(selected.value == "stacja"){
				pc.disabled = false;
				tel.disabled = true;
	    	} else {
	    		pc.disabled = true;
	    		tel.disabled = false;
	    	}
	    }
	    
	    function init() {
		    var sel = document.getElementById("selectType");
		    onSelect(sel);	
	    }; 
	    
	    init();
	</script>
	<script type="text/javascript" src="webjars/jquery/2.2.4/jquery.min.js"></script>
	<script type="text/javascript" src="webjars/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</body>
</html>