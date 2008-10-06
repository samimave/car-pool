<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="java.util.*, java.text.*, car.pool.persistance.*, org.verisign.joid.consumer.OpenIdFilter, car.pool.user.*"%>

<%
HttpSession s = request.getSession(false);

//force the user to login to view the page
//user a container for the users information
User user = null;
if(s.getAttribute("signedin") != null ) {
	user = (User)s.getAttribute("user");
} else {
	response.sendRedirect(request.getContextPath());
}

//simple date processing for display on page
Date now = new Date();
String time = new SimpleDateFormat("HH:mm").format(now);
String date = new SimpleDateFormat("dd/MM/yyyy").format(now);
CarPoolStore cps = new CarPoolStoreImpl();

//make the options for the street select box
LocationList locations = cps.getLocations();
String options = "";
//if (locations != null) {
	while (locations.next()){
		options += "<option value='"+locations.getID()+"'>"+locations.getStreetName()+"</option>";
	}
//}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE> Offer a Ride </TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<SCRIPT type="text/javascript" src="CalendarPopup.js"></SCRIPT>
    	<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ" type="text/javascript"></script>
 
		<script type="text/javascript">
			var locations = new Array();
			
			<%
			LocationList loc = cps.getLocations();
			for(int i = 0; loc.next(); i++) {
				%>locations[<%=i%>] = <%=loc.getStreetName()%>;<%
			}
			%>
			 function getAddress1(addrs){
                 var from = "";
                 //LocationList loc = cps.getLocations();
                 addrs = document.getElementById('streetFrom').value;
                         // from = locations.getStreetName(addrs);
                 for(i = 0; i < locations.length; i++ ) {
                     if(i == addrs) {
                         return locations[i];
                     }
                 }

                 return -1;
                         
         }
		</script>
		<SCRIPT type="text/javascript">
			var cal = new CalendarPopup();

			//PLEASE LEAVE THESE THREE FUNCTIONS HERE
			//for some reason they have to be above getAddress for geocoder to work
			function codeFrom(response) {
				document.getElementById("offer").fromCoord.value=response.lat() + "," + response.lng();
				//getLength();
				}
			function codeTo(response) {
				document.getElementById("offer").toCoord.value=response.lat() + "," + response.lng();
				//getLength();
				}
			function getLength(){
    			  fromCoord = document.getElementById("offer").fromCoord.value;
    			  fromCoord = fromCoord.split(",");
      		   	  toCoord = document.getElementById("offer").toCoord.value;
      		   	  toCoord = toCoord.split(",");

      		   	  fromPoint = new GLatLng(parseFloat(fromCoord[0]). parseFloat(fromCoord[1]));
      		   	  toPoint = new GLatLng(parseFloat(toCoord[0]). parseFloat(toCoord[1]));

      		   	  length = fromPoint.getDistance(toPoint);
      		   	  alert(length);
				
			}
			// a function to get the from and to streets from the combobox and pass them to the 
			// form call "showMap" which then post to the "displayRouteMap.jsp" to be display on google map
      		function getAddress(origin){
      			  startIdx = document.getElementById("offer").streetFrom.selectedIndex;
      		   	  startLoc = document.getElementById("offer").streetFrom.options[startIdx].text;
     			  endIdx   = document.getElementById("offer").streetTo.selectedIndex;
     		   	  endLoc   = document.getElementById("offer").streetTo.options[endIdx].text;
     		   	  houseNum  = document.getElementById("offer").houseFrom.value;
     		   	  document.getElementById("map").mapFrom.value=startLoc;
     		   	  document.getElementById("map").mapTo.value=endLoc;
     		   	  document.getElementById("map").mapHouse.value=houseNum;

     		   	  var geocoder = new GClientGeocoder();

     		   	  var from = houseNum + " " + startLoc + " PALMERSTON NORTH NEW ZEALAND";
     		   	  var to = endLoc + " PALMERSTON NORTH NEW ZEALAND";
    		   	
     		   	  if(origin == "from"){geocoder.getLatLng(from, codeFrom);}
     		   	  if(origin == "to"){geocoder.getLatLng(to, codeTo);}
   		   	 
      		}
      		
			function activate(field) {
				field.disabled=false;
				if(document.styleSheets)field.style.display  = 'inline';
				  	field.focus(); 
			}
			function process_choice(selection,textfield, selectfield, image) {
				if (selection.value == 'sel'){
					textfield.style.display = 'none';
					selectfield.style.display = 'none';
					image.style.display = 'none';
				}
				if(selection.value == '0') {
					activate(textfield); 
					activate(image);
				    selectfield.style.display = 'none';
				    selectfield.disabled = true; 
				    if(document.styleSheets)selectfield.style.display  = 'none';
				    	selectfield.value = ''; 
				 }
				if(selection.value == '1') {
					activate(selectfield)
					image.style.display = 'none';
					textfield.style.display = 'none';
				    textfield.disabled = true; 
				    if(document.styleSheets)textfield.style.display  = 'none';
				    	textfield.value = ''; 
				 }


			
			}

		</SCRIPT>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>	

		<DIV class="Content" id="Content" >
			<p>Please enter the relevant details and click confirm.</p>
			<FORM NAME="offerFrm" id="offer" method="post" action="newRideConfirmation.jsp">
				<INPUT TYPE="hidden" NAME="user" VALUE="<%=OpenIdFilter.getCurrentUser(s)%>" SIZE="25">
					<TABLE class="rideDetails">
					<%// Information on if ride is an offer or request. 
					 //If Ride is a request then numSeats label should be no. of seats requested
					 //else it should be no. of seats available.
					//<tr> <td>Ride Type:</td> <td>	
					//<SELECT name="rideType">
					//	<option value="Ride Offer">Ride Offer</option>
					//</SELECT></td> </tr>	
					//<tr><th>&nbsp;</th></tr> %>

					<% /* Location FROM, TO & VIA. 
						Streets is a combo box so user can type or use drop down to select
						a street. All streets boxes will need to be populated 
						from the database table streets*/%>
					<tr> <th colspan='2' style='border:2px outset #333333'>Departure From</th><th>&nbsp;</th> </tr>	
					<tr><th>&nbsp;</th></tr> 
					<tr> <td>House number:</td> 
					<td><INPUT TYPE="text" NAME="houseFrom" SIZE="25"></td> </tr>
					<tr> <td>Street:</td> <td>
					<SELECT name="streetFrom"  onChange="getAddress('from')">
           		  		<option selected="selected">Select a Street</option>
	           		 	<%=options %>
       				</SELECT></td> </tr>
        			<tr> <td>Region:</td> <td>Palmerston North</td> </tr>
					<tr><th>&nbsp;</th></tr> 

					<tr> <th colspan='2' style='border:2px outset #333333'>Arrival At</th><th>&nbsp;</th> </tr>	
					<tr><th>&nbsp;</th></tr> 
					<tr> <td>House number:</td> 
					<td><INPUT TYPE="text" NAME="houseTo" SIZE="25"></td> </tr>
					<tr> <td>Street:</td> <td>
					<SELECT name="streetTo" onChange="getAddress('to')">
           		  		<option selected="selected">Select a Street</option>
	           		  	<%=options %>
       				 </SELECT></td> </tr>
					<tr> <td>Region:</td>  <td>Palmerston North</td> </tr>
					<tr><th>&nbsp;</th></tr> 

					<%/* If one off option is chosen then user can choose date(s) of ride and if
					regular is chosen user can choose startDate, days of ride and endDate*/%>
					<tr> <th colspan='2' style='border:2px outset #333333'>Timing</th><th>&nbsp;</th> <th>&nbsp;</th> </tr>
					<tr><th>&nbsp;</th></tr> 
					<tr> <td>Recurrence:</td> <td>
					<SELECT name="recurrence"  onchange="process_choice(this,document.offerFrm.depDate, document.offerFrm.depDays, document.offerFrm.calIcon, document.offerFrm.calIcon)">
						<option value="sel">Choose date or days</option>
						<option value="0">One-Off</option>
						<option value="1">Regular</option>
					</SELECT></td> </tr>
					
					<tr><td>&nbsp;</td> <td><INPUT TYPE="text" NAME="depDate" style="display: none" VALUE="(dd/MM/yyyy)" SIZE="25"> <A HREF="#" onClick="cal.select(document.forms['offerFrm'].depDate,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img name="calIcon" style="display: none" border="0" src="calendar_icon.jpg" width="27" height="23"></A> </td> </tr> 
					<tr> <td>&nbsp;</td><td><SELECT name="depDays" multiple="true" style="display: none">
						<option value=1>Monday</option>
						<option value =2>Tuesday</option>
						<option value =3>Wednesday</option>
						<option value=4>Thursday</option>
						<option value=5>Friday</option>
						<option value=6>Saturday</option>
						<option value=7>Sunday</option>
					</SELECT></td> </tr>
					
					<tr> <td>Departure Time(hh:mm):</td> <td><INPUT TYPE="text" NAME="depTime" VALUE="<%= time %>" SIZE="25"></td> </tr>
					<tr> <td>Approx Trip Length(min):</td> <td><INPUT TYPE="text" NAME="tripLength" VALUE="15" SIZE="25"></td> </tr>
					
					<tr><th>&nbsp;</th></tr> 
					<tr>  <th colspan='2' style='border:2px outset #333333'>Additional Details</th> <th>&nbsp;</th> <th>&nbsp;</th> </tr>	
					<tr><th>&nbsp;</th></tr>
					<tr> <td>Number of passenger seats:</td> <td><INPUT TYPE="text" NAME="numSeats" SIZE="25"></td> </tr>

					<tr> <td>Other Comments:</td> <td><INPUT TYPE="text" NAME="xtraInfo" SIZE="25"></td> </tr>
					<tr> <td><INPUT TYPE="hidden" NAME="fromCoord" SIZE="25"></td> </tr>
					<tr> <td><INPUT TYPE="hidden" NAME="toCoord" SIZE="25"></td> </tr>
					<tr> <td><INPUT TYPE="submit" NAME="submit" VALUE="Confirm" SIZE="25"></td> <td>&nbsp;</td> </tr>
				</TABLE>

			</FORM>
			<br />
			<FORM name="showMap" id="map" method="post" target="_blank" action="displayRouteMap.jsp">
					<INPUT type="submit" value="View Map" onClick="getAddress()"/> 
					<INPUT type="hidden" name="mapFrom" >
				    <INPUT type="hidden" name="mapTo"   >
					<INPUT type="hidden" name="mapHouse" >
			</FORM>
		</DIV>
		
	<%@ include file="leftMenu.html" %>

	</BODY>
</HTML>
