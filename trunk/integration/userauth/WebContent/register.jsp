<%@page contentType="text/html; charset=ISO-8859-1"%>

<%
//HttpSession s = request.getSession(false);
//CarPoolStore cps = new CarPoolStoreImpl();
%>

<HTML>
	<HEAD>
		<TITLE> Registration </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

		<DIV class="content">
			<p>Please enter the relevant details and click confirm.</p>
			<FORM NAME="offerFrm" method="post" action="confirmReg.jsp">
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

				<INPUT TYPE="submit" NAME="confirmReg" VALUE="Confirm Registration" SIZE="25"> <br /> <br />
			</FORM>
		</DIV>

	<DIV id="navAlpha">
		Please enter your details.
	</DIV>

	<DIV id="navBeta">
		
	</DIV>

	</BODY>
</HTML>