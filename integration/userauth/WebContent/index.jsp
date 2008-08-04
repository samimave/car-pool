<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page import="org.verisign.joid.consumer.OpenIdFilter" %>

<%
if (request.getAttribute("logout") == "yes") {
	session.invalidate();
}
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
		<%if(OpenIdFilter.getCurrentUser(s) == null) {
			%>Please Log in<%
		} else {
		%> Logged in as <% out.println(OpenIdFilter.getCurrentUser(s));  }%>
	</div>

	<div id="navBeta">
		<%@include file="openidlogin.html"%>
	</div>
		
	</body>
</html>

