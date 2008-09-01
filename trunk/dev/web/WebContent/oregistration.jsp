<%@ page language="java" contentType="text/html; charset=US-ASCII" pageEncoding="US-ASCII"%>
<%@ page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.user.authentication.servlet.HtmlUtils"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<title>Sign Up for The Car Pool!</title>
<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>
</head>
<body>
	<%@ include file="heading.html" %>
	
	<div class="content">
	<%if(OpenIdFilter.getCurrentUser(session) != null) { %>
		<h1>Register yourself by filling in your details below</h1>
		<form action="oadduser" method="post">
			<div>UserName: <input type="text" name="userName"/><a href="#">Check Availability</a></div>
			<div>Email: <input type="text" name="email"/></div>
			<div>Phone: <input type="text" name="phone"/></div>
			<div><input type="submit" value="Register"/></div>
		</form>
	<%} else { %>
		<h1>Please Authenticate yourself using OpenId</h1>
			<%=HtmlUtils.generateSigninForm("openidlogin", "post") %>
	<%} %>
	</div>
	<div id="navAlpha">
		Please enter your details.
	</div>

	<div id="navBeta">
		
	</div>
</body>
</html>