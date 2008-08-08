<%@page import="java.util.*, java.text.*" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter" %>

<%
String user = OpenIdFilter.getCurrentUser(session);
Date rnow = new Date();
String rtime = DateFormat.getTimeInstance(DateFormat.SHORT).format(rnow);
String rdate = DateFormat.getDateInstance().format(rnow);
%>

<DIV id="navBeta">
	Hi <%= user %>
	Your current social score is: &lt;integer?&gt;.
	<p> <%= rtime %> <%= rdate %></p>
		
</DIV>