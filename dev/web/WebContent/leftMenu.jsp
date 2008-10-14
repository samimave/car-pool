<%@page import="car.pool.user.*"%>
<%
HttpSession session2 = request.getSession(true);				//get session and user info
User user2 = (User)session2.getAttribute("user");
String username = user2 != null ? user2.getUserName() : "";
%>
<DIV id="Menu" class="Menu">
	<p><a href="<%=response.encodeURL("welcome.jsp")%>"> <img class="logo" border="0" src="images/Car Pool 6 75.bmp" width="263" height="158"> </a></p> <br />

	<p><a href="<%=response.encodeURL("welcome.jsp")%>">Home</a></p> <br />

	<h2>User Account </h2>
	<p>-&gt;<a href="<%=response.encodeURL("myDetails.jsp")%>">Edit Account Details</a></p> 
	<p>-&gt;<a href="<%=response.encodeURL("myRideDetails.jsp")%>">Edit Ride Details</a></p> <br />

	<h2>New Rides</h2>
	<p>-&gt;<a href="<%=response.encodeURL("addARide.jsp")%>">Offer A Ride</a></p>
	<p>-&gt;<a href="<%=response.encodeURL("searchRides.jsp")%>">Find A Ride</a></p> <br />
	
	<h2>More Info</h2>
	<p>-&gt;<a href="<%=response.encodeURL("faq.jsp")%>">Frequently Asked Questions</a></p> 
	<p>-&gt;<a href="<%=response.encodeURL("about.jsp")%>">About Our Site</a></p><br />
	<%if(username.toLowerCase().startsWith("admin")) { %>
	<p><a href="<%=response.encodeURL("adminView.jsp")%>">Admin Tasks</a></p> <br />	
	<%} %>
	<p><a href="<%=response.encodeURL("logout.jsp")%>">Logout</a></p>
</DIV>