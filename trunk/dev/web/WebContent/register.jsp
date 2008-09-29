<%@page contentType="text/html; charset=ISO-8859-1" import="car.pool.persistance.*"%>

<%
HttpSession s = request.getSession(true);
String message = "";
if(request.getAttribute("error") != null) {
	message = (String)request.getAttribute("error");
}
%>

<HTML>
	<HEAD>
		<TITLE>Sign Up for The Car Pool!</TITLE>
		<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>
		<%@include file="include/javascriptincludes.html" %>
	</HEAD>
	<BODY onload="formCookieCheck()">

	<%@ include file="heading.html" %>	

		<div class="content">
			<%if(message.length() > 0) { %><strong><%=message %></strong><%} %>
			<p>Register yourself by filling in your details below</p>
			<FORM name="register" id="register" onsubmit="return (formCookieCheck() && normalRegisterFormValidation(this) && isUserNameAvailable())" method="post" action="adduser">
				<TABLE class="register">
					<tr> <td>User name:</td> <td><INPUT type="text" name="userName" size="25"/></td> <td><a href="#" onclick="checkUserNameAvailable()">Check Availability</a><b id="availableoutput"></b></td> </tr>
					<tr> <td>Password:</td> <td><INPUT type="password" name="password1" size="25"/></td> </tr>
					<tr> <td>Confirm password:</td> <td><INPUT type="password" name="password2" size="25"/></td> </tr>
					<tr> <td>Email address:</td> <td><INPUT type="text" name="email" size="25"/></td> </tr>			
					<tr> <td>Phone Number:</td> <td><INPUT type="text" name="phone" size="25"/></td> </tr>
					<tr> <td>&nbsp; </td> <td><INPUT type="submit" value="Register" SIZE="25"/></td> </tr>
				</TABLE>
			</FORM>
		</div>

	<div id="navAlpha">
		Please enter your details.
		<%if(message.length() > 0) { %><strong><%=message %></strong><%} %>
	</div>

	<div id="navBeta">
		
	</div>

	</BODY>
</HTML>
