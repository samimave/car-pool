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
		
		//if you have been redirected here from deleting a ride remove the ride
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("remRide") != null) {
			boolean yes = cps.removeRide(Integer.parseInt(request
					.getParameter("rideSelect")));
			delConf = "<p>"
					+ "You have successfully updated the selected ride."
					+ yes+"</p>";
		}

		//if you have been redirected here from editing the seats of a ride edit it
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

		//if you have been redirected here from editing a ride time edit it
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("Rtime") != null) {
			cps.updateStartTime(Integer.parseInt(request
					.getParameter("rideSelect")), request
					.getParameter("Rtime"));
			updateTimeConf = "<p>"
					+ "You have successfully updated the selected ride."
					+ "</p>";
		}

		//if you have been redirected here from editing a ride's start loc edit it
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

		//if you have been redirected here from editing a ride's end loc edit it
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

		//if you have been redirected here from editing a ride date edit it
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
		
		
		//user just Registered interest in a ride
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("streetTo") != null
				&& request.getParameter("houseNo") != null) {
			cps.takeRide(currentUser, Integer.parseInt(request
					.getParameter("rideSelect")), Integer
					.parseInt(request.getParameter("streetTo")),
					Integer.parseInt(request.getParameter("houseNo")),
					Integer.parseInt(request.getParameter("houseNo"))); 
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
				if (rl2.getRideID() == Integer.parseInt(request
						.getParameter("rideSelect"))) {
					el = rl2.getEndLocation();
					dt = new SimpleDateFormat("dd/MM/yyyy").format(rl2
							.getRideDate());
					tm = rl2.getTime();
					break;
				}
			}
			takeConf = "<p>"
					+ "You have requested to be picked up from "
					+ request.getParameter("houseNo") + " " + target
					+ " at " + tm + " on " + dt + "</p>";
			//emails sent to driver and user
			try {
				Integer id = new Integer(rl2.getUserID());
				UserManager manager = new UserManager();
				User rideUser = manager.getUserByUserId(id);
				String message = String.format("Dear %s\nThank you for registering your interest in this ride. Depending on if the driver can pick you up from the location you requested they will confirm you for the ride or reject you. Please make sure you both discuss information like the sharing of petrol costs beforehand in order to avoid confusion on the day. You can contact them using %s.\n\nGetting you new rides when you need them.\nThe Car Pool",user.getUserName(), rideUser.getEmail());
				String address = user.getEmail();
				String subject = "Car Pool Ride request";
				Email email = new Email();
				email.setMessage(message);
				email.setSubject(subject);
				email.setToAddress(address);
				SMTP.send(email);
				message = String.format("Dear %s\n%s registered interest in your ride from %s %s to %s %s on %s at %s. You confirm or reject this user from your account page.  Please make sure you both discuss information like the sharing of petrol costs beforehand in order to avoid confusion on the day. You can contact them using %s.\n\nGetting you new rides when you need them.\nThe Car Pool",rideUser.getUserName(),user.getUserName(), rl2.getStreetStart(), rl2.getStartLocation(), rl2.getStreetEnd(), rl2.getEndLocation(), rl2.getRideDate(), rl2.getTime(), user.getEmail());
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
		
		//Changing social score of driver based on rating user gave them
		//1  2  3  4  5  6  7  8  9  10   <<<<< what user posts
		//-4 -3 -2 -1 0  0  1  2  3  4    <<<<< how the score changes based on that
		if ((request.getParameter("feedbackRide")!=null) && (request.getParameter("rideRate")!=null)){
			if (Integer.parseInt(request.getParameter("rideRate"))== 1){
				cps.addScore(cps.getTripID(Integer.parseInt(request.getParameter("FdbckForRide")), currentUser), Integer.parseInt(request.getParameter("DriverUserID")), -4 );//Integer.parseInt(request.getParameter("rideRate"))
			}
			if (Integer.parseInt(request.getParameter("rideRate"))== 2){
				cps.addScore(cps.getTripID(Integer.parseInt(request.getParameter("FdbckForRide")), currentUser), Integer.parseInt(request.getParameter("DriverUserID")), -3 );
			}
			if (Integer.parseInt(request.getParameter("rideRate"))== 3){
				cps.addScore(cps.getTripID(Integer.parseInt(request.getParameter("FdbckForRide")), currentUser), Integer.parseInt(request.getParameter("DriverUserID")), -2 );
			}
			if (Integer.parseInt(request.getParameter("rideRate"))== 4){
				cps.addScore(cps.getTripID(Integer.parseInt(request.getParameter("FdbckForRide")), currentUser), Integer.parseInt(request.getParameter("DriverUserID")), -1 );
			}
			if (Integer.parseInt(request.getParameter("rideRate"))== 5){
				cps.addScore(cps.getTripID(Integer.parseInt(request.getParameter("FdbckForRide")), currentUser), Integer.parseInt(request.getParameter("DriverUserID")), 0 );
			}
			if (Integer.parseInt(request.getParameter("rideRate"))== 6){
				cps.addScore(cps.getTripID(Integer.parseInt(request.getParameter("FdbckForRide")), currentUser), Integer.parseInt(request.getParameter("DriverUserID")), 0 );
			}
			if (Integer.parseInt(request.getParameter("rideRate"))== 7){
				cps.addScore(cps.getTripID(Integer.parseInt(request.getParameter("FdbckForRide")), currentUser), Integer.parseInt(request.getParameter("DriverUserID")), 1 );
			}
			if (Integer.parseInt(request.getParameter("rideRate"))== 8){
				cps.addScore(cps.getTripID(Integer.parseInt(request.getParameter("FdbckForRide")), currentUser), Integer.parseInt(request.getParameter("DriverUserID")), 2 );
			}
			if (Integer.parseInt(request.getParameter("rideRate"))== 9){
				cps.addScore(cps.getTripID(Integer.parseInt(request.getParameter("FdbckForRide")), currentUser), Integer.parseInt(request.getParameter("DriverUserID")), 3 );
			}
			if (Integer.parseInt(request.getParameter("rideRate"))== 10){
				cps.addScore(cps.getTripID(Integer.parseInt(request.getParameter("FdbckForRide")), currentUser), Integer.parseInt(request.getParameter("DriverUserID")), 4 );
			}
		}
		
		//-------- Find the rides a user has offered and if there are users awaiting approval for those rides ----------//
		
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
				userTable += "<td> <a href='"+ response.encodeURL(request.getContextPath()+ "/rideDetails.jsp?rideselect="+ rl.getRideID() + "&userselect="+ rl.getUsername()) + "'>" + "Link to ride page"+ "</a> </td></tr>";
			}
		}

		if (userExist) {
			userTable = "<table class='rideDetailsSearch'> <tr> <th>Starting From</th> <th>Going To</th>"
					+ "<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th><th>Users Awaiting Approval</th><th>Edit Ride Details</th> </tr>"
					+ userTable + "</table>";
		}

		//-------- Find the rides a user has been accepted into and is awaiting acceptance into ----------//
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

				acceptedTable += "<tr><form action='"+response.encodeURL("addRideEvent.jsp")+"' method=\"post\" target=\"_blank\" >";
				acceptedTable += "<input type=\"hidden\" name=\"withdrawConfirmedRide\" value=\"yes"
						+ "\">";
				acceptedTable += "<td>" + from + "</td> ";
				acceptedTable += "<td>" + to + "</td> ";
				acceptedTable += "<td>"
						+ new SimpleDateFormat("dd/MM/yyyy").format(tr
								.getRideDate()) + "</td> ";
				acceptedTable += "<td>" + tr.getTime() + "</td> ";
				acceptedTable += "<td>" + tr.getStreetNumber() + " "
						+ tr.getPickUp() + "</td>";
				acceptedTable += "<input type=\"hidden\" name=\"from\" value=\""
						+ fromID + "\">";
				acceptedTable += "<input type=\"hidden\" name=\"to\" value=\""
						+ toID + "\">";
				acceptedTable += "<input type=\"hidden\" name=\"date\" value=\""
						+ new SimpleDateFormat("yyyy-MM-dd").format(tr
								.getRideDate()) + "\">";
				acceptedTable += "<input type=\"hidden\" name=\"time\" value=\""
						+ tr.getTime() + "\">";
				acceptedTable += "<input type=\"hidden\" name=\"length\" value=\""
						+ tr.getTime() + "\">";
				acceptedTable += "<td><input type=\"submit\" value=\"Add\" /></td>";
				acceptedTable += "</form>";

				acceptedTable += "<form action='"+response.encodeURL("myRideDetails.jsp")+"' method=\"post\">";
				acceptedTable += "<input type=\"hidden\" name=\"withdrawConfirmedRide\" value=\"yes"
						+ "\">";
				acceptedTable += "<input type=\"hidden\" name=\"withdrawUserID\" value=\""+ currentUser + "\">";
				acceptedTable += "<input type=\"hidden\" name=\"withdrawRideID\" value=\""
						+ tr.getRideID() + "\">";
				//acceptedTable += "<td>"+ tr.getUsername() +"</td> ";	
				acceptedTable += "<td><input type=\"submit\" value=\"Withdraw\" /></td>";
				acceptedTable += "<td> <a href='"
						+ response.encodeURL(request.getContextPath()
						+ "/rideDetails.jsp?rideselect="
						+ tr.getRideID() + "&userselect="
						+ tr.getUsername()) + "'>" + "Link to ride page"
						+ "</a> </td>";
				acceptedTable += "</form></tr>";

			}
			// This awaitTable shows the rides that the uesr is requested and user can withdraw the request
			else if (tr.getConfirmed() != true) {
				awaitExist = true;

				awaitTable += "<tr><form action='"+response.encodeURL("myRideDetails.jsp")+"' method=\"post\">";
				awaitTable += "<input type=\"hidden\" name=\"withdrawNotConfirmedRide\" value=\"yes"
						+ "\">";
				awaitTable += "<input type=\"hidden\" name=\"withdrawUserID\" value=\""
						+ currentUser + "\">";
				awaitTable += "<input type=\"hidden\" name=\"withdrawRideID\" value=\""
						+ tr.getRideID() + "\">";
				awaitTable += "<td>" + from + "</td>";
				awaitTable += "<td>" + to + "</td>";
				awaitTable += "<td>"
						+ new SimpleDateFormat("dd/MM/yyyy").format(tr
								.getRideDate()) + "</td> ";
				awaitTable += "<td>" + tr.getTime() + "</td> ";
				awaitTable += "<td>" + tr.getStreetNumber() + " "
						+ tr.getPickUp() + "</td>";
				awaitTable += "<td><input type=\"submit\" value=\"Withdraw\" /></td>";
				awaitTable += "<td> <a href='"+ response.encodeURL(request.getContextPath()+ "/rideDetails.jsp?rideselect="+ tr.getRideID() + "&userselect="+ tr.getUsername()) + "'>" + "Link to ride page"+ "</a> </td>";
				awaitTable += "</form></tr>";
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
						feedbackTable += "<form action='"+response.encodeURL("myRideDetails.jsp")+"' method=\"post\">";
						feedbackTable += "<input type=\"hidden\" name=\"feedbackRide\" value=\"yes"+ "\">";
						feedbackTable += "<input type=\"hidden\" name=\"DriverUserID\" value=\""+ driverID + "\">";
						feedbackTable += "<input type=\"hidden\" name=\"FdbckForRide\" value=\""+ tr2.getRideID() + "\">";
						feedbackTable += "<td><input type=\"text\" name=\"rideRate\" SIZE=\"10\">";
						feedbackTable += "<input type=\"submit\" value=\"Rate Ride\" /></td>";
						feedbackTable += "</form> </tr>";
					}
				}
			
		}
			if ((feedExist)&&(!scoreDone)) {
				feedbackTable = "<p>Please leave a rating between 1 (bad) to 10 (good) for the ride. This rating shall remain anonymous. You are encouraged to click on the Link to Ride Page and state your opinion of the ride for the benefit of other users who want to know more about the person who offered the ride.</p><br />"
						+"<table class='rideDetailsSearch'> <tr><th>Starting From</th> <th>Going To</th>"
						+ "<th>Departure Date</th> <th>Departure Time</th><th>Link</th> <th>Rating (between 1 & 10)</th></tr>"
						+ feedbackTable + "</table>";
			} else {
				feedbackTable = "<div class='Box' id='Box'><p>No rides to provide feedback for.</p></div>";
			}
	} else {
		response.sendRedirect(request.getContextPath());
	}


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD html 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>Your Rides</title>
		<style type="text/css" media="screen">@import "TwoColumnLayout.css";</style>
	</head>
	<body>

	<%@ include file="heading.html" %>

	<div class="Content" id="Content">
		<h2 class="title" id="title">Your Rides</h2>
		<br />
		<%=takeConf%>
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
	</div>

	<%@ include file="leftMenu.jsp" %>

	</body>
</html>