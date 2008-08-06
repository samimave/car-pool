<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter" %>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(session) == null) {
	response.sendRedirect("/index.jsp");
}
%>

<HTML>
	<HEAD>
		<TITLE> Ride Successfully Added! </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="content">
			<p>Thank you for adding a ride from <%= request.getParameter("from1") %>, to <%= request.getParameter("to1") %>;  
			scheduled for <%= request.getParameter("time1") %> <%= request.getParameter("date1") %>. </p>
			<FORM action="addRideEvent.jsp" method="post">
            <INPUT type="hidden" name="from" value="<%=request.getParameter("from1") %>">
			<INPUT type="hidden" name="to" value="<%=request.getParameter("to1") %>">
			<INPUT type="hidden" name="stime" value="<%=request.getParameter("time1") %>">
			<INPUT type="hidden" name="etime" value="<%=request.getParameter("time2") %>">
			<INPUT type="hidden" name="date" value="<%=request.getParameter("date1") %>">
			<INPUT type="submit" value="Add to Google Calendar" />
			</FORM>
		</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>