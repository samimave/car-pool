<%//@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.user.*,java.text.*,car.pool.user.*,java.util.*" %>
<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	// a container for the users information
	User user = null;
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");

		//DO ALL STUFF HERE
		int profileId = Integer.parseInt(request.getParameter("profileId"));
		

	} else {
		response.sendRedirect(request.getContextPath());
	}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>

		<TITLE>User Profile</TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<SCRIPT type="text/javascript" src="CalendarPopup.js"></SCRIPT>
		<SCRIPT type="text/javascript">
			var cal = new CalendarPopup();
		</script>

	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

	<DIV class="Content" id="Content">
		<h2 class="title" id="title">Ride Information</h2>
		<br /><br />
		<h2>User Profile:</h2>
		<div class="Box" id="Box">
		<table>
		
		</table>
		<br />
		</div>
		<br /><br />
		<h2>Rides User Has Offered:</h2>
		<div class="Box" id="Box">
		</div>
		<br /> <br /> <br />
		<p>-- <a href="welcome.jsp">Home</a> --</p>	
	</DIV>

	<%@ include file="leftMenu.html" %>

	</BODY>
</HTML>