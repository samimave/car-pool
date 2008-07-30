<%@page import="java.util.*, java.text.*" %>

<%
String user = (String)session.getAttribute("username");
Date rnow = new Date();
String rtime = DateFormat.getTimeInstance(DateFormat.SHORT).format(rnow);
String rdate = DateFormat.getDateInstance().format(rnow);
%>

<div id="navBeta">
	Hi &lt;<%= user %>&gt;!
	Your current social score is: &lt;integer?&gt;.
	<p> <%= rtime %> <%= rdate %></p>

</div>