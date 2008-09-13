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

//will delete the current database, must be entered manually in the url 
if (request.getParameter("delete") != null) {
	CarPoolStoreImpl cps = new CarPoolStoreImpl();
	cps.removeAll("donotusethis");
}
%>


<HTML>
	<HEAD>
		<TITLE> The Car Pool </TITLE>
		<STYLE type="text/css" media="screen">@import "2ColumnLayout.css";</STYLE>
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

	<%@ include file="headingTest.html" %> <br />

	<DIV id="Content" class="Content">
		<p>Please log in.</p>
	</DIV>

	<DIV id="Menu" class="Menu">

		<p><a href="welcome.jsp"> <img class="logo" border="0" src="Car Pool 6 75.bmp" width="263" height="158"> </a></p> <br />

		<p>Log in via OpenId:</p>
		<FORM class="login" name="openid_identifier" action="openidlogin" method="post">
			<INPUT type="hidden" name="openid_signin" value="true"/>
				<TABLE class="login" border="0">
			   		<tr><td>OpenId:</td><td><INPUT type="text" name="openid_url" id="openid_url" size="18"/></td></tr>
			   		<tr><td></td><td align="left"><INPUT type="submit" value="Login"/></td></tr>
				</TABLE>
		</FORM>
		<p>Enter your OpenID and if you have not registered with our site previously and your OpenID is valid you will eventually be redirected to Registration page.</p> <br />
 
		<p>Or Log in via your username and password</p>
		<FORM name="passwordlogin" action="login" method="post">
			<INPUT type="hidden" name="normal_signin" value="true">
			<TABLE class="login">
				<tr><td>Username:</td><td><INPUT type="text" name="username" size="18"/></td></tr>
				<tr><td>Password:</td><td><INPUT type="password"name="userpass" size="18"/></td></tr>
				<tr><td></td><td><INPUT type="submit" value="Login"/></td></tr>
			</TABLE>
		</FORM>
		<p>Not registered and don't want to use OpenId, then <a href="register.jsp">register here</a>.</p>
	</DIV>		
	</BODY>
</HTML>

