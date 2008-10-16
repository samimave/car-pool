<%@page errorPage="errorPage.jsp"%>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,java.text.SimpleDateFormat,car.pool.user.*,java.util.*" %>

<%
	HttpSession s = request.getSession(true);

	//a user doesnt need to log in to view this page
	//a container for the users information
	User user = null;
	String Sto = "";
	String Sfrom = "";
	String dateString = "";
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
	dateString = request.getParameter("searchDate");
	if (!dateString.isEmpty()) {
		Date dtTmp = new SimpleDateFormat("dd/MM/yyyy").parse(dateString);
		strOutDt = new SimpleDateFormat("yyyy-MM-dd").format(dtTmp);
	} else {
		dateString = "no date was entered";
	}

	//FROM AND TO

	String fromIdx = request.getParameter("streetFrom");
	String toIdx = request.getParameter("streetTo");
	System.out.println("f: "+fromIdx+"; t: "+toIdx);
	
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
	
	//used to hold the list of co-ordinates that will later be filtered by calculations
	ArrayList<String> geoCodes = new ArrayList<String>();

	//used to hold a '/' and ':" delimted string of co-ordinates to be mapped
	String mapCoords = "";

	//boolean variables to make it easy to find out later what sort of data has been 
	//entered by the searcher
	boolean userNull = username.equals("no username entered");
	boolean dateNull = dateString.equals("no date was entered");
	boolean locsNull = Sto.equals("no location entered") && Sfrom.equals("no location entered");

	//variable used to simplify if statements that find out if a certain search mode
	//should be used
	boolean anythingElse;
	
	//this is set to 'true' once a search method has been used to prevent other
	//search methods from being used as well
	boolean done = false;

	int rideNum;

	//---------------SEARCH RIDES BY USER----------------------------------
	String userTable = "";

	boolean userExist = false;
	
	anythingElse = !dateNull || !locsNull;

	if (!userNull && !anythingElse && !done) {
		//get list of rides matching search criteria
		RideListing u = cps.searchRideListing(RideListing.searchUser,
				username);
		
		done = true;
		//System.out.println("user");

		while (u.next()) {
			if (!userExist) {
				userTable = ""; //first time round get rid of unwanted text
			}

			String from = u.getStartLocation();
			String to = u.getEndLocation();

			String d = new SimpleDateFormat("dd/MM/yyyy").format(u.getRideDate()) + " " + u.getTime();
			Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);

			if (!avoidDuplicates.contains(u.getRideID())
					&& dt.after(new Date())) {
				userExist = true;

				avoidDuplicates.add(u.getRideID());

				//build list of co-ordinates to map
				mapCoords += u.getGeoLocation() + ":";
				
				//build table of rides
				if (user != null) {
				userTable += "<tr> <td>"
						+ "<a href='"
						+ response.encodeURL(request.getContextPath()
								+ "/profile.jsp?profileId="
								+ u.getUserID()) + "'>"
						+ u.getUsername() + "</a></td>";
				} else {
					userTable += "<tr> <td>" + u.getUsername() + "</td>";
				}
				userTable += "<td>" + from + "</td> ";
				userTable += "<td>" + to + "</td> ";
				userTable += "<td>"
						+ new SimpleDateFormat("dd/MM/yyyy").format(u
								.getRideDate()) + "</td> ";
				userTable += "<td>" + u.getTime() + "</td> ";
				userTable += "<td>" + u.getAvailableSeats() + "</td> ";
				if ((user != null)) {
					userTable += "<td> <a href='" + response.encodeURL(request.getContextPath()
							+ "/rideDetails.jsp?rideselect="
							+ u.getRideID() + "&userselect="
							+ u.getUsername()) + "'>"
							+ "Link to ride page" + "</a> </td> </tr>";
				} else {
					userTable += "<td>login to view more</td> </tr>";
				}
			} else {
				userTable = "";
			}
		}
	}

	//---------------SEARCH RIDES BY DATE----------------------------------
	String dateTable = "";
	boolean dateExist = false;

	anythingElse = !userNull || !locsNull;

	if (!dateNull && !anythingElse && !done) {

		//get list of rides matching search criteria
		RideListing daTbl = cps.searchRideListing(
				RideListing.searchDate, strOutDt);
		//System.out.println("date - "+strOutDt);
		
		done = true;

		while (daTbl.next()) {
			if (!dateExist) {
				dateTable = ""; //first time round get rid of unwanted text
			}

			//code to get the name associated with the street id
			String from = daTbl.getStartLocation();
			String to = daTbl.getEndLocation();

			String d = new SimpleDateFormat("dd/MM/yyyy").format(daTbl.getRideDate()) + " " + daTbl.getTime();
			Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);
			
			//System.out.println(dt.after(new Date()));

			if (!avoidDuplicates.contains(daTbl.getRideID()) && dt.after(new Date())) {
				
				dateExist = true;
				avoidDuplicates.add(daTbl.getRideID());

				//build list of co-ordinates to map
				mapCoords += daTbl.getGeoLocation() + ":";
				
				//build table of rides
				if (user != null) {
				dateTable += "<tr> <td>"
						+ "<a href='"
						+ response.encodeURL(request.getContextPath()
								+ "/profile.jsp?profileId="
								+ daTbl.getUserID()) + "'>"
						+ daTbl.getUsername() + "</a></td>";
				} else {
					userTable += "<tr> <td>" + daTbl.getUsername() + "</td>";
				}
				dateTable += "<td>" + from + "</td> ";
				dateTable += "<td>" + to + "</td> ";
				dateTable += "<td>"
						+ new SimpleDateFormat("dd/MM/yyyy")
								.format(daTbl.getRideDate()) + "</td> ";
				dateTable += "<td>" + daTbl.getTime() + "</td> ";
				dateTable += "<td>" + daTbl.getAvailableSeats()
						+ "</td> ";
				if ((user != null)) {
					dateTable += "<td> <a href='" + response.encodeURL(request.getContextPath()
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
			//System.out.println(mapCoords);
		}
	}
	
	

	//---------------SEARCH RIDES COMBO----------------------------------
	ArrayList<String> cTable = new ArrayList<String>();
	String tempTable = "";
	String comboTable = "";

	//used to keep track of rides through the selection process
	rideNum = 0;

	//used to simplify if statement later as part of first filter
	boolean addRide = false;
	
	//get all ride from databse
	RideListing rides = cps.getRideListing();

	if (!done) {
		//System.out.println("combo");
		done = true;
		while (rides.next()) {

			String from = rides.getStartLocation();
			String to = rides.getEndLocation();

			String d = new SimpleDateFormat("dd/MM/yyyy").format(rides.getRideDate())+ " " + rides.getTime();
			Date dt = new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(d);

			//depending on combinations of date and user inputs, decide if this ride should
			//go to the next stage of filters
			if (!userNull && !dateNull) {
				addRide = dateString.equals(new SimpleDateFormat("dd/MM/yyyy").format(rides.getRideDate())) && username.equals(rides.getUsername());
			} else if(userNull && !dateNull){
				addRide = dateString.equals(new SimpleDateFormat("dd/MM/yyyy").format(rides.getRideDate()));
			} else if(!userNull && dateNull){
				addRide = username.equals(rides.getUsername());
			} else {
				addRide = true;
			}

			if (!avoidDuplicates.contains(rides.getRideID())&& dt.after(new Date()) && addRide) {

				avoidDuplicates.add(rides.getRideID());
				
				//IF no locations have been entered then simply add the ride co-ordinates
				//to the list to be mapped
				//ELSE then add the co-ordinates to geoCodes for further procesing
				if(locsNull){
					mapCoords += rides.getGeoLocation();
				}else{
					geoCodes.add(rideNum + ">" + rides.getGeoLocation());
				}
				rideNum++;
				//System.out.println("mapCoords: |"+mapCoords+"|");
				
				//build table
				if (user != null) {
				tempTable += "<tr> <td>"+ "<a href='"+ response.encodeURL(request.getContextPath()+ "/profile.jsp?profileId="+ rides.getUserID()) + "'>"+ rides.getUsername() + "</a></td>";
				} else {
					tempTable += "<tr> <td>" + rides.getUsername() + "</td>";
				}
				tempTable += "<td>" + from + "</td> ";
				tempTable += "<td>" + to + "</td> ";
				tempTable += "<td>"+ new SimpleDateFormat("dd/MM/yyyy").format(rides.getRideDate()) + "</td> ";
				tempTable += "<td>" + rides.getTime() + "</td> ";
				tempTable += "<td>" + rides.getAvailableSeats()	+ "</td> ";
				if (user != null) {
					tempTable += "<td> <a href='"+ response.encodeURL(request.getContextPath()+ "/rideDetails.jsp?rideselect="+ rides.getRideID()+ "&userselect="+ rides.getUsername()) + "'>"+ "Link to ride page" + "</a> </td> </tr>";
				} else {
					tempTable += "<td>login to view more</td> </tr>";
				}
				
				cTable.add(tempTable);
				tempTable = "";
			} else {
				tempTable = "";
			}





		}
		
		//if locations have been entered
		if(!locsNull){
			//perform a detailed search of rides based on co-ordinates
			//get a list of rides with co-ordinates to be displayed
			String[] matches = getMatches(geoCodes, request.getParameter("fromCoord"), request.getParameter("toCoord"), userNull, dateNull);
			String[] rideIDs = matches[0].split(",");
			mapCoords = matches[1];
			//System.out.println("table" + rideIDs.length);
			
			//build table of rides
			if(!rideIDs[0].equals("")){
				if (rideIDs.length > 0) {
					for (int i = 0; i < rideIDs.length; i++) {
						comboTable += cTable.get(Integer.parseInt(rideIDs[i]));
						//System.out.println(i + " " + rideIDs[i]);
					}
				}
			}
		}else{
			//build table of rides
			for (int i = 0; i < cTable.size(); i++) {
				comboTable += cTable.get(i);
				//System.out.println(i);
			}
		}
		//System.out.println("mapCoords: |"+mapCoords+"|");
		
	}

	//---------------COMBINE RESULTS----------------------------------

	if (!mapCoords.equals("")) {
		//build final table of rides
		rideTable = userTable + dateTable + comboTable;
		rideTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"
				+ "<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th> <th>More Info</th> </tr>"
				+ rideTable + "</table>";
	} else {
		rideTable = "<div class='Box' id='Box'><p>Sorry, no rides were found that match your criteria.</p></div>";
	}
	//-------------------------------------------------------------------
%>

<%!public String[] getMatches(ArrayList<String> rides, String fromCoord, String toCoord, boolean user, boolean date){

	//**********
	//get co-ordinates from strings and put them into 'double' form
	//also, set up variable that will later be populated for each ride
	boolean noFrom = fromCoord.equals("");
	boolean noTo = toCoord.equals("");
	String[] result = new String[2];
	result[0] = "";
	result[1] = "";
	
	double sFromLat = 0;
	double sFromLng = 0;
	if(!noFrom){
		String[] searchFrom = fromCoord.split(",");
 		sFromLat = Double.parseDouble(searchFrom[0]);
 		sFromLng = Double.parseDouble(searchFrom[1]);
	}
	
	double sToLat = 0;
	double sToLng = 0;
	if(!noTo){
		String[] searchTo = toCoord.split(",");
		sToLat = Double.parseDouble(searchTo[0]);
		sToLng = Double.parseDouble(searchTo[1]);
	}
	
	ArrayList<Integer> id = new ArrayList<Integer>();
	
	double fromLat, fromLng;
	double toLat, toLng;
	
	double[] StartToSearcher, StartToEnd;
	
	String[] ride, rideLocs, from, to;
	//**********
	//**********
	
	for(int i=0;i<rides.size();i++){
		ride = rides.get(i).split(">");
		
		rideLocs = ride[1].split("/");
	
		//**********
		//get 'double' lat/long co-ords for this ride
		try{
			from = rideLocs[0].split(",");
			fromLat = Double.parseDouble(from[0]);
			fromLng = Double.parseDouble(from[1]);
		}catch(Exception e){
			fromLat = 0;
			fromLng = 0;
		}
		

		try{
			to = rideLocs[1].split(",");
			toLat = Double.parseDouble(to[0]);
			toLng = Double.parseDouble(to[1]);
		}catch(Exception e){
			toLat = 0;
			toLng = 0;
		}
		//**********
		//**********
			
		//find straight-line distance from the start of the ride to the end
		StartToEnd = distance(fromLat, fromLng, toLat, toLng);
		
		//come up with a sensible radius to search in (1km min)
		double radius = StartToEnd[0] * 0.1;
		if(radius < 1){
			radius = 1;
		}

		//if end points are within a suitable radius
		if(distance(sToLat, sToLng, toLat, toLng)[0] < radius){
			if(noFrom && ! noTo){
				result[0] += ride[0] + ",";
				result[1] += ride[1] + ":";
			}else if(!noFrom && !noTo){
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
	}
	return result;
}%>

<%!public double[] distance(double sLat, double sLng, double rLat, double rLng) {

		double result[] = new double[2];

		sLat = Math.toRadians(sLat);
		sLng = Math.toRadians(sLng);
		rLat = Math.toRadians(rLat);
		rLng = Math.toRadians(rLng);

		//formula based on example found here: http://www.movable-type.co.uk/scripts/latlong.html
		double earthRad = 6371; // km
		result[0] = Math.acos(Math.sin(sLat) * Math.sin(rLat) + Math.cos(sLat)
				* Math.cos(rLat) * Math.cos(rLng - sLng))
				* earthRad;

		//ditance between points
		result[0] = Math.abs(result[0]);

		double y = Math.sin(sLng - rLng) * Math.cos(rLat);
		double x = Math.cos(sLat) * Math.sin(rLat) - Math.sin(sLat)
				* Math.cos(rLat) * Math.cos(sLng - rLng);
		//bearing (in radians) of vector between the two points
		result[1] = (Math.atan2(y, x) + 2 * Math.PI) % Math.PI;

		return result;
	}%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<TITLE>Ride Search Results</TITLE>
<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
<%@include file="include/javascriptincludes.html"%>

</HEAD>
<BODY>

	
	<%@ include file="heading.html" %>

	<DIV class="Content" id="Content">
		<h2 class="title" id="title">Automatic Search</h2>
		<br /><br />
		<h2>Results:</h2>
		<div class="Box" id="Box">
		<br />
		<h3>You Searched For:</h3>
		<div class="Box" id="Box">
		<FORM NAME="resultFrm" id="result">	
			<TABLE class="rideSearch">
				<tr><td>Location from:</td> <td><%=Sfrom%></td></tr>
				<tr><td>Location to:</td> <td><%=Sto%></td></tr>
				<tr><td>Date:</td> <td><%=dateString%></td></tr>
				<tr><td>User:</td> <td><%=username%></td>
			</TABLE>
		</FORM>
		</div>
		<br />
		<h3>Rides Found:</h3>
		<%=rideTable %>
	<br />
	<FORM NAME="resultFrm" id="result"  method="post" action="displayResultsMap.jsp" target = "_blank">
	<input type="hidden" name="mapCoords" value="<%=mapCoords %>"/>
	<p>Click here to <input type="submit" value="View Map"/></p>
	</FORM>
	</div>

		<br /><br />
		<p>-- <a href="<%=response.encodeURL("searchRides.jsp")%>">Go back to Search page</a> --</p>
	</DIV>



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
