<%//@page errorPage="errorPage.jsp" %>
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
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");
	
		UserManager manager = null;
		manager = new UserManager(); 
		driver = manager.getUserByUserId(Integer.parseInt(request.getParameter("profileId")));
		cps = new CarPoolStoreImpl();
		

		
		RideListing rl = cps.searchRideListing(RideListing.searchUser,driver.getUserName());
		boolean userExist = false;
		while (rl.next()) {
			if (!userExist) {
				userTable = ""; //first time round get rid of unwanted text
			}
			userExist = true;

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
			String d = new SimpleDateFormat("dd/MM/yyyy").format(rl
					.getRideDate())
					+ " " + rl.getTime();
			Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);
			if (dt.after(new Date())) {
				userTable += "<td> <a href='"
						+ response.encodeURL(request.getContextPath()
						+ "/rideDetails.jsp?rideselect="
						+ rl.getRideID()) + "'>"
						+ "Link to Ride Page"
						+ "</a> </td> </tr>";
			} else {
				userTable += "<td>Old ride.</td></tr>";
			}
		}

		if (userExist) {
			userTable = "<table class='rideDetailsSearch'> <tr> <th>Starting From</th> <th>Going To</th>"
					+ "<th>Departure Date</th> <th>Departure Time</th><th>Link to Ride Page</th> </tr>"
					+ userTable + "</table>";
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
			<% %>
		<table>
		<tr><td>Username: </td><td><%=driver.getUserName()%></td></tr>
		<tr><td>Email: </td><td><%=driver.getEmail() %></td></tr>
		<tr><td>Social Score: </td><td><%=cps.getScore(driver.getUserId()) %>
	
		</table>
		<br />
		</div>
		<br /><br />
		<h2>Rides User Has Offered:</h2>
		<div class="Box" id="Box">
		<%=userTable %>
		</div>
		<br /> <br /> <br />
		<p>-- <a href="welcome.jsp">Home</a> --</p>	
	</DIV>

	<%@ include file="leftMenu.jsp" %>

	</BODY>
</HTML>