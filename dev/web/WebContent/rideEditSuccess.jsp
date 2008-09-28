<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>

<%
String delConf = "";
String updateConf = "";

User user = null;
//force the user to login to view the page
if (session.isNew() || (OpenIdFilter.getCurrentUser(session) == null && session.getAttribute("signedin") == null)) {
	//response.sendRedirect("");
	request.getRequestDispatcher("").forward(request, response);
} else {
	user = (User)session.getAttribute("user");

	//code to interact with db
	CarPoolStore cps = new CarPoolStoreImpl();

	
	
	//if you have been redirected here from deleting a ride print useful info
	if (request.getParameter("rideSelect") != null && request.getParameter("remRide") != null ){
		cps.removeRide( Integer.parseInt(request.getParameter("rideSelect")));
		delConf = "<p>" + "You have successfully deleted the ride you wanted to" + "</p>";
	}
	
	
	//if you have been redirected here from editing a ride print useful info && request.getParameter("Rseats") != null
	if (request.getParameter("rideSelect") != null && request.getParameter("updateRide") != null){
		//Integer.parseInt(request.getParameter("Rseats"))
		cps.updateSeats( Integer.parseInt(request.getParameter("rideSelect")), 100);
		updateConf = "<p>" + "You have successfullyy updated the ride you wanted to" + "</p>";
	}
	
}
%>



<HTML>
	<HEAD>
		<TITLE>User Account Page</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
		<%@include file="include/javascriptincludes.html" %>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

	<DIV class="content">
		<%=delConf%>
		<%=updateConf%>
		<%=request.getParameter("Rseats") %>
	</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>