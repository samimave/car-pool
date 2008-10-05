<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*, java.util.ArrayList, java.text.*"%>

<%
String takeConf = "";
String openIDTableRow = "";
User user = null;
//code to get ride details
//temp placeholder variables
String userTable = "<p>No rides found.</p>";
String acceptedTable = "<p>No rides found.</p>";
String awaitTable = "<p>No rides found.</p>";
int socialScore=0;

//force the user to login to view the page
if (session.isNew() || (OpenIdFilter.getCurrentUser(session) == null && session.getAttribute("signedin") == null)) {
	//response.sendRedirect("");
	request.getRequestDispatcher("").forward(request, response);
} else {
	user = (User)session.getAttribute("user");

	//code to interact with db
	CarPoolStore cps = new CarPoolStoreImpl();
	int currentUser = user.getUserId();
	String nameOfUser = user.getUserName();
	socialScore = cps.getScore(currentUser);

	boolean userExist = false;
	ArrayList<Integer> rideIDs = new ArrayList<Integer>();

	RideListing rl = cps.searchRideListing(RideListing.searchUser, nameOfUser);
	
	while (rl.next()) {
		if (!userExist) {
			userTable = "";		//first time round get rid of unwanted text
		}
		userExist = true;
		rideIDs.add(rl.getRideID());
		String from = rl.getStartLocation();
		String to = rl.getEndLocation();
			userTable += "<tr> <td>"+ rl.getUsername() +"</td> ";	
			userTable += "<td>"+ from +"</td> ";
			userTable += "<td>"+ to +"</td> ";
			userTable += "<td>"+ new SimpleDateFormat("dd/MM/yyyy").format(rl.getRideDate()) +"</td> ";
			userTable += "<td>"+ rl.getTime() +"</td> ";
			userTable += "<td>"+ rl.getAvailableSeats() +"</td> ";
			userTable += "<td> <a href='"+ request.getContextPath() +"/myRideEdit.jsp?rideselect="+ rl.getRideID() +"&userselect="+rl.getUsername()+"'>"+ "Link to ride page" +"</a> </td> </tr>";

			
	}

	if (userExist) {
		userTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"+
		"<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th><th>Link</th> </tr>"+ userTable +"</table>";
	}
	
	boolean rideExist = false;
	boolean awaitExist = false;
	TakenRides tr = cps.getTakenRides(currentUser);
	while (tr.hasNext()){
		if (!rideExist) {
			acceptedTable = "";		//first time round get rid of unwanted text
		}
		if (!awaitExist) {
			awaitTable = "";		//first time round get rid of unwanted text
		}
		
		//rideIDs.add(rl.getRideID());
		String from = tr.getStartLocation();
		String to = tr.getStopLocation();
		
		if((tr.getConfirmed()==true)){
			rideExist = true;
			acceptedTable += "<tr><FORM action=\"myDetails.jsp\" method=\"post\">";	
			acceptedTable += "<INPUT type=\"hidden\" name=\"withdrawRide\" value=\"yes" + "\">";
			//acceptedTable += "<td>"+ tr.getUsername() +"</td> ";	
			acceptedTable += "<td>"+ from +"</td> ";
			acceptedTable += "<td>"+ to +"</td> ";
			acceptedTable += "<td>"+ new SimpleDateFormat("dd/MM/yyyy").format(tr.getRideDate()) +"</td> ";
			acceptedTable += "<td>"+ tr.getTime() +"</td> ";
			acceptedTable += "<td>"+"Add"+"</td> ";
			acceptedTable += "<td><INPUT type=\"submit\" value=\"Withdraw\" /></td>";
			acceptedTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ tr.getRideID() +"&userselect="+tr.getUsername() +"'>"+ "Link to ride page" +"</a> </td>";
			acceptedTable += "</FORM></tr>";	
		}
		else if (tr.getConfirmed()!=true){
			awaitExist = true;
			awaitTable += "<tr><td>"+from+"</td>";
			awaitTable += "<td>"+ to+"</td>";
			awaitTable += "<td>"+ new SimpleDateFormat("dd/MM/yyyy").format(tr.getRideDate()) +"</td> ";
			awaitTable += "<td>"+ tr.getTime() +"</td> ";
			awaitTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ tr.getRideID() +"&userselect="+tr.getUsername() +"'>"+ "Link to ride page" +"</a> </td>";
			
		}
	}

	if (rideExist) {
		acceptedTable = "<table class='rideDetailsSearch'> <tr><th>Starting From</th> <th>Going To</th>"+
		"<th>Departure Date</th> <th>Departure Time</th><th>Add Ride to Google Calendar</th> <th>Withdraw from Ride</th> <th>Link</th> </tr>"+ acceptedTable +"</table>";
	}
		
	if (awaitExist) {
		awaitTable = "<table class='rideDetailsSearch'> <tr><th>Starting From</th> <th>Going To</th>"+
		"<th>Departure Date</th> <th>Departure Time</th> <th>Link</th> </tr>"+ awaitTable +"</table>";
	}
	


	//input openids to the table
	String entries = "";
	
	for (String oid : user.getOpenIds()) {
		entries += "<option value="+oid+">"+oid+"</option>";
	}
	if (entries != "") {
		openIDTableRow = "<tr> <td>Open ID:</td> <td><select multiple='multiple' NAME='openid'>"+entries+"</select></td> </tr>";
	}

	
	//if you have been redirected here from taking a ride print useful info
	if (request.getParameter("rideSelect") != null && request.getParameter("streetTo") != null && request.getParameter("houseNo") != null) {
		cps.takeRide(currentUser,Integer.parseInt(request.getParameter("rideSelect")),Integer.parseInt(request.getParameter("streetTo")),
			Integer.parseInt(request.getParameter("houseNo")));
		LocationList locations = cps.getLocations();
		String target = "";
		while (locations.next()){
			if (locations.getID() == Integer.parseInt(request.getParameter("streetTo"))) {
				target = locations.getStreetName();
			}
		}
		RideListing rl2 = cps.getRideListing();
		String el = "";
		String dt = "";
		String tm = "";
		while (rl2.next()){
			//System.out.println(rl2.getRideID()+", "+request.getParameter("rideSelect"));
			if (rl2.getRideID() == Integer.parseInt(request.getParameter("rideSelect"))) {
				el = rl2.getEndLocation();
				dt = new SimpleDateFormat("dd/MM/yyyy").format(rl2.getRideDate());
				tm = rl2.getTime();
			}
		}
		takeConf = "<p>" + "You have requested to be picked up from " +request.getParameter("houseNo")+" "+target+" at "+tm+" on "+dt+ "</p>";
	}
	
	
	
	
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE>User Account Page</TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

	<DIV class="Content" id="Content">
		<h2 align="center">Welcome to your Account Page</h2><br /><br />
		<%=takeConf %>
		<h2>Your user details appear below:</h2>
		<p>Your current social score is: <%=socialScore%></p>
		<FORM name="updateDetails" action="updateuser" method="post">
			<INPUT type="hidden" name="updateDetails" value="yes">
			<TABLE class='userDetails'>
				<tr> <td>Username:</td> <td><%=user != null ? user.getUserName():""%><!-- <INPUT TYPE="text" NAME="userName" SIZE="25" value="<%=user != null ? user.getUserName() : ""%>">--></td> </tr> 
				<tr> <td>Email Address:</td> <td><INPUT TYPE="text" NAME="email" SIZE="25" value="<%=user != null ? user.getEmail() : ""%>"></td> </tr> 
				<tr> <td>Phone Number:</td> <td><INPUT TYPE="text" NAME="phone" SIZE="25" value="<%=user != null ? user.getPhoneNumber() : ""%>"></td> </tr>
  				<tr> <td>&nbsp;</td> <td><INPUT TYPE="submit" NAME="confirmUpdate" VALUE="Update Details" SIZE="25"></td> </tr>
			</TABLE>
		</FORM>
		<h2>Detach a OpenId from your account</h2>
		<form action="removeopenid">
			<input type="hidden" name="removeopenid"/>
			<table class="updateDetails">
				<tr><td><%=openIDTableRow %></td></tr>
				<tr><td><input type="submit" value="Detach"/></td></tr>
			</table>
		</form>
		<h2>Detach a OpenId from your account</h2>
		<form action="addopenid">
			<input type="hidden" name="addopenid"/>
			<table class="updateDetails">
				<tr><td>OpenId to add: <input type="text" name="openid"/ size="25"/></td></tr>
				<tr><td><input type="submit" value="Attach"/></td></tr>
			</table>
		</form>
		<h2>Your ride details appear below:</h2><br />
		<table>
		<tr> <th colspan='2' style='border:2px outset #333333'>Rides you have Offered</th><th>&nbsp;</th> <th>&nbsp;</th></tr>
		<tr><th>&nbsp;</th></tr>
		<%=userTable %>
		</table>
		
		<table>
		<tr> <th colspan='2' style='border:2px outset #333333'>You have been approved for the following rides</th><th>&nbsp;</th> <th>&nbsp;</th></tr>
		<tr><th>&nbsp;</th></tr>
		<%=acceptedTable %>
		</table>

		<table>
		<tr> <th colspan='2' style='border:2px outset #333333'>You are awaiting approval for the following rides</th><th>&nbsp;</th> <th>&nbsp;</th></tr>
		<tr><th>&nbsp;</th></tr>
		<%=awaitTable %>
		</table>
		
	</DIV>

	<%@ include file="leftMenu.html" %>

	</BODY>
</HTML>