<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page import="org.verisign.joid.consumer.OpenIdFilter" %>

<%
HttpSession s = request.getSession(true);
%>

<html>
	<head>
		<title> The Car Pool </title>
		<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>
	</head>
	<body>

	<%@ include file="heading.html" %>

		<div class="content">
			<h5 align="center">Welcome to The Car Pool</h5>
			<p>Please Log in.</p>
		</div>

	<div id="navAlpha">
		<%if(OpenIdFilter.getCurrentUser(request.getSession()) == null) {
			%>Please Log in<%
		} else {
		%> Logged in as <% out.println(OpenIdFilter.getCurrentUser(request.getSession()));  }%>
	</div>

	<div id="navBeta">
		<%@include file="openidlogin.html"%>
	</div>
		
	</body>
</html>

