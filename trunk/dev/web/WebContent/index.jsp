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

	<DIV id="navBeta">
		Log in via OpenId:
		<FORM class="login" name="openid_identifier" action="openidlogin" method="post">
			<INPUT type="hidden" name="openid_signin" value="true"/>
				<table class="login" border="0">
			   		<tr><td>OpenId:</td><td><INPUT type="text" name="openid_url" id="openid_url" size="18"/></td></tr>
			   		<tr><td></td><td align="left"><INPUT type="submit" value="Login"/></td></tr>
				</table>
		</FORM>
		Enter your OpenID and if you have not registered with our site previously and your OpenID is valid you will eventually be redirected to Registration page. <br><br>
 
		Or Log in via your username and password
		<form name="passwordlogin" action="login" method="post">
			<input type="hidden" name="normal_signin" value="true">
			<table class="login">
				<tr><td>Username</td><td><input type="text" name="username" size="18"/></td></tr>
				<tr><td>Password</td><td><input type="password"name="userpass" size="18"/></td></tr>
				<tr><td></td><td><input type="submit" value="Login"/></td></tr>
			</table>
		</form>
		Not registered and don't want to use OpenId, then <a href="register.jsp">register here</a>.
	</div>		
	</BODY>
</HTML>

