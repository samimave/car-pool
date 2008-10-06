
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="java.util.Formatter, org.verisign.joid.consumer.OpenIdFilter, org.verisign.joid.util.UrlUtils, org.verisign.joid.OpenIdException, car.pool.persistance.*, car.pool.user.User, car.pool.user.UserManager, car.pool.user.UserFactory, car.pool.persistance.exception.InvaildUserNamePassword,java.util.*" %>

<%
HttpSession s = request.getSession(true);

// a container for the users information
User user = null;
if(s.getAttribute("signedin") != null ) {
	user = (User)s.getAttribute("user");
} else {
	response.sendRedirect(request.getContextPath());
}

//code to allow interaction with db
CarPoolStore cps = new CarPoolStoreImpl();

//code to add user to the db
if (request.getParameter("newUser") != null) {
	cps.addUser((String)request.getParameter("openid_url"),(String)request.getParameter("userName"),(String)request.getParameter("email"),(String)request.getParameter("phone"));
}


int rideCount=0;
ArrayList<Integer> rideIDs = new ArrayList<Integer>();
RideListing rl = cps.searchRideListing(RideListing.searchUser, user.getUserName());
while (rl.next()) {
	rideIDs.add(rl.getRideID());
	rideCount++;
}

int requestCount = 0;
for (int i=0; i<rideIDs.size(); i++){
	RideDetail rd = cps.getRideDetail(rideIDs.get(i));
	while (rd.hasNext()){
		if ((rd.getUserID()!=user.getUserId())&&(rd.getConfirmed()==false)){
			requestCount++;
		}
	}
}



%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE> Welcome to The Car Pool </TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<%@include file="include/javascriptincludes.html" %>
	</HEAD>
	<BODY onload="runBrowserTests()">

	<%@ include file="heading.html" %>

	<DIV class="Content" id="Content">
		<h2>Welcome to The Car Pool,
		<%if(s.getAttribute("signedin") != null ) {%>
			<%=" "+user.getUserName()%><%//OpenIdFilter.getCurrentUser(s)%></h2>
		<%} %>
		<p>Your current social score is <%=cps.getScore((user.getUserId()))%></p>
		<p>Your have offered <%=rideCount%> rides in total so far!</p>
		<p>Your have <%=requestCount%> users awaiting approval for rides you have offered!</p>
		<p>Click  <a href=myDetails.jsp>here</a> to access your account page and approve them or edit your details.</p>
	</DIV>		

	<%@ include file="leftMenu.html" %>

	</BODY>
</HTML>

