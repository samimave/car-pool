<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.user.*,java.text.*,car.pool.user.*,java.util.*" %>
<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	// a container for the users information
	User user = null;																		//holds information about the user
	String date = "";																		//the current date
	String options = "";																	//
	String from = "";																		//origin street 
	int fromHouseNo = 0;																	//origin house number
	String to = "";																			//destination street
	int toHouseNo = 0;																		//destination house number
	String uname = "";																		
	int seats = 0;																			//number of seats in the ride
	String dateR = null;
	String timeR = "";
	List<String> viaAddress = new ArrayList<String>();
	String requestTable = "no users found";													//shows users awaiting confirmation into the ride
	String acceptedTable = "no users found";												//shows users confirmed into the ride
	String table = "";
	int dbID = 0;																			//current users id
	int rideID = 0;																			//current ride id
	String reDirURL = "";																	//to redirect back to this page if needed
	if (s.getAttribute("signedin") != null) {												//if the user is logged in
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
					+ locations.getStreetName() + "</option>";								//populate the streets dropdown box
		}

		dbID = user.getUserId();															//current user id	
		rideID = Integer.parseInt(request.getParameter("rideselect"));						//
		RideListing u = cps.getRideListing();												//list of rides in db
		
		reDirURL = response.encodeURL("myRideEdit.jsp?rideselect=" + rideID + "&userselect=" + request.getParameter("userselect")); //used to return the user to this page 
		
		String detailsTable = "<p>No info found.</p>";
		boolean ridesExist = false;

		//System.out.println("got here!");
		while (u.next()) {																	//for each ride
			if (u.getRideID() == rideID) {													//if this is the ride we are interested in
				if (!ridesExist) {															//get all the information about the ride
					detailsTable = ""; //first time round get rid of unwanted text
				}
				ridesExist = true;
				fromHouseNo = u.getStreetStart();
				from = u.getStartLocation();
				to = u.getEndLocation();
				toHouseNo = u.getStreetEnd();
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
		
		//Hmmmm I think I have fixed the issue with the tables but to make the code simpler than this, I don't know how

		//get the details of a ride
		RideDetail rd = cps.getRideDetail(rideID);
		boolean whatever = true;
		while (rd.hasNext() && whatever == true) {
			whatever = true;
			//System.out.println("something1");
			if (!requestExist) {
				requestTable = "";
			}
			if (!acceptExist) {
				acceptedTable = "";
			}
			//if the user in the matches table is not the driver
			//and if the user is not confirmed for a ride
			//then add the user to the request table with their details

			if ((rd.getUserID() != dbID) && (rd.getConfirmed() == false)) {
				//System.out.println("request exists");
				requestExist = true;
				requestTable += "<tr><td>" + rd.getUsername() + "</td>";
				//this is the place where the driver will have to pick them up from
				requestTable += "<td>" + rd.getStreetNumber() + " "
						+ rd.getLocationName() + "</td>";
				//this is the confirm user button
				requestTable += "<form action="+response.encodeURL("rideEditSuccess.jsp")+" method=\"post\">";
				requestTable += "<input type=\"hidden\" name=\"confirmUser\" value=\"yes"
						+ "\">";
				requestTable += "<input type=\"hidden\" name=\"confirmUserID\" value=\""
						+ rd.getUserID() + "\">";
				requestTable += "<input type=\"hidden\" name=\"confirmForRide\" value=\""
						+ rideID + "\">";
				requestTable += "<td><input type=\"submit\" value=\"Confirm User\" /></td>";
				requestTable += "<input type=\"hidden\" name=\"reDirURL\" value=\""
					+ reDirURL + "\">";
				requestTable += "</form>";
				//this is the reject user button
				requestTable += "<form action=\"rideEditSuccess.jsp\" method=\"post\">";
				requestTable += "<input type=\"hidden\" name=\"rejectUser\" value=\"yes"
						+ "\">";
				requestTable += "<input type=\"hidden\" name=\"confirmUserID\" value=\""
						+ rd.getUserID() + "\">";
				requestTable += "<input type=\"hidden\" name=\"confirmForRide\" value=\""
						+ rideID + "\">";
				requestTable += "<input type=\"hidden\" name=\"reDirURL\" value=\""
						+ reDirURL + "\">";
				requestTable += "<td><input type=\"submit\" value=\"Reject User\" /></td></tr>";
				requestTable += "</form>";

				//otherwise if in the Matches table the user is not the driver and the driver has
				//been confirmed for a ride
				//then add them to the accepted table
			} else if ((rd.getUserID() != dbID)
					&& (rd.getConfirmed() == true)) {
				acceptExist = true;
				acceptedTable += "<tr><td>" + rd.getUsername()
						+ "</td>";
				acceptedTable += "<td>" + rd.getStreetNumber()
						+ "&nbsp;" + rd.getLocationName()
						+ "</td></tr>";
			}
		}
			
			//if there exists users who are awaiting approval then this is the table heading
			if (requestExist) {
				System.out.println("req ex");
				requestTable = "<table class='rideDetailsSearch'> <tr> <th>Request from</th> <th>Pick Up From</th><th>Confirm</th><th>Reject</th></tr>"
						+ requestTable + "</table>";
			} else {
				requestTable = "<div class='Box' id='Box'><p>None.</p></div><br />";
			}

			//if there exists users who have been approved then this is the table heading
			if (acceptExist) {
				System.out.println("acc ex");
				acceptedTable = "<table class='rideDetailsSearch'> <tr> <th>Request from</th> <th>Pick Up From</th></tr>"
						+ acceptedTable + "</table>";
			} else {
				acceptedTable = "<div class='Box' id='Box'><p>None.</p></div>";
			}

%>


<%
	///////////////////////////
		//view ride comments code//
		///////////////////////////
		Vector<String> comments = cps.getRideComment(rideID);
		String[] the_comment;
		reDirURL = response.encodeURL("myRideEdit.jsp?rideselect=" + rideID
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
					delButton = "<form action="+response.encodeURL("delAComment.jsp")+" method=\"post\">";
					delButton += "<input type=\"hidden\" name=\"idComment\" value=\""
							+ the_comment[0] + "\">";
					delButton += "<input type=\"hidden\" name=\"reDirURL\" value=\""
							+ reDirURL + "\">";
					delButton += "<input type=\"submit\" value=\"Delete Comment\" />";
					delButton += "</form>";
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

	} else {
		response.sendRedirect(request.getContextPath());
	}
	///////////////////////////
	///////////////////////////
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD html 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>

		<title>Ride Details</title>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<script type="text/javascript" src="javascript/CalendarPopup.js"></script>
		<script type="text/javascript" src="javascript/yav.js"></script>
		<script type="text/javascript" src="javascript/yav-config.js"></script>
		<script type="text/javascript" src="javascript/date.js"></script>
		<script
			src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAwEEggV_Hd8onlfSgA_kgZBTz-RVM6WN_1Yrxj3B45o6dXx3SPxRBd9zQMOS18U6DzRdS0kg6JbFdlA"
			type="text/javascript"></script>
		<script type="text/javascript">
			var cal = new CalendarPopup();
		</script>
		<script>
		//http://www.mattkruse.com/javascript/date/ for helpful examples
		function checkTime() {
		    var msg;
		    var reg = new RegExp("^[0-2][0-9]:[0-5][0-9]$");
		    var curTime = formatDate(new Date(),"HH:mm");
		    var inpTime = document.forms['updateTime'].Rtime.value;
		    if ( reg.test(inpTime) ) {
				var curDate = formatDate(new Date(),"dd/MM/yyyy");
				var inpDate = document.forms['updateDate'].Rdate.value;
				var d_result1 = compareDates(curDate,"dd/MM/yyyy",inpDate,"dd/MM/yyyy");
				var d_result2 = compareDates(inpDate,"dd/MM/yyyy",curDate,"dd/MM/yyyy");
			    if ((d_result1 == 0) && (d_result2 == 0)) {
					var t_result = compareDates(curTime,"HH:mm",inpTime,"HH:mm");
					if ( t_result == 0 ) {
						msg = null;
					} else {
						msg = "Time must be in the future."
					}
			    } else if (d_result1 == 1) {
					msg = 'Date has already passed.';
			    } else {
					msg = null;
			    }
			} else {
			    msg = 'Incorrect time.';
			}
			return msg;
		}

		function checkDate() {
			var msg;
			var curDate = formatDate(new Date(),"dd/MM/yyyy");
			var inpDate = document.forms['updateDate'].Rdate.value;
			var result1 = compareDates(curDate,"dd/MM/yyyy",inpDate,"dd/MM/yyyy");
			var result2 = compareDates(inpDate,"dd/MM/yyyy",curDate,"dd/MM/yyyy");
		    if ((result1 == 0) && (result2 == 0)) {
		    	var reg = new RegExp("^[0-2][0-9]:[0-5][0-9]$");
		    	var curTime = formatDate(new Date(),"HH:mm");
			    var inpTime = document.forms['updateTime'].Rtime.value;
		    	if ( reg.test(inpTime) ) {
		    		var t_result = compareDates(curTime,"HH:mm",inpTime,"HH:mm");
					if ( t_result == 0 ) {
						msg = null;
					} else {
						msg = "Time must be in the future."
					}
		    	} else {
					msg = 'Incorrect time.';
		    	}
		    } else if (result1 == 0) {
			    msg = null;
			} else {
			    msg = 'Date has already passed.';
			}
			return msg;
		}
		
		var sl_rules=new Array();
		sl_rules[0]='startFromHN:origin house number|required';
		sl_rules[1]='startFromHN:origin house number|numeric';
		sl_rules[2]='startFrom:origin street|required';

		var el_rules=new Array();
		el_rules[0]='endToHN:destination house number|required';
		el_rules[1]='endToHN:destination house number|numeric';
		el_rules[2]='endTo:destination street|required';

		var d_rules=new Array();
		d_rules[0]='Rdate:date|required';
		d_rules[1]='Rdate:date|date';
		d_rules[2]='Rdate|custom|checkDate()';
		
		var t_rules=new Array();
		t_rules[0]='Rtime:departure time|required';
		t_rules[1]='Rtime|custom|checkTime()';
		
		var s_rules=new Array();
		s_rules[0]='numSeats:number of seats|required';
		s_rules[1]='numSeats:number of seats|numeric';
		</script>

	<script type="text/javascript">
						function codeFrom(response) {
							document.getElementById("updateStartS").fromCoord.value=response.lat() + "," + response.lng();
							}
						function codeTo(response) {
							document.getElementById("updateEndS").toCoord.value=response.lat() + "," + response.lng();
							}
						// a function to get the from and to streets from the combobox and pass them to the 
						// form call "showMap" which then post to the "displayRouteMap.jsp" to be display on google map
			      		function getAddress(origin){
			      			 var geocoder = new GClientGeocoder();
							if(origin == "from"){
								startIdx = document.getElementById("updateStartS").startFrom.selectedIndex;
								startLoc = document.getElementById("updateStartS").startFrom.options[startIdx].text;
								startNum  = document.getElementById("updateStartS").startFromHN.value;
				     				
								var from = startNum + " " + startLoc + " PALMERSTON NORTH NEW ZEALAND";
								geocoder.getLatLng(from, codeFrom);
							}

			     		   	if(origin == "to"){
								endIdx   = document.getElementById("updateEndS").endTo.selectedIndex;
				     		   	endLoc   = document.getElementById("updateEndS").endTo.options[endIdx].text;
				     		   	endNum  = document.getElementById("updateEndS").endToHN.value;

								var to = endNum + " " + endLoc + " PALMERSTON NORTH NEW ZEALAND";
				     		   	geocoder.getLatLng(to, codeTo);
				     		}
			      		}
		</script>
	</head>
	<body ><%//onload="yav.init('updateStartS', sl_rules); yav.init('updateEndS', el_rules); yav.init('updateDate', d_rules); yav.init('updateTime', t_rules); yav.init('updateSeats', s_rules);">%>

	<%@ include file="heading.html" %>	

	<DIV class="Content" id="Content">
		<h2 class="title" id="title">Ride Information</h2>
		<br /><br />
		<h2>Edit Ride Information:</h2>
		<div class="Box" id="Box">
		<br />
		<h3>Location:</h3>
		<div class="Box" id="Box">
		<form name="updateStartS" id="updateStartS" onsubmit="return yav.performCheck('updateStartS', sl_rules, 'inline');" action="<%=response.encodeURL("rideEditSuccess.jsp") %>" method="post">
			<input type="hidden" name="updateRide" value="yes"/>
			<input type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<input type="hidden" name="reDirURL" value="<%=reDirURL%>"/>
			<input type="hidden" name="fromCoord" size="25"/>	
			<table>
				<tr> <td> Start Street:  <%=fromHouseNo%> <%=from%></td> <td>&nbsp;</td></tr>
				<tr><td><input type="text" name="startFromHN" size="25"	onkeypress="getAddress('from')" value=<%=fromHouseNo%>></td><td><span id=errorsDiv_startFromHN></span></td></tr>
				<tr> <td><select name="startFrom" onChange="getAddress('from')"><option selected="selected" value=''>Select a Street</option><%=options%></select></td><td><input type="submit" name="startFrom" value="Update Street" size="25">&nbsp;&nbsp;<span id=errorsDiv_startFrom></span></td></tr>
			</table>
		</form>
		<br />
		<form name="updateEndS" id="updateEndS" onsubmit="return yav.performCheck('updateEndS', el_rules, 'inline');" action="<%=response.encodeURL("rideEditSuccess.jsp") %>" method="post">
			<input type="hidden" name="updateRide" value="yes"/>
			<input type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<input type="hidden" name="reDirURL" value="<%=reDirURL%>"/>
			<input type="hidden" name="toCoord" size="25"/>
			<table>
				<tr> <td>End Street:  <%=toHouseNo%> <%=to%></td></tr>
 				<tr><td><input type="text" name="endToHN" size="25" onkeypress="getAddress('to')" value=<%=toHouseNo%>></td></tr>
				<tr> <td><select name="endTo" onChange="getAddress('to')"><option selected="selected" value=''>Select a Street</option><%=options%></select></td><td><input type="submit" name="endTo" value="Update Street" size="25">&nbsp;&nbsp;<span id=errorsDiv_endTo></span></td></tr>
			</table>
		</form>

		<form name="showMap" id="map3" method="post" target="_blank" action="displayRouteMap2.jsp">
			<p>Click here to <input type="submit" value="View Map" ></p>
			<input type="hidden" name="mapFrom" value="<%=from%>">
			<input type="hidden" name="mapTo"  value="<%=to%>" >
			<input type="hidden" name="mapVia"  value="<%=viaAddress%>" >
		</form>
		</div>
		<br /><br />
		<h3>Timing:</h3>
		<div class="Box" id="Box">
		<form name="updateDate" id="updateDate" onsubmit="return yav.performCheck('updateDate', d_rules, 'inline');" action="<%=response.encodeURL("rideEditSuccess.jsp") %>" method="post">
			<input type="hidden" name="updateRide" value="yes">
			<input type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<input type="hidden" name="reDirURL" value="<%=reDirURL%>"/>
			<table>
				<tr> <td>Date (dd/MM/yyyy): </td> <td><input type="text" name="Rdate" size="25" value=<%=dateR%>><A href="#" onClick="cal.select(document.forms['updateDate'].Rdate,'anchor1','dd/MM/yyyy'); return false;" name="anchor1" ID="anchor1"><img name="calIcon" border="0" src="images/calendar_icon.jpg" width="27" height="23"></A></td><td><input type="submit" name="updateDate" value="Update Date" size="25">&nbsp;&nbsp;<span id=errorsDiv_Rdate></span></td></tr>
			</table>
		</form>
		<form name="updateTime" id="updateTime" onsubmit="return yav.performCheck('updateTime', t_rules, 'inline');" action="<%=response.encodeURL("rideEditSuccess.jsp") %>" method="post">
			<input type="hidden" name="updateRide" value="yes"/>
			<input type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<input type="hidden" name="reDirURL" value="<%=reDirURL%>"/>
			<table>
				<tr> <td>Time 24hr (hh:mm): </td><td><input type="text" name="Rtime" size="25" value=<%=timeR%>></td><td><input type="submit" name="updateTime" value="Update Time" size="25">&nbsp;&nbsp;<span id=errorsDiv_Rtime></span></td></tr>
			</table>
		</form>
		</div>
		<br /><br />
		<h3>Additional Information:</h3>
		<div class="Box" id="Box">
		<form name="updateSeats" onsubmit="return yav.performCheck('updateSeats', s_rules, 'inline');" action="<%=response.encodeURL("rideEditSuccess.jsp") %>" method="post">
			<input type="hidden" name="updateRide" value="yes"/>
			<input type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<input type="hidden" name="reDirURL" value="<%=reDirURL%>"/>
			<table>
				<tr><td>Seats: </td><td><input type="text" name="numSeats" value=<%=seats%> size="25"></td><td><input type="submit" name="updateSeats" value="Update Seats" size="25">&nbsp;&nbsp;<span id=errorsDiv_numSeats></span></td></tr>
			</table>
		</form>
		</div>
		<form name="withdraw" action="<%=response.encodeURL("rideEditSuccess.jsp") %>" method="post">
			<input type="hidden" name="remRide"/>
			<input type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect")%>">
			<input type="hidden" name="reDirURL" value="<%=response.encodeURL("myRideDetails.jsp")%>"/>
			<br />
			<p>Click here to <input type="submit" name="removeRide" value="Withdraw Ride" size="25"></p>
			<p>Warning: social score penalty.</p>
		</form>
		</div>
		<br /><br />
		<h2>Other Users:</h2>
		<div class="Box" id="Box">
		<br />
		<h3>Riders awaiting your approval:</h3>
		<%=requestTable%>
		<br />
		<h3>Riders you have approved:</h3>
		<%=acceptedTable%>
		</div>
		<br /><br />
		<h2>Ride Comments:</h2>
		<div class="Box" id="Box">
		<%=table%>
		<form name="addComment" action="<%=response.encodeURL("addAComment.jsp") %>" method="post">
			<table width="100%">
				<tr><td >
					<input type="hidden" name="idRide" value="<%=rideID%>">
					<input type="hidden" name="idUser" value="<%=dbID%>">
					<input type="hidden" name="reDirURL" value="<%=reDirURL%>"/>
					<textarea cols="50" rows="4" name="comment"></textarea>
				</td></tr>
				<tr><td>
					<input type="submit" value="Add Comment" />
				</td></tr>
			</table>
		</form>
		</div>
		<br /> <br /> <br />
		<p>-- <a href="<%=response.encodeURL("welcome.jsp") %>">Home</a> --</p>	
	</DIV>

	<%@ include file="leftMenu.jsp" %>

	</body>
</html>