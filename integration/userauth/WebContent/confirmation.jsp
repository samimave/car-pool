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
		</div>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</body>
</html>