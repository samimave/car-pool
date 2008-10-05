<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, java.text.SimpleDateFormat,car.pool.user.*,java.util.*" %>

<%
CarPoolStore cps = new CarPoolStoreImpl();

HttpSession s = request.getSession(true);

//a container for the users information
User user = null;
if(s.getAttribute("signedin") != null ) {
	user = (User)s.getAttribute("user");
} else {
	response.sendRedirect(request.getContextPath());
}
int rideCount=0;
//count the number of rides in the db
RideListing rl = cps.getRideListing();		
while (rl.next()){
	rideCount++;
}



//##############################ALL RIDES TABLE##############################

boolean rExist = false;
String allTable = "";
RideListing all = cps.getRideListing();
while (all.next()) {
	rExist = true;
	String from = all.getStartLocation();
	String to = all.getEndLocation();
	
	allTable += "<tr> <td>"+ all.getUsername() +"</td> ";	
	allTable += "<td>"+ from +"</td> ";
	allTable += "<td>"+ to +"</td> ";
	allTable += "<td>"+ new SimpleDateFormat("dd/MM/yyyy").format(all.getRideDate()) +"</td> ";
	allTable += "<td>"+ all.getTime() +"</td> ";
	allTable += "<td>"+ all.getAvailableSeats() +"</td> ";
	if (user != null) {
		allTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ all.getRideID() +"&userselect="+all.getUsername() +"'>"+ "Link to ride page" +"</a> </td> </tr>";
	} else {
		allTable += "<td>login to view more</td> </tr>";
	}
}
//##############################SEARCH RIDE TABLE##############################


//---------------COMBINE RESULTS----------------------------------
	String rideTable = allTable; 
	if (rExist) {
		rideTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"+
			"<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th> <th>More Info</th> </tr>"+ rideTable +"</table>";
	}
	else {
		rideTable = "<tr><td>No rides were found</td></tr>";
	}
//-------------------------------------------------------------------



%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE>Ride Search Results</TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css"; </STYLE>
		<%@include file="include/javascriptincludes.html" %>
	</HEAD>
	<BODY>
<%@ include file="heading.html" %>
		<DIV class="Content" id="Content">
		
			<p>There are currently <%=rideCount %> rides in the database!</p>
			<%=rideTable %>


		</DIV>

<%
if (user != null) { 		//depending if the user is logged in or not different side menus should be displayed
%> 
	<jsp:include page="leftMenu.html" flush="false" />
<%
} else { 
%>
	<jsp:include page="leftMenuLogin.html" flush="false" />
<%
} 
%>
	</BODY>
</HTML>
