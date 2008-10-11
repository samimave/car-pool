<%//@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,java.text.SimpleDateFormat,car.pool.user.*,java.util.*" %>

<%
	HttpSession s = request.getSession(true);

	//a user doesnt need to log in to view this page
	//a container for the users information
	User user = null;
	String Sto = "";
	String Sfrom = "";
	String strTmp = "";
	String username = "";
	String rideTable = "";
	CarPoolStore cps = new CarPoolStoreImpl();
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");
	}
	//----------------------search parameters------------------------
	//USERNAME
	username = "no username entered";
	if (request.getParameter("sUser") != "") {
		username = request.getParameter("sUser");
	} else {
		username = "no username entered";
	}

	//DATE
	//date formatting for use by db 
	//dd/MM/yyyy -> yyyy-MM-dd
	String strOutDt = "no date entered";
	strTmp = request.getParameter("searchDate");
	if (!strTmp.isEmpty()) {
		Date dtTmp = new SimpleDateFormat("dd/MM/yyyy").parse(strTmp);
		strOutDt = new SimpleDateFormat("yyyy-MM-dd").format(dtTmp);
	} else {
		strTmp = "no date was entered";
	}

	//FROM AND TO

	String fromIdx = request.getParameter("searchFrom");
	String toIdx = request.getParameter("searchTo");

	if (fromIdx.contains("Select a Street")) {
		Sfrom = "no location entered";
	} else {
		//code to get the name associated with the street id
		LocationList allLocs = cps.getLocations();
		while (allLocs.next()) {
			if ((allLocs.getID() == Integer.parseInt(fromIdx))) {
				Sfrom = allLocs.getStreetName();
			}
		}
	}

	if (toIdx.contains("Select a Street")) {
		Sto = "no location entered";
	} else {
		//code to get the name associated with the street id
		LocationList allLocs = cps.getLocations();
		while (allLocs.next()) {
			if ((allLocs.getID() == Integer.parseInt(toIdx))) {
				Sto = allLocs.getStreetName();
			}
		}
	}
	//----------------------end search parameters------------------------

	//##############################SEARCH RIDE TABLE##############################

	ArrayList<Integer> avoidDuplicates = new ArrayList<Integer>();
	ArrayList<String> geoCodes = new ArrayList<String>();
	
	String mapCoords = "";

	boolean userNull = username.equals("no username entered");
	boolean dateNull = strTmp.equals("");
	
	boolean anythingElse;
	
	int rideNum;

	//---------------SEARCH RIDES BY USER----------------------------------
	String userTable= "";

	boolean userExist = false;
	
	anythingElse = (strTmp != "") || (Sfrom == "no location entered") || (Sto != "no location entered");

	if (!userNull && !anythingElse) {
		RideListing u = cps.searchRideListing(RideListing.searchUser,
				username);

		while (u.next()) {
			if (!userExist) {
				userTable= ""; //first time round get rid of unwanted text
			}

			String from = u.getStartLocation();
			String to = u.getEndLocation();
			
			String d = new SimpleDateFormat("dd/MM/yyyy").format(u.getRideDate())+" "+u.getTime();
			Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);

			if (!avoidDuplicates.contains(u.getRideID()) && dt.after(new Date())) {
				userExist = true;
				
				avoidDuplicates.add(u.getRideID());
				
				mapCoords += u.getGeoLocation() + ":";

				userTable+= "<tr> <td>" + "<a href='"+response.encodeURL(request.getContextPath()+"/profile.jsp?profileId="+ u.getUserID())+"'>"+u.getUsername()+ "</a></td>";
				userTable+= "<td>" + from + "</td> ";
				userTable+= "<td>" + to + "</td> ";
				userTable+= "<td>"	+ new SimpleDateFormat("dd/MM/yyyy").format(u.getRideDate()) + "</td> ";
				userTable+= "<td>" + u.getTime() + "</td> ";
				userTable+= "<td>" + u.getAvailableSeats() + "</td> ";
				if (user != null) {
					userTable+= "<td> <a href='"
							+ response.encodeURL(request.getContextPath()
							+ "/rideDetails.jsp?rideselect=" + u.getRideID()
							+ "&userselect=" + u.getUsername()) + "'>"
							+ "Link to ride page" + "</a> </td> </tr>";
				} else {
					userTable+= "<td>login to view more</td> </tr>";
				}
			} else {
				userTable= "";
			}
		}
	}

	//---------------SEARCH RIDES BY DATE----------------------------------
	String dateTable = "";
	boolean dateExist = false;
	
	anythingElse = (username != "no username entered") || (Sfrom != "no location entered") || (Sto != "no location entered");

	if (!dateNull && !anythingElse) {

		RideListing daTbl = cps.searchRideListing(RideListing.searchDate, strOutDt);

		while (daTbl.next()) {
			if (!dateExist) {
				dateTable = ""; //first time round get rid of unwanted text
			}

			//code to get the name associated with the street id
			String from = daTbl.getStartLocation();
			String to = daTbl.getEndLocation();

			String d = new SimpleDateFormat("dd/MM/yyyy").format(daTbl.getRideDate())+" "+daTbl.getTime();
			Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);
			
			if (!avoidDuplicates.contains(daTbl.getRideID()) && dt.after(new Date())) {
				dateExist = true;
				avoidDuplicates.add(daTbl.getRideID());
				
				mapCoords += daTbl.getGeoLocation() + ":";

				dateTable += "<tr> <td>" + "<a href='"+response.encodeURL(request.getContextPath()+"/profile.jsp?profileId="+ daTbl.getUserID())+"'>"+daTbl.getUsername()+ "</a></td>";
				dateTable += "<td>" + from + "</td> ";
				dateTable += "<td>" + to + "</td> ";
				dateTable += "<td>"+ new SimpleDateFormat("dd/MM/yyyy").format(daTbl.getRideDate()) + "</td> ";
				dateTable += "<td>" + daTbl.getTime() + "</td> ";
				dateTable += "<td>" + daTbl.getAvailableSeats()+ "</td> ";
				if (user != null) {
					dateTable += "<td> <a href='"
							+ response.encodeURL(request.getContextPath()
							+ "/rideDetails.jsp?rideselect="
							+ daTbl.getRideID() + "&userselect="
							+ daTbl.getUsername()) + "'>"
							+ "Link to ride page" + "</a> </td> </tr>";
				} else {
					dateTable += "<td>login to view more</td> </tr>";
				}
			} else {
				dateTable = "";
			}

		}
	}

	//---------------SEARCH RIDES COMBO----------------------------------
	ArrayList<String> cTable = new ArrayList<String>();
	String tempTable = "";
	String comboTable = "";
	
	rideNum = 0;

	boolean search = false;
	boolean addRide = false;
	
	RideListing rides = null;

	if (!userNull) {
		rides = cps.searchRideListing(RideListing.searchUser, username);
		search = true;
	}else if(!dateNull){
		rides = cps.searchRideListing(RideListing.searchDate, strOutDt);
		search = true;
	}else{
		search = false;
	}
		
	if(search){
		while (rides.next()) {

			String from = rides.getStartLocation();
			String to = rides.getEndLocation();
			
			String d = new SimpleDateFormat("dd/MM/yyyy").format(rides.getRideDate())+" "+rides.getTime();
			Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);
			
			if(!userNull && !dateNull){
				addRide = strTmp.equals(new SimpleDateFormat("dd/MM/yyyy").format(rides.getRideDate()));
			}else{
				addRide = true;
			}

			if (!avoidDuplicates.contains(rides.getRideID()) && dt.after(new Date()) && addRide) {

				avoidDuplicates.add(rides.getRideID());
				geoCodes.add(rideNum + ">" + rides.getGeoLocation());
				rideNum++;

				tempTable += "<tr> <td>" + "<a href='"+response.encodeURL(request.getContextPath()+"/profile.jsp?profileId="+ rides.getUserID())+"'>"+rides.getUsername()+ "</a></td>";
				tempTable += "<td>" + from + "</td> ";
				tempTable += "<td>" + to + "</td> ";
				tempTable += "<td>"	+ new SimpleDateFormat("dd/MM/yyyy").format(rides.getRideDate()) + "</td> ";
				tempTable += "<td>" + rides.getTime() + "</td> ";
				tempTable += "<td>" + rides.getAvailableSeats() + "</td> ";
				if (user != null) {
					tempTable += "<td> <a href='"
							+ response.encodeURL(request.getContextPath()
							+ "/rideDetails.jsp?rideselect=" + rides.getRideID()
							+ "&userselect=" + rides.getUsername()) + "'>"
							+ "Link to ride page" + "</a> </td> </tr>";
				} else {
					tempTable += "<td>login to view more</td> </tr>";
				}
			} else {
				tempTable = "";
			}
			
			cTable.add(tempTable);
			tempTable = "";

		}
		
		String[] matches = getMatches(geoCodes, request.getParameter("fromCoord"), request.getParameter("toCoord"));
		String[] rideIDs = matches[0].split(",");
		mapCoords = matches[1];

		for(int i=0;i<rideIDs.length;i++){
			comboTable += cTable.get(Integer.parseInt(rideIDs[i]));
		}
	}

	//---------------COMBINE RESULTS----------------------------------
	

	
		
	if (!mapCoords.equals("")) {
		rideTable = userTable + dateTable + comboTable;
		rideTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"
				+ "<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th> <th>More Info</th> </tr>"
				+ rideTable
				+ "</table>";
	} else {
		rideTable = "<p>Sorry, no rides were found that match your criteria.</p>";
	}
	//-------------------------------------------------------------------
