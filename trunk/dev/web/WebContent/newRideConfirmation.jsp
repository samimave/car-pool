<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, java.text.SimpleDateFormat, car.pool.user.*, java.util.Date" %>

<%
HttpSession s = request.getSession(false);

//force the user to login to view the page
// a container for the users information
User user = null;
if(s.getAttribute("signedin") != null ) {
	user = (User)s.getAttribute("user");
} else {
	response.sendRedirect(request.getContextPath());
}

//add ride information to database
CarPoolStore cps = new CarPoolStoreImpl();
user = (User)s.getAttribute("user");
int dbID = user.getUserId();//cps.getUserIdByURL(request.getParameter("user"));

//date formatting for use by db 
//dd/MM/yyyy -> yyyy-MM-dd
String strTmp = request.getParameter("depDate");
Date dtTmp = new SimpleDateFormat("dd/MM/yyyy").parse(strTmp);
String strOutDt = new SimpleDateFormat("yyyy-MM-dd").format(dtTmp);



int rideID = cps.addRide(dbID,Integer.parseInt(request.getParameter("numSeats")),strOutDt,Integer.parseInt(request.getParameter("streetFrom")),Integer.parseInt(request.getParameter("streetTo")),Integer.parseInt(request.getParameter("houseFrom")),Integer.parseInt(request.getParameter("recurrence")),request.getParameter("depTime"),request.getParameter("xtraInfo"));
//add social score
cps.addScore(cps.getTripID(rideID,dbID),dbID,5);

LocationList allLocs = cps.getLocations();

String from = "";
while (allLocs.next()){
	if (allLocs.getID() == Integer.parseInt(request.getParameter("streetFrom")))
		from = allLocs.getStreetName();	
}

LocationList allLocs2 = cps.getLocations();

String to = "";
while (allLocs2.next()){
	if (allLocs2.getID() == Integer.parseInt(request.getParameter("streetTo")))
		to = allLocs2.getStreetName();	
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE> Ride Successfully Added! </TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="Content" id="Content">
			<p>Thank you for adding a <%=request.getParameter("rideType") %> from <%= from %>, to <%= to %> ;  
			scheduled for <%= request.getParameter("depTime") %> <%= request.getParameter("depDate") %>. </p>
			<FORM action="addRideEvent.jsp" method="post" target="_blank">
            	<INPUT type="hidden" name="from" value="<%=request.getParameter("streetFrom") %>">
				<INPUT type="hidden" name="to" value="<%=request.getParameter("streetTo") %>">
				<INPUT type="hidden" name="time" value="<%=request.getParameter("depTime") %>">
				<INPUT type="hidden" name="length" value="<%=request.getParameter("tripLength") %>">
				<INPUT type="hidden" name="date" value="<%=strOutDt %>">
				<INPUT type="submit" value="Add to Google Calendar" />
			</FORM>
		</DIV>

	<%@ include file="leftMenu.html" %>

	</BODY>
</HTML>
