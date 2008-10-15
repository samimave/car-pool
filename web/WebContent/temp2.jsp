<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>
<%
//force the user to login to view the page
System.out.println(OpenIdFilter.getCurrentUser(request.getSession()));
System.out.println(session.getAttribute("signedin"));
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

//being nice to our users
String message = "";

CarPoolStore cps = new CarPoolStoreImpl();

// RideListing rl = cps.getRideListing();
User user = (User)session.getAttribute("user");
int dbID = user.getUserId();
int rideID = Integer.parseInt(request.getParameter("rideselect"));


RideListing u = cps.searchRideListing(RideListing.searchUser, request.getParameter("userselect"));


String detailsTable = "<p>No info found.</p>";
boolean ridesExist = false;
String from = "";
String to = "";

//System.out.println("got here!");
while (u.next()) {					
	//TODO: this page will work when rl.next() returns
	//System.out.println("rl.getRideID(): "+rl.getRideID());
	if (u.getRideID() == rideID) {
		if (!ridesExist) {
			detailsTable = "";		//first time round get rid of unwanted text
		}
		ridesExist = true;
		from = u.getEndLocation();
		to = u.getStartLocation();
		
		String comment_button_builder = "<FORM action=\"viewComments.jsp\" method=\"post\" target=\"_blank\"> <INPUT type=\"hidden\" name=\"idRide\" value=\"" + rideID + "\"> <INPUT type=\"hidden\" name=\"idUser\" value=\"" + dbID + "\"> <INPUT type=\"submit\" value=\"View Ride Comments\" /></FORM>";
		
		detailsTable += "<tr> <td>Username:</td>  <td>"+ u.getUsername() +"</td></tr> ";
		detailsTable += "<tr> <td> Start Region: </td> <td>"+ from + "</td> </tr>";
		detailsTable += "<tr> <td> Stop Region: </td> <td>"+ to +"</td></tr> ";
		detailsTable += "<tr> <td>Date: </td> <td>"+ u.getRideDate() +"</td></tr> ";
		detailsTable += "<tr> <td> Time: </td> <td>" + " null"+ "</td> </tr>";
		detailsTable += "<tr> <td> Seats: </td> <td>"+ u.getAvailableSeats() +"</td> </tr>";
		detailsTable += "<tr> <td> Additional Info: </td> <td>"+ comment_button_builder +"</td> </tr>";
	}
}
//finish table
if (ridesExist) {
	detailsTable = "<table class='rideDetailsSearch'>"+ detailsTable +"</table>";	
}

//make the options for the street select box
LocationList locations = cps.getLocations();
String options = "";
while (locations.next()){
	options += "<option value='"+locations.getID()+"'>"+locations.getStreetName()+"</option>";
}

%>



<HTML>
	<HEAD>
		<TITLE> Ride Details </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

	<DIV class="content">
		<h2>The ride details appear below:</h2>
		<%=detailsTable %><br>
		<FORM name="comments" action="myDetails.jsp" method="post">
			<INPUT type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect") %>">
			<TABLE class='userComments'>
				<tr> <td>Pick me up from:</td> </tr>
				<tr> <td>House Number</td> <td><INPUT type="text" name="houseNo"></td> </tr>
				<tr> <td>Street</td> <td><SELECT name="streetTo">
           				<option selected="selected">Select a Street</option>
	                	<%=options %>
       				</SELECT></td> </tr>
				<tr> <td>Add a Comment/Query</td> <td><INPUT type="text" name="xtraInfo" size="55"></td> </tr>
				<tr> <td>&nbsp;</td> <td><INPUT type="submit" name="joinRide" value="Take Ride" size="25"></td> </tr>
			</TABLE>
		</FORM>
			
	</DIV>

	<FORM name="showMap" id="map2" method="post" target="_blank" action="displayRouteMap.jsp">
		<INPUT type="submit" value="View Map" > 
		<INPUT type="hidden" name="mapFrom" value= "<%=from%>">
		<INPUT type="hidden" name="mapTo"  value= "<%=to%>" >
		
	</FORM>
		


	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>