<%@page errorPage="errorPage.jsp" %>
<?xml version="1.0" encoding="US-ASCII" ?>
<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<%
if(request.getParameter("username") == null || request.getParameter("userpass") == null) {
	response.sendRedirect(request.getContextPath());
} else {
	String username = request.getParameter("username");
	String userpass = request.getParameter("userpass");
	if(!username.toLowerCase().startsWith("admin") && !userpass.equals("12weak34")) {
		response.sendRedirect(request.getContextPath());
	}
}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII" />
		<title>Administrator Registration</title>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<%@include file="include/javascriptincludes.html" %>
	</head>
	<body>
		<%@ include file="heading.html" %>
		
		<div class="Content" id="Content">
			
		</div>
		
		<div class="Menu" id="Menu">
			<p><a href="<%=response.encodeURL("welcome.jsp")%>"> <img class="logo" border="0" src="images/Car Pool 6 75.bmp" width="263" height="158"> </a></p> <br />
			Please enter your details.
		</div>
	</body>
</html>