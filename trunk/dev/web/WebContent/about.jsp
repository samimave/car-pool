<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>
<%
User user = null;
//check if the user is logged in and viewing the page
if (!(OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null)) {
	user = (User)session.getAttribute("user"); 
}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>About Us</title>
	<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>
</head>
<body>
	<%@ include file="heading.html" %>

	<DIV class="content" id="content">
		<p>A paragraph about our website</p>
		<p><a href="welcome.jsp">Home</a></p>
	</DIV>

<%
if (user != null) { 		//depending if the user is logged in or not different side menus should be displayed
%> 
	<jsp:include page="leftMenu.html" flush="false" />
	<jsp:include page="rightMenu.jsp" flush="false" />
<%
} else { 
%>
	<jsp:include page="leftMenuLogin.html" flush="false" />
	<jsp:include page="rightMenuLogin.html" flush="false" />
<%
} 
%>

</body>
</html>