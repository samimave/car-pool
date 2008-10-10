<%@page isErrorPage="true" %>
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
	<title>Site Error</title>
	<style type="text/css" media="screen">@import "TwoColumnLayout.css";</style>
	<%@include file="include/javascriptincludes.html" %>
</head>
<body>
	<%@ include file="heading.html" %>

	<DIV class="content" id="Content">
		<h2 class="title" id="title">An Error Occurred</h2>
		<br /><br />
		<h2>Message:</h2>
		<div class="Box" id="Box">
			<p>An error has occurred in the site and the administrator has been notified.</p>
			<p>Please try again in a few minutes. We are sorry for any inconvenience.</p>
		</div>
				<br /> <br /> <br />
<%
if (user != null) { 		//depending if the user is logged in or not different link should be displayed
%> 
	<p>-- <a href="<%=response.encodeURL("welcome.jsp")%>">Home</a> --</p>	
<%
} else { 
%>
	<p>-- <a href="<%=response.encodeURL("index.jsp")%>">Back to Login Page</a> --</p>	
<%
} 
%>
	</DIV>

<%
if (user != null) { 		//depending if the user is logged in or not different side menus should be displayed
%> 
	<jsp:include page="leftMenu.jsp" flush="false" />
<%
} else { 
%>
	<jsp:include page="leftMenuLogin.jsp" flush="false" />
<%
} 
%>

</body>
</html>