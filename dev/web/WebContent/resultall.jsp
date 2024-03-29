<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,java.text.SimpleDateFormat,car.pool.user.*,java.util.*" %>

<%
	HttpSession s = request.getSession(true);

	//a user doesnt need to log in to view this page
	//a container for the users information
	User user = null;
	CarPoolStore cps = new CarPoolStoreImpl();
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");
	}
	int rideCount = 0;
	//count the number of rides in the db
	RideListing rl = cps.getRideListing();
	while (rl.next()) {
		String d = new SimpleDateFormat("dd/MM/yyyy").format(rl.getRideDate())+" "+rl.getTime();
		Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);
		if (dt.after(new Date())) {
			rideCount++;
		}
	}

	//##############################ALL RIDES TABLE##############################

	boolean rExist = false;
	String allTable = "";
	RideListing all = cps.getRideListing();
	while (all.next()) {
		String d = new SimpleDateFormat("dd/MM/yyyy").format(all.getRideDate())+" "+all.getTime();
		Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);
		if (dt.after(new Date())) {
			rExist = true;
			String from = all.getStartLocation();
			String to = all.getEndLocation();
			if (user != null) {
				allTable += "<tr> <td>" + "<a href='"+response.encodeURL(request.getContextPath()+"/profile.jsp?profileId="+ all.getUserID())+"'>"+all.getUsername()+ "</a></td>";
			} else {
				allTable += "<tr> <td>" +all.getUsername()+ "</td>";
			}
			allTable += "<td>" + from + "</td> ";
			allTable += "<td>" + to + "</td> ";
			allTable += "<td>"
					+ new SimpleDateFormat("dd/MM/yyyy").format(all
							.getRideDate()) + "</td> ";
			allTable += "<td>" + all.getTime() + "</td> ";
			allTable += "<td>" + all.getAvailableSeats() + "</td> ";
			if ((user != null)) {
				allTable += "<td> <a href='" + response.encodeURL(request.getContextPath()
						+ "/rideDetails.jsp?rideselect="
						+ all.getRideID() + "&userselect="
						+ all.getUsername()) + "'>"
						+ "Link to ride page" + "</a> </td> </tr>";
			} else {
				allTable += "<td>login to view more</td> </tr>";
			}
		}
	}
	//##############################SEARCH RIDE TABLE##############################

	//---------------COMBINE RESULTS----------------------------------
	String rideTable = allTable;
	if (rExist) {
		rideTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"
				+ "<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th> <th>More Info</th> </tr>"
				+ rideTable + "</tr></table>";
	} else {
		rideTable = "<p>Sorry, no rides were found that match your criteria.</p>";
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
			<h2 class="title" id="title">Manual Search</h2>
			<br /><br />
			<h2>Results:</h2>
			<div class="Box" id="Box">
				<p>There are currently <%=rideCount%> rides in the database!</p><br />
				<h3>Click 'Link to ride page' To Take A Ride:</h3>
				<%=rideTable%>
			</div>
			<br /><br /><br />
			<p>-- <a href="<%=response.encodeURL("searchRides.jsp") %>">Go back to Search page</a> --</p>
		</DIV>

<%
	if (user != null) { //depending if the user is logged in or not different side menus should be displayed
%> 
	<jsp:include page="leftMenu.jsp" flush="false" />
<%
	} else {
%>
	<jsp:include page="leftMenuLogin.jsp" flush="false" />
<%
	}
%>
	</BODY>
</HTML>
