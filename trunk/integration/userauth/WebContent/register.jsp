<%@page contentType="text/html; charset=ISO-8859-1" import="car.pool.persistance.*"%>

<%

%>

<HTML>
	<HEAD>
		<TITLE>Sign Up for The Car Pool!</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

		<DIV class="content">
			<p>Please enter the relevant details and click confirm.</p>
			<FORM NAME="offerFrm" method="post" action="welcome.jsp">
				<INPUT type="hidden" name="newUser" value="yes">
				<h2>User Account:</h2>
				<p>Open ID Account:<p> 
				<INPUT TYPE="text" NAME="openid_url" SIZE="25">
				
				<p>User Name for this site:<p>
				<INPUT TYPE="text" NAME="userName" SIZE="25"> 
				<a href="#">Check Availability</a> <br /> <br />

				<h2>Additional Details:</h2>
				<p>Email address:<p> 
				<INPUT TYPE="text" NAME="email" SIZE="25">

				<p>Phone Number:<p> 
				<INPUT TYPE="text" NAME="phone" SIZE="25"><br /> <br />

				<INPUT TYPE="submit" NAME="confirmReg" VALUE="Confirm" SIZE="25"> <br /> <br />
			</FORM>
		</DIV>

	<DIV id="navAlpha">
		Please enter your details.
	</DIV>

	<DIV id="navBeta">
		
	</DIV>

	</BODY>
</HTML>