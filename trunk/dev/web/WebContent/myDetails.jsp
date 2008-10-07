<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*, java.util.ArrayList, java.text.*"%>

<%
HttpSession s = request.getSession(false);

//force the user to login to view the page
//user a container for the users information
User user = null;
String takeConf = "";
String openIDTableRow = "";
String openIDTableForm = "";
//code to get ride details
//temp placeholder variables
String userTable = "<p>No rides found.</p>";
String acceptedTable = "<p>No rides found.</p>";
String awaitTable = "<p>No rides found.</p>";
int socialScore=0;

if (s.getAttribute("signedin") != null) {
	user = (User) s.getAttribute("user");

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
			userTable += "<td> <a href='"+ request.getContextPath() +"/myRideEdit.jsp?rideselect="+ rl.getRideID() +"&userselect="+rl.getUsername()+"'>"+ "Click to manage ride & riders" +"</a> </td> </tr>";

			
	}

	if (userExist) {
		userTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"+
		"<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th><th>Edit Ride Details</th> </tr>"+ userTable +"</table>";
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
		String fromID = tr.getStartID();
		String toID = tr.getStopID();
		
		
		// This acceptedTable shows the rides that the uesr is in and user can withdraw themself from the ride
		// also user can add the ride to their google calender.
		if((tr.getConfirmed()==true)){
			rideExist = true;
			acceptedTable += "<tr><FORM action=\"addRideEvent.jsp\" method=\"post\" target=\"_blank\">";	
			acceptedTable += "<INPUT type=\"hidden\" name=\"withdrawConfirmedRide\" value=\"yes" + "\">";
			acceptedTable += "<td>"+ from +"</td> ";
			acceptedTable += "<td>"+ to +"</td> ";
			acceptedTable += "<td>"+ new SimpleDateFormat("dd/MM/yyyy").format(tr.getRideDate()) +"</td> ";
			acceptedTable += "<td>"+ tr.getTime() +"</td> ";
			acceptedTable += "<td>"+ tr.getStreetNumber()+" "+ tr.getPickUp() +"</td>";
			acceptedTable += "<INPUT type=\"hidden\" name=\"from\" value=\""+fromID + "\">";
			acceptedTable += "<INPUT type=\"hidden\" name=\"to\" value=\""+toID + "\">";
			acceptedTable += "<INPUT type=\"hidden\" name=\"date\" value=\""+new SimpleDateFormat("yyyy-MM-dd").format(tr.getRideDate()) + "\">";
			acceptedTable += "<INPUT type=\"hidden\" name=\"time\" value=\""+tr.getTime() + "\">";	
			acceptedTable += "<INPUT type=\"hidden\" name=\"length\" value=\""+tr.getTime() + "\">";
			acceptedTable += "<td><INPUT type=\"submit\" value=\"Add\" /></td>";
			acceptedTable += "</FORM>";			
			
			acceptedTable += "<FORM action=\"rideEditSuccess.jsp\" method=\"post\">";	
			acceptedTable += "<INPUT type=\"hidden\" name=\"withdrawConfirmedRide\" value=\"yes" + "\">";			
			acceptedTable += "<INPUT type=\"hidden\" name=\"withdrawUserID\" value=\""+currentUser + "\">";
			acceptedTable += "<INPUT type=\"hidden\" name=\"withdrawRideID\" value=\""+tr.getRideID() + "\">";			
			//acceptedTable += "<td>"+ tr.getUsername() +"</td> ";	
			acceptedTable += "<td><INPUT type=\"submit\" value=\"Withdraw\" /></td>";
			acceptedTable += "<td> <a href='"+ request.getContextPath() +"/rideDetails.jsp?rideselect="+ tr.getRideID() +"&userselect="+tr.getUsername() +"'>"+ "Link to ride page" +"</a> </td>";
			acceptedTable += "</FORM></tr>";
			
		}
		// This awaitTable shows the rides that the uesr is requested and user can withdraw the request
		else if (tr.getConfirmed()!=true){
			awaitExist = true;
			awaitTable += "<tr><FORM action=\"rideEditSuccess.jsp\" method=\"post\">";
			awaitTable += "<INPUT type=\"hidden\" name=\"withdrawNotConfirmedRide\" value=\"yes" + "\">";
			awaitTable += "<INPUT type=\"hidden\" name=\"withdrawUserID\" value=\""+currentUser + "\">";
			awaitTable += "<INPUT type=\"hidden\" name=\"withdrawRideID\" value=\""+tr.getRideID() + "\">";
			awaitTable += "<td>"+from+"</td>";
			awaitTable += "<td>"+ to+"</td>";
			awaitTable += "<td>"+ new SimpleDateFormat("dd/MM/yyyy").format(tr.getRideDate()) +"</td> ";
			awaitTable += "<td>"+ tr.getTime() +"</td> ";
			awaitTable += "<td>"+ tr.getStreetNumber()+" "+ tr.getPickUp() +"</td>";
			awaitTable += "<td><INPUT type=\"submit\" value=\"Withdraw\" /></td>";
			awaitTable += "<td> <a href='"+ request.getContextPath() +"/rideDetails.jsp?rideselect="+ tr.getRideID() +"&userselect="+tr.getUsername() +"'>"+ "Link to ride page" +"</a> </td>";
			awaitTable += "</FORM></tr>";
		}
	}

	if (rideExist) {
		acceptedTable = "<table class='rideDetailsSearch'> <tr><th>Starting From</th> <th>Going To</th>"+
		"<th>Departure Date</th> <th>Departure Time</th><th>Your Pick Up Point</th><th>Add Ride to Google Calendar</th> <th>Withdraw from Ride</th> <th>Link</th> </tr>"+ acceptedTable +"</table>";
	}
	else{
			acceptedTable = "<table><tr><td>No users were found.</td></tr></table>";
	}
		
	if (awaitExist) {
		awaitTable = "<table class='rideDetailsSearch'> <tr><th>Starting From</th> <th>Going To</th>"+
		"<th>Departure Date</th> <th>Departure Time</th> <th>Your Pick Up Point</th> <th>Withdraw from Ride</th> <th>Link</th> </tr>"+ awaitTable +"</table>";
	}
	else{
		awaitTable = "<table><tr><td>No users were found.</td></tr></table>";
}
	


	//input openids to the table
	String entries = "";
	for (String oid : user.getOpenIds()) {
		entries += "<option value="+oid+">"+oid+"</option>";
	}
	if (entries != "") {
		openIDTableRow = "<tr> <td>OpenId to remove:</td> <td><select multiple='multiple' NAME='openid'>"+entries+"</select></td> </tr>";
	} 
	if (openIDTableRow != "") {
		openIDTableForm = "<br /><h3>Detach an OpenId from your account:</h3><FORM action='removeopenid'> <INPUT type='hidden' name='removeopenid' /> <TABLE class='updateDetails'>"+openIDTableRow+"<tr></TABLE> <br /><p>Click here to <INPUT type='submit' value='Detach OpenId'/></p><br /><br />";
	} 
	
	//if you have been redirected here from taking a ride print useful info
	if (request.getParameter("rideSelect") != null && request.getParameter("streetTo") != null && request.getParameter("houseNo") != null) {
		cps.takeRide(currentUser,Integer.parseInt(request.getParameter("rideSelect")),Integer.parseInt(request.getParameter("streetTo")),
			Integer.parseInt(request.getParameter("houseNo")),Integer.parseInt(request.getParameter("houseNo"))); //TODO: house end number?
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
	
} else {
	response.sendRedirect(request.getContextPath());
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
		<h2 class="title" id="title">Your Account</h2>
		<br />
		<%=takeConf%>
		<br />
		<h2>Your user details appear below:</h2>
		<div class="Box" id="Box">
		<p>Your current social score is: <%=socialScore%></p>
		<FORM name="updateDetails" action="updateuser" method="post">
			<INPUT type="hidden" name="updateDetails" value="yes">
			<TABLE class='userDetails'>
				<tr> <td>Username:</td> <td><%=user != null ? user.getUserName():""%><!-- <INPUT TYPE="text" NAME="userName" SIZE="25" value="<%=user != null ? user.getUserName() : ""%>">--></td> </tr> 
				<tr> <td>Email Address:</td> <td><INPUT TYPE="text" NAME="email" SIZE="25" value="<%=user != null ? user.getEmail() : ""%>"></td> </tr> 
				<tr> <td>Phone Number:</td> <td><INPUT TYPE="text" NAME="phone" SIZE="25" value="<%=user != null ? user.getPhoneNumber() : ""%>"></td> </tr>
			</TABLE>
			<br />
			<p>Click here to <INPUT TYPE="submit" NAME="confirmUpdate" VALUE="Update Details" SIZE="25"></p>
		</FORM>
		</div>
		<br /><br />
		<h2>Your OpenId:</h2>
		<div class="Box" id="Box">
		<%=openIDTableForm %>
		<h3>Attach an OpenId to your account:</h3>
		<FORM action="addopenid">
			<INPUT type="hidden" name="addopenid"/>
			<TABLE class="updateDetails">
				<tr><td>OpenId to add:</td> <td><INPUT type="text" name="openid"/ size="25"/></td></tr>
			</TABLE>
			<p>Click here to <INPUT type="submit" value="Attach OpenId"/></p>
		</FORM>
		</div>
		<br /><br />
		<h2>Your ride details appear below:</h2>
		<div class="Box" id="Box">
			<h3>Rides you have offered:</h3>
			<%=userTable %>
			<br /><br />
			<h3>You have been approved for the following rides:</h3>	
			<%=acceptedTable %>
			<br /><br />
			<h3>You are awaiting approval for the following rides:</h3>
			<%=awaitTable %>
		</div>
		<br /> <br /> <br />
		<p>-- <a href="welcome.jsp">Home</a> --</p>
	</DIV>

	<%@ include file="leftMenu.html" %>

	</BODY>
</HTML>