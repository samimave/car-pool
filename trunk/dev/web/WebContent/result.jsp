<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, java.text.SimpleDateFormat" %>

<%
CarPoolStore cps = new CarPoolStoreImpl();

//----search parameters-----
String username = request.getParameter("sUser");
String date = request.getParameter("searchDate");

//code to get the name associated with the street id
LocationList forSallLocs = cps.getLocations();
String Sfrom = request.getParameter("startLoc");
String Sto = request.getParameter("endLoc");

//----search parameters-----



String rideTable = "";
boolean ridesExist = false;

	//---------------SEARCH RIDES BY USER----------------------------------

if (username != null)	{
	RideListing rl = cps.searchRideListing(RideListing.searchUser, username);
	
	while (rl.next()) {
		//if (!ridesExist) {
		//	rideTable = "";		//first time round get rid of unwanted text
		//}
		ridesExist = true;
		
		//code to get the name associated with the street id
		LocationList allLocs = cps.getLocations();
		String from = rl.getEndLocation();
		String to = rl.getStartLocation();

		
		rideTable += "<tr> <td>"+ rl.getUsername() +"</td> ";	
		rideTable += "<td>"+ from +"</td> ";
		rideTable += "<td>"+ to +"</td> ";
		rideTable += "<td>"+ rl.getRideDate() +"</td> ";
		rideTable += "<td>"+ "null" +"</td> ";
		rideTable += "<td>"+ rl.getAvailableSeats() +"</td> ";
		rideTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ rl.getRideID() +"'>"+ "Link to ride page" +"</a> </td> </tr>";
	}
}
	//---------------SEARCH RIDES BY DATE----------------------------------
	
if (date != null)	{
	
	RideListing rl = cps.searchRideListing(RideListing.searchDate, date);
	
	while (rl.next()) {
//		if (!ridesExist) {
//			rideTable = "";		//first time round get rid of unwanted text
//		}
		ridesExist = true;
		
		//code to get the name associated with the street id
		LocationList allLocs = cps.getLocations();
		String from = rl.getEndLocation();
		String to = rl.getStartLocation();

		
		rideTable += "<tr> <td>"+ rl.getUsername() +"</td> ";	
		rideTable += "<td>"+ from +"</td> ";
		rideTable += "<td>"+ to +"</td> ";
		rideTable += "<td>"+ rl.getRideDate() +"</td> ";
		rideTable += "<td>"+ "null" +"</td> ";
		rideTable += "<td>"+ rl.getAvailableSeats() +"</td> ";
		rideTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ rl.getRideID() +"'>"+ "Link to ride page" +"</a> </td> </tr>";
	}
}


//---------------SEARCH RIDES BY FROM----------------------------------
	
if (Sfrom != null) {
	RideListing rl = cps.searchRideListing(RideListing.searchDate, Sfrom);
	
	while (rl.next()) {
//		if (!ridesExist) {
//			rideTable = "";		//first time round get rid of unwanted text
//		}
		ridesExist = true;
		
		//code to get the name associated with the street id
		LocationList allLocs = cps.getLocations();
		String from = rl.getEndLocation();
		String to = rl.getStartLocation();

		
		rideTable += "<tr> <td>"+ rl.getUsername() +"</td> ";	
		rideTable += "<td>"+ from +"</td> ";
		rideTable += "<td>"+ to +"</td> ";
		rideTable += "<td>"+ rl.getRideDate() +"</td> ";
		rideTable += "<td>"+ "null" +"</td> ";
		rideTable += "<td>"+ rl.getAvailableSeats() +"</td> ";
		rideTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ rl.getRideID() +"'>"+ "Link to ride page" +"</a> </td> </tr>";
	}
}
//---------------SEARCH RIDES BY TO----------------------------------
	
if (Sto != null) {
	RideListing rl = cps.searchRideListing(RideListing.searchDate, Sto);
	
	while (rl.next()) {
//		if (!ridesExist) {
//			rideTable = "";		//first time round get rid of unwanted text
//		}
		ridesExist = true;
		
		//code to get the name associated with the street id
		LocationList allLocs = cps.getLocations();
		String from = rl.getEndLocation();
		String to = rl.getStartLocation();

		
		rideTable += "<tr> <td>"+ rl.getUsername() +"</td> ";	
		rideTable += "<td>"+ from +"</td> ";
		rideTable += "<td>"+ to +"</td> ";
		rideTable += "<td>"+ rl.getRideDate() +"</td> ";
		rideTable += "<td>"+ "null" +"</td> ";
		rideTable += "<td>"+ rl.getAvailableSeats() +"</td> ";
		rideTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ rl.getRideID() +"'>"+ "Link to ride page" +"</a> </td> </tr>";
	}
}
	
//---------------------------------------------------------------	

	if (ridesExist) {
		rideTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"+
			"<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th> <th>More Info</th> </tr>"+ rideTable +"</table>";
	}
	else {
		rideTable = "no rides were found";
	}

%>

<HTML>
	<HEAD>
		<TITLE>Ride Search Results</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css"; </STYLE>
	</HEAD>
	<BODY>
<%@ include file="heading.html" %>
		<DIV class="content">
		
			<FORM NAME="resultFrm" id="result">	
				<TABLE class="rideSearch">
					<tr><td>You searched for -</td></tr>
					<tr><td>Location from:</td> <td><%=Sfrom%></td></tr>
					<tr><td>Location to:</td> <td><%=Sto%></td></tr>
					<tr><td>Date:</td> <td><%=date%></td></tr>
					<tr><td>User:</td> <td><%=username %></td>
	
					<tr><td>Search results appear below</td></tr>
					<%=rideTable %>

					<tr><td> <a href=searchRides.jsp>Go back to Search page</a> </td> </tr>

				</TABLE>
			</FORM>
		</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>
	</BODY>
</HTML>
