<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, org.verisign.joid.util.UrlUtils, org.verisign.joid.OpenIdException, car.pool.persistance.*, car.pool.user.User, car.pool.user.UserManager, car.pool.user.UserFactory, car.pool.persistance.exception.InvaildUserNamePassword" %>

<%
// a container for the users information
User user = null;
if(session.getAttribute("signedin") != null ) {
	user = (User)session.getAttribute("user");
} else {
	response.sendRedirect("");
}

//being nice to our users
String message = "";
if (request.getParameter("sThx") != null) {
	message += "<p> Thanks for signing up! </p>";
}

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
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

	<DIV class="content">
		<h2 align="center">Welcome to The Car Pool,
		<%if(session.getAttribute("signedin") != null ) {%>
			<%=" "+user.getUserName()%><%//OpenIdFilter.getCurrentUser(request.getSession())%></h2>
		<%} %>
		<%=message %>
		<p>Eventually the person's upcoming rides will be displayed here.</p>
	</DIV>		

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>

