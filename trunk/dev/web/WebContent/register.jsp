<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page import="car.pool.persistance.*"%>

<%
HttpSession s = request.getSession(true);
String message = "";
if(request.getParameter("error") != null) {
	message = request.getParameter("error");
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE>Sign Up for The Car Pool!</TITLE>
		<style type="text/css" media="screen">@import "TwoColumnLayout.css";</style>
		<%@include file="include/javascriptincludes.html" %>
	</HEAD>
	<BODY onload="formCookieCheck()">

	<%@ include file="heading.html" %>	

		<div class="Content" id="Content">
			<%if(message.length() > 0) { %><strong><%=message %></strong><%} %>
			<h2 class="title" id="title">Sign Up for The Car Pool</h2>
			<br /><br />
			<h2>Please Enter Your Details:</h2>
			<div class="Box" id="Box">
			<FORM name="register" id="register" onsubmit="return (formCookieCheck() && normalRegisterFormValidation(this) && isUserNameAvailable())" method="post" action="adduser">
				<TABLE class="register">
					<tr> <td>User name:</td> <td><INPUT type="text" name="userName" size="25"/></td> <td><a href="#" onclick="checkUserNameAvailable()">Check Availability</a><b id="availableoutput"></b></td> </tr>
					<tr> <td>Password:</td> <td><INPUT type="password" name="password1" size="25"/></td> </tr>
					<tr> <td>Confirm password:</td> <td><INPUT type="password" name="password2" size="25"/></td> </tr>
					<tr> <td>Email address:</td> <td><INPUT type="text" name="email" size="25"/></td> </tr>			
					<tr> <td>Phone Number:</td> <td><INPUT type="text" name="phone" size="25"/></td> </tr>
					<tr> <td colspan="2"><img src="blurredimage" width="200" height="100"/></td> </tr>
					<tr> <td>Enter the characters shown above:</td><td><input type="text" name="verifytext"/></td> </tr>
				</TABLE>
			<br />
			<p>Click here to <INPUT type="submit" value="Register"/></p>
			</FORM>
			</div>
		</div>

	<div class="Menu" id="Menu">
		<p><a href="welcome.jsp"> <img class="logo" border="0" src="Car Pool 6 75.bmp" width="263" height="158"> </a></p> <br />
		Please enter your details.
		<%if(message.length() > 0) { %><strong><%=message %></strong><%} %>
	</div>

	</BODY>
</HTML>
