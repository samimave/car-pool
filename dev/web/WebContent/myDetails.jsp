<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.user.*,java.util.ArrayList,java.text.*,java.util.*, car.pool.email.*"%>

<%
	HttpSession s = request.getSession(false);

String delConf = "";
String updateSeatConf = "";
String updateTimeConf = "";
String updateStartS = "";
String updateEndS = "";
String updateDateConf = "";
String updateUserConf = "";

	//force the user to login to view the page
	//user a container for the users information
	User user = null;
	String takeConf = "";
	String openIDTableRow = "";
	String openIDTableForm = "";
	//code to get ride details
	//temp placeholder variables
	String userTable = "<div class='Box' id='Box'><p>No rides offered. Click here to <a href='"+response.encodeURL("addARide.jsp")+"'>offer a ride.</a></p></div>";
	String acceptedTable = "<p>No rides found.</p>";
	String awaitTable = "<p>No rides found.</p>";
	String feedbackTable = "";
	int socialScore = 0;

	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");

		//code to interact with db
		CarPoolStore cps = new CarPoolStoreImpl();
		int currentUser = user.getUserId();
		String nameOfUser = user.getUserName();
		socialScore = cps.getScore(currentUser);
		int dbID = user.getUserId();

		boolean userExist = false;
		ArrayList<Integer> rideIDs = new ArrayList<Integer>();

		
		
		//if you have been redirected here from deleting a ride print useful info
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("remRide") != null) {
			boolean yes = cps.removeRide(Integer.parseInt(request
					.getParameter("rideSelect")));
			delConf = "<p>"
					+ "You have successfully updated the selected ride."
					+ yes+"</p>";
		}

		//if you have been redirected here from editing a ride print useful info
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("numSeats") != null) {
			int seat = Integer.parseInt(request
					.getParameter("numSeats"));
			seat++;
			cps.updateSeats(Integer.parseInt(request
					.getParameter("rideSelect")), seat);
			updateSeatConf = "<p>"
					+ "You have successfully updated the selected ride."
					+ "</p>";
		}

		//if you have been redirected here from editing a ride print useful info
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("Rtime") != null) {
			cps.updateStartTime(Integer.parseInt(request
					.getParameter("rideSelect")), request
					.getParameter("Rtime"));
			updateTimeConf = "<p>"
					+ "You have successfully updated the selected ride."
					+ "</p>";
		}

		//if you have been redirected here from editing a ride print useful info && request.getParameter("Rseats") != null
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("startFromHN") != null
				&& request.getParameter("startFrom") != null) {
			cps.updateStartLoc(Integer.parseInt(request
					.getParameter("rideSelect")), Integer
					.parseInt(request.getParameter("startFromHN")),Integer
					.parseInt(request.getParameter("startFrom")),dbID);
			updateStartS = "<p>"
					+ "You have successfully updated the selected ride."
					+ "</p>";
		}

		//if you have been redirected here from editing a ride print useful info && request.getParameter("Rseats") != null
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("endToHN") != null
				&& request.getParameter("endTo") != null) {
			cps.updateEndLoc(Integer.parseInt(request
					.getParameter("rideSelect")), Integer
					.parseInt(request.getParameter("endToHN")),Integer
					.parseInt(request.getParameter("endTo")),dbID);
			updateEndS = "<p>"
					+ "You have successfully updated the selected ride."
					+ "</p>";
		}

		//if you have been redirected here from editing a ride print useful info && request.getParameter("Rseats") != null
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("Rdate") != null) {
			String strTmp = request.getParameter("Rdate");
			Date dtTmp = new SimpleDateFormat("dd/MM/yyyy")
					.parse(strTmp);
			String strOutDt = new SimpleDateFormat("yyyy-MM-dd")
					.format(dtTmp);
			//Integer.parseInt(request.getParameter("Rseats"))
			cps.updateStartDate(Integer.parseInt(request
					.getParameter("rideSelect")), strOutDt);
			updateSeatConf = "<p>"
					+ "You have successfully updated the selected ride."
					+ "</p>";
		}

		//if you have been redirected here from accepting a user print useful info
		//IF YOU ACCEPTED OR REJECTED A USER UPDATE DATABASE
		if (request.getParameter("confirmUser") != null) {
			cps.acceptUser(Integer.parseInt(request
					.getParameter("confirmUserID")), Integer
					.parseInt(request.getParameter("confirmForRide")),
					1);
			cps.addScore(cps.getTripID(Integer.parseInt(request
					.getParameter("confirmForRide")), dbID), dbID, 3);
			updateUserConf = "<p>"
					+ "You have successfully accepted the selected user."
					+ "</p>";
		}
		
		if (request.getParameter("rejectUser") != null) {
			cps.removeRide(Integer.parseInt(request
					.getParameter("confirmUserID")), Integer
					.parseInt(request.getParameter("confirmForRide")));
			updateUserConf = "<p>"
					+ "You have successfully removed the selected user"
					+ "</p>";
		}

		//if you have been redirected here from withdraw the user from ride print useful info
		//IF YOU WITHDRAW YOURSELF FROM THE RIDE YOU HAVE TAKEN OR THE RIDE YOU HAVE REQUESTED UPDATE DATABASE
		if (request.getParameter("withdrawConfirmedRide") != null) {
			cps.removeRide(Integer.parseInt(request
					.getParameter("withdrawUserID")), Integer
					.parseInt(request.getParameter("withdrawRideID")));
			updateUserConf = "<p>"
					+ "You have successfully withdrawn from the selected ride."
					+ "</p>";
		}

		if (request.getParameter("withdrawNotConfirmedRide") != null) {
			cps.removeRide(Integer.parseInt(request
					.getParameter("withdrawUserID")), Integer
					.parseInt(request.getParameter("withdrawRideID")));
			updateUserConf = "<p>"
					+ "You have successfully withdrawn from the selected ride."
					+ "</p>";
		}
		
		
		//USER JUST TOOK A RIDE
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("streetTo") != null
				&& request.getParameter("houseNo") != null) {
			cps.takeRide(currentUser, Integer.parseInt(request
					.getParameter("rideSelect")), Integer
					.parseInt(request.getParameter("streetTo")),
					Integer.parseInt(request.getParameter("houseNo")),
					Integer.parseInt(request.getParameter("houseNo"))); //TODO: house end number?
			LocationList locations = cps.getLocations();
			String target = "";
			while (locations.next()) {
				if (locations.getID() == Integer.parseInt(request
						.getParameter("streetTo"))) {
					target = locations.getStreetName();
				}
			}
			RideListing rl2 = cps.getRideListing();
			String el = "";
			String dt = "";
			String tm = "";
			while (rl2.next()) {
				//System.out.println(rl2.getRideID()+", "+request.getParameter("rideSelect"));
				if (rl2.getRideID() == Integer.parseInt(request
						.getParameter("rideSelect"))) {
					el = rl2.getEndLocation();
					dt = new SimpleDateFormat("dd/MM/yyyy").format(rl2
							.getRideDate());
					tm = rl2.getTime();
				}
			}
			takeConf = "<p>"
					+ "You have requested to be picked up from "
					+ request.getParameter("houseNo") + " " + target
					+ " at " + tm + " on " + dt + "</p>";
			try {
				Integer id = new Integer(rl2.getUserID());
				UserManager manager = new UserManager();
				User rideUser = manager.getUserByUserId(id);
				String message = String.format("Dear %s\nThank you for registering your interest in this ride. Depending on if the driver can pick you up from the location you requested they will confirm you for the ride or reject you. Please make sure you both discuss information like the sharing of petrol costs beforehand in order to avoid confusion on the day. You can contact them using %s.\n Getting you new rides when you need them.",user.getUserName(), rideUser.getEmail());
				String address = user.getEmail();
				String subject = "Car Pool Ride request";
				Email email = new Email();
				email.setMessage(message);
				email.setSubject(subject);
				email.setToAddress(address);
				SMTP.send(email);
				message = String.format("Dear %s\n%s registered interest in your ride from %s %s to %s %s on %s at %s. You confirm or reject this user from your account page.  Please make sure you both discuss information like the sharing of petrol costs beforehand in order to avoid confusion on the day. You can contact them using %s.\n Getting you new rides when you need them.",rideUser.getUserName(),user.getUserName(), rl2.getStreetStart(), rl2.getStartLocation(), rl2.getStreetEnd(), rl2.getEndLocation(), rl2.getRideDate(), rl2.getTime(), user.getEmail());
				address = rideUser.getEmail();
				subject = "Car Pool Ride request";
				email.setMessage(message);
				email.setSubject(subject);
				email.setToAddress(address);
				SMTP.send(email);
			} catch(SMTPException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			}
		}
		
		
		//PROVIDING FEEDBACK TO SOME DRIVER
		if ((request.getParameter("feedbackRide")!=null) && (request.getParameter("rideRate")!=null)){
			cps.addScore(cps.getTripID(Integer.parseInt(request.getParameter("FdbckForRide")), currentUser), Integer.parseInt(request.getParameter("DriverUserID")), Integer.parseInt(request.getParameter("rideRate")));
		}
		
		
		RideListing rl = cps.searchRideListing(RideListing.searchUser,nameOfUser);
	
		while (rl.next()) {
			if (!userExist) {
				userTable = ""; //first time round get rid of unwanted text
			}
			userExist = true;
			rideIDs.add(rl.getRideID());
			//to know if there are users awaiting approval
			RideDetail rd = cps.getRideDetail(rl.getRideID());
			String requestExistA = "no";
			while (rd.hasNext()) {
				if ((rd.getUserID() != currentUser)
						&& (rd.getConfirmed() == false)) {
					requestExistA = "yes";
				}
			}

			//getting the ride info
			String from = rl.getStartLocation();
			String to = rl.getEndLocation();
			//userTable += "<tr> <td>" + rl.getUsername() + "</td> ";
			userTable += "<tr><td>" + rl.getStreetStart() + " " + from
					+ "</td> ";
			userTable += "<td>" + rl.getStreetEnd() + " " + to
					+ "</td> ";
			userTable += "<td>"
					+ new SimpleDateFormat("dd/MM/yyyy").format(rl
							.getRideDate()) + "</td> ";
			userTable += "<td>" + rl.getTime() + "</td> ";
			userTable += "<td>" + rl.getAvailableSeats() + "</td> ";
			userTable += "<td>" + requestExistA + "</td> ";
			String d = new SimpleDateFormat("dd/MM/yyyy").format(rl
					.getRideDate())
					+ " " + rl.getTime();
			Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);
			if (dt.after(new Date())) {
				userTable += "<td> <a href='"
						+ response.encodeURL(request.getContextPath()
						+ "/myRideEdit.jsp?rideselect="
						+ rl.getRideID() + "&userselect="
						+ rl.getUsername()) + "'>"
						+ "Manage ride & riders."
						+ "</a> </td> </tr>";
			} else {
				userTable += "<td>Old ride.</td></tr>";
			}
		}

		if (userExist) {
			userTable = "<table class='rideDetailsSearch'> <tr> <th>Starting From</th> <th>Going To</th>"
					+ "<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th><th>Users Awaiting Approval</th><th>Edit Ride Details</th> </tr>"
					+ userTable + "</table>";
		}

		boolean rideExist = false;
		boolean awaitExist = false;
		boolean something = false;
		TakenRides tr = cps.getTakenRides(currentUser);
		while (tr.hasNext() /*&& something == false*/) {
			//System.out.println("tr");
			something = true;
			if (!rideExist) {
				acceptedTable = ""; //first time round get rid of unwanted text
			}
			if (!awaitExist) {
				awaitTable = ""; //first time round get rid of unwanted text
			}

			//rideIDs.add(rl.getRideID());
			String from = tr.getStartLocation();
			String to = tr.getStopLocation();
			String fromID = tr.getStartID();
			String toID = tr.getStopID();

			// This acceptedTable shows the rides that the uesr is in and user can withdraw themself from the ride
			// also user can add the ride to their google calender.
			if ((tr.getConfirmed() == true)) {
				rideExist = true;

				acceptedTable += "<tr><FORM action='"+response.encodeURL("addRideEvent.jsp")+"' method=\"post\" target=\"_blank\" >";
				acceptedTable += "<INPUT type=\"hidden\" name=\"withdrawConfirmedRide\" value=\"yes"
						+ "\">";
				acceptedTable += "<td>" + from + "</td> ";
				acceptedTable += "<td>" + to + "</td> ";
				acceptedTable += "<td>"
						+ new SimpleDateFormat("dd/MM/yyyy").format(tr
								.getRideDate()) + "</td> ";
				acceptedTable += "<td>" + tr.getTime() + "</td> ";
				acceptedTable += "<td>" + tr.getStreetNumber() + " "
						+ tr.getPickUp() + "</td>";
				acceptedTable += "<INPUT type=\"hidden\" name=\"from\" value=\""
						+ fromID + "\">";
				acceptedTable += "<INPUT type=\"hidden\" name=\"to\" value=\""
						+ toID + "\">";
				acceptedTable += "<INPUT type=\"hidden\" name=\"date\" value=\""
						+ new SimpleDateFormat("yyyy-MM-dd").format(tr
								.getRideDate()) + "\">";
				acceptedTable += "<INPUT type=\"hidden\" name=\"time\" value=\""
						+ tr.getTime() + "\">";
				acceptedTable += "<INPUT type=\"hidden\" name=\"length\" value=\""
						+ tr.getTime() + "\">";
				acceptedTable += "<td><INPUT type=\"submit\" value=\"Add\" /></td>";
				acceptedTable += "</FORM>";

				acceptedTable += "<FORM action='"+response.encodeURL("myDetails.jsp")+"' method=\"post\">";
				acceptedTable += "<INPUT type=\"hidden\" name=\"withdrawConfirmedRide\" value=\"yes"
						+ "\">";
				acceptedTable += "<INPUT type=\"hidden\" name=\"withdrawUserID\" value=\""+ currentUser + "\">";
				acceptedTable += "<INPUT type=\"hidden\" name=\"withdrawRideID\" value=\""
						+ tr.getRideID() + "\">";
				//acceptedTable += "<td>"+ tr.getUsername() +"</td> ";	
				acceptedTable += "<td><INPUT type=\"submit\" value=\"Withdraw\" /></td>";
				acceptedTable += "<td> <a href='"
						+ response.encodeURL(request.getContextPath()
						+ "/rideDetails.jsp?rideselect="
						+ tr.getRideID() + "&userselect="
						+ tr.getUsername()) + "'>" + "Link to ride page"
						+ "</a> </td>";
				acceptedTable += "</FORM></tr>";

			}
			// This awaitTable shows the rides that the uesr is requested and user can withdraw the request
			else if (tr.getConfirmed() != true) {
				awaitExist = true;

				awaitTable += "<tr><FORM action='"+response.encodeURL("myDetails.jsp")+"' method=\"post\">";
				awaitTable += "<INPUT type=\"hidden\" name=\"withdrawNotConfirmedRide\" value=\"yes"
						+ "\">";
				awaitTable += "<INPUT type=\"hidden\" name=\"withdrawUserID\" value=\""
						+ currentUser + "\">";
				awaitTable += "<INPUT type=\"hidden\" name=\"withdrawRideID\" value=\""
						+ tr.getRideID() + "\">";
				awaitTable += "<td>" + from + "</td>";
				awaitTable += "<td>" + to + "</td>";
				awaitTable += "<td>"
						+ new SimpleDateFormat("dd/MM/yyyy").format(tr
								.getRideDate()) + "</td> ";
				awaitTable += "<td>" + tr.getTime() + "</td> ";
				awaitTable += "<td>" + tr.getStreetNumber() + " "
						+ tr.getPickUp() + "</td>";
				awaitTable += "<td><INPUT type=\"submit\" value=\"Withdraw\" /></td>";
				awaitTable += "<td> <a href='"
						+ response.encodeURL(request.getContextPath()
						+ "/rideDetails.jsp?rideselect="
						+ tr.getRideID() + "&userselect="
						+ tr.getUsername()) + "'>" + "Link to ride page"
						+ "</a> </td>";
				awaitTable += "</FORM></tr>";
			}
		}

		if (rideExist) {
			acceptedTable = "<table class='rideDetailsSearch'> <tr><th>Starting From</th> <th>Going To</th>"
					+ "<th>Departure Date</th> <th>Departure Time</th><th>Your Pick Up Point</th><th>Add Ride to Google Calendar</th> <th>Withdraw from Ride</th> <th>Link</th> </tr>"
					+ acceptedTable + "</table>";
		} else {
			acceptedTable = "<div class='Box' id='Box'><p>No rides found. Click here to <a href='"+response.encodeURL("searchRides.jsp")+"'>find a ride.</a></p></div>";
		}

		if (awaitExist) {
			awaitTable = "<table class='rideDetailsSearch'> <tr><th>Starting From</th> <th>Going To</th>"
					+ "<th>Departure Date</th> <th>Departure Time</th> <th>Your Pick Up Point</th> <th>Withdraw from Ride</th> <th>Link</th> </tr>"
					+ awaitTable + "</table>";
		} else {
			awaitTable = "<div class='Box' id='Box'><p>No rides found.</p></div>";
		}

		//feedback table for rides you have been approved for
		
		boolean feedExist = false;
		boolean scoreDone = false;
		TakenRides tr2 = cps.getTakenRides(currentUser);
		while (tr2.hasNext()) {
			if (!feedExist) {
				feedbackTable = ""; //first time round get rid of unwanted text
			}
			
				String fromF = tr2.getStartLocation();
				String toF = tr2.getStopLocation();
				String fromIDF = tr2.getStartID();
				String toIDF = tr2.getStopID();
				int driverID = 0;
				// This feedbackTable shows the rides that the uesr is in so they can provide feedback after the ride
				if ((tr2.getConfirmed() == true)) {
					RideListing rl2 = cps.getRideListing();
					while (rl2.next()){
						if (rl2.getRideID() == tr2.getRideID()){
							driverID = rl2.getUserID();
						}
					}
					feedExist = true;
					scoreDone = cps.hasUserAddedScore(tr2.getRideID(), currentUser);
					if (!scoreDone){
						feedbackTable += "<td>" + fromF + "</td> ";
						feedbackTable += "<td>" + toF + "</td> ";
						feedbackTable += "<td>"+ new SimpleDateFormat("dd/MM/yyyy").format(tr2.getRideDate()) + "</td> ";
						feedbackTable += "<td>" + tr2.getTime() + "</td> ";
						String d = new SimpleDateFormat("dd/MM/yyyy").format(tr2.getRideDate())+ " " + tr2.getTime();
						Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);
						if (dt.after(new Date())) {
							feedbackTable += "<td> <a href='"
									+ response.encodeURL(request.getContextPath()
									+ "/rideDetails.jsp?rideselect="
									+ tr2.getRideID()) + "'>"
									+ "Link to Ride Page"
									+ "</a> </td>";
						} else {
							feedbackTable += "<td> <a href='"
								+ response.encodeURL(request.getContextPath()
								+ "/oldRideDetails.jsp?rideselect="
								+ tr2.getRideID()) + "'>"
								+ "Link to Ride Page"
								+ "</a></td>";
						}
						feedbackTable += "<FORM action='"+response.encodeURL("myDetails.jsp")+"' method=\"post\">";
						feedbackTable += "<INPUT type=\"hidden\" name=\"feedbackRide\" value=\"yes"+ "\">";
						feedbackTable += "<INPUT type=\"hidden\" name=\"DriverUserID\" value=\""+ driverID + "\">";
						feedbackTable += "<INPUT type=\"hidden\" name=\"FdbckForRide\" value=\""+ tr2.getRideID() + "\">";
						feedbackTable += "<td><INPUT TYPE=\"text\" NAME=\"rideRate\" SIZE=\"10\">";
						feedbackTable += "<INPUT type=\"submit\" value=\"Rate Ride\" /></td>";
						feedbackTable += "</FORM> </tr>";
					}
				}
			
		}
			if ((feedExist)&&(!scoreDone)) {
				feedbackTable = "<p>This rating shall remain anonymous. You are encouraged to click on the Link to Ride Page and state your opinion of the ride for the benefit of other users who want to know more about the person who offered the ride.</p>"
						+"<table class='rideDetailsSearch'> <tr><th>Starting From</th> <th>Going To</th>"
						+ "<th>Departure Date</th> <th>Departure Time</th><th>Link</th> <th>Rating (between 1 & 10)</th></tr>"
						+ feedbackTable + "</table>";
			} else {
				feedbackTable = "<div class='Box' id='Box'><p>No rides to provide feedback for.</p></div>";
			}
		
		
	
		//input openids to the table
		String entries = "";
		int idcount = 0;
		String lastid = "";
		for (String oid : user.getOpenIds()) {
			entries += "<option value=" + oid + ">" + oid + "</option>";
			lastid = oid;
			idcount++;
			
		}
		//System.out.println("idcount: "+idcount);
		if (idcount > 1) {
			if (entries != "") {
				openIDTableRow = "<tr> <td>OpenId to remove:</td> <td><select multiple='multiple' NAME='openid'>"
						+ entries + "</select></td> </tr>";
			}
			if (openIDTableRow != "") {
				openIDTableForm = "<br /><h3>Current OpenIds associated with your account:</h3><div class='Box' id='Box'><FORM action='"+response.encodeURL("removeopenid")+"'> <INPUT type='hidden' name='removeopenid' /> <TABLE class='updateDetails'>"
						+ openIDTableRow
						+ "<tr></TABLE> <br /><p>Click here to <INPUT type='submit' value='Detach OpenId'/></p></div><br /><br />";
			}
		} else if (idcount == 1) {
			//System.out.println("made form");
				openIDTableForm = "<br /><h3>Current OpenId associated with your account:</h3><div class='Box' id='Box'><TABLE class='updateDetails'><tr><td>OpenId: </td><td>"
						+ lastid
						+ "</td></tr></table></div><br /><br />";
		}

	


	} else {
		response.sendRedirect(request.getContextPath());
	}


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE>User Account Page</TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<script type="text/javascript" src="javascript/yav.js"></script>
		<script type="text/javascript" src="javascript/yav-config.js"></script>
		<script>
		var u_rules=new Array();
		u_rules[0]='email|required';
		u_rules[1]='email|email';
		u_rules[2]='phone|numeric';
		u_rules[3]='newPassword1:new password|equal|$newPassword2:confirmed password';

		var ad_rules=new Array();
		ad_rules[0]='openid|required';
		</script>
	</HEAD>
	<BODY onload="yav.init('updateDtls', u_rules); yav.init('addoid', ad_rules);">

	<%@ include file="heading.html" %>

	<DIV class="Content" id="Content">
		<h2 class="title" id="title">Your Account</h2>
		<br />
		<%=takeConf%>
		<br />
		<h2>Your user details appear below:</h2>
		<div class="Box" id="Box">
		<p>Your current social score is: <%=socialScore%></p>
		<br />
		<FORM id="updateDtls" name="updateDtls" onsubmit="return yav.performCheck('updateDtls', u_rules, 'inline');" action="<%=response.encodeURL("updateuser") %>" method="post">
			<INPUT type="hidden" name="updateDetails" value="yes">
			<TABLE> 
				<tr> <td>Username:</td> <td><%=user != null ? user.getUserName() : ""%></td> </tr> 
				<tr> <td>Email Address:</td> <td><INPUT TYPE="text" NAME="email" SIZE="25" value="<%=user != null ? user.getEmail() : ""%>">&nbsp;&nbsp;<span id=errorsDiv_email></span></td> </tr> 
				<tr> <td>Phone Number:</td> <td><INPUT TYPE="text" NAME="phone" SIZE="25" value="<%=user != null ? user.getPhoneNumber() : ""%>">&nbsp;&nbsp;<span id=errorsDiv_phone></span></td> </tr>
				<tr> <td><%if( OpenIdFilter.getCurrentUser(s) != null) {%>Add a <%}else{ %>Change <%} %>password?:</td><td> <input type="checkbox" name="changePassword" value="isChecked"/> </td> </tr>
				<%if( OpenIdFilter.getCurrentUser(s) == null) {%><tr> <td>Old Password:</td><td> <input type="password" name="oldpassword"/> &nbsp;&nbsp;<span id=errorsDiv_oldpassword></span></td> </tr><%} %>
				<tr> <td>New password:</td><td> <input type="password" name="newPassword1"/> &nbsp;&nbsp;<span id=errorsDiv_newPassword1></span></td> </tr>
				<tr> <td>Confirm new password:</td><td> <input type="password" name="newPassword2"/> &nbsp;&nbsp;<span id=errorsDiv_newPassword2></span></td> </tr>
			</TABLE>
			<br />
			<p>Click here to <INPUT TYPE="submit" NAME="confirmUpdate" VALUE="Update Details" SIZE="25"></p>
		</FORM>
		</div>
		<br /><br />
		<h2>Your OpenId:</h2>
		<div class="Box" id="Box">
		<%=openIDTableForm%>
		<h3>Attach an OpenId to your account:</h3>
		<div class="Box" id="Box">
		<FORM id="addoid" name="addoid" onsubmit="return yav.performCheck('addoid', ad_rules, 'inline');" action="<%=response.encodeURL("addopenid") %>" method="post">
			<INPUT type="hidden" name="addopenid"/>
			<p>Want to know more about OpenId? <a href="http://openid.net/" target = "_blank">Click here.</a></p><br /><br />
			<TABLE>
				<tr><td>OpenId to add:</td> <td><INPUT type="text" name="openid" size="25"/>&nbsp;&nbsp;<span id=errorsDiv_openid></span></td></tr>
			</TABLE>
			<br />
			<p>Click here to <INPUT type="submit" value="Attach OpenId"/></p>
		</FORM>
		</div>
		</div>
		<br /><br />
		<h2>Your ride details appear below:</h2>
		<div class="Box" id="Box">
			<h3>Rides you have offered:</h3>
			<%=userTable%>
			<br /><br />
			<h3>You have been approved for the following rides:</h3>	
			<%=acceptedTable%>
			<br /><br />
			<h3>You are awaiting approval for the following rides:</h3>
			<%=awaitTable%><br/><br/>
			<h3>Please provide a rating for the following rides after they are over. </h3>
			<%=feedbackTable%>
		</div>
		<br /> <br /> <br />
		<p>-- <a href="<%=response.encodeURL("welcome.jsp") %>">Home</a> --</p>
	</DIV>

	<%@ include file="leftMenu.jsp" %>

	</BODY>
</HTML>