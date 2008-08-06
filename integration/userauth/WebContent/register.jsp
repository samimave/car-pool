<%@page contentType="text/html; charset=ISO-8859-1" import="car.pool.persistance.*"%>

<%
//HttpSession s = request.getSession(false);
car.pool.persistance.CarPoolStore cps = new CarPoolStoreImpl();
%>

<html>
	<head>
		<title> Registration </title>
		<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>


	</head>
	<body>

	<%@ include file="heading.html" %>	

		<div class="content">
			<p>Please enter the relevant details and click confirm.</p>
			<FORM NAME="offerFrm" method="post" action="confirmationReg.jsp">
				<h5>User Account:</h5>
				<p>Open ID Account:<p> 
				<INPUT TYPE="text" NAME="openId" SIZE="25">
				
				<p>User Name for this site:<p>
				<INPUT TYPE="text" NAME="userName" SIZE="25"> 
				<INPUT TYPE="submit" NAME="checkUserName" VALUE="Confirm availability" SIZE="25"> <br /> <br />

				<h5>Additional Details:</h5>
				<p>Email address:<p> 
				<INPUT TYPE="text" NAME="email" SIZE="25">

				<p>Phone Number:<p> 
				<INPUT TYPE="text" NAME="phone" SIZE="25"><br /> <br />

				<INPUT TYPE="submit" NAME="confirmReg" VALUE="Confirm Registration" SIZE="25" onclick="<% cps.addUser("aUser","theirPassword"); %>"> <br /> <br />
			</FORM>
		</div>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</body>
</html>