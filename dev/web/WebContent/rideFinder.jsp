<%@page contentType="text/html; charset=ISO-8859-1"%>
<%@page
	import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, java.text.SimpleDateFormat,car.pool.user.*,java.util.*, java.lang.Math.*"%>

<%
CarPoolStore cps = new CarPoolStoreImpl();

HttpSession s = request.getSession(true);

User user = null;
//check if the user is logged in and viewing the page
if (!(OpenIdFilter.getCurrentUser(s) == null && s.getAttribute("signedin") == null)) {
	user = (User)s.getAttribute("user"); 
}

//----------------------search parameters------------------------
//DATE
//date formatting for use by db 
//dd/MM/yyyy -> yyyy-MM-dd
String strOutDt = "no date entered";
String strTmp = request.getParameter("searchDate");
if (!strTmp.isEmpty() ){ 
	Date dtTmp = new SimpleDateFormat("dd/MM/yyyy").parse(strTmp);
	strOutDt = new SimpleDateFormat("yyyy-MM-dd").format(dtTmp);
}
else {
	strTmp = "no date was entered";
}


//----------------------end search parameters------------------------

//##############################SEARCH RIDE TABLE##############################

ArrayList<Integer> avoidDuplicates = new ArrayList<Integer>();
ArrayList<String> geoCodes = new ArrayList<String>();

String testInput = request.getParameter("stuff");
String output = "";
String[] test = testInput.split(":");
for(int i=0;i<test.length;i++){
	geoCodes.add(i + ">" + test[i]);
	//output += i + ">" + test[i] + "<br>";
}
testInput = "breakpoint";
/*
//---------------SEARCH RIDES BY DATE----------------------------------
String dateTable = "";
boolean dateExist = false;

if (strTmp != "")	{
	
	RideListing daTbl = cps.searchRideListing(RideListing.searchDate, strOutDt);
	
	while (daTbl.next()) {
		if (!dateExist) {
			dateTable = "";		//first time round get rid of unwanted text
		}
		dateExist = true;
		
		//code to get the name associated with the street id
		String from = daTbl.getStartLocation();
		String to = daTbl.getEndLocation();

		if (!avoidDuplicates.contains(daTbl.getRideID())){
			avoidDuplicates.add(daTbl.getRideID());
			
			dateTable += "<tr> <td>"+ daTbl.getUsername() +"</td> ";	
			dateTable += "<td>"+ from +"</td> ";
			dateTable += "<td>"+ to +"</td> ";
			dateTable += "<td>"+ new SimpleDateFormat("dd/MM/yyyy").format(daTbl.getRideDate()) +"</td> ";
			dateTable += "<td>"+ daTbl.getTime() +"</td> ";
			dateTable += "<td>"+ daTbl.getAvailableSeats() +"</td> ";
			daTbl
			if (user != null) {	
				dateTable += "<td> <a href='"+ request.getContextPath() +"/rideDetails.jsp?rideselect="+ daTbl.getRideID() +"&userselect="+daTbl.getUsername()+"'>"+ "Link to ride page" +"</a> </td> </tr>";
			} else {
				dateTable += "<td>login to view more</td> </tr>";
			}
		}
		else {
			dateTable = "";
		}
		
	}
}
*/
//-------------------------------------------------------------------

String[] matches = getMatches(geoCodes, request.getParameter("fromCoord"), request.getParameter("toCoord"));
String[] rideIDs = matches[0].split(",");
String mapCoords = matches[1];

%>

<%!	public String[] getMatches(ArrayList<String> rides, String fromCoord, String toCoord){

	String[] result = new String[2];
	result[0] = "";
	result[1] = "";
	
	String[] searchFrom = fromCoord.split(",");
	double sFromLat = Double.parseDouble(searchFrom[0]);
	double sFromLng = Double.parseDouble(searchFrom[1]);
	
	String[] searchTo = fromCoord.split(",");
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

		//if end points are within 3km
		if(distance(sToLat, sToLng, toLat, toLng)[0] < 3){
			StartToSearcher = distance(sFromLat, sFromLng, fromLat, fromLng);
			StartToEnd = distance(fromLat, fromLng, toLat, toLng);

			if((StartToSearcher[0]<StartToEnd[0])){
				if(Math.abs((StartToSearcher[1] - StartToEnd[1])) < Math.PI){
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
	result[1] = Math.atan2(y, x);//    .toBrng();
	
	return result;
}%>



<HTML>
<HEAD>
<TITLE>Ride Search Results</TITLE>
<STYLE type="text/css" media="screen">
@import "3ColumnLayout.css";
</STYLE>
<%@include file="include/javascriptincludes.html"%>
<script
	src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ"
	type="text/javascript"></script>
</HEAD>
<BODY>
<%@ include file="heading.html"%>
<DIV class="content">

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
if (user != null) { 		//depending if the user is logged in or not different side menus should be displayed
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
