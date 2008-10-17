<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page import="car.pool.persistance.*, car.pool.user.registration.RandomTextGenerator, java.util.Random"%>

<%
HttpSession s = request.getSession(true);
String message = "";
if(request.getParameter("error") != null) {
	message = request.getParameter("error");
}
RandomTextGenerator generator = new RandomTextGenerator();
Random r = new Random();
Integer pos = r.nextInt(generator.size());					//set the number of the displayed quote text as a session attribute
s.setAttribute("quote_pos", pos);
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
			}
			return false;
		}
		
		var rules=new Array();
		rules[0]='userName|required';
		rules[1]='password|required';
		rules[2]='password2:Confirmed password|equal|$password';
		rules[3]='phone|numeric';
		rules[4]='email|required';
		rules[5]='email|email';
		rules[6]='verifytext:image text|required';
		
		//yav.addHelp('userName', 'Provide your username');
		//yav.addHelp('password', 'Provide your password');
		//yav.addHelp('password2', 'Confirm your password');
		//yav.addHelp('phone', 'Provide a contact phone number');
		//yav.addHelp('email', 'Provide your e-mail');
		//yav.addHelp('verifytext', 'Enter the text shown above');
		</script>
	</HEAD>
	<BODY onload="yav.init('register', rules);">

	<%@ include file="heading.html" %>	

		<div class="Content" id="Content">
			<%if(message.length() > 0) { %><strong><%=message %></strong><%} %>
			<h2 class="title" id="title">Sign Up for The Car Pool</h2>
			<br /><br />
			<h2>Please Enter Your Details:</h2>
			<div class="Box" id="Box">
			<p>Note: * indicates a required field.</p><br />
			<FORM name="register" id="register" onsubmit="return checkOnSubmit('register', rules);" method="post" action="<%=response.encodeURL("adduser")%>">
				<TABLE class="register">
					<tr> <td>User name*:</td> <td><INPUT type="text" name="userName" size="25"/>&nbsp;&nbsp;<span id=errorsDiv_userName></span></td> </tr>
					<tr> <td>Password*:</td> <td><INPUT type="password" name="password" size="25"/>&nbsp;&nbsp;<span id=errorsDiv_password></span></td> </tr>
					<tr> <td>Confirm password*:</td> <td><INPUT type="password" name="password2" size="25"/>&nbsp;&nbsp;<span id=errorsDiv_password2></span></td> </tr>
					<tr> <td>Email address*:</td> <td><INPUT type="text" name="email" size="25"/>&nbsp;&nbsp;<span id=errorsDiv_email></span></td> </tr>			
					<tr> <td>Phone Number:</td> <td><INPUT type="text" name="phone" size="25"/>&nbsp;&nbsp;<span id=errorsDiv_phone></span></td> </tr>
					<tr> <td colspan="2"><img src="<%=response.encodeURL("blurredimage") %>" width="200" height="100"/></td> </tr>
					<tr> <td>Enter the characters shown above*:</td><td><input type="text" name="verifytext"/>&nbsp;&nbsp;<span id=errorsDiv_verifytext></span></td> </tr>
				</TABLE>
			<br />
			<p>Click here to <INPUT type="submit" value="Register"/></p>
			</FORM>
			</div>
		</div>

	<div class="Menu" id="Menu">
		<p><a href="welcome.jsp"> <img class="logo" border="0" src="images/Car Pool 6 75.bmp" width="263" height="158"> </a></p> <br />
		Please enter your details.
		<%if(message.length() > 0) { %><strong><%=message %></strong><%} %>
	</div>

	</BODY>
</HTML>
