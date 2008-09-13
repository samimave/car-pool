<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>
<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

//being nice to our users
String message = "";

CarPoolStore cps = new CarPoolStoreImpl();
RideListing rl = cps.getRideListing();
User user = (User)session.getAttribute("user");
int dbID = user.getUserId();//cps.getUserIdByURL(request.getParameter("user"));
int rideID = Integer.parseInt(request.getParameter("rideselect"));

String detailsTable = "<p>No info found.</p>";
boolean ridesExist = false;

if ((rl.next()) && (rl.getRideID() == rideID)) {
	ridesExist = true;
	detailsTable = "<table class='detailsTable'> <tr> </tr>";
	detailsTable += "<tr> <td>Username:</td>  <td>"+ rl.getUsername() +"</td></tr> ";
	detailsTable += "<tr> <td> Start Region: </td> <td>"+ rl.getStartLocation() + "</td> </tr>";
	detailsTable += "<tr> <td> Stop Region: </td> <td>"+ rl.getEndLocation() +"</td></tr> ";
	detailsTable += "<tr> <td>Date: </td> <td>"+ rl.getRideDate() +"</td></tr> ";
	detailsTable += "<tr> <td> Time: </td> <td>" + rl.getTime()+ "</td> </tr>";
	detailsTable += "<tr> <td> Seats: </td> <td>"+ rl.getAvailableSeats() +"</td> </tr>";
	detailsTable += "<tr> <td> Additional Info: </td> <td>"+ rl.getComment() +"</td> </tr>";
}

while ((rl.next()) && (rl.getRideID() == rideID)) {
	detailsTable = "<table class='detailsTable'> <tr> </tr>";
	detailsTable += "<tr> <td>Username:</td>  <td>"+ rl.getUsername() +"</td></tr> ";
	detailsTable += "<tr> <td> Start Region: </td> <td>"+ rl.getStartLocation() + "</td> </tr>";
	detailsTable += "<tr> <td> Stop Region: </td> <td>"+ rl.getEndLocation() +"</td></tr> ";
	detailsTable += "<tr> <td>Date: </td> <td>"+ rl.getRideDate() +"</td></tr> ";
	detailsTable += "<tr> <td> Time: </td> <td>" + rl.getTime()+ "</td> </tr>";
	detailsTable += "<tr> <td> Seats: </td> <td>"+ rl.getAvailableSeats() +"</td> </tr>";
	detailsTable += "<tr> <td> Additional Info: </td> <td>"+ rl.getComment() +"</td> </tr>";
}

if (ridesExist) {
	detailsTable += "</table>";
}
%>

<HTML>
	<HEAD>
		<TITLE> Ride Details </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

	<DIV class="content">
		<h2>The ride details appear below:</h2>
		<%=request.getParameter("rideselect") %>
		<%=detailsTable %><br>
		<FORM name="comments" action="" method="post">
			<TABLE class='userComments'>
				<tr> <td>Add a Comment/Query</td> <td><INPUT TYPE="text" NAME="xtraInfo" SIZE="55"></td> </tr>
			</TABLE>
			<INPUT TYPE="submit" NAME="addComment" VALUE="Add Comment" SIZE="25">
		</FORM>
		
		


	</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>