<%@page import="java.util.*, java.text.*" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.user.*" %>

<%
//User user = ;
String openid = OpenIdFilter.getCurrentUser(session);
String name = "unknown";
if(session.getAttribute("signedin") != null ) {
	name = ((User)session.getAttribute("user")).getUserName()+"!";
}
Date rnow = new Date();
String rtime = DateFormat.getTimeInstance(DateFormat.SHORT).format(rnow);
String rdate = DateFormat.getDateInstance().format(rnow);
%>

<DIV id="navBeta" class="navBeta">
	Hi <%=name  %><br />
	Your current social score is: &lt;integer?&gt;.<br />
	<p> <%= rtime %> <%= rdate %></p>
</DIV>