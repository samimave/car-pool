<%@ page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.email.*" %>

<%
HttpSession s = request.getSession(false);

//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(s) == null && s.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

//being nice to our users
String message = "";
Formatter formatter = new Formatter();
//code to allow interaction with db
CarPoolStore cps = new CarPoolStoreImpl();
RideListing rl = cps.getRideListing();
int currentUser = cps.getUserIdByURL(OpenIdFilter.getCurrentUser(s));


//code to add a ride to the user's selected rides
if (request.getParameter("rideselect") != null) {
	int rideID = Integer.parseInt(request.getParameter("rideselect"));
	while (rl.next()) {
		if (rideID == rl.getRideID()) {
			cps.takeRide(currentUser,rideID,Integer.parseInt(rl.getStartLocation()), Integer.parseInt(rl.getEndLocation()));
			formatter.format(String.format("<p>You have successfully booked a ride from: %s, to: %s, on: %s</p>", rl.getStartLocation(), rl.getEndLocation(), rl.getRideDate()));
			message = formatter.toString();
			//message += "<p>You have successfully booked a ride from: "+rl.getStartLocation()+", to: "+rl.getEndLocation()+", on "+rl.getRideDate()+".</p>";
			try {
				Email email = new Email();
				User user = (User)session.getAttribute("user");
				if(user != null && user.getEmail() != null) {
					email.setToAddress(user.getEmail());
					email.setSubject("Car Pool Ride booking success");
					email.setMessage(String.format("You have successfully booked a ride from: %s, to: %s, on: %s\n", rl.getStartLocation(), rl.getEndLocation(), rl.getRideDate()));
					SMTP.send(email);
				}
				User offerer = new UserManager().getUserByUserId(new Integer(rl.getUserID()));
				if(offerer != null && offerer.getEmail() != null) {
					email.setToAddress(offerer.getEmail());
					email.setSubject("Car Pool booking for your offered ride");
					email.setMessage(String.format("%s has booked a seat for the ride you offered from: %s, to: %s, on: %s", user.getUserName(), rl.getStartLocation(), rl.getEndLocation(), rl.getRideDate()));
					SMTP.send(email);
				}
			} catch(SMTPException e) {
				// Sorry no go. Might not be set up properly
				e.printStackTrace();
			}
		}
	}
}
%>

<HTML>
	<HEAD>
		<TITLE> Ride Successfully Booked! </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
		<%@include file="include/javascriptincludes.html" %>
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