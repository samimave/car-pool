<%@page contentType="text/html; charset=ISO-8859-1" import="car.pool.persistance.*"%>

<%

%>

<html>
	<head>
		<title>Sign Up for The Car Pool!</title>
		<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>
	</head>
	<body>

	<%@ include file="heading.html" %>	

		<div class="content">
			<p>Please enter the relevant details and click confirm.</p>
			<form method="post" action="adduser">
				<h2>User Account:</h2>
				<p>User Name for this site:<p>
				<input type="text" name="userName" size="25"/> 
				<a href="#">Check Availability</a> <br /> <br />
				<p>Password</p>
				<p>The password you wish to use<p>
				<input type="password" name="password1"/>
				<p>Retype your password to confirm<p>
				<input type="password" name="password2"/>
				<h2>Additional Details:</h2>
				<p>Email address:<p> 
				<input type="text" name="email" size="25"/>

				<p>Phone Number:<p> 
				<input type="text" name="phone" size="25"/><br /> <br />

				<input type="submit" value="Confirm" SIZE="25"/> <br /> <br />
			</form>
		</div>

	<div id="navAlpha">
		Please enter your details.
	</div>

	<div id="navBeta">
		
	</div>

	</body>
</html>
