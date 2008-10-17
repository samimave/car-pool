<%@page errorPage="errorPage.jsp"%>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.user.*,java.util.*,java.text.*" %>
<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	//a container for the users information
	User user = null;
	
	
	int rideID = 0;
	int dbID = 0;
	int driverID=0;
	String from = "";
	String to = "";
	String detailsTable = "<p>No info found.</p>";
	String acceptedTable = "<p>No users confirmed yet.</p>";
	List<String> viaAddress = new ArrayList<String>();
	String table = "";
	String options = "";
	String reDirURL = "";
	Date dt = new Date();
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");

		CarPoolStore cps = new CarPoolStoreImpl();

		//the variable dbID is the id of the current user
		dbID = user.getUserId();
		//rideID is the ID of the ride
		rideID = Integer.parseInt(request.getParameter("rideselect"));

		//get all the information of a ride 
		RideListing r = cps.getRideListing();
		RideListing u = r.getAll();

		boolean ridesExist = false;
		
		//while there are rides to go through
		while (u.next()) {
			//if the id of the ride is the ride id we want
			if (u.getRideID() == rideID) {
				
				if (!ridesExist) {
					detailsTable = ""; //first time round get rid of unwanted text
				}
				
				//set the boolean to true
				ridesExist = true;
				
				//get all the iformation regarding that ride
				from = u.getStartLocation();
				to = u.getEndLocation();
				driverID = u.getUserID();
				
				//make the table
				detailsTable += "<tr> <td>Ride Offered By:</td>  <td>" + "<a href='"+response.encodeURL(request.getContextPath()+"/profile.jsp?profileId="+ u.getUserID())+"'>"+u.getUsername()+ "</a></td></tr>";
				//detailsTable += "<tr> <td>Ride Offered By:</td>  <td>"	+ u.getUsername() + "</td></tr> ";
				detailsTable += "<tr> <td> Starting From: </td> <td>"+ u.getStreetStart()+" "+ from + "</td> </tr>";
				detailsTable += "<tr> <td> Going to: </td> <td>"	+ u.getStreetEnd()+" "+ to + "</td></tr> ";
				detailsTable += "<tr> <td>Date: </td> <td>"	+ new SimpleDateFormat("dd/MM/yyyy").format(u.getRideDate()) + "</td></tr> ";
				detailsTable += "<tr> <td> Time: </td> <td>"+ u.getTime() + "</td> </tr>";
				detailsTable += "<tr> <td> Seats: </td> <td>"+ u.getAvailableSeats() + "</td> </tr>";
				detailsTable += "<tr> <td> Additional Info: </td> <td>"+ u.getComment()+"</td> </tr>";
				break;
			}
		}

		String d = new SimpleDateFormat("dd/MM/yyyy").format(u.getRideDate()) + " " + u.getTime();
		dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);
		
		//pass the "via address" - what other locations does the ride have to go past?
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

		//finish table
		if (ridesExist) {
			detailsTable = "<table class='rideDetailsSearch'>"
					+ detailsTable + "</table>";
		}

		//make the options for the street select box
		LocationList locations = cps.getLocations();
		while (locations.next()) {
			options += "<option value='" + locations.getID() + "'>"
					+ locations.getStreetName() + "</option>";
		}
		
		
		//shows who has been confirmed for the ride already
		//and where they shall be picked up from
		boolean acceptExist = false;
		RideDetail rd = cps.getRideDetail(rideID);
		boolean whatever = true;
		while (rd.hasNext() && whatever == true) {
			whatever = true;
			if (!acceptExist) {
				acceptedTable = "";
			}
			//if the rider is not the driver and the rider is confirmed for the ride
			if ((rd.getUserID() != driverID) && (rd.getConfirmed() == true)) {
				acceptExist = true;
				acceptedTable += "<tr><td>" + "<a href='"+response.encodeURL(request.getContextPath()+"/profile.jsp?profileId="+ rd.getUserID())+"'>"+rd.getUsername()+ "</a></td>";
				acceptedTable += "<td>" + rd.getStreetNumber()
						+ "&nbsp;" + rd.getLocationName()
						+ "</td></tr>";
			}
		}
			//if there exists users who have been approved then this is the table heading
			if (acceptExist) {
				System.out.println("acc ex");
				acceptedTable = "<table class='rideDetailsSearch'> <tr> <th>Confirmed User</th> <th>Pick Up Point</th></tr>"
						+ acceptedTable + "</table>";
			} else {
				acceptedTable = "<div class='Box' id='Box'><p>None.</p></div>";
			}

		
%>

