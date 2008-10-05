<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>
<%@page import="java.io.ObjectOutputStream"%>
<%
HttpSession s = request.getSession(true);

int timeout = s.getMaxInactiveInterval();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE> The Car Pool </TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<%@include file="include/javascriptincludes.html" %>
	</HEAD>
	<BODY onload="formCookieCheck()">

	<%@ include file="heading.html" %>

	<DIV id="Content" class="Content">
		<p>To see what rides we have available without logging in <a href="searchRides.jsp">click here.</a></p>
		<p>To find out more about our website and what we offer <a href="about.jsp">click here.</a></p>
	</DIV>

	<%@ include file="leftMenuLogin.html" %>

	</BODY>
</HTML>

