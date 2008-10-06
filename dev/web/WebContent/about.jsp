<%@page errorPage="errorPage.jsp" %>
<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>
<%
HttpSession s = request.getSession(true);

//a user doesnt need to log in to view this page
//a container for the users information
User user = null;
if(s.getAttribute("signedin") != null ) {
	user = (User)s.getAttribute("user");
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>About Us</title>
	<style type="text/css" media="screen">@import "TwoColumnLayout.css";</style>
	<%@include file="include/javascriptincludes.html" %>
</head>
<body>
	<%@ include file="heading.html" %>

	<DIV class="Content" id="Content">
		<h2 class="title" id="title">About The Car Pool</h2>
		<br /><br />
		<h2>What We Provide:</h2>
		<div class="Box" id="Box">
			<p>A paragraph or two about our website</p>
		</div>
		<br /> <br /> <br />
<%
if (user != null) { 		//depending if the user is logged in or not different link should be displayed
%> 
	<p>-- <a href="welcome.jsp">Home</a> --</p>	
<%
} else { 
%>
	<p>-- <a href="index.jsp">Back to Login Page</a> --</p>	
<%
} 
%>
		</DIV>

<%
if (user != null) { 		//depending if the user is logged in or not different side menus should be displayed
%> 
	<jsp:include page="leftMenu.html" flush="false" />
<%
} else { 
%>
	<jsp:include page="leftMenuLogin.html" flush="false" />
<%
} 
%>

</body>
</html>