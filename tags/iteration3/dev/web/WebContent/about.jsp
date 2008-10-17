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

//enable links depending on whether the user is logged in
String addMsg = "";
String regMsg = "";
if (user != null) {
	addMsg = "<a href='"+response.encodeURL("addARide.jsp")+"'>offer a ride</a>";
	regMsg = "register";
} else {
	addMsg = "offer a ride";
	regMsg = "<a href='"+response.encodeURL("register.jsp")+"'>register</a>";
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

	<div class="Content" id="Content">
		<h2 class="title" id="title">About The Car Pool</h2>
		<br /><br />
		<h2>What We Provide:</h2>
		<div class="Box" id="Box">
			<p>Carpooling is all about reducing congestion on the roads, making an effort to keep our  
				environment healthy and, yes, saving money through shared petrol costs. The Car Pool has been designed 
				to facilitate you in your carpooling efforts, and best of all it is free to use! All you need to 
				do is <%=regMsg %> with our site to get started. Going somewhere? Why not <%=addMsg %>
				so others going to the same place can share a ride with you! Want to go somewhere? Have a look at the 
				<a href="<%=response.encodeURL("searchRides.jsp")%>">rides available</a> to see if someone else is going your way so you can take a ride with them.
			</p>
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
		</div>

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