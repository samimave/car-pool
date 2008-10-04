<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="java.util.Formatter, org.verisign.joid.consumer.OpenIdFilter, org.verisign.joid.util.UrlUtils, org.verisign.joid.OpenIdException, car.pool.persistance.*, car.pool.user.User, car.pool.user.UserManager, car.pool.user.UserFactory, car.pool.persistance.exception.InvaildUserNamePassword" %>

<%
HttpSession s = request.getSession(true);

//a container for the users information
/*User user = null;
if(s.getAttribute("signedin") != null ) {
	user = (User)s.getAttribute("user");
} else {
	response.sendRedirect("");
}*/ //TODO: uncomment

//code to allow interaction with db
CarPoolStore cps = new CarPoolStoreImpl();

//code to add user to the db
if (request.getParameter("newUser") != null) {
	cps.addUser((String)request.getParameter("openid_url"),(String)request.getParameter("userName"),(String)request.getParameter("email"),(String)request.getParameter("phone"));
}
%>

<HTML>
	<HEAD>
		<TITLE> Welcome to The Car Pool </TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<%@include file="include/javascriptincludes.html" %>
	</HEAD>
	<BODY onload="runBrowserTests()">

	<%@ include file="headingTest.html" %>

	<DIV id="Content" class="Content">
		<h2>Welcome to The Car Pool,
		<%/*if(s.getAttribute("signedin") != null ) {%>
			<%=" "+user.getUserName()%></h2>
		<%} */%>
		<p>Eventually the person's upcoming rides will be displayed here.</p>
	</DIV>		

	<%@ include file="leftMenuTest.html" %>

	</BODY>
</HTML>

