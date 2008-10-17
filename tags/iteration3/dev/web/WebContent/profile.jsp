<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.user.*,java.text.*,car.pool.user.*,java.util.*" %>
<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	// a container for the users information
	User user = null;
	User driver = null;
	CarPoolStore cps = null;
	String userTable = "";
	String acceptedTable = "";
	int count = 0;
	int countA = 0;
	if (s.getAttribute("signedin") != null) {													//if the user is logged in
		user = (User) s.getAttribute("user");
	
		UserManager manager = null;																//get information about the user
		manager = new UserManager(); 
		driver = manager.getUserByUserId(Integer.parseInt(request.getParameter("profileId")));
		cps = new CarPoolStoreImpl();
		

		//OFFERED RIDES
		RideListing rl = cps.searchRideListing(RideListing.searchUser,driver.getUserName());
		boolean userExist = false;
		while (rl.next()) {
			if (!userExist) {
				userTable = ""; //first time round get rid of unwanted text
			}
			userExist = true;
			count++;
			//getting the ride info
			String from = rl.getStartLocation();
			String to = rl.getEndLocation();
			//userTable += "<tr> <td>" + rl.getUsername() + "</td> ";
			userTable += "<tr><td>" + rl.getStreetStart() + " " + from + "</td> ";
			userTable += "<td>" + rl.getStreetEnd() + " " + to + "</td> ";
			userTable += "<td>"	+ new SimpleDateFormat("dd/MM/yyyy").format(rl.getRideDate()) + "</td> ";
			userTable += "<td>" + rl.getTime() + "</td> ";
			userTable += "<td> <a href='" + response.encodeURL(request.getContextPath()
						+ "/rideDetails.jsp?rideselect=" + rl.getRideID()) + "'>"
						+ "Link to Ride Page" + "</a> </td> </tr>";
		}

		if (userExist) {
			userTable = "<p>Click on the Link to Ride Page to see if past riders have left feedback for the ride offered</p><br/>"+"<table class='rideDetailsSearch'> <tr> <th>Starting From</th> <th>Going To</th>"
					+ "<th>Departure Date</th> <th>Departure Time</th><th>Link</th> </tr>"
					+ userTable + "</table>";
		}
		else {
			userTable= "<div class='Box' id='Box'><p>None.</p></div>";
		}
		
		
		//RIDES WHERE USER WAS RIDER NOT DRIVER
		boolean rideExist = false;
		boolean something = false;
		TakenRides tr = cps.getTakenRides(driver.getUserId());
		while (tr.hasNext() /*&& something == false*/) {
			//System.out.println("tr");
			something = true;
			if (!rideExist) {
				acceptedTable = ""; //first time round get rid of unwanted text
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
				countA++;
				acceptedTable += "<tr><td>" + from + "</td> ";
				acceptedTable += "<td>" + to + "</td> ";
				acceptedTable += "<td>"	+ new SimpleDateFormat("dd/MM/yyyy").format(tr.getRideDate()) + "</td> ";
				acceptedTable += "<td>" + tr.getTime() + "</td> ";
				String d = new SimpleDateFormat("dd/MM/yyyy").format(tr.getRideDate())+ " " + tr.getTime();
				Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);
				if (dt.after(new Date())) {
					acceptedTable += "<td> <a href='"
							+ response.encodeURL(request.getContextPath()
							+ "/rideDetails.jsp?rideselect="
							+ tr.getRideID()) + "'>"
							+ "Link to Ride Page"
							+ "</a> </td> </tr>";
				} else {
					acceptedTable += "<td> <a href='"
						+ response.encodeURL(request.getContextPath()
						+ "/oldRideDetails.jsp?rideselect="
						+ tr.getRideID()) + "'>"
						+ "Link to Ride Page"
						+ "</a> </td> </tr>";
				}

			}
		}
		if (rideExist) {
			acceptedTable ="<p>Click on the Link to Ride Page to see if user has left feedback for ride they took part in.</p><br/>"+ "<table class='rideDetailsSearch'> <tr><th>Starting From</th> <th>Going To</th>"
					+ "<th>Departure Date</th> <th>Departure Time</th> <th>Link</th> </tr>"
					+ acceptedTable + "</table>";
		} else {
			acceptedTable ="<div class='Box' id='Box'><p>None.</p></div>";
		}

	} else {
		response.sendRedirect(request.getContextPath());
	}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>

		<TITLE>User Profile</TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

	<DIV class="Content" id="Content">
		<h2 class="title" id="title">Ride Information</h2>
		<br /><br />
		<h2>User Profile:</h2>
		<div class="Box" id="Box">
		<table class='rideDetailsSearch'>
		<tr><td>Username: </td><td><%=driver.getUserName()%></td></tr>
		<tr><td>Email: </td><td><%=driver.getEmail() %></td></tr>
		<tr><td>Social Score: </td><td><%=driver.getSocialScore() %></td></tr>
		</table>
	
		</div>
		<br /><br />
		<h2>Rides User Has Offered:</h2>
		<div class="Box" id="Box">
		<h3>Total number of rides offered by user: <%=count%></h3><br/>
		<%=userTable %>
		</div>
		<br /> <br /> 

		<h2>Rides User Has Accepted:</h2>
		<div class="Box" id="Box">
		<h3>Total number of rides accepted by user: <%=countA%> </h3><br/>
		<%=acceptedTable %>
		</div>
		<br /> <br /><br />
		<p>-- <a href="welcome.jsp">Home</a> --</p>	
	</DIV>

	<%@ include file="leftMenu.jsp" %>

	</BODY>
</HTML>