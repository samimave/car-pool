<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*, java.util.*, java.text.SimpleDateFormat " %>

<%


String delConf = "";
String updateSeatConf = "";
String updateTimeConf = "";
String updateStartS = "";
String updateEndS = "";
String updateDateConf = "";


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
	if (request.getParameter("rideSelect") != null && request.getParameter("numSeats") != null){
		//Integer.parseInt(request.getParameter("Rseats"))
		cps.updateSeats( Integer.parseInt(request.getParameter("rideSelect")), Integer.parseInt(request.getParameter("numSeats")));
		updateSeatConf = "<p>" + "You have successfully updated the ride you wanted to" + "</p>";
	}
	
	//if you have been redirected here from editing a ride print useful info && request.getParameter("Rseats") != null
	if (request.getParameter("rideSelect") != null && request.getParameter("Rtime") != null){
		cps.updateStartTime( Integer.parseInt(request.getParameter("rideSelect")), request.getParameter("Rtime") );
		updateTimeConf = "<p>" + "You have successfully updated the ride you wanted to" + "</p>";
	}
	
	//if you have been redirected here from editing a ride print useful info && request.getParameter("Rseats") != null
	if (request.getParameter("rideSelect") != null && request.getParameter("startFrom") != null){
		cps.updateStartLoc( Integer.parseInt(request.getParameter("rideSelect")), Integer.parseInt(request.getParameter("startFrom")) );
		updateStartS = "<p>" + "You have successfully updated the ride you wanted to" + "</p>";
	}
	
	//if you have been redirected here from editing a ride print useful info && request.getParameter("Rseats") != null
	if (request.getParameter("rideSelect") != null && request.getParameter("endTo") != null){
		cps.updateEndLoc( Integer.parseInt(request.getParameter("rideSelect")), Integer.parseInt(request.getParameter("endTo")) );
		updateEndS = "<p>" + "You have successfully updated the ride you wanted to" + "</p>";
	}
	
	//if you have been redirected here from editing a ride print useful info && request.getParameter("Rseats") != null
	if (request.getParameter("rideSelect") != null && request.getParameter("Rdate") != null){
		String strTmp = request.getParameter("Rdate");
		Date dtTmp = new SimpleDateFormat("dd/MM/yyyy").parse(strTmp);
		String strOutDt = new SimpleDateFormat("yyyy-MM-dd").format(dtTmp);
		//Integer.parseInt(request.getParameter("Rseats"))
		cps.updateStartDate( Integer.parseInt(request.getParameter("rideSelect")), strOutDt);
		updateSeatConf = "<p>" + "You have successfully updated the ride you wanted to" + "</p>";
	}
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE>User Account Page</TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

	<DIV class="Content" id="Content">
		<%=delConf%>
		<%=updateSeatConf%>
		<%=updateTimeConf%>
		<%=updateStartS %>
		<%=updateEndS %>
		<%=updateDateConf %>
	</DIV>

	<%@ include file="leftMenu.html" %>

	</BODY>
</HTML>