<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.email.*,car.pool.user.*,java.util.*" %>

<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	//a container for the users information
	User user = null;
	String message = "";
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");

		Formatter formatter = new Formatter();
		//code to allow interaction with db
		CarPoolStore cps = new CarPoolStoreImpl();
		RideListing rl = cps.getRideListing();
		int currentUser = cps.getUserIdByURL(OpenIdFilter
				.getCurrentUser(s));

		//code to add a ride to the user's selected rides
		if (request.getParameter("rideselect") != null) {
			int rideID = Integer.parseInt(request
					.getParameter("rideselect"));
			while (rl.next()) {
				if (rideID == rl.getRideID()) {
					cps.takeRide(currentUser, rideID, Integer
							.parseInt(rl.getStartLocation()), Integer
							.parseInt(rl.getEndLocation()));
					formatter
							.format(String
									.format(
											"<p>You have successfully booked a ride from: %s, to: %s, on: %s</p>",
											rl.getStartLocation(), rl
													.getEndLocation(),
											rl.getRideDate()));
					message = formatter.toString();
					//message += "<p>You have successfully booked a ride from: "+rl.getStartLocation()+", to: "+rl.getEndLocation()+", on "+rl.getRideDate()+".</p>";
					try {
						Email email = new Email();
						user = (User) s.getAttribute("user");
						if (user != null && user.getEmail() != null) {
							email.setToAddress(user.getEmail());
							email
									.setSubject("Car Pool Ride booking success");
							email
									.setMessage(String
											.format(
													"You have successfully booked a ride from: %s, to: %s, on: %s\n",
													rl
															.getStartLocation(),
													rl.getEndLocation(),
													rl.getRideDate()));
							SMTP.send(email);
						}
						User offerer = new UserManager()
								.getUserByUserId(new Integer(rl
										.getUserID()));
						if (offerer != null
								&& offerer.getEmail() != null) {
							email.setToAddress(offerer.getEmail());
							email
									.setSubject("Car Pool booking for your offered ride");
							email
									.setMessage(String
											.format(
													"%s has booked a seat for the ride you offered from: %s, to: %s, on: %s",
													user.getUserName(),
													rl
															.getStartLocation(),
													rl.getEndLocation(),
													rl.getRideDate()));
							SMTP.send(email);
						}
					} catch (SMTPException e) {
						// Sorry no go. Might not be set up properly
						e.printStackTrace();
					}
				}
			}
		}
	} else {
		response.sendRedirect(request.getContextPath());
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE> Ride Successfully Booked! </TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<%@include file="include/javascriptincludes.html" %>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="Content" id="Content">
			<%=message%>
		</DIV>

	<%@ include file="leftMenu.html" %>

	</BODY>
</HTML>