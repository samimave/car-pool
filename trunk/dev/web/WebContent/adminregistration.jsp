<%@page errorPage="errorPage.jsp" %>
<?xml version="1.0" encoding="US-ASCII" ?>
<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<%
String username = request.getParameter("username");
String userpass = request.getParameter("userpass");
String message = "";
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
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<%@include file="include/javascriptincludes.html" %>
	</head>
	<body>
		<%@ include file="heading.html" %>
		
		<div class="Content" id="Content">
			<% if(message.length() > 0) {%><p><strong><%=message %></strong></p><%} %>
			<form action="adminreg" method="post">
				<input type="hidden" name="adminreg" value="yes"/>
				<input type="hidden" name="username" value="<%=username %>"/>
				<input type="hidden" name="userpass" value="<%=userpass %>"/>
				<table class="register">
					<tr><td>Password: </td><td> <input type="password" name="password1"/> </td></tr>
					<tr><td>Repeat Password: </td><td><input type="password" name="password2"/></td></tr>
					<tr><td>Email: </td><td><input type="text" name="email"/></td></tr>
					<tr><td>Phone: </td><td><input type="text" name="phone"/></td></tr>
					<tr> <td>&nbsp;</td> <td><input type="submit" value="Create"/></td> </tr>
				</table>
			</form>
		</div>
		
		<div class="Menu" id="Menu">
			<p><a href="<%=response.encodeURL("welcome.jsp")%>"> <img class="logo" border="0" src="images/Car Pool 6 75.bmp" width="263" height="158"> </a></p> <br />
			Please enter your details. 
			<% if(message.length() > 0) {%><p><strong><%=message %></strong></p><%} %>
		</div>
	</body>
</html>