<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="java.util.Formatter,org.verisign.joid.consumer.OpenIdFilter,org.verisign.joid.util.UrlUtils,org.verisign.joid.OpenIdException,car.pool.persistance.*,car.pool.user.User,car.pool.user.UserManager,car.pool.user.UserFactory,car.pool.persistance.exception.InvaildUserNamePassword,java.util.*" %>

<%
	HttpSession s = request.getSession(true);

	//a user needs to log in to view this page
	// a container for the users information
	User user = null;
	CarPoolStore cps = new CarPoolStoreImpl();
	int rideCount = 0;
	int requestCount = 0;
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");

		//code to add user to the db if they have just registered
		if (request.getParameter("newUser") != null) {
			cps.addUser((String) request.getParameter("openid_url"),
					(String) request.getParameter("userName"),
					(String) request.getParameter("email"),
					(String) request.getParameter("phone"));
		}

		//code to find the number of requests a user has to join a ride
		ArrayList<Integer> rideIDs = new ArrayList<Integer>();
		RideListing rl = cps.searchRideListing(RideListing.searchUser,user.getUserName());
		while (rl.next()) {
			rideIDs.add(rl.getRideID());
			rideCount++;
		}

		for (int i = 0; i < rideIDs.size(); i++) {
			RideDetail rd = cps.getRideDetail(rideIDs.get(i));
			while (rd.hasNext()) {
				if ((rd.getUserID() != user.getUserId()) && (rd.getConfirmed() == false)) {
					requestCount++;
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
		<TITLE>Welcome to The Car Pool</TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<%@include file="include/javascriptincludes.html" %>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

	<DIV class="Content" id="Content">
		<h2 class="title" id="title">Welcome to The Car Pool,
		<%
			if (s.getAttribute("signedin") != null) {
		%>
			<%=" " + user.getUserName()%><%
				//OpenIdFilter.getCurrentUser(s)
			%></h2>
		<%
			}
		%>
		<br /><br />
		<h2>Instructions:</h2>
		<div class="Box" id="Box">
			<p>Make a selection from the menu on your left to explore what our site has to offer.</p>
		</div>
		<br /><br />
		<h2>A Summary Of Your Details:</h2>
		<div class="Box" id="Box">
			<p>Your current social score is <%=cps.getScore((user.getUserId()))%></p>
			<p>Your have offered <%=rideCount%> rides in total so far!</p>
			<p>Your have <%=requestCount%> users awaiting approval for rides you have offered!</p>
			<%if (requestCount > 0) { %>
			<p>Click <a href="<%=response.encodeURL("myRideDetails.jsp") %>">here</a> to view their requests.</p>
			<%} %>
			<p>Click <a href="<%=response.encodeURL("myDetails.jsp") %>">here</a> to access your account page.</p>
		</div>
		<br /> <br /> <br />
		<p>-- <a href="<%=response.encodeURL("logout.jsp") %>">Logout</a> --</p>
	</DIV>		

	<%@ include file="leftMenu.jsp" %>

	</BODY>
</HTML>

