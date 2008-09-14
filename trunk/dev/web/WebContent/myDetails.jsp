<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}
User user = (User)session.getAttribute("user");

//code to interact with db
CarPoolStore cps = new CarPoolStoreImpl();
//String openID = OpenIdFilter.getCurrentUser(request.getSession());
int currentUser = user.getUserId();//cps.getUserIdByURL(openID);

//cps.

//code to update details if requested
if (request.getParameter("updateDetails") != null) {
	cps.addUser((String)request.getParameter("openid_url"),(String)request.getParameter("userName"),(String)request.getParameter("email"),(String)request.getParameter("phone"));
}

// code to get ride details
//temp placeholder variables
String offerTable = "<p>No rides found.</p>";
String acceptedTable = "<p>No rides found.</p>";
String requestTable = "<p>No rides found.</p>";
boolean ridesExist = false;
RideListing rl = cps.getRideListing();
if ((rl.next()) && (rl.getUserID() == currentUser)) {
	ridesExist = true;
	offerTable = "<table class='rideDetailsSearch'> <tr> <th class = rDh> Offered By </th> <th class = rDh> From </th> <th class = rDh> To </th> <th class = rDh> Date </th> <th class = rDh> Time </th> <th class = rDh> Available Seats </th> </tr>";
	offerTable += "<tr> <td  class = 'rD'>"+ rl.getUsername() +"</td> ";
	offerTable += "<td  class = 'rD'>"+ rl.getStartLocation() + "</td> ";
	offerTable += "<td  class = 'rD'>"+ rl.getEndLocation() +"</td> ";
	offerTable += "<td  class = 'rD'>"+ rl.getRideDate() +"</td> ";
	offerTable += "<td  class = 'rD'> null </td> ";
	offerTable += "<td  class = 'rD'>"+ rl.getAvailableSeats() +"</td> </tr>";
}
while ((rl.next())&& (rl.getUserID() == currentUser))  {
	offerTable += "<tr> <td>"+ rl.getUsername() +"</td> ";	
	offerTable += "<td  class = 'rD'>"+ rl.getStartLocation() + "</td> ";
	offerTable += "<td  class = 'rD'>"+ rl.getEndLocation() +"</td> ";
	offerTable += "<td  class = 'rD'>"+ rl.getRideDate() +"</td> ";
	offerTable += "<td  class = 'rD'> null </td> ";
	offerTable += "<td  class = 'rD'>"+ rl.getAvailableSeats() +"</td> </tr>";
}
if (ridesExist) {
	offerTable += "</table>";
}

//input openids to the table
String entries = "";
String openIDTableRow = "";
for (String oid : user.getOpenIds()) {
	entries += "<option value="+oid+">"+oid+"</option>";
}
if (entries != "") {
	openIDTableRow = "<tr> <td>Open ID:</td> <td><select multiple='multiple' NAME='openid_url'>"+entries+"</select></td> </tr>";
}
%>



<HTML>
	<HEAD>
		<TITLE>User Account Page</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

	<DIV class="content">
		<h2 align="center">Welcome to your Account Page</h2><br /><br />
		<h2>Your user details appear below:</h2>
		<FORM name="updateDetails" action="test.jsp" method="post">
			<INPUT type="hidden" name="updateDetails" value="yes">
			<TABLE class='userDetails'>
				<%=openIDTableRow %>
				<tr> <td>Username:</td> <td><INPUT TYPE="text" NAME="userName" SIZE="25" value="<%=user.getUserName()%>"></td> </tr> 
				<tr> <td>Email Address:</td> <td><INPUT TYPE="text" NAME="email" SIZE="25" value="<%=user.getEmail()%>"></td> </tr> 
				<tr> <td>Phone Number:</td> <td><INPUT TYPE="text" NAME="phone" SIZE="25" value="<%=user.getPhoneNumber()%>"></td> </tr>
  				<tr> <td>&nbsp;</td> <td><INPUT TYPE="submit" NAME="confirmUpdate" VALUE="Update Details" SIZE="25"></td> </tr>
			</TABLE>
		</FORM>
		<h2>Your ride details appear below:</h2><br>
		<p>Your offers</p>
		<%=offerTable %><br>
		<p>Approving acceptance</p>
		<p>The users below are awaiting your approval on their acceptance of your offer. If you can pick them up at the place they want click Approve otherwise click Reject.</p>
		<%//when the user click approve the boolean value confirm should be set to true. %>
		<%=requestTable %>
		<p>Rides you have been accepted and approved for.</p>
		<%=acceptedTable %>
	</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>