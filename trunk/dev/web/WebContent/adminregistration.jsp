<%@page errorPage="errorPage.jsp" %>
<?xml version="1.0" encoding="US-ASCII" ?>
<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<%
String username = request.getParameter("username");
String userpass = request.getParameter("userpass");
String message = "";

//if the user has entered valid admin details continue, else redirect to login page
if(username == null || userpass == null) {
	response.sendRedirect(request.getContextPath());
} else {
	username = request.getParameter("username");
	userpass = request.getParameter("userpass");
	if(!username.toLowerCase().startsWith("admin") && !userpass.equals("12weak34")) {
		response.sendRedirect(request.getContextPath());
	} else {
		if(request.getParameter("error") != null ) {
			message = request.getParameter("error");
		}
	}
}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII" />
		<title>Administrator Registration</title>
		<style type="text/css" media="screen">@import "TwoColumnLayout.css";</style>
		<%@include file="include/javascriptincludes.html" %>
		<script>
		//form validation rules
		var rules=new Array();
		rules[0]='password|required';
		rules[1]='password2:Confirmed password|equal|$password';
		rules[2]='phone|numeric';
		rules[3]='email|required';
		rules[4]='email|email';
		
		//could provide helpful text if needed
		//yav.addHelp('userName', 'Provide your username');
		//yav.addHelp('password', 'Provide your password');
		//yav.addHelp('password2', 'Confirm your password');
		//yav.addHelp('phone', 'Provide a contact phone number');
		//yav.addHelp('email', 'Provide your e-mail');
		//yav.addHelp('verifytext', 'Enter the text shown above');
		</script>
	</head>
	<body onload="yav.init('register', rules);">
		<%@ include file="heading.html" %>
		
		<div class="Content" id="Content">
			<% if(message.length() > 0) {%><p><strong><%=message %></strong></p><%} %>
			<h2 class="title" id="title">Admin Registration</h2>
			<br /><br />
			<h2>Please Enter Admin Details:</h2>
			<div class="Box" id="Box">
			<p>Note: * indicates a required field.</p><br />
			<form name="register" id="register" onsubmit="return checkOnSubmit('register', rules);" action="<%=response.encodeURL("adminreg")%>" method="post">
				<input type="hidden" name="adminreg" value="yes"/>
				<input type="hidden" name="username" value="<%=username %>"/>
				<input type="hidden" name="userpass" value="<%=userpass %>"/>
				<table class="register">
					<tr><td>Password*: </td><td><input type="password" name="password" size="25"/>&nbsp;&nbsp;<span id=errorsDiv_password></span></td></tr>
					<tr><td>Confirm Password*: </td><td><input type="password" name="password2" size="25"/>&nbsp;&nbsp;<span id=errorsDiv_password2></span></td></tr>
					<tr><td>Email*: </td><td><input type="text" name="email" size="25"/>&nbsp;&nbsp;<span id=errorsDiv_email></span></td></tr>
					<tr><td>Phone: </td><td><input type="text" name="phone" size="25"/>&nbsp;&nbsp;<span id=errorsDiv_phone></span></td></tr>
					</table>
			<br />
			<p>Click here to <input type="submit" value="Register"/></p>
			</form>
			</div>
		</div>
		
		<div class="Menu" id="Menu">
			<p><a href="<%=response.encodeURL("welcome.jsp")%>"> <img class="logo" border="0" src="images/Car Pool 6 75.bmp" width="263" height="158"> </a></p> <br />
			Please enter your details. 
			<% if(message.length() > 0) {%><p><strong><%=message %></strong></p><%} %>
		</div>
	</body>
</html>