<%@page import="java.util.*, java.text.*" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter" %>

<%
String user = OpenIdFilter.getCurrentUser(session);
Date rnow = new Date();
String rtime = DateFormat.getTimeInstance(DateFormat.SHORT).format(rnow);
String rdate = DateFormat.getDateInstance().format(rnow);
%>

<div id="navBeta">
	Hi &lt;<%= user %>&gt;!
	Your current social score is: &lt;integer?&gt;.
	<p> <%= rtime %> <%= rdate %></p>

</div>