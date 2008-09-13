<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, java.text.SimpleDateFormat" %>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

//add ride information to database
CarPoolStore cps = new CarPoolStoreImpl();
User user = (User)session.getAttribute("user");
int dbID = user.getUserId();//cps.getUserIdByURL(request.getParameter("user"));

//date formatting for use by db 
//dd/MM/yyyy -> yyyy-MM-dd
String strTmp = request.getParameter("depDate");
Date dtTmp = new SimpleDateFormat("dd/MM/yyyy").parse(strTmp);
String strOutDt = new SimpleDateFormat("yyyy-MM-dd").format(dtTmp);

//addRide(int user, int availableSeats, String startDate, int startLocation, int endLocation, int streetNumber, int reoccur, String time, String comment)

cps.addRide(dbID,Integer.parseInt(request.getParameter("numSeats")),strOutDt,Integer.parseInt(request.getParameter("streetFrom")),Integer.parseInt(request.getParameter("streetTo")),Integer.parseInt(request.getParameter("houseFrom")),Integer.parseInt(request.getParameter("recurrence")),request.getParameter("depTime"),request.getParameter("xtraInfo"));

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

<HTML>
	<HEAD>
		<TITLE> Ride Successfully Added! </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="content">
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

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>
