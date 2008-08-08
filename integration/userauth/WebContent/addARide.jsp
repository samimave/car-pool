<%@page contentType="text/html; charset=ISO-8859-1" import="java.util.*, java.text.*, org.verisign.joid.consumer.OpenIdFilter"%>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(session) == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

//simple date processing for display on page
Date now = new Date();
String time = DateFormat.getTimeInstance(DateFormat.SHORT).format(now);
String date = DateFormat.getDateInstance().format(now);
%>

<HTML>
	<HEAD>
		<TITLE> Offer a Ride </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
		<SCRIPT type="text/javascript" src="CalendarPopup.js"></SCRIPT>
		<SCRIPT type="text/javascript">
			var cal = new CalendarPopup();
		</SCRIPT>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

		<DIV class="content">
			<p>Please enter the relevant details and click confirm.</p>
			<FORM NAME="offerFrm" method="post" action="newRideConfirmation.jsp">
				<INPUT TYPE="hidden" NAME="user" VALUE="<%=OpenIdFilter.getCurrentUser(request.getSession())%>" SIZE="25">
				<TABLE class="rideDetails">
					<tr> <th> <h2>Location:</h2> </th> <th>&nbsp;</th> </tr>
					<tr> <td>From:</td> <td><INPUT TYPE="text" NAME="from" VALUE="" SIZE="25"></td> </tr> 
					<tr> <td>To:</td> <td><INPUT TYPE="text" NAME="to" VALUE="" SIZE="25"></td> </tr>

					<tr> <th> <h2>Timing:</h2> </th> <th>&nbsp;</th> </tr>
					<tr> <td>Date (dd/MM/yyyy):</td> <td><INPUT TYPE="text" NAME="depDate" VALUE="<%= date %>" SIZE="25"> <A HREF="#" onClick="cal.select(document.forms['offerFrm'].depDate,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img border="0" src="calendar_icon.jpg" width="27" height="23"></A> </td> </tr> 
					<tr> <td>Departure Time (hh:mm):</td> <td><INPUT TYPE="text" NAME="depTime" VALUE="<%= time %>" SIZE="25"></td> </tr>
					<tr> <td>Approximate Trip Length (minutes):</td> <td><INPUT TYPE="text" NAME="tripLength" VALUE="15" SIZE="25"></td> </tr>

					<tr> <th> <h2>Additional Details:</h2> </th> <th>&nbsp;</th> </tr>
					<tr> <td>Reccurence:</td> <td>
						<INPUT type="radio" name="RideType" id="one-off" />
						<label for="one-off">One-off</label> <br />
						<INPUT type="radio" name="RideType" id="regular" />
						<label for="regular">Regular</label></td> </tr> 
					<tr> <td>Number of passenger seats available:</td> <td><INPUT TYPE="text" NAME="numSeats" SIZE="25"></td> </tr>
					<tr> <td>Extra info (e.g. place of departure):</td> <td><INPUT TYPE="text" NAME="xtraInfo" SIZE="25"></td> </tr>
			 		<tr> <td>Return Trip:</td> <td>	
						<SELECT name="return">
						<option value="Yes">Yes</option>
						<option value="No">No</option>
						</SELECT></td> </tr>
					<tr> <td><INPUT TYPE="submit" NAME="submit" VALUE="Confirm" SIZE="25"></td> <td>&nbsp;</td> </tr>
				</TABLE>
			</FORM>
		</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>