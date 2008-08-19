<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*, car.pool.user.*" %>

<%
HttpSession s = request.getSession(true);

//to show who is logged in
String message = "Please log in.";
/*if (OpenIdFilter.getCurrentUser(s) != null ) {
	message = "Logged in as "+OpenIdFilter.getCurrentUser(s);
} else*/ if(  session.getAttribute("signedin") != null ) {
	message = "Logged in as " + ((User)session.getAttribute("user")).getUserName();
}

if (request.getParameter("del") != null) {
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
				window.location = "/Car_Pool_Project/index.jsp?del=yes";
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
		<%//if (OpenIdFilter.getCurrentUser(s) != null) { %>
			<%//message %> <br />
		<%/*} else*/ if(  session.getAttribute("signedin") != null ) { %>
			<%=message %>
		<%} else { %>
			<%=message %>
			<form name="passwordlogin" action="welcome.jsp" action="post">
				<input type="hidden" name="normal_signin" value="true">
				<input type="text" name="username"/><br/>
				<input type="password"name="userpass"/><br/>
				<input type="submit" value="Login"/>
			</form>
		<%} %>
		<a onclick="confirmation()">DANGEROUS!<br />DO NOT CLICK!</a>
	</DIV>

	<DIV id="navBeta">
		<FORM class="login" name="openid_identifier" action="welcome.jsp" method="post">
			<p><INPUT type="hidden" name="signin" value="true"/>Your OpenId: <br />
			   <INPUT type="text" name="openid_url" id="openid_url" size="18"/>
			   <INPUT type="submit" value="Login"/></p>
			<a href="register.jsp">Sign up</a>
		</FORM>
	</DIV>
		
	</BODY>
</HTML>