%>

<%! public boolean containsID(int ID, String[] list){
	
	String strID = Integer.toString(ID);
	
	for(int i=0;i<list.length;i++){
		if(list[i].equals(strID)){
			return true;
		}
	}
	return false;
}
%>
<%!	public String[] getMatches(ArrayList<String> rides, String fromCoord, String toCoord){

	String[] result = new String[2];
	result[0] = "";
	result[1] = "";
	
	String[] searchFrom = fromCoord.split(",");
	double sFromLat = Double.parseDouble(searchFrom[0]);
	double sFromLng = Double.parseDouble(searchFrom[1]);
	
	String[] searchTo = toCoord.split(",");
	double sToLat = Double.parseDouble(searchTo[0]);
	double sToLng = Double.parseDouble(searchTo[1]);
	
	ArrayList<Integer> id = new ArrayList<Integer>();
	double fromLat, fromLng;
	double toLat, toLng;
	
	double[] StartToSearcher, StartToEnd;
	
	String[] ride, rideLocs, from, to;
	
	for(int i=0;i<rides.size();i++){
		ride = rides.get(i).split(">");
		
		rideLocs = ride[1].split("/");
	
		from = rideLocs[0].split(",");
		fromLat = Double.parseDouble(from[0]);
		fromLng = Double.parseDouble(from[1]);
		
		to = rideLocs[1].split(",");
		toLat = Double.parseDouble(to[0]);
		toLng = Double.parseDouble(to[1]);

		//find straight-line distance from the start of the ride to the end
		StartToEnd = distance(fromLat, fromLng, toLat, toLng);
		
		//come up with a sensible radius to search in (3km min)
		double radius = StartToEnd[0] * 0.1;
		if(radius < 3){
			radius = 3;
		}

		//if end points are within a suitable radius
		if(distance(sToLat, sToLng, toLat, toLng)[0] < radius){
			//find straight-line distance from the start of the ride to where the searcher wants to start from
			StartToSearcher = distance(sFromLat, sFromLng, fromLat, fromLng);

			//if ride distance is less than dist. between start and searcher then keep going
			if((StartToSearcher[0]<StartToEnd[0])){
				//if the searcher will not have to travel the opposite way to pick up the searcher (unless the two parties live within a reasonable radius)
				if((Math.abs(StartToSearcher[1] - StartToEnd[1]) < (Math.PI))|(distance(sFromLat, sFromLng, fromLat, fromLng)[0] < radius)){
					result[0] += ride[0] + ",";
					result[1] += ride[1] + ":";
				}
			}
		}
	}
	return result;
}
%>

