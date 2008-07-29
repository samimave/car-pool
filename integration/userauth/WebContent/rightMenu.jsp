<%@page import="java.util.*, java.text.*" %>

<%
String user = (String)s.getAttribute("username");
%>

<div id="navBeta">
	Hi &lt;<%= user %>&gt;!
	Your current social score is: &lt;integer?&gt;.
<%
Date rnow = new Date();
String rtime = DateFormat.getTimeInstance(DateFormat.SHORT).format(rnow);
String rdate = DateFormat.getDateInstance().format(rnow);
%>
	<p> <%= rtime %> <%= rdate %></p>

</div>