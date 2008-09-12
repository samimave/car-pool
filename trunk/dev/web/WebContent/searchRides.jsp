<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

User user = (User)session.getAttribute("user");

boolean ridesExist = false;
String rideTable = "<p>No rides found.</p>";
CarPoolStore cps = new CarPoolStoreImpl();
RideListing rl = cps.getRideListing();
if (rl.next()) {
	ridesExist = true;
	rideTable = "<table class = 'rideDetailsSearch'> <tr> <th class = rDh> Offered By </th> <th class = rDh> From </th> <th class = rDh> To </th> <th class = rDh> Date </th> <th class = rDh> Time </th> <th class = rDh> Seats </th> <th class = rDh> More Info</th> </tr>";
	rideTable += "<tr> <td class = 'rD'>"+ rl.getUsername() +"</td> ";
	rideTable += "<td  class = 'rD'> <a href='"+ request.getContextPath() +"/temp.jsp?rideselect="+ rl.getRideID() +"'>"+ rl.getStartLocation() +"</a> </td> ";
	rideTable += "<td  class = 'rD'>"+ rl.getEndLocation() +"</td> ";
	rideTable += "<td  class = 'rD'>"+ rl.getRideDate() +"</td> ";
	rideTable += "<td  class = 'rD'> null </td> ";
	rideTable += "<td  class = 'rD'>"+ rl.getAvailableSeats() +"</td>";
	rideTable += "<td  class = 'rD'> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ rl.getRideID() +"'>"+ "Link to ride page" +"</a> </td> </tr>";
}
while (rl.next()) {
	rideTable += "<tr> <td>"+ rl.getUsername() +"</td> ";	
	rideTable += "<td  class = 'rD'> <a href='"+ request.getContextPath() +"/temp.jsp?rideselect="+ "More" +"'>"+ rl.getStartLocation() +"</a> </td> ";
	rideTable += "<td  class = 'rD'>"+ rl.getEndLocation() +"</td> ";
	rideTable += "<td  class = 'rD'>"+ rl.getRideDate() +"</td> ";
	rideTable += "<td  class = 'rD'> null </td> ";
	rideTable += "<td  class = 'rD'>"+ rl.getAvailableSeats() +"</td> ";
	rideTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ rl.getRideID() +"'>"+ "Link to ride page" +"</a> </td> </tr>";
}
if (ridesExist) {
	rideTable += "</table>";
}
//int dbID = cps.getUserIdByURL(request.getParameter("user"));
%>

<HTML>
	<HEAD>
		<TITLE>Ride Search</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css"; 
		</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="content">
			<p>Please enter the search criteria in the boxes below and click search</p>
			<FORM NAME="searchFrm" method="post" action="newRideConfirmation.jsp" >	
				<TABLE class="rideSearch">
					<tr> <td>Ride Type:</td> <td>
					<SELECT name="rideType">
						<option value="sel">Select an Option</option>
						<option value="Ride Offer">Ride Offer</option>
						<option value="Ride Request">Ride Request</option>
					</SELECT></td> </tr>	
					<tr> <td>Reccurence:</td> <td>
					<SELECT name="reccurence">
						<option value="sel">Select an Option</option>
						<option value="oneoff">One-Off</option>
						<option value="regular">Regular</option>
					</SELECT></td> </tr>
					<tr> <td>Return Trip:</td> <td>						
					<SELECT name="return">
						<option value="sel">Select an Option</option>
						<option value="Yes">Yes</option>
						<option value="No">No</option>
					</SELECT></td> </tr><br></br>
					<tr> <td><INPUT TYPE="submit" NAME="search" VALUE="Search" SIZE="25"></td> <td>&nbsp;</td> </tr>

					<%=rideTable %>
				</TABLE>
			</FORM>
		</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>