<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, java.text.SimpleDateFormat,car.pool.user.*,java.util.*" %>

<%
CarPoolStore cps = new CarPoolStoreImpl();

User user = null;
//check if the user is logged in and viewing the page
if (!(OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null)) {
	user = (User)session.getAttribute("user"); 
}

//----------------------search parameters------------------------
//USERNAME
String username = "no username entered";
if (request.getParameter("sUser")!=""){
	username = request.getParameter("sUser");
}
else {
	username = "no username entered";
}

//DATE
//date formatting for use by db 
//dd/MM/yyyy -> yyyy-MM-dd
String strOutDt = "no date entered";
String strTmp = request.getParameter("searchDate");
if (strTmp != ""){ 
	Date dtTmp = new SimpleDateFormat("dd/MM/yyyy").parse(strTmp);
	strOutDt = new SimpleDateFormat("yyyy-MM-dd").format(dtTmp);
}
else {
	strTmp = "no date was entered";
}

//FROM AND TO
String Sfrom = "";
String Sto = "";

String fromIdx = request.getParameter("searchFrom");
String toIdx = request.getParameter("searchTo");

if (fromIdx.contains("Select a Street")){
	Sfrom = "no location entered";}
else{
	//code to get the name associated with the street id
	LocationList allLocs = cps.getLocations();
	while (allLocs.next()){
		if ((allLocs.getID() == Integer.parseInt(fromIdx))) {
			Sfrom = allLocs.getStreetName();	
		} 
	}
}

if (toIdx.contains("Select a Street")){
	Sto = "no location entered";}
else {
	//code to get the name associated with the street id
	LocationList allLocs = cps.getLocations();
	while (allLocs.next()){
		if ((allLocs.getID() == Integer.parseInt(toIdx))) {
			Sto = allLocs.getStreetName();	
		} 
	}
}
//----------------------end search parameters------------------------


//##############################ALL RIDES TABLE##############################



String allTable = "";
RideListing all = cps.getRideListing();
while (all.next()) {
	String from = all.getStartLocation();
	String to = all.getEndLocation();
	
	allTable += "<tr> <td>"+ all.getUsername() +"</td> ";	
	allTable += "<td>"+ from +"</td> ";
	allTable += "<td>"+ to +"</td> ";
	allTable += "<td>"+ all.getRideDate() +"</td> ";
	allTable += "<td>"+ all.getTime() +"</td> ";
	allTable += "<td>"+ all.getAvailableSeats() +"</td> ";
	if (user != null) {
		allTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ all.getRideID() +"'>"+ "Link to ride page" +"</a> </td> </tr>";
	} else {
		allTable += "<td>login to view more</td> </tr>";
	}
}


//##############################SEARCH RIDE TABLE##############################

ArrayList<Integer> avoidDuplicates = new ArrayList<Integer>();

//---------------SEARCH RIDES BY USER----------------------------------
String userTable = "";
boolean userExist = false;

if (username != "no username entered")	{
	RideListing u = cps.searchRideListing(RideListing.searchUser, username);
	
	while (u.next()) {
		if (!userExist) {
			userTable = "";		//first time round get rid of unwanted text
		}
		userExist = true;
		
		String from = u.getEndLocation();
		String to = u.getStartLocation();

		if (!avoidDuplicates.contains(u.getRideID())){
			avoidDuplicates.add(u.getRideID());
			
			userTable += "<tr> <td>"+ u.getUsername() +"</td> ";	
			userTable += "<td>"+ from +"</td> ";
			userTable += "<td>"+ to +"</td> ";
			userTable += "<td>"+ u.getRideDate() +"</td> ";
			userTable += "<td>"+ u.getTime() +"</td> ";
			userTable += "<td>"+ u.getAvailableSeats() +"</td> ";
			if (user != null) {
				userTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ u.getRideID() +"&userselect="+u.getUsername()+"'>"+ "Link to ride page" +"</a> </td> </tr>";
			} else {
				userTable += "<td>login to view more</td> </tr>";
			}
		}
		else {
			userTable = "";
		}

	}
}

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
		String from = daTbl.getEndLocation();
		String to = daTbl.getStartLocation();

		if (!avoidDuplicates.contains(daTbl.getRideID())){
			avoidDuplicates.add(daTbl.getRideID());
			
			dateTable += "<tr> <td>"+ daTbl.getUsername() +"</td> ";	
			dateTable += "<td>"+ from +"</td> ";
			dateTable += "<td>"+ to +"</td> ";
			dateTable += "<td>"+ daTbl.getRideDate() +"</td> ";
			dateTable += "<td>"+ daTbl.getTime() +"</td> ";
			dateTable += "<td>"+ daTbl.getAvailableSeats() +"</td> ";
			if (user != null) {	
				dateTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ daTbl.getRideID() +"&userselect="+daTbl.getUsername()+"'>"+ "Link to ride page" +"</a> </td> </tr>";
			} else {
				dateTable += "<td>login to view more</td> </tr>";
			}
		}
		else {
			dateTable = "";
		}
		
	}
}


