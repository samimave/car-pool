<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="car.pool.user.*" %>
<%
HttpSession s = request.getSession(false);

//force the user to login to view the page
//a container for the users information
User user = null;
if(s.getAttribute("signedin") != null ) {
	user = (User)s.getAttribute("user");
} else {
	response.sendRedirect(request.getContextPath());
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<style type="text/css" media="screen">@import "TwoColumnLayout.css";</style>
		<title>User Details Updated</title>
		<%@include file="include/javascriptincludes.html" %>
	</head>
	<body>
		<div class="Content" id="Content">
			Your details have been updated successfully, thank you.
		</div>

	<%@ include file="leftMenu.html" %>

	</body>
</html>