<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page import="car.pool.persistance.*" %>

<%
CarPoolStore cps = new CarPoolStoreImpl();
cps.addUser(request.getAttribute("openID"),request.getAttribute("userName"),request.getAttribute("email"),request.getAttribute("phone"));
%>

<HTML>
	<HEAD>
		<TITLE>Sign Up for The Car Pool!</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

	<DIV class="content">
		Should output something saying it has worked. 
	</DIV>

	<DIV id="navAlpha">
		Please enter your details.
	</DIV>

	<DIV id="navBeta">
		
	</DIV>

	</BODY>
</HTML>