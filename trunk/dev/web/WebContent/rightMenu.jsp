<%@page import="java.util.*, java.text.*" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.user.*" %>

<%
//User user = ;
String openid = OpenIdFilter.getCurrentUser(session);
Date rnow = new Date();
String rtime = DateFormat.getTimeInstance(DateFormat.SHORT).format(rnow);
String rdate = DateFormat.getDateInstance().format(rnow);
%>

<DIV id="navBeta">
	Hi <%= ((User)session.getAttribute("user")).getUserName() %>
	Your current social score is: &lt;integer?&gt;.
	<p> <%= rtime %> <%= rdate %></p>
		
</DIV>