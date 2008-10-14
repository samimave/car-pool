<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>
<%@page import="java.io.ObjectOutputStream"%>
<%
HttpSession s = request.getSession(true);

int timeout = s.getMaxInactiveInterval();
String message = null;
boolean error = request.getParameter("error") != null;
if( error) {
	message = request.getParameter("error");			//if we are passed an error message display it on the page
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE> The Car Pool </TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<%@include file="include/javascriptincludes.html" %>
<script>
//validation rules 
//NOTE: I dont think this actually works because we are importing the forms to the page
var oid_login_rules = new Array();
oid_login_rules[0] = 'openid_url|required';

var norm_login_rules = new Array();
norm_login_rules[0] = 'username|required';
norm_login_rules[1] = 'userpass|required';
</script>
	</HEAD>
	<BODY onload="yav.init('openid_identifier', oid_login_rules); yav.init('passwordlogin', norm_login_rules);">

	<%@ include file="heading.html" %>

	<DIV id="Content" class="Content">
		<%if(error) { %><p><strong><%=message %></strong></p><%} %>
		<h2 class="title" id="title">Please Log In</h2>
		<br /><br />
		<h2>Options Available Without Logging In:</h2>
		<div class="Box" id="Box">
			<p>To see what rides we have available <a href="<%=response.encodeURL("searchRides.jsp") %>">click here</a>.</p>
			<p>To find out more about our website and what we offer <a href=<%=response.encodeURL("about.jsp")%>>click here</a>.</p>
		</div>
	</DIV>

	<jsp:include page="leftMenuLogin.jsp" flush="false"/>

	</BODY>
</HTML>

