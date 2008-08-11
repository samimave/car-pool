<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, org.verisign.joid.util.UrlUtils, org.verisign.joid.OpenIdException, car.pool.persistance.*" %>

<%
//code to validate user's openID
	if (request.getParameter("signin") != null) {
		try {
			StringBuffer returnTo = new StringBuffer(UrlUtils
					.getBaseUrl(request));
			returnTo.append(request.getServletPath());
			String id = request.getParameter("openid_url");
			if (!id.startsWith("http:")) {
				id = "http://" + id;
			}
			String trustRoot = UrlUtils.getBaseUrl(request);

			String str = OpenIdFilter.joid().getAuthUrl(id,
					returnTo.toString(), trustRoot);
			response.sendRedirect(str);
		} catch (OpenIdException e) {
			StringBuffer buff = new StringBuffer();
			buff.append(request.getContextPath());
			buff.append("/index.jsp");

			response.sendRedirect(buff.toString());
		}
	} else {
		String loggedInAs = OpenIdFilter.getCurrentUser(request.getSession());
		if (loggedInAs == null
				&& request.getParameter(OpenIdFilter.OPENID_ATTRIBUTE) != null) {
			session.setAttribute(OpenIdFilter.OPENID_IDENTITY, request
					.getParameter(OpenIdFilter.OPENID_IDENTITY));
			loggedInAs = OpenIdFilter.getCurrentUser(request
					.getSession());
		}
		if (loggedInAs != null) {
		} else {
			StringBuffer buff = new StringBuffer();
			buff.append(request.getContextPath());
			buff.append("/index.jsp");
			response.sendRedirect(buff.toString());
		}
	}

//being nice to our users
String message = "";
if (request.getParameter("sThx") != null) {
	message += "<p> Thanks for signing up! </p>";
}

//code to allow interaction with db
CarPoolStore cps = new CarPoolStoreImpl();
RideListing rl = cps.getRideListing();
int currentUser = cps.getUserIdByURL(OpenIdFilter.getCurrentUser(request.getSession()));

//code to add user to the db
if (request.getParameter("newUser") != null) {
	cps.addUser((String)request.getParameter("openid_url"),(String)request.getParameter("userName"),(String)request.getParameter("email"),(String)request.getParameter("phone"));
}

//code to add a ride to the user's selected rides
if (request.getParameter("rideselect") != null) {
	int rideID = Integer.parseInt(request.getParameter("rideselect"));
	while (rl.next()) {
		if (rideID == rl.getRideID()) {
			cps.takeRide(currentUser,rideID);
			message += "<p>You have booked a ride from: "+rl.getStartLocation()+", to: "+rl.getEndLocation()+", on "+rl.getRideDate()+".</p>";
		}
	}
}
%>

<HTML>
	<HEAD>
		<TITLE> Welcome to The Car Pool </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

	<DIV class="content">
		<h2 align="center">Welcome to The Car Pool <%=OpenIdFilter.getCurrentUser(request.getSession())%></h2>
		<%=message %>
		<p>Eventually the person's upcoming rides will be displayed here.</p>
	</DIV>		

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>

