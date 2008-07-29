<%@page contentType="text/html; charset=ISO-8859-1"%>

<%//@page import=""%>

<%
HttpSession s = request.getSession(true);
%>

<html>
	<head>
		<title> The Car Pool </title>
		<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>
	</head>
	<body>

	<%@ include file="heading.html" %>

		<div class="content">
			<h5 align="center">Welcome to The Car Pool</h5>
			<p>Please Log in.</p>
		</div>

	<div id="navAlpha">
		Please Log in.
	</div>

	<div id="navBeta">
		<FORM NAME="login" method="post" action="welcome.jsp">
			UserName:<br />
			<INPUT TYPE="text" NAME="user" VALUE="" SIZE="15">
			Password:<br />
			<INPUT TYPE="text" NAME="pword" VALUE="" SIZE="15"> 
			<INPUT TYPE="submit" NAME="submit" VALUE="Login" SIZE="15" onclick=""> 
		</FORM>
		<a href="welcome.jsp">Sign Up</a>
	</div>
		
	</body>
</html>