<%
		///////////////////////////
		//view ride comments code//
		///////////////////////////
		
		//Given the ride id get the comments relating to that ride
		Vector<String> comments = cps.getRideComment(rideID);
		String[] the_comment;
		reDirURL = response.encodeURL("rideDetails.jsp?rideselect=" + rideID
				+ "&userselect=" + request.getParameter("userselect"));

		//table builder
		String evenRow = "<tr bgcolor=\"#EEEEEE\">";
		String oddRow = "<tr bgcolor=\"white\">";
		String col1 = "<td width=\"15%\">";
		String col2 = "</td><td width=\"20%\">";
		String col3 = "</td><td width=\"75%\">";
		String endRow = "</td></tr>";
		table = "<table width=\"100%\">";
		String delButton;

		//create headings
		table += evenRow + /*col1 + "Comment #" +*/ col2 + "User" + col3
				+ "Comment" + endRow;

		//if no comments for ride then say so
		if (comments.size() < 1) {
			table += oddRow
					+ "<td colspan=\"3\">No comments added for this ride.</td></tr>";
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
					delButton = "<FORM action="+response.encodeURL("delAComment.jsp")+" method=\"post\">";
					delButton += "<INPUT type=\"hidden\" name=\"idComment\" value=\""
							+ the_comment[0] + "\">";
					delButton += "<INPUT type=\"hidden\" name=\"reDirURL\" value=\""
							+ reDirURL + "\">";
					delButton += "<INPUT type=\"submit\" value=\"Delete Comment\" />";
					delButton += "</FORM>";
				} else {
					delButton = "";
				}
				UserManager manager = null;
				manager = new UserManager(); 
				User commenter = manager.getUserByUserId(Integer.parseInt(the_comment[1]));
				String comName = commenter.getUserName();
				table += /*col1 + the_comment[0] +*/ col2 + comName
						+ col3 + the_comment[3] + delButton + endRow;
			} catch (Exception e) {
				table += endRow;
			}
		}

		//close table
		table += "</table>";
		///////////////////////////
		///////////////////////////
	} else {
		response.sendRedirect(request.getContextPath());
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE> Ride Details </TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<%@include file="include/javascriptincludes.html" %>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

 	<DIV class="Content" id="Content">
		<h2 class="title" id="title">Ride Information</h2>
		<br /><br />
		<h2>Details:</h2>
		<div class="Box" id="Box">
		<h3>The details of the ride appear below:</h3>
		<br><%=detailsTable%><br/><br/>
		<h3>The following users have been confirmed for this ride:</h3>
		<br><%=acceptedTable%><br/><br/>
		<FORM name="showMap" id="map2" method="post" target="_blank" action="displayRouteMap2.jsp">
			<p>Click here to <INPUT type="submit" value="View Map" ></p> 
			<INPUT type="hidden" name="mapFrom" value= "<%=from%>">
			<INPUT type="hidden" name="mapTo"  value= "<%=to%>" >
			<INPUT type="hidden" name="mapVia"  value= "<%=viaAddress%>" >
		</FORM>
		</div>
		<% if (driverID != dbID || dt.after(new Date())) { %>
		<br /><br />
		<h2>Take Ride:</h2>
		<div class="Box" id="Box">
		<FORM name="ride" action="<%=response.encodeURL("myRideDetails.jsp") %>" method="post">
			<INPUT type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<h3>Please Pick Me Up From:</h3>
			<TABLE class='rideD'>
				<tr> <td>House Number:</td> <td><INPUT type="text" name="houseNo"></td> </tr>
				<tr> <td>Street:</td> <td><SELECT name="streetTo">
           				<option selected="selected">Select a Street</option>
	                	<%=options%>
       				</SELECT></td> </tr>
			</TABLE>
			<p>Note: if you can meet the driver at their starting point then specify that same starting point
			 as the pick-me-up.</p> 
			<br />
			<p>Click here to <INPUT type="submit" name="joinRide" value="Register Interest in Ride" size="25"></p>
		</FORM>
		</div>
		<% } 
		//System.out.println("driver: "+driverID);
		//System.out.println("user: "+dbID);
		%>
		<br /><br />
		<h2>Ride Comments:</h2>
		<div class="Box" id="Box">
		<%=table%>
		<FORM name = "addComment" action="<%=response.encodeURL("addAComment.jsp") %>" method="post">
			<TABLE width="100%">
				<tr><td>
					<INPUT type="hidden" name="idRide" value="<%=rideID%>">
					<INPUT type="hidden" name="idUser" value="<%=dbID%>">
					<INPUT type="hidden" name="reDirURL" value="<%=reDirURL%>"/>
					<TEXTAREA cols="50" rows="4" name="comment"></TEXTAREA>
				</td></tr>
			</TABLE>
			<br />
			<p>Click here to <INPUT type="submit" value="Add Comment" /></p>
		</FORM>
		</div>
		<br /> <br /> <br />
		<p>-- <a href="<%=response.encodeURL("welcome.jsp") %>">Home</a> --</p>	
	</DIV>

	<%@ include file="leftMenu.jsp" %>

	</BODY>
</HTML>