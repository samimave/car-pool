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
			<p>Please enter the relevant details and click confirm.</p>
			<FORM NAME="offerFrm" method="post" action="confirmation.jsp">
				<h5>Date and Time:</h5>
				<p>Date:<p> 
				<INPUT TYPE="text" NAME="date1" VALUE="<%= date %>" SIZE="25">
				<A HREF="#" onClick="cal.select(document.forms['offerFrm'].date1,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img border="0" src="calendar_icon.jpg" width="27" height="23"></A>
				<p>Time:<p>
				<INPUT TYPE="text" NAME="time1" VALUE="<%= time %>" SIZE="25"> 
				<h5>Location:</h5>
				<p>From:</p>
				<INPUT TYPE="text" NAME="from1" VALUE="" SIZE="25"> 
				<p>To:</p> 
				<INPUT TYPE="text" NAME="to1" VALUE="" SIZE="25"> <br /> <br />
				<INPUT TYPE="submit" NAME="submit" VALUE="Confirm" SIZE="25">
			</FORM>
		</div>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</body>
</html>