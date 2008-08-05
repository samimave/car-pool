<%@page contentType="text/html; charset=ISO-8859-1" import="java.util.*, java.text.*"%>

<%
//HttpSession s = request.getSession(false);
%>

<html>
	<head>
		<title> Offer a Ride </title>
		<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>
		<SCRIPT type="text/javascript" src="CalendarPopup.js"></SCRIPT>
		<SCRIPT type="text/javascript">
			var cal = new CalendarPopup();
		</SCRIPT>
<%
Date now = new Date();
String time = DateFormat.getTimeInstance(DateFormat.SHORT).format(now);
String date = DateFormat.getDateInstance().format(now);
%>
	</head>
	<body>

	<%@ include file="heading.html" %>	

		<div class="content">
			<p>Ride Offered By:<p>
			<INPUT TYPE="text" NAME="user" VALUE="<%="add logged in user's name" %>" SIZE="25"><br /> <br />

			<p>Please enter the relevant details and click confirm.</p>
			<FORM NAME="offerFrm" method="post" action="confirmation.jsp">
				<h5>Location:</h5>
				<p>From:</p>
				<INPUT TYPE="text" NAME="from1" VALUE="" SIZE="25"> 
				<p>To:</p> 
				<INPUT TYPE="text" NAME="to1" VALUE="" SIZE="25"> <br /> <br />

				<p>Type of ride:</p>
				<form name="inputType1" action="">
				<input type="radio" name="RideType" id="one-off" />
				<label for="one-off">One-off</label>
				<br />
				<input type="radio" name="RideType" id="regular" />
				<label for="regular">Regular</label>
				</form>

				<h5>The details:</h5>
				<p>Date:<p> 
				<INPUT TYPE="text" NAME="date1" VALUE="<%= date %>" SIZE="25">
				<A HREF="#" onClick="cal.select(document.forms['offerFrm'].date1,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img border="0" src="calendar_icon.jpg" width="27" height="23"></A>
				<p>Departure Time:<p>
				<INPUT TYPE="text" NAME="time1" VALUE="<%= time %>" SIZE="25"> 
				<p>Arrival Time:<p>
				<INPUT TYPE="text" NAME="time2" VALUE="<%= time %>" SIZE="25"> 
				<p>Additional details (e.g. place of departure):<p>
				<INPUT TYPE="text" NAME="place1" SIZE="25"> 
				<p>Seats Available:<p>
				<INPUT TYPE="text" NAME="seat1" SIZE="25"> <br /> <br />

				<p>Return Trip:</p>
				<select>
				<option onclick="displayHide(true)">Yes</option>
				<option onclick="displayHide(false)">No</option>
				</select><br /> <br /><br /> <br />



				<INPUT TYPE="submit" NAME="submit" VALUE="Confirm" SIZE="25">
			</FORM>
		</div>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</body>
</html>