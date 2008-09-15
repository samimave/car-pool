<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

User user = (User)session.getAttribute("user");

boolean ridesExist = false;
String rideTable = "<p>No rides found.</p>";
CarPoolStore cps = new CarPoolStoreImpl();
RideListing rl = cps.getRideListing();
while (rl.next()) {
	if (!ridesExist) {
		rideTable = "";		//first time round get rid of unwanted text
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
	
	rideTable += "<tr> <td>"+ rl.getUsername() +"</td> ";	
	rideTable += "<td>"+ from +"</td> ";
	rideTable += "<td>"+ to +"</td> ";
	rideTable += "<td>"+ rl.getRideDate() +"</td> ";
	rideTable += "<td>"+ rl.getTime() +"</td> ";
	rideTable += "<td>"+ rl.getAvailableSeats() +"</td> ";
	rideTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ rl.getRideID() +"'>"+ "Link to ride page" +"</a> </td> </tr>";
}
if (ridesExist) {
	rideTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"+
		"<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th> <th>More Info</th> </tr>"+ rideTable +"</table>";
}
%>

<HTML>
	<HEAD>
		<TITLE>Ride Search</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css"; </STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="content">
			<p>Please enter the search criteria in the boxes below and click search</p>
			<FORM NAME="searchFrm" method="post" action="newRideConfirmation.jsp" >	
				<TABLE class="rideSearch">
					<tr> <td>Ride Type:</td> <td>
					<SELECT name="rideType">
						<option value="sel">Select an Option</option>
						<option value="Ride Offer">Ride Offer</option>
						<option value="Ride Request">Ride Request</option>
					</SELECT></td> </tr>	
					<tr> <td>Reccurence:</td> <td>
					<SELECT name="reccurence">
						<option value="sel">Select an Option</option>
						<option value="oneoff">One-Off</option>
						<option value="regular">Regular</option>
					</SELECT></td> </tr>
					<tr> <td>Return Trip:</td> <td>						
					<SELECT name="return">
						<option value="sel">Select an Option</option>
						<option value="Yes">Yes</option>
						<option value="No">No</option>
					</SELECT></td> </tr>
					<tr> <td>&nbsp;</td> <td><INPUT TYPE="submit" NAME="search" VALUE="Search" SIZE="25"></td> </tr>

					<%=rideTable %>
				</TABLE>
			</FORM>
		</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>