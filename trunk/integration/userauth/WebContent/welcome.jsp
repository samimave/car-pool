<%@page import="org.verisign.joid.consumer.OpenIdFilter" %>
<%@page import="org.verisign.joid.util.UrlUtils" %>
<%@page import="org.verisign.joid.OpenIdException" %>

<%@page contentType="text/html; charset=ISO-8859-1" %>

<%
//HttpSession s = request.getSession(false);
//String uname = request.getParameter("user");
//session.setAttribute("username",uname);
%>

<html>
	<head>
		<title> Welcome to The Car Pool </title>
		<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>
	</head>
	<body>

	<%@ include file="heading.html" %>
	<%  if(request.getParameter("signin") != null) {
			try {
				StringBuffer returnTo = new StringBuffer(UrlUtils.getBaseUrl(request));
				returnTo.append(request.getServletPath());
				String id = request.getParameter("openid_url");
				if (!id.startsWith("http:")) {
					id = "http://" + id;
				}
				String trustRoot = UrlUtils.getBaseUrl(request);
				
				String str = OpenIdFilter.joid().getAuthUrl(id, returnTo.toString(), trustRoot);
				response.sendRedirect(str);
			} catch (OpenIdException e) {
				StringBuffer buff = new StringBuffer();
				buff.append(request.getContextPath());
				buff.append("/index.jsp");
				
				response.sendRedirect(buff.toString());
			}
		} else {
			String loggedInAs = OpenIdFilter.getCurrentUser(session);
			if( loggedInAs == null  && request.getParameter(OpenIdFilter.OPENID_ATTRIBUTE) != null) {
				session.setAttribute(OpenIdFilter.OPENID_IDENTITY, request.getParameter(OpenIdFilter.OPENID_IDENTITY));
				loggedInAs = OpenIdFilter.getCurrentUser(request.getSession());
			}
			if(loggedInAs != null) {%>
		<div class="content">
			<h5 align="center">Welcome to The Car Pool <%=OpenIdFilter.getCurrentUser(request.getSession())%></h5>
			<p>Eventually the person's upcoming rides will be displayed here.</p>
			<a href="index.jsp?logout=yes">Logout</a>
		</div>		
			<%} else {
				StringBuffer buff = new StringBuffer();
				buff.append(request.getContextPath());
				buff.append("/index.jsp");
				response.sendRedirect(buff.toString());
			}
		}%>
		

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</body>
</html>

