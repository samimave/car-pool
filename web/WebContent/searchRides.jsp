<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*,java.util.*,java.text.*" %>

<%
User user = null;
//check if the user is logged in and viewing the page
if (!(OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null)) {
	user = (User)session.getAttribute("user"); 
}

//simple date processing for display on page
Date now = new Date();
String date = DateFormat.getDateInstance().format(now);


CarPoolStore cps = new CarPoolStoreImpl();
//make the options for the street select box
LocationList locations = cps.getLocations();
String options = "";
while (locations.next()){
	options += "<option value='"+locations.getID()+"'>"+locations.getStreetName()+"</option>";
}
int rideCount=0;
//count the number of rides in the db
RideListing rl = cps.getRideListing();		//TODO: make this work
while (rl.next()){
	rideCount++;
}
%>

<HTML>
	<HEAD>
		<TITLE>Ride Search</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css"; </STYLE>
		<SCRIPT type="text/javascript" src="CalendarPopup.js"></SCRIPT>
		<SCRIPT type="text/javascript">
			var cal = new CalendarPopup();
		</script>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="content">
			<p>There are currently <%=rideCount %> rides in the database!</p>
			<p>Please enter the search criteria in the boxes below and click search</p>
			<FORM NAME="searchFrm" id="search" method="post" action="result.jsp">	
				<TABLE class="rideSearch">
	
					<tr> <td>Street From:</td> <td>
					<SELECT name="searchFrom" >
           		  		<option selected="selected">Select a Street</option>
	           		 	<%=options %>
       				</SELECT></td> </tr>
					<tr> <td> OR Street To:</td> <td>
					<SELECT name="searchTo">
           		  		<option selected="selected">Select a Street</option>
	           		  	<%=options %>
       				 </SELECT></td> </tr>
				
					<tr> <td>OR Date (dd/MM/yyyy):</td> <td><INPUT TYPE="text" NAME="searchDate" VALUE="<%= date %>" SIZE="25"> <A HREF="#" onClick="cal.select(document.forms['searchFrm'].searchDate,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img name="calIcon" border="0" src="calendar_icon.jpg" width="27" height="23"></A> </td> </tr> 
					<tr> <td>OR User:</td> <td><INPUT TYPE="text" NAME="sUser" VALUE="" SIZE="25"></td> </tr>
					<tr> <td>&nbsp;</td> <td><INPUT TYPE="submit" NAME="search" VALUE="Search" SIZE="25"></td> </tr>

				</TABLE>
			</FORM>
			<p><a href="welcome.jsp">Home</a></p>
		</DIV>

<%
if (user != null) { 		//depending if the user is logged in or not different side menus should be displayed
%> 
	<jsp:include page="leftMenu.html" flush="false" />
	<jsp:include page="rightMenu.jsp" flush="false" />
<%
} else { 
%>
	<jsp:include page="leftMenuLogin.html" flush="false" />
	<jsp:include page="rightMenuLogin.html" flush="false" />
<%
} 
%>

	</BODY>
</HTML>