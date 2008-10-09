<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*,java.util.*,java.text.*" %>

<%
HttpSession s = request.getSession(true);

User user = null;
//check if the user is logged in and viewing the page
if (!(OpenIdFilter.getCurrentUser(s) == null && s.getAttribute("signedin") == null)) {
	user = (User)s.getAttribute("user"); 
}

//simple date processing for display on page
Date now = new Date();
//String date = DateFormat.getDateInstance().format(now);
String date = new SimpleDateFormat("dd/MM/yyyy").format(now);

CarPoolStore cps = new CarPoolStoreImpl();
//make the options for the street select box
LocationList locations = cps.getLocations();
String options = "";
while (locations.next()){
	options += "<option value='"+locations.getID()+"'>"+locations.getStreetName()+"</option>";
}
int rideCount=0;
//count the number of rides in the db
RideListing rl = cps.getRideListing();		
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
		<%@include file="include/javascriptincludes.html" %>
   		<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ" type="text/javascript"></script>
 
		<SCRIPT type="text/javascript">
						function codeFrom(response) {
							document.getElementById("search").fromCoord.value=response.lat() + "," + response.lng();
							}
						function codeTo(response) {
							document.getElementById("search").toCoord.value=response.lat() + "," + response.lng();
							}
						// a function to get the from and to streets from the combobox and pass them to the 
						// form call "showMap" which then post to the "displayRouteMap.jsp" to be display on google map
			      		function getAddress(origin){
			      			  startIdx = document.getElementById("search").streetFrom.selectedIndex;
			      		   	  startLoc = document.getElementById("search").streetFrom.options[startIdx].text;
			     			  endIdx   = document.getElementById("search").streetTo.selectedIndex;
			     		   	  endLoc   = document.getElementById("search").streetTo.options[endIdx].text;
			     		   	  startNum  = document.getElementById("search").numFrom.value;
			     		   	  endNum  = document.getElementById("search").numTo.value;

			     		   	  var geocoder = new GClientGeocoder();
			
			     		   	  var from = startNum + " " + startLoc + " PALMERSTON NORTH NEW ZEALAND";
			     		   	  var to = endNum + " " + endLoc + " PALMERSTON NORTH NEW ZEALAND";
			    		   	
			     		   	  if(origin == "from"){geocoder.getLatLng(from, codeFrom);}
			     		   	  if(origin == "to"){geocoder.getLatLng(to, codeTo);}
			   		   	 
			      		}
		</script>

	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="content">
			<p>There are currently <%=rideCount %> rides in the database!</p>
			<p>Please enter the search criteria in the boxes below and click search</p>
			<FORM NAME="searchFrm" id="search" method="post" action="rideFinder.jsp">	
				<TABLE class="rideSearch">

					<tr> <td>From:</td><td><INPUT type="text" name="numFrom" size="5" onkeypress="getAddress('from')" /></td> <td>
					<SELECT name="streetFrom" onChange="getAddress('from')" >
           		  		<option selected="selected">Select a Street</option>
	           		 	<%=options %>
       				</SELECT></td> </tr>
					<tr> <td>To:</td><td><INPUT type="text" name="numTo" size="5" onkeypress="getAddress('to')" /></td> <td>
					<SELECT name="streetTo" onChange="getAddress('to')">
           		  		<option selected="selected">Select a Street</option>
	           		  	<%=options %>
       				 </SELECT></td> </tr>
				
					<tr> <td>Date (dd/MM/yyyy):</td> <td colspan="2"><INPUT TYPE="text" NAME="searchDate" VALUE="<%= date %>" SIZE="25"> <A HREF="#" onClick="cal.select(document.forms['searchFrm'].searchDate,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img name="calIcon" border="0" src="calendar_icon.jpg" width="27" height="23"></A> 
						<INPUT TYPE="text" NAME="fromCoord" SIZE="25">
						<INPUT TYPE="text" NAME="toCoord" SIZE="25">
						<INPUT TYPE="text" NAME="stuff" SIZE="25">

					</td></tr>
					<tr> <td>&nbsp;					</td> <td><INPUT TYPE="submit" NAME="search" VALUE="Search" SIZE="25"></td> </tr>

				</TABLE>
			</FORM>
			<Form name="showAll" id="showAll" method="post" action="resultall.jsp">
				<input type="hidden" name="showAll" value="yes"/>
				<INPUT TYPE="submit" NAME="all" VALUE="Show All Rides" SIZE="25">
			</Form>
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