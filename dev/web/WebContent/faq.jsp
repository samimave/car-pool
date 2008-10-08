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

<h2>How can I register with this site?</h2>
1. OpenId Registration<br/>
You may use an any OpenId account to register with our site. To do this enter your OpenId account
in the text box with the OpenId sign beside it (located in the left menu) and you will be taken to the appropriate OpenId provider's 
website where you can validate your account by entering your password. Once  you are signed in there you will be 
redirected to our website. If you have not previously registered with us you will be taken to the registration form where 
you can choose your username, enter an email address and other details required.
<br/>
2. Username & Password<br/>
You can also register with our site using a username and password. For that just click on the --Register here-- link located in the left menu, enter the relevant details and
you are ready to go! An email will be sent to you informing you of the success of your registration.
<br/><br/>
<h2>How can I change my email address or other details?</h2>
When you are logged in click on the --Edit Details-- link in the menu on the left. You will be taken to your account page. Here you can change the details you want
to such as email address and phone number. You can attach an OpenID with your account. You can attach another OpenID if you already have an existing one. 
<br/><br/>
<h2>How can I offer a ride?</h2>
Once you are logged into the site you can click on the --Offer a Ride-- link on the menu in the left. You will be taken to the appropriate page where you can specify 
the departure and arrival addresses, the departure date, time and approximate time you think the trip will take, the number of seats you have available and anything else that needs to be mentioned.
Clicking --View Map-- will open up a Google Map in a new window. This map will show you a route between the arrival and departure points. Clicking on --Confirm Ride Offer-- will add the ride to the system. 
Once you have clicked --Confirm Ride Offer-- you will be taken to a page that gives you the option of adding the ride as an event in your Google Calendar.
Clicking on Add to Google Calendar. If you click on --Add to your Google Calendar-- a new window will open where you can log into your Gmail account and add the ride to your
Google Calendar. 
<br/><br/>
<h2>Some users have registered interest in my ride. What should I do?</h2>
When a member is interested in your ride they will mention the place they will like to be 
picked up from. You can see a list of the users interested in your ride through your account page
by click on the --Manage Ride & Riders-- link for a particular ride. On the ride's page you will be able to see a table of
the users who are awaiting your approval. Depending on if you can pick them up from the location they have mentioned
and if you trust them you can confirm or reject a user. If you confirm a user then this user will move to the list 
of users approved for that ride.<br/><br/>
<h2>How can I find rides?</h2>
You can click on the --Find a Ride-- link in the menu on the left. Clicking on --Show All Rides-- will show you all the current rides on offer. 
---other info to be added here after Ben's search nearby rides is done---
<br/><br/>
<h2>How do I accept a ride?</h2>
After you have searched for rides. Click on the link that leads to more details of a ride that you are interested in.
There you can accept a ride by clicking on Take Ride after you have added details about where you would like to be picked up from.
It is then up to the person who offered you the ride to decide if they can indeed pick you up from that location. It is best to discuss
details on the ride page through comments before taking a ride. You will receive an email when you are accepted by the driver of the ride or
rejected.<br/><br/>
<h2>Why is this site restricted to only Palmerston North streets?</h2>
Currently we have restricted the scope of this site to within Palmerston North only. If this site is successful in Palmerston North
then we will consider expanding it first to all regions in Manawatu and then perhaps throughout New Zealand. 
<br/><br/>
<h2>I can't find the street I want...</h2>
We aim to ensure that our information about the streets is up to date. However if you know a street exists that we
do not have in our database please email us at --what email?-- and we will add it to the database as soon as we can.
<br/><br/>
<h2>How does the Social Scoring system work?</h2>
Your social score enables other members in the community to find out how reliable you are.
It depends on how many rides you have offered and how many people have taken your rides.
<br/><br/>
<h2>Why won't the Google Map display correctly for me?</h2>
This could be because your browser does not support Google Maps. Currently Google Maps should display fine on Firefox 3.0.1, Opera 9.52 and Internet Explorer 8.
<br/><br/>
<h2>Why won't the site let me log in?</h2>
Are you sure you have cookies enabled? This site requires cookies to be enabled.
<br/><br/>
<h2>What browsers is this site compatible with?</h2>
This site should work well on Firefox 3.0.1, Opera 9.52 and Internet Explorer 8. You can also use this site through other browsers
such as Internet Explorer 7 however Google Maps may not work well with them.
<br/><br/>
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