<%@page contentType="text/html; charset=ISO-8859-1" %>

<%
//HttpSession s = request.getSession(false);
%>

<html>
	<head>
		<title> Ride Successfully Added! </title>
		<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>
	</head>
	<body>

	<%@ include file="heading.html" %>

		<div class="content">
			<p>Thank you for adding a ride from <%= request.getParameter("from1") %>, to <%= request.getParameter("to1") %>;  
			scheduled for <%= request.getParameter("time1") %> <%= request.getParameter("date1") %>. </p>
			<form action="addRideEvent.jsp" method="post">
            <input type="hidden" name="from" value="<%=request.getParameter("from1") %>">
			<input type="hidden" name="to" value="<%=request.getParameter("to1") %>">
			<input type="hidden" name="time" value="<%=request.getParameter("time1") %>">
			<input type="hidden" name="date" value="<%=request.getParameter("date1") %>">
			<input type="submit" value="Add to Google Calendar" />
			</form>
		</div>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</body>
</html>