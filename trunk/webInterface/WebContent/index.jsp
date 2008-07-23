<%@page contentType="text/html; charset=ISO-8859-1" %>
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
		<FORM NAME="login" method="post" action="">
			<p>UserName:<p> 
			<INPUT TYPE="text" NAME="user" VALUE="" SIZE="25">
			<p>Password:<p>
			<INPUT TYPE="text" NAME="pword" VALUE="" SIZE="25"> 
			<INPUT TYPE="submit" NAME="submit" VALUE="Submit" SIZE="25">
		</FORM>
		<a href="welcome.jsp">Sign Up</a>
	</div>
		
	</body>
</html>