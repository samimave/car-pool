<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, org.verisign.joid.util.UrlUtils, org.verisign.joid.OpenIdException, car.pool.persistance.*" %>

<%
//being nice to our users
String message = "";
if (request.getParameter("sThx") != null) {
	message = "<p> Thanks for signing up! </p>";
}
	
//code to add user to the db
if (request.getParameter("newUser") != null) {
	CarPoolStore cps = new CarPoolStoreImpl();
	cps.addUser((String)request.getParameter("openid_url"),(String)request.getParameter("userName"),(String)request.getParameter("email"),(String)request.getParameter("phone"));
}

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
			buff.append("/index.jsp?sThx=yes");

			response.sendRedirect(buff.toString());
		}
	} else {
		String loggedInAs = OpenIdFilter.getCurrentUser(session);
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

