<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.user.*,java.text.*,car.pool.user.*,java.util.*" %>
<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	// a container for the users information
	User user = null;
	String date = "";
	String options = "";
	String from = "";
	String to = "";
	String uname = "";
	int seats = 0;
	String dateR = null;
	String timeR = "";
	List<String> viaAddress = new ArrayList<String>();
	String requestTable = "no users found";
	String acceptedTable = "no users found";
	String table = "";
	int dbID = 0;
	int rideID = 0;
	String reDirURL = "";
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");

		//simple date processing for display on page
		Date now = new Date();
		//String date = DateFormat.getDateInstance().format(now);
		date = new SimpleDateFormat("dd/MM/yyyy").format(now);

		CarPoolStore cps = new CarPoolStoreImpl();
		//make the options for the street select box
		LocationList locations = cps.getLocations();
		while (locations.next()) {
			options += "<option value='" + locations.getID() + "'>"
					+ locations.getStreetName() + "</option>";
		}

		dbID = user.getUserId();
		rideID = Integer.parseInt(request.getParameter("rideselect"));
		RideListing u = cps.getRideListing();

		String detailsTable = "<p>No info found.</p>";
		boolean ridesExist = false;

		//System.out.println("got here!");
		while (u.next()) {
			if (u.getRideID() == rideID) {
				if (!ridesExist) {
					detailsTable = ""; //first time round get rid of unwanted text
				}
				ridesExist = true;
				from = u.getStartLocation();
				to = u.getEndLocation();
				uname = u.getUsername();
				seats = u.getAvailableSeats();
				dateR = new SimpleDateFormat("dd/MM/yyyy").format(u
						.getRideDate());
				timeR = u.getTime();

			}
		}

		// pass the "via address"
		String sNumber = "";
		String sName = "";
		String viaLoc = "";
		RideDetail rdVia = cps.getRideDetail(rideID);
		while (rdVia.hasNext()) {
			sNumber = Integer.toString(rdVia.getStreetNumber());
			sName = rdVia.getLocationName();
			viaLoc = sNumber + " " + sName;
			viaAddress.add(viaLoc);
		}

		boolean requestExist = false;
		boolean acceptExist = false;
		RideDetail rd = cps.getRideDetail(rideID);
		while (rd.hasNext()) {
			if (!requestExist) {
				requestTable = "<tr><td>no users found</td></tr><tr><td>&nbsp;</td></tr>";
			}
			if (!acceptExist) {
				acceptedTable = "<tr><td>no users found</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>";
			}
			if ((rd.getUserID() != dbID)
					&& (rd.getConfirmed() == false)) {
				requestExist = true;
				requestTable += "<tr><td>" + rd.getUsername() + "</td>";
				requestTable += "<td>" + rd.getStreetNumber()
						+ "&nbsp;" + rd.getLocationName() + "</td>";
				requestTable += "<FORM action=\"rideEditSuccess.jsp\" method=\"post\">";
				requestTable += "<INPUT type=\"hidden\" name=\"confirmUser\" value=\"yes"
						+ "\">";
				requestTable += "<INPUT type=\"hidden\" name=\"confirmUserID\" value=\""
						+ rd.getUserID() + "\">";
				requestTable += "<INPUT type=\"hidden\" name=\"confirmForRide\" value=\""
						+ rideID + "\">";
				requestTable += "<td><INPUT type=\"submit\" value=\"Confirm User\" /></td>";
				requestTable += "</FORM>";
				requestTable += "<FORM action=\"rideEditSuccess.jsp\" method=\"post\">";
				requestTable += "<INPUT type=\"hidden\" name=\"rejectUser\" value=\"yes"
						+ "\">";
				requestTable += "<INPUT type=\"hidden\" name=\"confirmUserID\" value=\""
						+ rd.getUserID() + "\">";
				requestTable += "<INPUT type=\"hidden\" name=\"confirmForRide\" value=\""
						+ rideID + "\">";
				requestTable += "<td><INPUT type=\"submit\" value=\"Reject User\" /></td>";
				requestTable += "</FORM></tr>";
			} else if ((rd.getUserID() != dbID)
					&& (rd.getConfirmed() == true)) {
				acceptExist = true;
				acceptedTable += "<tr><td>" + rd.getUsername()
						+ "</td>";
				acceptedTable += "<td>" + rd.getStreetNumber()
						+ "&nbsp;" + rd.getLocationName()
						+ "</td></tr>";
				//TODO: get the house number too
			}
		}

		if (requestExist) {
			requestTable = "<table class='rideDetailsSearch'> <tr> <th>Request from</th> <th>Pick Up From</th><th>Confirm</th><th>Reject</th></tr>"
					+ requestTable + "</table>";
		}
		requestTable += "<tr><td>&nbsp;</td></tr>";

		if (acceptExist) {
			acceptedTable = "<table class='rideDetailsSearch'> <tr> <th>Request from</th> <th>Pick Up From</th></tr>"
					+ acceptedTable + "</table>";
		}

		acceptedTable += "<tr><td>&nbsp;</td></tr>";
