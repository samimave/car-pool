<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*" %>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(session) == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}


String offerTable = "<p>No rides found.</p>";
String acceptedTable = "<p>No rides found.</p>";
String requestTable = "<p>No rides found.</p>";

//int dbID = cps.getUserIdByURL(request.getParameter("user"));
%>



<HTML>
	<HEAD>
		<TITLE>User Account Page</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

<DIV class="content">
		<h2 align="center">Welcome to your Account Page</h2></br></br>
		<p><b>Your user details appear below<b></p>
		<INPUT TYPE="submit" NAME="edit" VALUE="Edit" SIZE="25"></br></br>
		<p><b>Your ride details appear below<b></p>
		<p><em><u>Your offers</u></em></p>
		<%=offerTable %>
		<p><em><u>Accepted Rides</u></em></p>
		<%=acceptedTable %>
		<p><em><u>Your requests</u></em></p>
		<%=requestTable %>

	</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>