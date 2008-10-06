<%@page errorPage="errorPage.jsp" %>
<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>
<%
HttpSession s = request.getSession(true);

//a user doesnt need to log in to view this page
//a container for the users information
User user = null;
if(s.getAttribute("signedin") != null ) {
	user = (User)s.getAttribute("user");
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>About Us</title>
	<style type="text/css" media="screen">@import "TwoColumnLayout.css";</style>
	<%@include file="include/javascriptincludes.html" %>
</head>
<body>
	<%@ include file="heading.html" %>

	<DIV class="Content" id="Content">
		<h2 class="title" id="title">Frequently Asked Questions</h2>
		<br /><br />
		<h2>and their answers:</h2>
		<div class="Box" id="Box">
			<p>

Que: How can I register with this site?
Ans: There are two ways you can do this -
1. OpenId Registration
You may use an any OpenId account to register with our site. To do this simply enter your OpenId account
in the text box with the OpenId sign beside it in the left menu and you will be taken to the appropriate OpenId provider's 
website where you can validate your account by entering your password. Once  you are signed in there you will be 
redirected to our website. If you have not previously registered with use you will be taken to the registration form where 
you can choose your username, enter an email address and other details required.
<br/><br/>
You can also register with our site using a username and password. For that just click on the "Register here" link, enter the relevant details and
you are ready to go! An email will be sent to you informing you of the success of your registration.
<br/><br/>
How can I change my email address or other details?
Click on the Edit Details link in the menu on the left. you will be taken to your account page. Here you can change the details you want
to such as email address and phone number. 
<br/><br/>
How can I offer a ride?
Once you are logged into the site you can click on the Offer a Ride link on the menu in the left. There you can specify the departure and 
arrival address, the departure time and date, the numbre of seats that are available and anything else that needs to be mentioned.
Clicking View Map will open up a Google Mao in a new window and clicking on Confirm will add the ride to the system. Once you ahve
clicked Confirm you will be taken to a page that asks you if you want to add the ride as an event in your Google Calendar.
Clicking on Add to Google Calendar a new window will open where you can log into your Gmail account and add the ride to your
Google Calendar.
<br/><br/>
How can I find rides?
You can click on the Find A Ride link. Clicking on Show All Rides will show you all tje current rides on offer. 
When you search for a ride all your parameters will be searched for on an  OR basis to maximise search results. So 
specifyinh a street from and user will mean rides that match either criteria will get displayed. Additionally when you 
select a street to search all rides near that street are displayed as well.
<br/><br/>
Why won't the Google Map display correctly for me?
<br/><br/>
Why won't the site log me in?
-cookies stuff?
<br/><br/>
What browsers is this site compaitibe with?
<br/><br/>
Why is this site restricted to only Palmerston North streets?
Currently we are testing oue site within PN only. If this site is successful in PN theren we will
consider expanding it forst to regions in Manawati and then perhaps throughout NZ.
<br/><br/>
What is the social score for?
To help the community recognise how much a member contributes and if they are trustworthy enough,
<br/><br/>

How do I accept a ride? What os with the whole waiting for an acceptance thing?
</p>
		</div>
		<br /> <br /> <br />
<%
if (user != null) { 		//depending if the user is logged in or not different link should be displayed
%> 
	<p>-- <a href="welcome.jsp">Home</a> --</p>	
<%
} else { 
%>
	<p>-- <a href="index.jsp">Back to Login Page</a> --</p>	
<%
} 
%>
		</DIV>

<%
if (user != null) { 		//depending if the user is logged in or not different side menus should be displayed
%> 
	<jsp:include page="leftMenu.html" flush="false" />
<%
} else { 
%>
	<jsp:include page="leftMenuLogin.html" flush="false" />
<%
} 
%>

</body>
</html>