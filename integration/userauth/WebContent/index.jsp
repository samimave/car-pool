<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page import="org.verisign.joid.consumer.OpenIdFilter" %>

<%
HttpSession s = request.getSession(true);
String message = "Please log in.";
if (OpenIdFilter.getCurrentUser(s) != null) {
	message = "Logged in as "+OpenIdFilter.getCurrentUser(s);
}
%>

<HTML>
	<HEAD>
		<TITLE> The Car Pool </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="content">
			<h5 align="center">Welcome to The Car Pool</h5>
			<p>Please log in.</p>
		</DIV>

	<DIV id="navAlpha">
		<%=message %>
	</DIV>

	<DIV id="navBeta">
		<FORM class="login" name="openid_identifier" action="welcome.jsp" method="post">
			<p><INPUT type="hidden" name="signin" value="true"/>Your OpenId: <br />
			   <INPUT type="text" name="openid_url" id="openid_url" size="18"/>
			   <INPUT type="submit" value="Login"/></p>
			<a href="register.jsp">Sign up</a>
		</FORM>
	</DIV>
		
	</BODY>
</HTML>