//---------------SEARCH RIDES BY FROM ONLY----------------------------------
String fromTable = "";
boolean fromExist = false;

if (Sfrom != "no location entered") {
	RideListing f = cps.searchRideListing(RideListing.searchLocationStart, Sfrom);
	
	while (f.next()) {
		if (!fromExist) {
			fromTable = "";		//first time round get rid of unwanted text
		}
		fromExist = true;
		

		String from = f.getStartLocation();
		String to = f.getEndLocation();

		if (!avoidDuplicates.contains(f.getRideID())){
			avoidDuplicates.add(f.getRideID());
			
			fromTable += "<tr> <td>"+ f.getUsername() +"</td> ";	
			fromTable += "<td>"+ from +"</td> ";
			fromTable += "<td>"+ to +"</td> ";
			fromTable += "<td>"+ f.getRideDate() +"</td> ";
			fromTable += "<td>"+ f.getTime() +"</td> ";
			fromTable += "<td>"+ f.getAvailableSeats() +"</td> ";
			if (user != null) {
				fromTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ f.getRideID()  +"&userselect="+f.getUsername()+"'>"+ "Link to ride page" +"</a> </td> </tr>";
			} else {
				fromTable += "<td>login to view more</td> </tr>";
			}
		}
		else{
			fromTable = "";
		}
		
	}
}



//---------------SEARCH RIDES BY TO ONLY----------------------------------
String toTable = "";
boolean toExist = false;

if (Sto != "no location entered") {
	RideListing t = cps.searchRideListing(RideListing.searchLocationEnd, Sto);
	
	while (t.next()) {
		if (!toExist) {
			toTable = "";		//first time round get rid of unwanted text
		}
		toExist = true;

		String from = t.getStartLocation();
		String to = t.getEndLocation();
		
		if (!avoidDuplicates.contains(t.getRideID())){
			avoidDuplicates.add(t.getRideID());
			
			toTable += "<tr> <td>"+ t.getUsername() +"</td> ";	
			toTable += "<td>"+ from +"</td> ";
			toTable += "<td>"+ to +"</td> ";
			toTable += "<td>"+ t.getRideDate() +"</td> ";
			toTable += "<td>"+ t.getTime() +"</td> ";
			toTable += "<td>"+ t.getAvailableSeats() +"</td> ";
			if (user != null) {
				toTable += "<td> <a href='"+ request.getContextPath() +"/temp2.jsp?rideselect="+ t.getRideID() +"&userselect="+t.getUsername() +"'>"+ "Link to ride page" +"</a> </td> </tr>";
			} else {
				toTable += "<td>login to view more</td> </tr>";
			}
		}
		else {
			toTable = "";
		}
	
	}
}

//---------------COMBINE RESULTS----------------------------------
	String rideTable = "";
	boolean ridesExist= false;
	if ((userExist) || (dateExist) || (fromExist) || (toExist)){
		ridesExist=true;
		rideTable = userTable+dateTable+fromTable+toTable;
	}
	 
	if (ridesExist) {
		rideTable = "<table class='rideDetailsSearch'> <tr> <th>Ride Offered By</th> <th>Starting From</th> <th>Going To</th>"+
			"<th>Departure Date</th> <th>Departure Time</th> <th>Number of Available Seats</th> <th>More Info</th> </tr>"+ rideTable +"</table>";
	}
	else if ((username=="no username was entered")&&(strTmp=="no date was entered")&&(Sfrom == "no location was entered")&&(Sto=="no location was entered")){
		rideTable = allTable;
	}
	else {
		rideTable = "<tr><td>No rides were found</td></tr>";
	}
//-------------------------------------------------------------------

%>

<HTML>
	<HEAD>
		<TITLE>Ride Search Results</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css"; </STYLE>
	</HEAD>
	<BODY>
<%@ include file="heading.html" %>
		<DIV class="content">
		
			<FORM NAME="resultFrm" id="result">	
				<TABLE class="rideSearch">
					<tr><td>You searched for -</td></tr>
					<tr><td>Location from:</td> <td><%=Sfrom%></td></tr>
					<tr><td>Location to:</td> <td><%=Sto%></td></tr>
					<tr><td>Date:</td> <td><%=strTmp%></td></tr>
					<tr><td>User:</td> <td><%=username %></td>
	
					<tr><td>Search results appear below</td></tr>
					<%=rideTable %>
					
					<tr><td> <a href=searchRides.jsp>Go back to Search page</a> </td> </tr>

				</TABLE>
			</FORM>
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