<%! public double[] distance(double sLat,double sLng,double rLat,double rLng){
	
	double result[] = new double[2];
	
	sLat = Math.toRadians(sLat);
	sLng = Math.toRadians(sLng);
	rLat = Math.toRadians(rLat);
	rLng = Math.toRadians(rLng);
	
	//formula based on example found here: http://www.movable-type.co.uk/scripts/latlong.html
	double earthRad = 6371; // km
	result[0] = Math.acos(Math.sin(sLat)*Math.sin(rLat) + 
	                  Math.cos(sLat)*Math.cos(rLat) *
	                  Math.cos(rLng-sLng)) * earthRad;
	
	result[0] = Math.abs(result[0]);
	
	double y = Math.sin(sLng-rLng) * Math.cos(rLat);
	double x = Math.cos(sLat)*Math.sin(rLat) -
	        Math.sin(sLat)*Math.cos(rLat)*Math.cos(sLng-rLng);
	result[1] = (Math.atan2(y, x) + 2 * Math.PI) % Math.PI;
	
	return result;
}%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<TITLE>Ride Search Results</TITLE>
<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
<%@include file="include/javascriptincludes.html"%>
<script
	src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ"
	type="text/javascript"></script>
</HEAD>
<BODY>

	
	<%@ include file="heading.html" %>

	<DIV class="Content" id="Content">
		<div class="Box" id="Box">
		<br />
		<h3>You Searched For:</h3>
		<div class="Box" id="Box">
		<FORM NAME="resultFrm" id="result">	
			<TABLE class="rideSearch">
				<tr><td>Location from:</td> <td><%=Sfrom%></td></tr>
				<tr><td>Location to:</td> <td><%=Sto%></td></tr>
				<tr><td>Date:</td> <td><%=strTmp%></td></tr>
				<tr><td>User:</td> <td><%=username%></td>
			</TABLE>
		</FORM>
		</div>
		<br /><br />
		<p>-- <a href="<%=response.encodeURL("searchRides.jsp") %>">Go back to Search page</a> --</p>
	</DIV>
	<FORM NAME="resultFrm" id="result">
	<TABLE border=1>
		<tr>
			<td>
			<div id="map" style="width: 550px; height: 450px"></div>
			</td>
	
		</tr>
	</TABLE>
	</FORM>
	</DIV>

