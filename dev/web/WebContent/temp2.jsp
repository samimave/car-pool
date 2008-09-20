<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>
<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

//being nice to our users
String message = "";

CarPoolStore cps = new CarPoolStoreImpl();
RideListing rl = cps.getRideListing();
User user = (User)session.getAttribute("user");
int dbID = user.getUserId();
int rideID = Integer.parseInt(request.getParameter("rideselect"));

String detailsTable = "<p>No info found.</p>";
boolean ridesExist = false;

//System.out.println("got here!");
while (rl.next()) {					//TODO: this page will work when rl.next() returns
	//System.out.println("rl.getRideID(): "+rl.getRideID());
	if (rl.getRideID() == rideID) {
		if (!ridesExist) {
			detailsTable = "";		//first time round get rid of unwanted text
		}
		ridesExist = true;
		
		//code to get the name associated with the street id
		LocationList allLocs = cps.getLocations();
		String from = "";
		String to = "";
		while (allLocs.next()){
			if (allLocs.getID() == Integer.parseInt(rl.getStartLocation())) {
				from = allLocs.getStreetName();	
			} else if (allLocs.getID() == Integer.parseInt(rl.getEndLocation())) {
				to = allLocs.getStreetName();
			}
				
		}
		
		detailsTable += "<tr> <td>Username:</td>  <td>"+ rl.getUsername() +"</td></tr> ";
		detailsTable += "<tr> <td> Start Region: </td> <td>"+ from + "</td> </tr>";
		detailsTable += "<tr> <td> Stop Region: </td> <td>"+ to +"</td></tr> ";
		detailsTable += "<tr> <td>Date: </td> <td>"+ rl.getRideDate() +"</td></tr> ";
		detailsTable += "<tr> <td> Time: </td> <td>" + rl.getTime()+ "</td> </tr>";
		detailsTable += "<tr> <td> Seats: </td> <td>"+ rl.getAvailableSeats() +"</td> </tr>";
		detailsTable += "<tr> <td> Additional Info: </td> <td>"+ rl.getComment() +"</td> </tr>";
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

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>