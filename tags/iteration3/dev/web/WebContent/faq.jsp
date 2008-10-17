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
	<title>FAQs</title>
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
			
<ul>
<li><a href="#register">How can I register with this site?</a></li>
<li><a href="#editUser">How can I change my email address or other details?</a></li>
<li><a href="#offerRide">How can I offer a ride?</a></li>
<li><a href="#interestRide">Some users have registered interest in my ride. What should I do?</a></li>
<li><a href="#findRide">How can I find rides?</a></li>
<li><a href="#acceptRide">How do I accept a ride?</a></li>
<li><a href="#pn">Why is this site restricted to only Palmerston North streets?</a></li>
<li><a href="#noStreet">I can't find the street I want...</a></li>
<li><a href="#tooManyStreet">When I search by streets other locations turn up as well.</a></li>
<li><a href="#social">How does the Social Scoring system work?</a></li>
<li><a href="#openid">What's all this fuss about OpenId?</a></li>
<li><a href="#map">Why won't the Google Map display correctly for me?</a></li>
<li><a href="#browser">What browsers is this site compatible with?</a></li>
</ul>
-----------------------------------------------------------------------------------------------------------------------
<br/><br/>
<h2><a name="register"> How can I register with this site?</a></h2>
<ol>
<li><h3>OpenId Registration</h3></li>
<p>You may use an OpenId account to register with our site. To do this enter your OpenId account
in the text box with the OpenId sign beside it (located in the left menu) and you will be taken to the appropriate OpenId provider's 
website where you can validate your account by entering your password. Once  you are signed in there you will be 
redirected to our website. If you have not previously registered with us you will be taken to the registration form where 
you can choose your username, enter an email address and other details required.</p>
<br />
<li><h3>Username & Password</h3></li>
<p>You can also register with our site using a username and password. For that just click on the --Register here-- link located in the left menu, enter the relevant details and
you are ready to go! An email will be sent to you informing you of the success of your registration. After registering if you choose to switch to OpenId you can add
an OpenId to your account through the --<a href="<%=response.encodeURL("myDetails.jsp") %>">Edit Details</a>-- link on the left</p>
</ol>

<h2><a name="editUser">How can I change my email address or other details?</a></h2>
<p>When you are logged in click on the --<a href="<%=response.encodeURL("myDetails.jsp") %>">Edit Details</a>-- link in the menu on the left to be taken to your account page. Here you can change your account information
such as email address and phone number. You can attach also choose to add an OpenId with your account (or another if you already have one).</p> 
<br/><br/>

<h2><a name="offerRide">How can I offer a ride?</a></h2>
<p>Once you are logged into the site you can click on the --<a href="<%=response.encodeURL("addARide.jsp") %>">Offer A Ride</a>-- link on the menu in the left. You will be taken to the appropriate page where you can specify 
the departure and arrival addresses, the departure date, time and approximate time you think the trip will take, the number of seats you have available and anything else that needs to be mentioned.
Clicking --View Map-- will open up a Google Map in a new window. This map will show you a route between the arrival and departure points. Clicking on --Confirm Ride Offer-- will add the ride to the system. 
Once you have clicked --Confirm Ride Offer-- you will be taken to a page that gives you the option of adding the ride as an event in your Google Calendar.
Clicking on Add to Google Calendar. If you click on --Add to your Google Calendar-- a new window will open where you can log into your Gmail account and add the ride to your Google Calendar.</p> 
<br/><br/>

<h2><a name="interestRide">Some users have registered interest in my ride. What should I do?</a></h2>
<p>When a member is interested in your ride they will mention the place they will like to be 
picked up from. You can see a list of the users interested in your ride through your account page
by click on the --Manage Ride & Riders-- link for a particular ride. On the ride's page you will be able to see a table of
the users who are awaiting your approval. Depending on if you can pick them up from the location they have mentioned
and if you trust them you can confirm or reject a user. If you confirm a user then this user will move to the list 
of users approved for that ride.</p>
<br/><br/>

<h2><a name="findRide">How can I find rides?</a></h2>
<p>You can click on the --<a href="<%=response.encodeURL("searchRides.jsp") %>">Search Rides</a>-- link in the menu on the left. You will be directed to a page where you can choose 
--<a href="<%=response.encodeURL("resultall.jsp") %>">Show All Rides</a>-- will show you all the current rides on offer. You can also search using criteria such as date, username and locations.</p>
<br/><br/>

<h2><a name="acceptRide">How do I accept a ride?</a></h2>
<p>After you have searched for rides. Click on the link that leads to more details of a ride that you are interested in.
There you can accept a ride by clicking on Register Interest for Ride after you have added details about where you would like to be picked up from.
It is then up to the person who offered you the ride to decide if they can indeed pick you up from that location. It is best to discuss
details on the ride page through comments before taking a ride. You will receive an email when you are accepted by the driver of the ride or
rejected.</p>
<br/><br/>

<h2><a name="pn">Why is this site restricted to only Palmerston North streets?</a></h2>
<p>Currently we have restricted the scope of this site to within Palmerston North only. If this site is successful in Palmerston North
then we will consider expanding it first to all regions in Manawatu and then perhaps throughout New Zealand.</p> 
<br/><br/>

<h2><a name="noStreet">I can't find the street I want...</a></h2>
<p>We aim to ensure that our information about the streets is up to date. However if you know a street exists that we
do not have in our database please email us at carpoolproject@gmail.com and we will add it to the database as soon as we can.</p>
<br/><br/>

<h2><a name="tooManyStreet">When I search by streets other locations turn up as well.</a></h2>
<p>Our site uses a cunning and intricately complicated ride path projection system to figure out the routes taken by drivers and to
display the rides to you if they will pass by your origin and/or destination. This allows for a much more efficient car to passenger
ratio and if someone is passing by why not get them pick you up? Thats what we are all about after all.</p>
<br/><br/>

<h2><a name="social">How does the Social Scoring system work?</a></h2>
<p>Your social score enables other members in the community to find out how reliable you are.
It depends on how many rides you have offered, how many people you have confirmed for your ride and the rating those riders give you.</p>
<br/><br/>

<h2><a name="openid">What's all this fuss about OpenId?</a></h2>
<p><img src="images/login-bg.gif" width="16" height="16"/> The <a href="http://openid.net/" target="_blank">OpenId</a> site can explain better than we ever could.</p>
<br/><br/>

<h2><a name="map">Why won't the Google Map display correctly for me?</a></h2>
<p>This could be because your browser does not support Google Maps. Currently Google Maps should display fine on Firefox 3.0.1, Opera 9.52 and Internet Explorer 8.</p>
<br/><br/>

<h2><a name="browser">What browsers is this site compatible with?</a></h2>
<p>This site should work well on Firefox 3.0.1, Opera 9.52 and Internet Explorer 8. This site is compatable with other browsers
such as Internet Explorer 7 and older however Google Maps may not work well with them.</p>
<br/><br/>

		</div>
		<br /> <br /> <br />
<%
if (user != null) { 		//depending if the user is logged in or not different link should be displayed
%> 
	<p>-- <a href="<%=response.encodeURL("welcome.jsp")%>">Home</a> --</p>	
<%
} else { 
%>
	<p>-- <a href="<%=response.encodeURL("index.jsp")%>">Back to Login Page</a> --</p>	
<%
} 
%>
		</DIV>

<%
if (user != null) { 		//depending if the user is logged in or not different side menus should be displayed
%> 
	<jsp:include page="leftMenu.jsp" flush="false" />
<%
} else { 
%>
	<jsp:include page="leftMenuLogin.jsp" flush="false" />
<%
} 
%>

</body>
</html>