<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,java.text.SimpleDateFormat,car.pool.user.*,java.util.*" %>

<%
	HttpSession s = request.getSession(true);

	//a user doesnt need to log in to view this page
	//a container for the users information
	User user = null;
	String Sto = "";
	String Sfrom = "";
	String strTmp = "";
	String username = "";
	String rideTable = "";
	CarPoolStore cps = new CarPoolStoreImpl();
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");
	}
	//----------------------search parameters------------------------
	//USERNAME
	username = "no username entered";
	if (request.getParameter("sUser") != "") {
		username = request.getParameter("sUser");
	} else {
		username = "no username entered";
	}

	//DATE
	//date formatting for use by db 
	//dd/MM/yyyy -> yyyy-MM-dd
	String strOutDt = "no date entered";
	strTmp = request.getParameter("searchDate");
	if (!strTmp.isEmpty()) {
		Date dtTmp = new SimpleDateFormat("dd/MM/yyyy").parse(strTmp);
		strOutDt = new SimpleDateFormat("yyyy-MM-dd").format(dtTmp);
	} else {
		strTmp = "no date was entered";
	}

	//FROM AND TO

	String fromIdx = request.getParameter("searchFrom");
	String toIdx = request.getParameter("searchTo");

	if (fromIdx.contains("Select a Street")) {
		Sfrom = "no location entered";
	} else {
		//code to get the name associated with the street id
		LocationList allLocs = cps.getLocations();
		while (allLocs.next()) {
			if ((allLocs.getID() == Integer.parseInt(fromIdx))) {
				Sfrom = allLocs.getStreetName();
			}
		}
	}

	if (toIdx.contains("Select a Street")) {
		Sto = "no location entered";
	} else {
		//code to get the name associated with the street id
		LocationList allLocs = cps.getLocations();
		while (allLocs.next()) {
			if ((allLocs.getID() == Integer.parseInt(toIdx))) {
				Sto = allLocs.getStreetName();
			}
		}
	}
	//----------------------end search parameters------------------------

	//##############################SEARCH RIDE TABLE##############################

	ArrayList<Integer> avoidDuplicates = new ArrayList<Integer>();

	//---------------SEARCH RIDES BY USER----------------------------------
	String userTable = "";
	boolean userExist = false;

	if (username != "no username entered") {
		RideListing u = cps.searchRideListing(RideListing.searchUser,
				username);

		while (u.next()) {
			if (!userExist) {
				userTable = ""; //first time round get rid of unwanted text
			}
			userExist = true;

			String from = u.getStartLocation();
			String to = u.getEndLocation();

			if (!avoidDuplicates.contains(u.getRideID())) {
				avoidDuplicates.add(u.getRideID());

				userTable += "<tr> <td>" + u.getUsername() + "</td> ";
				userTable += "<td>" + from + "</td> ";
				userTable += "<td>" + to + "</td> ";
				userTable += "<td>"
						+ new SimpleDateFormat("dd/MM/yyyy").format(u
								.getRideDate()) + "</td> ";
				userTable += "<td>" + u.getTime() + "</td> ";
				userTable += "<td>" + u.getAvailableSeats() + "</td> ";
				if (user != null) {
					userTable += "<td> <a href='"
							+ request.getContextPath()
							+ "/temp2.jsp?rideselect=" + u.getRideID()
							+ "&userselect=" + u.getUsername() + "'>"
							+ "Link to ride page" + "</a> </td> </tr>";
				} else {
					userTable += "<td>login to view more</td> </tr>";
				}
			} else {
				userTable = "";
			}

		}
	}

	//---------------SEARCH RIDES BY DATE----------------------------------
	String dateTable = "";
	boolean dateExist = false;

	if (strTmp != "") {

		RideListing daTbl = cps.searchRideListing(
				RideListing.searchDate, strOutDt);

		while (daTbl.next()) {
			if (!dateExist) {
				dateTable = ""; //first time round get rid of unwanted text
			}
			dateExist = true;

			//code to get the name associated with the street id
			String from = daTbl.getStartLocation();
			String to = daTbl.getEndLocation();

			if (!avoidDuplicates.contains(daTbl.getRideID())) {
				avoidDuplicates.add(daTbl.getRideID());

				dateTable += "<tr> <td>" + daTbl.getUsername()
						+ "</td> ";
				dateTable += "<td>" + from + "</td> ";
				dateTable += "<td>" + to + "</td> ";
				dateTable += "<td>"
						+ new SimpleDateFormat("dd/MM/yyyy")
								.format(daTbl.getRideDate()) + "</td> ";
				dateTable += "<td>" + daTbl.getTime() + "</td> ";
				dateTable += "<td>" + daTbl.getAvailableSeats()
						+ "</td> ";
				if (user != null) {
					dateTable += "<td> <a href='"
							+ request.getContextPath()
							+ "/rideDetails.jsp?rideselect="
							+ daTbl.getRideID() + "&userselect="
							+ daTbl.getUsername() + "'>"
							+ "Link to ride page" + "</a> </td> </tr>";
				} else {
					dateTable += "<td>login to view more</td> </tr>";
				}
			} else {
				dateTable = "";
			}

		}
	}

	//---------------SEARCH RIDES BY FROM ONLY----------------------------------
	String fromTable = "";
	boolean fromExist = false;

	if (Sfrom != "no location entered") {
		RideListing f = cps.searchRideListing(
				RideListing.searchLocationStart, Sfrom);

		while (f.next()) {
			if (!fromExist) {
				fromTable = ""; //first time round get rid of unwanted text
			}
			fromExist = true;

			String from = f.getStartLocation();
			String to = f.getEndLocation();

			if (!avoidDuplicates.contains(f.getRideID())) {
				avoidDuplicates.add(f.getRideID());

				fromTable += "<tr> <td>" + f.getUsername() + "</td> ";
				fromTable += "<td>" + from + "</td> ";
				fromTable += "<td>" + to + "</td> ";
				fromTable += "<td>"
						+ new SimpleDateFormat("dd/MM/yyyy").format(f
								.getRideDate()) + "</td> ";
				fromTable += "<td>" + f.getTime() + "</td> ";
				fromTable += "<td>" + f.getAvailableSeats() + "</td> ";
				if (user != null) {
					fromTable += "<td> <a href='"
							+ request.getContextPath()
							+ "/rideDetails.jsp?rideselect=" + f.getRideID()
							+ "&userselect=" + f.getUsername() + "'>"
							+ "Link to ride page" + "</a> </td> </tr>";
				} else {
					fromTable += "<td>login to view more</td> </tr>";
				}
			} else {
				fromTable = "";
			}

		}
	}

	//---------------SEARCH RIDES BY TO ONLY----------------------------------
	String toTable = "";
	boolean toExist = false;

	if (Sto != "no location entered") {
		RideListing t = cps.searchRideListing(
				RideListing.searchLocationEnd, Sto);

		while (t.next()) {
			if (!toExist) {
				toTable = ""; //first time round get rid of unwanted text
			}
			toExist = true;

			String from = t.getStartLocation();
			String to = t.getEndLocation();

			if (!avoidDuplicates.contains(t.getRideID())) {
				avoidDuplicates.add(t.getRideID());

				toTable += "<tr> <td>" + t.getUsername() + "</td> ";
				toTable += "<td>" + from + "</td> ";
				toTable += "<td>" + to + "</td> ";
				toTable += "<td>"
						+ new SimpleDateFormat("dd/MM/yyyy").format(t
								.getRideDate()) + "</td> ";
				toTable += "<td>" + t.getTime() + "</td> ";
				toTable += "<td>" + t.getAvailableSeats() + "</td> ";
				if (user != null) {
					toTable += "<td> <a href='"
							+ request.getContextPath()
							+ "/rideDetails.jsp?rideselect=" + t.getRideID()
							+ "&userselect=" + t.getUsername() + "'>"
							+ "Link to ride page" + "</a> </td> </tr>";
				} else {
					toTable += "<td>login to view more</td> </tr>";
				}
			} else {
				toTable = "";
			}

		}
	}

	//---------------COMBINE RESULTS----------------------------------
	boolean ridesExist = false;
	if ((userExist) || (dateExist) || (fromExist) || (toExist)) {
		ridesExist = true;
		rideTable = userTable + dateTable + fromTable + toTable;
	}

	if (ridesExist) {
		rideTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"
				+ "<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th> <th>More Info</th> </tr>"
				+ rideTable
				+ "</table>";
	} else {
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
		<h2 class="title" id="title">Automatic Search</h2>
		<br /><br />
		<h2>Results:</h2>
		<div class="Box" id="Box">
		<br />
		<h3>You Searched For:</h3>
		<div class="Box" id="Box">
		<FORM NAME="resultFrm" id="result">	
			<TABLE class="rideSearch">
				<tr><td>Location from:</td> <td><%=Sfrom%></td></tr>
				<tr><td>Location to:</td> <td><%=Sto%></td></tr>
				<tr><td>Date:</td> <td><%=strTmp%></td></tr>
				<tr><td>User:</td> <td><%=username%></td>
			</TABLE>
		</FORM>
		</div>
		<br /><br />
		<h3>Click 'Link to ride page' To Take A Ride:</h3>
		<%=rideTable%>					
		</div>
		<br /><br /><br />
		<p>-- <a href=searchRides.jsp>Go back to Search page</a> --</p>
	</DIV>

<%
	if (user != null) { //depending if the user is logged in or not different side menus should be displayed
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
