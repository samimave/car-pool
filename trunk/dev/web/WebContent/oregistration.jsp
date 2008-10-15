<%@ page errorPage="errorPage.jsp" %>
<%@ page contentType="text/html; charset=ISO-8859-1"%>
<%@ page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.user.authentication.servlet.HtmlUtils, java.util.*,car.pool.user.registration.RandomTextGenerator"%>
<%
HttpSession s = request.getSession(true);
String message = "";
if(request.getParameter("error") != null) {
	message = request.getParameter("error");
}
RandomTextGenerator generator = new RandomTextGenerator();
Random r = new Random();
Integer pos = r.nextInt(generator.size());
s.setAttribute("quote_pos", pos);								//set the number of the displayed quote text as a session attribute
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE>Sign Up for The Car Pool!</TITLE>
		<style type="text/css" media="screen">@import "TwoColumnLayout.css";</style>
		<%@include file="include/javascriptincludes.html" %>
		<script>
		function checkOnSubmit(formName, r) {
			if (isUserNameAvailable()) {
				if (yav.performCheck(formName, r, 'inline')) {
					return true;
				}
			} else {
				alert('Username already taken, please enter another');
			}
			return false;
		}
		
		var rules=new Array();
		rules[0]='userName|required';
		rules[1]='phone|numeric';
		rules[2]='email|required';
		rules[3]='email|email';
		rules[4]='verifytext:image text|required';
		
		//yav.addHelp('userName', 'Provide your username');
		//yav.addHelp('phone', 'Provide a contact phone number');
		//yav.addHelp('email', 'Provide your e-mail');
		//yav.addHelp('verifytext', 'Enter the text shown above');
		</script>
	</HEAD>
	<BODY onload="yav.init('register', rules);">
		<%@ include file="heading.html" %>
	
		<div class="Content" id="Content">
		<%if(OpenIdFilter.getCurrentUser(s) != null) { 
			if(message.length() > 0) { %><strong><%=message %></strong><%} %>
			<h2 class="title" id="title">Sign Up for The Car Pool</h2>
			<br /><br />
			<h2>Please Enter Your Details:</h2>
			<div class="Box" id="Box">
				<p>Note: * indicates a required field.</p><br />
				<FORM name="register" id="register" onsubmit="return checkOnSubmit('register', rules);" action="oadduser" method="post">
					<TABLE class="register"> 
						<tr> <td>UserName*:</td> <td><INPUT type="text" name="userName"/>&nbsp;&nbsp;<span id=errorsDiv_userName></span></td> </tr>
						<tr> <td>Email*:</td> <td><INPUT type="text" name="email"/>&nbsp;&nbsp;<span id=errorsDiv_email></span></td> </tr>
						<tr> <td>Phone:</td> <td><INPUT type="text" name="phone"/>&nbsp;&nbsp;<span id=errorsDiv_phone></span></td> </tr>
						<tr> <td colspan="2"><img src="blurredimage" width="200" height="100"/></td> </tr>
					<tr> <td>Enter the characters shown above:</td><td><input type="text" name="verifytext"/>&nbsp;&nbsp;<span id=errorsDiv_verifytext></span></td> </tr>
				</TABLE>
				<br />
				<p>Click here to <INPUT type="submit" value="Register"/></p>
			</FORM>
			</div>
		<%} else { %>
			<h1>Please Authenticate yourself using OpenId</h1>
				<%=HtmlUtils.generateSigninForm("openidlogin", "post") %>
		<%} %>
		</div>
	
		<div class="Menu" id="Menu">
			<p><a href="welcome.jsp"> <img class="logo" border="0" src="images/Car Pool 6 75.bmp" width="263" height="158"> </a></p> <br />
			<%if(message.length() > 0) { %><strong><%=message %></strong><%} %>
			Please enter your details.
		</div>
	
	</BODY>
</HTML>