%>


<%
	///////////////////////////
		//view ride comments code//
		///////////////////////////
		Vector<String> comments = cps.getRideComment(rideID);
		String[] the_comment;
		reDirURL = "myRideEdit.jsp?rideselect=" + rideID
				+ "&userselect=" + request.getParameter("userselect");

		//table builder
		String evenRow = "<tr bgcolor=\"#EEEEEE\">";
		String oddRow = "<tr bgcolor=\"white\">";
		String col1 = "<td width=\"15%\">";
		String col2 = "</td><td width=\"10%\">";
		String col3 = "</td><td width=\"75%\">";
		String endRow = "</td></tr>";

		table = "<table width = \"100%\">";

		String delButton;

		//create headings
		table += evenRow + col1 + "Comment #" + col2 + "User" + col3
				+ "Comment" + endRow;

		//if no comments for ride then say so
		if (comments.size() < 1) {
			table += oddRow
					+ "<td colspan=\"3\">Sorry, could not find any comments for this ride.  Please feel free to add one below</td></tr>";
		}

		//add comments, shading in every second row
		for (int i = 0; i < comments.size(); i++) {
			the_comment = comments.elementAt(i).split("_delim_");
			if (i % 2 != 0) {
				table += evenRow;
			} else {
				table += oddRow;
			}
			try {
				if (Integer.parseInt(the_comment[1]) == dbID) {
					delButton = "<FORM action=\"delAComment.jsp\" method=\"post\">";
					delButton += "<INPUT type=\"hidden\" name=\"idComment\" value=\""
							+ the_comment[0] + "\">";
					delButton += "<INPUT type=\"hidden\" name=\"reDirURL\" value=\""
							+ reDirURL + "\">";
					delButton += "<INPUT type=\"submit\" value=\"Delete Comment\" />";
					delButton += "</FORM>";
				} else {
					delButton = "";
				}
				table += col1 + the_comment[0] + col2 + the_comment[1]
						+ col3 + the_comment[3] + delButton + endRow;
			} catch (Exception e) {
				table += endRow;
			}
		}

		//close table
		table += "</table>";

	} else {
		response.sendRedirect(request.getContextPath());
	}
	///////////////////////////
	///////////////////////////
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>

		<TITLE>Ride Details</TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<SCRIPT type="text/javascript" src="CalendarPopup.js"></SCRIPT>
		<SCRIPT type="text/javascript">
			var cal = new CalendarPopup();
		</script>

	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

	<DIV class="Content" id="Content">
		<h2>The ride details appear below:</h2>

		<FORM name="updateStartS" action="rideEditSuccess.jsp" method="post">
			<input type="hidden" name="updateRide" value="yes"/>
			<INPUT type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<TABLE>
				<tr> <td> Start Street: <%=from%></td></tr>
				<tr><td><SELECT name="startFrom"><option selected="selected">Select a Street</option><%=options%></SELECT></td><td><INPUT type="submit" name="startFrom" value="Update Street" size="25"></td></tr>
			</TABLE>
		</FORM>
		<FORM name="updateEndS" action="rideEditSuccess.jsp" method="post">
			<input type="hidden" name="updateRide" value="yes"/>
			<INPUT type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<TABLE>
				<tr> <td>End Street: <%=to%></td></tr>
				<tr> <td><SELECT name="endTo"><option selected="selected">Select a Street</option><%=options%></SELECT></td><td><INPUT type="submit" name="endTo" value="Update Street" size="25"></td></tr>
			</TABLE>
		</FORM>

		<FORM name="showMap" id="map3" method="post" target="_blank" action="displayRouteMap2.jsp">
			<INPUT type="submit" value="View Map" > 
			<INPUT type="hidden" name="mapFrom" value= "<%=from%>">
			<INPUT type="hidden" name="mapTo"  value= "<%=to%>" >
			<INPUT type="hidden" name="mapVia"  value= "<%=viaAddress%>" >
		</FORM>

		<FORM name="updateDate" action="rideEditSuccess.jsp" method="post">
			<input type="hidden" name="updateRide" value="yes"/>
			<INPUT type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<TABLE>
				<tr> <td>Date: </td> <td><INPUT TYPE="text" NAME="Rdate" SIZE="25" value=<%=dateR%>><A HREF="#" onClick="cal.select(document.forms['updateDate'].Rdate,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img name="calIcon" border="0" src="calendar_icon.jpg" width="27" height="23"></A></td><td><INPUT type="submit" name="updateDate" value="Update Date" size="25"></td></tr>
			</TABLE>
		</FORM>
		<FORM name="updateTime" action="rideEditSuccess.jsp" method="post">
		<!-- <FORM name="updateTime" action="test.jsp" method="post">-->
			<input type="hidden" name="updateRide" value="yes"/>
			<INPUT type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<TABLE>
				<tr> <td> Time: </td><td><INPUT TYPE="text" NAME="Rtime" SIZE="25" value=<%=timeR%>></td><td><INPUT type="submit" name="updateTime" value="Update Time" size="25"></td></tr>
			</TABLE>
		</FORM>
		<FORM name="updateSeats" action="rideEditSuccess.jsp" method="post">
			<input type="hidden" name="updateRide" value="yes"/>
			<INPUT type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<TABLE>
				<tr><td>Seats: </td><td><INPUT TYPE="text" NAME="numSeats" value=<%=seats%> SIZE="25"></td><td><INPUT type="submit" name="updateSeats" value="Update Seats" size="25"></td></tr>
			</TABLE>
		</FORM>
		<FORM name="withdraw" action="rideEditSuccess.jsp" method="post">
			<input type="hidden" name="remRide"/>
			<INPUT type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<TABLE class='rideWithdraw'>
				<tr> <td><INPUT type="submit" name="removeRide" value="Withdraw Ride" size="25"></td> </tr>
			</TABLE>
		</FORM>
	<table>
		<tr> <th colspan='2' style='border:2px outset #333333'>Riders awaiting your approval</th><th>&nbsp;</th> <th>&nbsp;</th></tr>
		<tr><th>&nbsp;</th></tr>
		<%=requestTable%>
	</table>
	<table>
		<tr> <th colspan='2' style='border:2px outset #333333'>Riders you have approved</th><th>&nbsp;</th> <th>&nbsp;</th></tr>
		<tr><th>&nbsp;</th></tr>
		<%=acceptedTable%>
	</table>
		<%=table%>
		<FORM name = "addComment" action="addAComment.jsp" method="post">
			<TABLE width="100%">
				<tr><td >
					<INPUT type="hidden" name="idRide" value="<%=rideID%>">
					<INPUT type="hidden" name="idUser" value="<%=dbID%>">
					<INPUT type="hidden" name="reDirURL" value="<%=reDirURL%>"/>
					<TEXTAREA cols="50" rows="4" name="comment"></TEXTAREA>
				</td></tr>
				<tr><td>
					<INPUT type="submit" value="Add Comment" />
				</td></tr>
			</TABLE>
		</FORM>
	</DIV>

	<%@ include file="leftMenu.html" %>

	</BODY>
</HTML>