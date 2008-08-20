<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}
User user = (User)session.getAttribute("user");
//temp placeholder variables
String offerTable = "<p>No rides found.</p>";
String acceptedTable = "<p>No rides found.</p>";
String requestTable = "<p>No rides found.</p>";

//code to interact with db
CarPoolStore cps = new CarPoolStoreImpl();
//String openID = OpenIdFilter.getCurrentUser(request.getSession());
int currentUser = user.getUserId();//cps.getUserIdByURL(openID);

//cps.

//code to update details if requested
if (request.getParameter("updateDetails") != null) {
	cps.addUser((String)request.getParameter("openid_url"),(String)request.getParameter("userName"),(String)request.getParameter("email"),(String)request.getParameter("phone"));
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
		<FORM name="updateDetails" action="myDetails.jsp" method="post">
			<INPUT type="hidden" name="updateDetails" value="yes">
			<TABLE class='rideDetails'>
				<tr> <td>Open ID:</td> <td><INPUT TYPE="text" NAME="openid_url" SIZE="25" value="<%=user.getOpenIds().size() > 0 ? user.getOpenIds().toArray()[0] : null%>"></td> </tr>
				<tr> <td>Username:</td> <td><INPUT TYPE="text" NAME="userName" SIZE="25" value="<%=user.getUserName()%>"></td> </tr> 
				<tr> <td>Email Address:</td> <td><INPUT TYPE="text" NAME="email" SIZE="25" value="<%=user.getEmail()%>"></td> </tr> 
				<tr> <td>Phone Number:</td> <td><INPUT TYPE="text" NAME="phone" SIZE="25" value="<%=user.getPhoneNumber()%>"></td> </tr>  
			</TABLE>
			<INPUT TYPE="submit" NAME="confirmUpdate" VALUE="Update Details" SIZE="25">
		</FORM>
		<h2>Your ride details appear below:</h2>
		<p>our offers</p>
		<%=offerTable %>
		<p>Accepted Rides</p>
		<%=acceptedTable %>
		<p>Your requests</p>
		<%=requestTable %>

	</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>