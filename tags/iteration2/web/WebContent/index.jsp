<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*, car.pool.user.*" %>
<%@page import="java.io.ObjectOutputStream"%>
<%
HttpSession s = request.getSession(true);

//to show who is logged in
String message = "Please log in.";
/*if (OpenIdFilter.getCurrentUser(s) != null ) {
	message = "Logged in as "+OpenIdFilter.getCurrentUser(s);
} else*/ if(  session.getAttribute("signedin") != null ) {
	User user = ((User)session.getAttribute("user"));
	message = "Logged in as " + user.getUserName();
	message += " " + user.getUserId();
}

//will delete the current database
if (request.getParameter("delete") != null) {
	CarPoolStoreImpl cps = new CarPoolStoreImpl();
	cps.removeAll("donotusethis");
}
%>


<HTML>
	<HEAD>
		<TITLE> The Car Pool </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

	<DIV id="content" class="content">
		<h2 align="center">Welcome to The Car Pool</h2><br />
		<p>To see what rides we have available without logging in <a href="searchRides.jsp">click here.</a></p>
		<p>To find out more about our website and what we offer <a href="about.jsp">click here.</a></p>
	</DIV>

	<%@ include file="leftMenuLogin.html" %>

	<%@ include file="rightMenuLogin.html" %>	

	</BODY>
</HTML>

