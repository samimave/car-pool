<%@page errorPage="errorPage.jsp"%>
<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page
	import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.user.*,java.util.*,java.text.*"%>

<%
	HttpSession s = request.getSession(true);

	//user doesnt need to be logged in to view this page
	//a container for the users information
	User user = null;
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");
	}

	//simple date processing for display on page
	Date now = new Date();
	//String date = DateFormat.getDateInstance().format(now);
	String date = new SimpleDateFormat("dd/MM/yyyy").format(now);

	CarPoolStore cps = new CarPoolStoreImpl();
	//make the options for the street select box
	LocationList locations = cps.getLocations();
	String options = "";
	while (locations.next()) {
		options += "<option value='" + locations.getID() + "'>"
				+ locations.getStreetName() + "</option>";
	}
	int rideCount = 0;
	//count the number of rides in the db
	RideListing rl = cps.getRideListing();
	while (rl.next()) {
		String d = new SimpleDateFormat("dd/MM/yyyy").format(rl
				.getRideDate())
				+ " " + rl.getTime();
		Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);
		if (dt.after(now)) {
			rideCount++;

		}
	}
%>

<HTML>
	<HEAD>
		<TITLE>Ride Search</TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
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

<%@ include file="heading.html"%>

<DIV class="Content" id="Content">
	<h2 class="title" id="title">Find Rides</h2>
	<br />
	<br />
	<h2>Manual Search:</h2>
	<div class="Box" id="Box">
		<p>There are currently <%=rideCount%> rides in the database!</p>
		<br />
		<FORM name="showAll" id="showAll" method="post" action="<%=response.encodeURL("resultall.jsp")%>">
			<INPUT type="hidden" name="showAll" value="yes" />
			<p>Click here to <INPUT TYPE="submit" NAME="all" VALUE="Show All Rides"	SIZE="25"></p>
		</FORM>
	</div>
	<br />
	<br />
	<h2>Automatic Search:</h2>
	<div class="Box" id="Box">
		<p>Please enter the search criteria in the boxes below and click
		search. Rides matching any of the entered information will be displayed.</p>
		<br />
		<h3>Search Criteria:</h3>
		<div class="Box" id="Box">
		<FORM NAME="searchFrm" id="search" method="post" action="<%=response.encodeURL("result.jsp")%>">
		<INPUT TYPE="hidden" NAME="fromCoord"> 
		<INPUT TYPE="hidden" NAME="toCoord">
		<TABLE>
			<tr>
				<td>Ride Departing From:</td>
				<%//<td><INPUT type="text" name="numFrom" size="5" onkeypress="getAddress('from')" /></td> %>
				<td><SELECT name="streetFrom" onChange="getAddress('from')">
					<option selected="selected">Select a Street</option>
					<%=options%>
				</SELECT></td>
			</tr>
			<tr>
				<td>Ride Destination:</td>
				<%//<td><INPUT type="text" name="numTo" size="5" onkeypress="getAddress('to')" /></td>%>
				<td><SELECT name="streetTo" onChange="getAddress('to')">
					<option selected="selected">Select a Street</option>
					<%=options%>
				</SELECT></td>
			</tr>
			<tr>
				<td>Departure Date (dd/MM/yyyy):</td>
				<td><INPUT TYPE="text" NAME="searchDate" VALUE="<%=date%>" SIZE="25"> 
					<A HREF="#" onClick="cal.select(document.forms['searchFrm'].searchDate,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1">
					<img name="calIcon" border="0" src="calendar_icon.jpg" width="27" height="23"></A> 
				</td> 
			</tr>
			<tr>
				<td>Ride Offered By (username):</td>
				<td><INPUT TYPE="text" NAME="sUser" VALUE="" SIZE="25"></td>
			</tr>
		</TABLE>
		<br />
		<p>Click here to <INPUT TYPE="submit" NAME="search"
			VALUE="Search Rides" SIZE="25"></p>
		</FORM>
		</div>
	</div>
</DIV>
<%
	if (user != null) { //depending if the user is logged in or not different side menus should be displayed
%> <jsp:include page="leftMenu.jsp" flush="false" /> <%
 	} else {
 %> <jsp:include page="leftMenuLogin.jsp" flush="false" /> <%
 	}
 %>

</BODY>
</HTML>

