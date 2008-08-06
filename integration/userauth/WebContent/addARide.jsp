<%@page contentType="text/html; charset=ISO-8859-1" import="java.util.*, java.text.*, org.verisign.joid.consumer.OpenIdFilter"%>
<%@page import="org.verisign.joid.consumer.OpenIdFilter" %>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(session) == null) {
	response.sendRedirect("/index.jsp");
}
%>

<HTML>
	<HEAD>
		<TITLE> Offer a Ride </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
		<SCRIPT type="text/javascript" src="CalendarPopup.js"></SCRIPT>
		<SCRIPT type="text/javascript">
			var cal = new CalendarPopup();
		</SCRIPT>
<%
Date now = new Date();
String time = DateFormat.getTimeInstance(DateFormat.SHORT).format(now);
String date = DateFormat.getDateInstance().format(now);
%>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

		<DIV class="content">
			<p>Please enter the relevant details and click confirm.</p>
			<FORM NAME="offerFrm" method="post" action="newRideConfirmation.jsp">
				<h5>Location:</h5>
				<p> From: 
				<INPUT TYPE="text" NAME="from1" VALUE="" SIZE="25"> </p>
				<p>To:</p> 
				<INPUT TYPE="text" NAME="to1" VALUE="" SIZE="25"> <br /> <br />

				<h5>Timing:</h5>
				<p>Date: (dd/MM/yyyy)<p> 
				<INPUT TYPE="text" NAME="date1" VALUE="<%= date %>" SIZE="25">
				<A HREF="#" onClick="cal.select(document.forms['offerFrm'].date1,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img border="0" src="calendar_icon.jpg" width="27" height="23"></A>
				<p>Departure Time: (hh:mm)<p>
				<INPUT TYPE="text" NAME="time1" VALUE="<%= time %>" SIZE="25"> 
				<p>Approximate Trip Length: (minutes)<p>
				<INPUT TYPE="text" NAME="time2" VALUE="" SIZE="25"> 

				<h5>Additional Details:</h5>
				<p>Type of ride:</p>
				<INPUT type="radio" name="RideType" id="one-off" />
				<label for="one-off">One-off</label>
				<br />
				<INPUT type="radio" name="RideType" id="regular" />
				<label for="regular">Regular</label>

				<p>Number of passenger seats available:<p>
				<INPUT TYPE="text" NAME="seat1" SIZE="25"> <br /> <br />

				<p>Extra info (e.g. place of departure):<p>
				<INPUT TYPE="text" NAME="place1" SIZE="25"> 

				<p>Return Trip:</p>
				<SELECT>
				<option onclick="displayHide(true)">Yes</option>
				<option onclick="displayHide(false)">No</option>
				</SELECT><br /> <br /><br /> <br />

				<INPUT TYPE="hidden" NAME="user" VALUE="<%=OpenIdFilter.getCurrentUser(request.getSession())%>" SIZE="25">

				<INPUT TYPE="submit" NAME="submit" VALUE="Confirm" SIZE="25">
			</FORM>
		</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>