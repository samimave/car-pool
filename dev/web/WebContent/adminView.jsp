<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="java.util.*,java.text.*,org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.persistance.test.*,car.pool.locations.*,car.pool.user.*,car.pool.persistance.test.AddLocations"%>

<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	//a container for the users information
	User user = null;
	String userTable = "";							//contains a table displaying all users details in the db
	String rideTable = "";							//contains a table displaying all rides in the db
	if (s.getAttribute("signedin") != null) {										//if the user is logged in
		user = (User) s.getAttribute("user");
		if(!user.getUserName().toLowerCase().startsWith("admin")) {					//if the user is not an admin (dont think this can happen anyway)
			response.sendRedirect(response.encodeURL(""));
			return;
		}
		CarPoolStore cps = new CarPoolStoreImpl();									//contains important information
		if ((request.getParameter("addAllLoc"))!=null){								//if we were redirected here with a request to add locations
			AddLocations.addFromFile();												//add the locations
		}
		if (request.getParameter("locations") != null) {							//if we were passed a comma seperated string of locations to enter in the db
			
			String[] locList = request.getParameter("locations").split(", ");		//split them up 
			//System.out.println(locList);
			for (int i=0; i<locList.length; i++){			
			int region = -1;
			region = cps.addRegion("Palmerston North");
			cps.addLocation(region, locList[i]);									//add each to the db
			//System.out.println("street: " + locList[i]);
			}
		}

		String uName;																			//holds the users information
		String uEmail;
		String uPhone;
		String uSignUpDate;
		UserList nList = cps.getUserName();														//all users in the db

		String Table = "";																		//the rows with the users information
		while (nList.next()) {
			uName = nList.getUserName();
			uEmail = nList.getUserEmail();
			uPhone = nList.getUserPhone();
			uSignUpDate = nList.getUserSignUpDate();
			Table += "<tr> <td>" + uName + "</td> ";
			Table += "<td>" + uEmail + "</td> ";
			Table += "<td>" + uPhone + "</td> ";
			Table += "<td>" + uSignUpDate + "</td> </tr>";
		}
		userTable = "<table class='rideDetailsSearch'> <tr> <th>User Name</th> <th>Email</th> <th>Phone</th>"			//finish the table
				+ "<th>Sign Up Date</th> </tr>" + Table + "</table>";
		//true if there is at least one ride
		boolean rExist = false;																	
		RideListing all = cps.getRideListing();
		//for each ride in the db add a row to the table
		while (all.next()) {																	
			rExist = true;
			String from = all.getStartLocation();
			String to = all.getEndLocation();

			rideTable += "<tr> <td>" + all.getUsername() + "</td> ";
			rideTable += "<td>" + from + "</td> ";
			rideTable += "<td>" + to + "</td> ";
			rideTable += "<td>"
					+ new SimpleDateFormat("dd/MM/yyyy").format(all
							.getRideDate()) + "</td> ";
			rideTable += "<td>" + all.getTime() + "</td> ";
			rideTable += "<td>" + all.getAvailableSeats() + "</td> ";
			rideTable += "<td> <a href='" + response.encodeURL(request.getContextPath()
					+ "/rideDetails.jsp?rideselect=" + all.getRideID()
					+ "&userselect=" + all.getUsername()) + "'>"
					+ "Link to ride page" + "</a> </td> </tr>";

		}
		if (rExist) {																			//if there are rides in the db finish off the table
			rideTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"
					+ "<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th> <th>More Info</th> </tr>"
					+ rideTable + "</table>";
		}
	} else {
		response.sendRedirect(request.getContextPath());										//else redirect the user to the login page
	}
%>
		
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title> Administration Tasks</title>
		<style type="text/css" media="screen">@import "TwoColumnLayout.css";</style>
		<%@include file="include/javascriptincludes.html" %>
		</head>
	<body>

		<%@ include file="heading.html" %>

		<div class="Content" id="Content">
			<h2 class="title" id="title">Administrative Options</h2>
			<br /><br />
			<h2>Database:</h2>
			<div class="Box" id="Box">
			<form name="admin" action="<%=response.encodeURL("#")%>" method="post" >				
				<table>
					<tr><td>Enter a comma and space separated list of streets below</td></tr>
						<tr><td><textarea cols="50" rows="4" name="locations"></textarea></td>
						<td>&nbsp;</td> <td><input type="submit" value="Add Locations" size="25" onClick="<%//AddLocations.addFromFile();%>" ></td>
					</tr>
				</table>
			</form>
			<form name="adminFile" action="<%=response.encodeURL("adminView.jsp") %>" method="post" >	
			<input type="hidden" name="addAllLoc" value="yes">			
				<table>
					<tr><td>Click to add locations specified in the text file</td>
					<td><input type="submit" value="Add Locations" size="25"></td>
					</tr>
				</table>
			</form>

			<form name="delComment" action="<%=response.encodeURL("delAComment.jsp")%>" method="post" >
				<input type="hidden" name="reDirURL" value="adminView.jsp">
				<table>
					<tr><td>Delete a comment</td>
						<td><input type="text" name="idComment" value="Enter comment number here..." size="30"></td>
						<td>&nbsp;</td> <td><input type="submit" value="Delete Comment" size="25"></td>
					</tr>
				</table>
			</form>
			</div>
			<br /><br />
			<h2>Setup Email Functionality:</h2>
			<div class="Box" id="Box">
			<form id="email" action="javascript:void(0)" onsubmit="return setupemail(this)">
				<input type="hidden" name="emailconfig" value="yes"/>
				<table class="email">
					<tr><td>Use Authentication?:</td><td><input type="checkbox" name="authenticate"/></td></tr>
					<tr><td>Username:</td><td><input type="text" name="username"/> </td></tr>
					<tr><td>Password:</td><td><input type="password" name="password"/></td></tr>
					<tr><td>Reply To Address:</td><td><input type="text" name="replyTo"/></td></tr>
					<tr><td>SMTP URL:</td><td><input type="text" name="smtpURL"/></td></tr>
					<tr><td>SMTP port:</td><td><input type="text" name="port"/></td></tr>
					<tr><td>Use TLS?:</td><td><input type="checkbox" name="useTLS"/></td></tr>
					<tr><td>&nbsp;</td><td><input type="submit"/> </td></tr>
				</table>
			</form>
			<h2>Setup Proxy Configuration</h2>
			<h3>Current settings</h3>
			<object data="displayproxies" type="text/html" width="500" height="300">Sorry your browser don't support this tag</object>
			</div>
			<br /> <br /> 
			<h2>Users and Rides in the System:</h2>
			<div class="Box" id="Box">
			<h3>Users:</h3>	
			<table>
				<tr><td><%=userTable%></td></tr>
			</table>
			<br />
			<h3>Rides:</h3>					
			<table>
				<%=rideTable%>					
			</table>
			</div>
			<br /><br /><br />
			<p>-- <a href="<%=response.encodeURL("welcome.jsp")%>">Home</a> --</p>
		</div>

	<%@ include file="leftMenu.jsp" %>

	</body>
</html>