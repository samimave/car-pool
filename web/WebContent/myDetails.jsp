<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}
User user = (User)session.getAttribute("user");

//code to interact with db
CarPoolStore cps = new CarPoolStoreImpl();
//String openID = OpenIdFilter.getCurrentUser(request.getSession());
int currentUser = user.getUserId();//cps.getUserIdByURL(openID);
String nameOfUser = user.getUserName();
//code to update details if requested
//if (request.getParameter("updateDetails") != null) {
//	cps.addUser((String)request.getParameter("openid_url"),(String)request.getParameter("userName"),(String)request.getParameter("email"),(String)request.getParameter("phone"));
//}


// code to get ride details
//temp placeholder variables
String userTable = "<p>No rides found.</p>";
String acceptedTable = "<p>No rides found.</p>";
String requestTable = "<p>No rides found.</p>";


boolean userExist = false;


	RideListing rl = cps.searchRideListing(RideListing.searchUser, nameOfUser);
	
	while (rl.next()) {
		if (!userExist) {
			userTable = "";		//first time round get rid of unwanted text
		}
		userExist = true;
		
		String from = rl.getEndLocation();
		String to = rl.getStartLocation();
			
			userTable += "<tr> <td>"+ rl.getUsername() +"</td> ";	
			userTable += "<td>"+ from +"</td> ";
			userTable += "<td>"+ to +"</td> ";
			userTable += "<td>"+ rl.getRideDate() +"</td> ";
			userTable += "<td>"+ "rl.getTime()" +"</td> ";
			userTable += "<td>"+ rl.getAvailableSeats() +"</td> ";
			userTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ rl.getRideID() +"&userselect="+rl.getUsername()+"'>"+ "Link to ride page" +"</a> </td> </tr>";


	}



if (userExist) {
	userTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"+
	"<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th> </tr>"+ userTable +"</table>";
}

//input openids to the table
String entries = "";
String openIDTableRow = "";
for (String oid : user.getOpenIds()) {
	entries += "<option value="+oid+">"+oid+"</option>";
}
if (entries != "") {
	openIDTableRow = "<tr> <td>Open ID:</td> <td><select multiple='multiple' NAME='openid'>"+entries+"</select></td> </tr>";
}

String takeConf = "";
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

%>



<HTML>
	<HEAD>
		<TITLE>User Account Page</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

	<DIV class="content">
		<h2 align="center">Welcome to your Account Page</h2><br /><br />
		<%=takeConf %>
		<h2>Your user details appear below:</h2>
		<FORM name="updateDetails" action="updateuser" method="post">
			<INPUT type="hidden" name="updateDetails" value="yes">
			<TABLE class='userDetails'>
				<tr> <td>Username:</td> <td><%=user.getUserName()%><!-- <INPUT TYPE="text" NAME="userName" SIZE="25" value="<%=user.getUserName()%>">--></td> </tr> 
				<tr> <td>Email Address:</td> <td><INPUT TYPE="text" NAME="email" SIZE="25" value="<%=user.getEmail()%>"></td> </tr> 
				<tr> <td>Phone Number:</td> <td><INPUT TYPE="text" NAME="phone" SIZE="25" value="<%=user.getPhoneNumber()%>"></td> </tr>
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
				<tr><td>OpneId to add: <input type="text" name="openid"/ size="25"/></td></tr>
				<tr><td><input type="submit" value="Attach"/></td></tr>
			</table>
		</form>
		<h2>Your ride details appear below:</h2><br />
		<p>Your offers</p>
		<%=userTable %><br />
		<p>Approving acceptance</p>
		<p>The users below are awaiting your approval on their acceptance of your offer. If you can pick them up at the place they want click Approve otherwise click Reject.</p>
		<%//when the user click approve the boolean value confirm should be set to true. %>
		<%=requestTable %>
		<p>Rides you have been accepted and approved for.</p>
		<%=acceptedTable %>
	</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>