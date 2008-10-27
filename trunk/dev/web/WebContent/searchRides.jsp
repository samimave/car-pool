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
		<SCRIPT type="text/javascript" src="javascript/CalendarPopup.js"></SCRIPT>
		<SCRIPT type="text/javascript">
			var cal = new CalendarPopup();
		</script>
		<%@include file="include/javascriptincludes.html" %>
   		<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ" type="text/javascript"></script>
  		<%//massey key: ABQIAAAAwEEggV_Hd8onlfSgA_kgZBTz-RVM6WN_1Yrxj3B45o6dXx3SPxRBd9zQMOS18U6DzRdS0kg6JbFdlA
 	    //localhost key - ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ %>
		<SCRIPT type="text/javascript">
						function codeFrom(response) {
							document.getElementById("searchFrm").fromCoord.value=response.lat() + "," + response.lng();
							}
						function codeTo(response) {
							document.getElementById("searchFrm").toCoord.value=response.lat() + "," + response.lng();
							}
						// a function to get the from and to streets from the combobox and pass them to the 
						// form call "showMap" which then post to the "displayRouteMap.jsp" to be display on google map
			      		function getAddress(origin){
			      			  startIdx = document.getElementById("searchFrm").streetFrom.selectedIndex;
			      		   	  startLoc = document.getElementById("searchFrm").streetFrom.options[startIdx].text;
			     			  endIdx   = document.getElementById("searchFrm").streetTo.selectedIndex;
			     		   	  endLoc   = document.getElementById("searchFrm").streetTo.options[endIdx].text;
			     		   	  startNum  = document.getElementById("searchFrm").numFrom.value;
			     		   	  endNum  = document.getElementById("searchFrm").numTo.value;

			     		   	  var geocoder = new GClientGeocoder();
			
			     		   	  var from = startNum + " " + startLoc + " PALMERSTON NORTH NEW ZEALAND";
			     		   	  var to = endNum + " " + endLoc + " PALMERSTON NORTH NEW ZEALAND";
			    		   	
			     		   	  if(origin == "from"){geocoder.getLatLng(from, codeFrom);}
			     		   	  if(origin == "to"){geocoder.getLatLng(to, codeTo);}
			   		   	 
			      		}
		</script>
		<script>
		var rules=new Array();
		rules[0]='searchDate:date|date';
		rules[1]='numFrom:House number|numeric';
		rules[2]='numTo:House number|numeric';
		</script>

	</HEAD>
	<BODY onload="yav.init('searchFrm', rules);">

<%@ include file="heading.html"%>

<DIV class="Content" id="Content">
	<h2 class="title" id="title">Find Rides</h2>
	<br />
	<br />
	<h2>Manual Search:</h2>
	<div class="Box" id="Box">
		<p>You have the option of perusing the list of all available rides in the database to get a feel
		for what's out there or just for fun. Searching rides with the click of one button has never been 
		easier!</p>
		<br />
		<p>There are currently <%=rideCount%> rides in the database!</p>
		<br />
		<FORM name="showAll" id="showAll" action="<%=response.encodeURL("resultall.jsp")%>" method="post">
			<INPUT type="hidden" name="showAll" value="yes" />
			<p>Click here to <INPUT TYPE="submit" NAME="all" VALUE="Show All Rides"	SIZE="25" /></p>
		</FORM>
	</div>
	<br />
	<br />
	<h2>Automatic Search:</h2>
	<div class="Box" id="Box">
		<p>Our site uses a cunning and intricately complicated ride path projection system to 
		figure out the routes taken by drivers and to display the rides to you if they will pass by 
		your origin and/or destination. Searching rides by approximate location has never been easier!</p>
		<br />
		<p>
		Note: If a departure street is entered then a destination street must also be entered.
		</p>
		<br />
		<h3>Search Criteria:</h3>
		<div class="Box" id="Box">
		<FORM NAME="searchFrm" id="searchFrm" onsubmit="return yav.performCheck('searchFrm', rules, 'inline');" action="<%=response.encodeURL("result.jsp")%>" method="post" >
		<INPUT TYPE="hidden" NAME="fromCoord"> 
		<INPUT TYPE="hidden" NAME="toCoord">
		<TABLE>
			<tr> <th>Ride Departing From:</th> <td>&nbsp;</td> </tr>
			<tr> <td>House Number:</td> <td><INPUT type="text" name="numFrom" size="5" onkeypress="getAddress('from')" />&nbsp;&nbsp;<span id=errorsDiv_numFrom></span></td> </tr>
			<tr> <td>Street Name:</td> <td><SELECT name="streetFrom" onChange="getAddress('from')">
					<option selected="selected">Select a Street</option>
					<%=options%>
				</SELECT></td>
			</tr>
			<tr> <th>Ride Destination:</th> <td>&nbsp;</td> </tr>
			<tr> <td>House Number:</td><td><INPUT type="text" name="numTo" size="5" onkeypress="getAddress('to')" />&nbsp;&nbsp;<span id=errorsDiv_numTo></span></td> </tr>
			<tr> <td>Street Name:</td><td><SELECT name="streetTo" onChange="getAddress('to')">
					<option selected="selected">Select a Street</option>
					<%=options%>
				</SELECT></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>Departure Date (dd/MM/yyyy):</td>
				<td><INPUT TYPE="text" NAME="searchDate" VALUE="<%=date%>" SIZE="25"> 
					<A HREF="#" onClick="cal.select(document.forms['searchFrm'].searchDate,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1">
					<img name="calIcon" border="0" src="images/calendar_icon.jpg" width="27" height="23"></A> 
					&nbsp;&nbsp;<span id=errorsDiv_searchDate></span>
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

