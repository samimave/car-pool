<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*, car.pool.user.*" %>
<%@page import="java.io.ObjectOutputStream"%>
<%
HttpSession s = request.getSession(true);

//to show who is logged in
String message = "Please log in.";
/*if (OpenIdFilter.getCurrentUser(s) != null ) {
	message = "Logged in as "+OpenIdFilter.getCurrentUser(s);
} else*/ if(  session.getAttribute("signedin") != null ) {
	User user = ((User)session.getAttribute("user"));
	message = "Logged in as " + user.getUserName();
	message += " " + user.getUserId();
}

//will delete the current database
if (request.getParameter("delete") != null) {
	CarPoolStoreImpl cps = new CarPoolStoreImpl();
	cps.removeAll("donotusethis");
}
%>


<HTML>
	<HEAD>
		<TITLE> The Car Pool </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
		<script type="text/javascript">
		function confirmation() {
			var answer = confirm("DO NOT delete the database!!!")
			if (answer){
				window.location = "/Car_Pool_Project/index.jsp?delete=yes";
			}
			else{
				alert("phew, good choice.")
			}
		}
		</script>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

	<DIV class="content">
		<h2 align="center">Welcome to The Car Pool</h2>
		<p>Please log in.</p>
	</DIV>

	<DIV id="navAlpha">
		<%if (OpenIdFilter.getCurrentUser(s) != null || session.getAttribute("signedin") != null) { %>
			<%=message %> <br />
		<%} else { %>
			<%=message %>
			
		<%} %>
		<a onclick="confirmation()">DANGEROUS!<br />DO NOT CLICK!</a>
	</DIV>

	<%@ include file="rightMenuLogin.html" %>	

	</BODY>
</HTML>

