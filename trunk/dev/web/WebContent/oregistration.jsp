<%@ page language="java" contentType="text/html; charset=US-ASCII" pageEncoding="US-ASCII"%>
<%@ page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.user.authentication.servlet.HtmlUtils"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<TITLE>Sign Up for The Car Pool!</TITLE>
<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>
</HEAD>
<BODY>
	<%@ include file="heading.html" %>
	
	<div class="content">
	<%if(OpenIdFilter.getCurrentUser(session) != null) { %>
		<h1>Register yourself by filling in your details below</h1>
		<FORM action="oadduser" method="post">
			<TABLE class="register"> 
				<tr> <td>UserName:</td> <td><INPUT type="text" name="userName"/></td> <td><a href="#">Check Availability</a></td>
				<tr> <td>Email:</td> <td><INPUT type="text" name="email"/></td> </tr>
				<tr> <td>Phone:</td> <td><INPUT type="text" name="phone"/></td> </tr>
				<tr> <td>&nbsp;</td> <td><INPUT type="submit" value="Register"/></td> </tr>
			</TABLE>
		</FORM>
	<%} else { %>
		<h1>Please Authenticate yourself using OpenId</h1>
			<%=HtmlUtils.generateSigninForm("openidlogin", "post") %>
	<%} %>
	</div>

	<div id="navAlpha">
		Please enter your details.
	</div>

	<div id="navBeta">
		
	</div>

</BODY>
</HTML>