<script type="text/javascript">

    //localhost key - ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ
 	//massey key - ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRlE5ut_msTCy_drvRxhL-5WV5Z9RRgsjp91RhaFgOcfLwhiUE-yftYsA 
   
    //<![CDATA[
    
	window.onload = function() {
    	showLocation(); 
    
    }
	window.unload = GUnload();

   
	if (GBrowserIsCompatible()) {

		// Display the map, with some controls and set the initial location 
		var map = new GMap2(document.getElementById("map"));
		var geocoder = new GClientGeocoder();

		//get all the rides to map
		var rides = "<%=mapCoords %>".split(":");
		
		//route mapping code
		var directionsPanel = document.getElementById("my_textual_div");
		var routes = new Array();

		//create array of route objects
		for(var i=0; i<rides.length;i++){
			routes[i] = new GDirections(map, directionsPanel);
		}

		///	  
		map.addControl(new GLargeMapControl());
		map.addControl(new GMapTypeControl());
		map.setCenter(new GLatLng(-40.35814342293522, 175.6267547607422), 13);

		// It geocodes the address in the database associate with the ride
		// and adds a marker to the map at that location.
		function showLocation() {

			for(var i=0; i<rides.length;i++){
				routes[i].loadFromWaypoints(rides[i].split("/"));
			}

		}
	}

	// display a warning if the browser was not compatible
	else {
		alert("Sorry, displaying route map is not compatible with this browser");
	}

	//]]>
</script>

<%
	if (user != null) { //depending if the user is logged in or not different side menus should be displayed
%> 
	<jsp:include page="leftMenu.jsp" flush="false" />
<%
	} else {
%>
	<jsp:include page="leftMenuLogin.jsp" flush="false" />
<%
	}
%>
	</BODY>
</HTML>
