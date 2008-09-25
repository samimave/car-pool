<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>
<%
HttpSession s = request.getSession(false);

//force the user to login to view the page
//System.out.println(OpenIdFilter.getCurrentUser(s));
//System.out.println(s.getAttribute("signedin"));
if (OpenIdFilter.getCurrentUser(s) == null && s.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

//being nice to our users
String message = "";

CarPoolStore cps = new CarPoolStoreImpl();

User user = (User)s.getAttribute("user");
int dbID = user.getUserId();
int rideID = Integer.parseInt(request.getParameter("rideselect"));
RideListing u = cps.searchRideListing(RideListing.searchUser, request.getParameter("userselect"));


String detailsTable = "<p>No info found.</p>";
boolean ridesExist = false;
String from = "";
String to = "";

//System.out.println("got here!");
while (u.next()) {					
	if (u.getRideID() == rideID) {
		if (!ridesExist) {
			detailsTable = "";		//first time round get rid of unwanted text
		}
		ridesExist = true;
		from = u.getEndLocation();
		to = u.getStartLocation();
		
		detailsTable += "<tr> <td>Username:</td>  <td>"+ u.getUsername() +"</td></tr> ";
		detailsTable += "<tr> <td> Start Region: </td> <td>"+ from + "</td> </tr>";
		detailsTable += "<tr> <td> Stop Region: </td> <td>"+ to +"</td></tr> ";
		detailsTable += "<tr> <td>Date: </td> <td>"+ u.getRideDate() +"</td></tr> ";
		detailsTable += "<tr> <td> Time: </td> <td>" + u.getTime()+ "</td> </tr>";
		detailsTable += "<tr> <td> Seats: </td> <td>"+ u.getAvailableSeats() +"</td> </tr>";
		detailsTable += "<tr> <td> Additional Info: </td> <td></td> </tr>";
	}
}
//finish table
if (ridesExist) {
	detailsTable = "<table class='rideDetailsSearch'>"+ detailsTable +"</table>";	
}

//make the options for the street select box
LocationList locations = cps.getLocations();
String options = "";
while (locations.next()){
	options += "<option value='"+locations.getID()+"'>"+locations.getStreetName()+"</option>";
}

%>

<%
///////////////////////////
//view ride comments code//
///////////////////////////
Vector<String> comments = cps.getRideComment(rideID);
String[] the_comment;
String reDirURL = "myRideEdit.jsp?rideselect=" + rideID + "&userselect=" + request.getParameter("userselect");


//table builder
String evenRow = "<tr bgcolor=\"#EEEEEE\">";
String oddRow = "<tr bgcolor=\"white\">";
String col1 = "<td width=\"15%\">";
String col2 = "</td><td width=\"10%\">";
String col3 = "</td><td width=\"75%\">";
String endRow = "</td></tr>";

String table = "<table width = \"100%\">";

String delButton;

//create headings
table += evenRow + col1 + "Comment #" + col2 + "User" + col3 + "Comment" + endRow;

//if no comments for ride then say so
if(comments.size() < 1){
	table += oddRow + "<td colspan=\"3\">Sorry, could not find any comments for this ride.  Please feel free to add one below</td></tr>";	
}

//add comments, shading in every second row
for(int i=0;i<comments.size();i++){
	the_comment = comments.elementAt(i).split("_delim_");
	if(i%2 != 0){
		table += evenRow;
	}else{
		table += oddRow;
	}
	try{
	if(Integer.parseInt(the_comment[1]) == dbID){
		delButton = "<FORM action=\"delAComment.jsp\" method=\"post\">";
		delButton += "<INPUT type=\"hidden\" name=\"idComment\" value=\"" + the_comment[0] + "\">";
		delButton += "<INPUT type=\"hidden\" name=\"reDirURL\" value=\"" + reDirURL + "\">";
		delButton += "<INPUT type=\"submit\" value=\"Delete Comment\" />";
		delButton += "</FORM>";
	}else{
		delButton = "";
	}
	table += col1 + the_comment[0] + col2 + the_comment[1] + col3 + the_comment[3] + delButton + endRow;
	}catch(Exception e){
		table += endRow;
	}
}

//close table
table += "</table>";

///////////////////////////
///////////////////////////
%>

<HTML>
	<HEAD>

		<TITLE> Ride Details </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>

	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	<DIV class="content">
		<h2>The ride details appear below:</h2>
		<%=detailsTable %><br>
		<FORM name="showMap" id="map2" method="post" target="_blank" action="displayRouteMap.jsp">
			<INPUT type="submit" value="View Map" > 
			<INPUT type="hidden" name="mapFrom" value= "<%=from%>">
			<INPUT type="hidden" name="mapTo"  value= "<%=to%>" >
		</FORM>
		<FORM name="withdraw" action="rideEditSuccess.jsp" method="post">
			<INPUT type="hidden" name="rideSelect" value="<%=request.getParameter("rideselect") %>">
			<TABLE class='rideWithdraw'>
				<tr> <td>&nbsp;</td> <td><INPUT type="submit" name="removeRide" value="Withdraw Ride" size="25"></td> </tr>
			</TABLE>
		</FORM>
	
		<%=table %>
		<FORM name = "addComment" action="addAComment.jsp" method="post">
			<TABLE width="100%">
				<tr><td align=center>
					<INPUT type="hidden" name="idRide" value="<%=rideID %>">
					<INPUT type="hidden" name="idUser" value="<%=dbID %>">
					<INPUT type="hidden" name="reDirURL" value="<%=reDirURL %>"/>
					<TEXTAREA cols="50" rows="4" name="comment"></TEXTAREA>
				</td></tr>
				<tr><td align=center>
					<INPUT type="submit" value="Add Comment" />
				</td></tr>
		</FORM>

	</DIV>

		




	</BODY>
</HTML>