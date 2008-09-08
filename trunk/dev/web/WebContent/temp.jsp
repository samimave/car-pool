<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*" %>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

//being nice to our users
String message = "";

//code to allow interaction with db
CarPoolStore cps = new CarPoolStoreImpl();
RideListing rl = cps.getRideListing();
int currentUser = cps.getUserIdByURL(OpenIdFilter.getCurrentUser(request.getSession()));

//code to add a ride to the user's selected rides
if (request.getParameter("rideselect") != null) {
	int rideID = Integer.parseInt(request.getParameter("rideselect"));
	while (rl.next()) {
		if (rideID == rl.getRideID()) {
			cps.takeRide(currentUser,rideID,Integer.parseInt(rl.getStartLocation()), Integer.parseInt(rl.getEndLocation()));
			message += "<p>You have successfully booked a ride from: "+rl.getStartLocation()+", to: "+rl.getEndLocation()+", on "+rl.getRideDate()+".</p>";
		}
	}
}
%>

<HTML>
	<HEAD>
		<TITLE> Ride Successfully Booked! </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="content">
			<%=message %>
		</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>