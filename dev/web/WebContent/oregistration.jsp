<%@ page errorPage="errorPage.jsp" %>
<%@ page contentType="text/html; charset=ISO-8859-1"%>
<%@ page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.user.authentication.servlet.HtmlUtils"%>
<%
HttpSession s = request.getSession(true);
String message = "";
if(request.getAttribute("error") != null) {
	message = (String)request.getAttribute("error");
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<TITLE>Sign Up for The Car Pool!</TITLE>
<style type="text/css" media="screen">@import "TwoColumnLayout.css";</style>
<%@include file="include/javascriptincludes.html" %>
</HEAD>
<BODY>
	<%@ include file="heading.html" %>
	
	<div class="Content" id="Content">
	<%if(OpenIdFilter.getCurrentUser(s) != null) { 
		if(message.length() > 0) { %><strong><%=message %></strong><%} %>
		<h1>Register yourself by filling in your details below</h1>
		<FORM name="register" id="register" onsubmit="return (formCookieCheck() && openidRegisterFormValidation(this) && isUserNameAvailable())" action="oadduser" method="post">
			<TABLE class="register"> 
				<tr> <td>UserName:</td> <td><INPUT type="text" name="userName"/></td> <td><a href="#" onclick="checkUserNameAvailable()">Check Availability</a><b id="availableoutput"></b></td>
				<tr> <td>Email:</td> <td><INPUT type="text" name="email"/></td> </tr>
				<tr> <td>Phone:</td> <td><INPUT type="text" name="phone"/></td> </tr>
				<tr> <td>&nbsp;</td><td><img src="blurredimage" width="200" height="100"/></td> </tr>
				<tr> <td>Type in the characters in the image above</td><td><input type="text" name="verifytext"/></td> </tr>
				<tr> <td>&nbsp;</td> <td><INPUT type="submit" value="Register"/></td> </tr>
			</TABLE>
		</FORM>
	<%} else { %>
		<h1>Please Authenticate yourself using OpenId</h1>
			<%=HtmlUtils.generateSigninForm("openidlogin", "post") %>
	<%} %>
	</div>

	<div class="Menu" id="Menu">
		<p><a href="welcome.jsp"> <img class="logo" border="0" src="Car Pool 6 75.bmp" width="263" height="158"> </a></p> <br />
		<%if(message.length() > 0) { %><strong><%=message %></strong><%} %>
		Please enter your details.
	</div>

</BODY>
</HTML>