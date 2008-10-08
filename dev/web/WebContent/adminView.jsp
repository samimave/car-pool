<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="java.util.*,java.text.*,org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.persistance.test.*,car.pool.locations.*,car.pool.user.*,car.pool.persistance.test.AddLocations"%>

<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	//a container for the users information
	User user = null;
	String userTable = "";
	String rideTable = "";
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");

		CarPoolStore cps = new CarPoolStoreImpl();
		String[] locations = LocationImporter.importLocations();

		if (request.getParameter("locations") != null) {
			
			String[] locList = request.getParameter("locations").split(", ");
			//System.out.println(locList);
			for (int i=0; i<locList.length; i++){			
			int region = -1;
			region = cps.addRegion("Palmerston North");
			cps.addLocation(region, locList[i]);
			//System.out.println("street: " + locList[i]);
			}
		}

		String uName;
		String uEmail;
		String uPhone;
		String uSignUpDate;
		UserList nList = cps.getUserName();
		UserList eList = cps.getUserEmail();
		UserList pList = cps.getUserPhone();
		UserList sList = cps.getUserSignUpDate();

		String Table = "";
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
		userTable = "<table class='rideDetailsSearch'> <tr> <th>User Name</th> <th>Email</th> <th>Phone</th>"
				+ "<th>Sign Up Date</th> </tr>" + Table + "</table>";

		boolean rExist = false;
		RideListing all = cps.getRideListing();
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
			rideTable += "<td> <a href='" + request.getContextPath()
					+ "/rideDetails.jsp?rideselect=" + all.getRideID()
					+ "&userselect=" + all.getUsername() + "'>"
					+ "Link to ride page" + "</a> </td> </tr>";

		}
		if (rExist) {
			rideTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"
					+ "<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th> <th>More Info</th> </tr>"
					+ rideTable + "</table>";
		}
	} else {
		response.sendRedirect(request.getContextPath());
	}
%>
		
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE> Administration Tasks</TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<%@include file="include/javascriptincludes.html" %>
		</HEAD>
	<BODY>

		<%@ include file="heading.html" %>

		<DIV class="Content" id="Content">
			<h2 class="title" id="title">Administrative Options</h2>
			<br /><br />
			<h2>Database:</h2>
			<div class="Box" id="Box">
			<FORM NAME="admin" action="#" method="post" >				
				<table>
					<tr><td>Enter a comma and space separated list of streets below</td></tr>
						<tr><td><TEXTAREA cols="50" rows="4" name="locations"></TEXTAREA></td>
						<td>&nbsp;</td> <td><INPUT type="submit" value="Add Locations" size="25" onClick="<%AddLocations.addFromFile();%>" ></td>
					</tr>
				</table>
			</FORM>

			<FORM NAME="delComment" action="delAComment.jsp" method="post" >
				<table>
					<tr><td>Delete a comment</td>
						<td><INPUT type="text" name="idComment" value="Enter comment number here..." size="30"></td>
						<td>&nbsp;</td> <td><INPUT type="submit" value="Delete Comment" size="25"></td>
					</tr>
				</table>
			</FORM>
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
			</div>
			<br /> <br /> 
			<h2>Users and Rides in the System:</h2>
			<div class="Box" id="Box">
			<FORM NAME="resultFrm" id="result">
				<h3>Users:</h3>	
				<TABLE>
					<tr><td><%=userTable%></td></tr>
				</TABLE>
				<br />
				<h3>Rides:</h3>					
				<TABLE>
					<%=rideTable%>					
				</TABLE>
			</FORM>
			</div>
			<br /><br /><br />
			<p>-- <a href="welcome.jsp">Home</a> --</p>
		</DIV>

	<%@ include file="leftMenu.html" %>

	</BODY>
</HTML>