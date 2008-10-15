<%@page contentType="text/html; charset=ISO-8859-1" import="java.util.*, java.text.*, car.pool.persistance.*, org.verisign.joid.consumer.OpenIdFilter"%>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

//simple date processing for display on page
Date now = new Date();
String time = DateFormat.getTimeInstance(DateFormat.SHORT).format(now);
String date = DateFormat.getDateInstance().format(now);
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

<HTML>
	<HEAD>
		<TITLE> Offer or Request a Ride </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
		<SCRIPT type="text/javascript" src="CalendarPopup.js"></SCRIPT>
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

			// a function to get the from and to streets from the combobox and pass them to the 
			// form call "showMap" which then post to the "displayRouteMap.jsp" to be display on google map
      		function getAddress(){
      			  startIdx = document.getElementById("offer").streetFrom.selectedIndex;
      		   	  startLoc = document.getElementById("offer").streetFrom.options[startIdx].text;
     			  endIdx   = document.getElementById("offer").streetTo.selectedIndex;
     		   	  endLoc   = document.getElementById("offer").streetTo.options[endIdx].text;
     		   	  houseNum  = document.getElementById("offer").houseFrom.value;
     		   	  document.getElementById("map").mapFrom.value=startLoc;
     		   	  document.getElementById("map").mapTo.value=endLoc;
     		   	  document.getElementById("map").mapHouse.value=houseNum;
     		   	 
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

		<DIV class="content">
			<p>Please enter the relevant details and click confirm.</p>
			<FORM NAME="offerFrm" id="offer" method="post" action="newRideConfirmation.jsp">
				<INPUT TYPE="hidden" NAME="user" VALUE="<%=OpenIdFilter.getCurrentUser(request.getSession())%>" SIZE="25">
					<TABLE class="rideDetails">

					<%// Information on if ride is an offer or request. 
					 //If Ride is a request then numSeats label should be no. of seats requested
					 //else it should be no. of seats available.%>
					<tr> <td>Ride Type:</td> <td>	
					<SELECT name="rideType">
						<option value="Ride Offer">Ride Offer</option>
					</SELECT></td> </tr>	

					<% /* Location FROM, TO & VIA. 
						Streets is a combo box so user can type or use drop down to select
						a street. All streets boxes will need to be populated 
						from the database table streets*/%>
					
					<tr> <th> <h2>Location:</h2> </th> <th>&nbsp;</th> </tr>	
					<tr> <td>DEPARTURE FROM -</td> </tr>
					<tr> <td>House number:</td> 
					<td><INPUT TYPE="text" NAME="houseFrom" SIZE="25"></td> </tr>
					<tr> <td>Street:</td> <td>
					<SELECT name="streetFrom"  onChange="getAddress()">
           		  		<option selected="selected">Select a Street</option>
	           		 	<%=options %>
       				</SELECT></td> </tr>
        			<tr> <td>Region: Palmerston North</td> </tr>
					<tr><td>ARRIVAL AT -</td></tr> 
					<tr> <td>Street:</td> <td>
					<SELECT name="streetTo" onChange="getAddress()">
           		  		<option selected="selected">Select a Street</option>
	           		  	<%=options %>
       				 </SELECT></td> </tr>

					<tr> <td>Region: Palmerston North</td> </tr>

					<%/* If one off option is chosen then user can choose date(s) of ride and if
					regular is chosen user can choose startDate, days of ride and endDate*/%>
					<tr> <th> <h2>Timing:</h2> </th> <th>&nbsp;</th> </tr>
					<tr> <td>Recurrence:</td> <td>
					<SELECT name="recurrence"  onchange="process_choice(this,document.offerFrm.depDate, document.offerFrm.depDays, document.offerFrm.calIcon, document.offerFrm.calIcon)">
						<option value="sel">Select an Option</option>
						<option value="0">One-Off</option>
						<option value="1">Regular</option>
					</SELECT></td> </tr>
					
					<tr> <td>Date (dd/MM/yyyy):</td> <td><INPUT TYPE="text" NAME="depDate" style="display: none" VALUE="<%= date %>" SIZE="25"> <A HREF="#" onClick="cal.select(document.forms['offerFrm'].depDate,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img name="calIcon" style="display: none" border="0" src="calendar_icon.jpg" width="27" height="23"></A> </td> </tr> 
					<tr> <td>Days:</td> <td>
					<SELECT name="depDays" multiple="true" style="display: none">
						<option value=1>Monday</option>
						<option value =2>Tuesday</option>
						<option value =3>Wednesday</option>
						<option value=4>Thursday</option>
						<option value=5>Friday</option>
						<option value=6>Saturday</option>
						<option value=7>Sunday</option>
					</SELECT></td> </tr>
					
					<tr> <td>Departure Time (hh:mm):</td> <td><INPUT TYPE="text" NAME="depTime" VALUE="<%= time %>" SIZE="25"></td> </tr>
					<tr> <td>Approximate Trip Length (minutes):</td> <td><INPUT TYPE="text" NAME="tripLength" VALUE="15" SIZE="25"></td> </tr>

					<tr> <th> <h2>Additional Details:</h2> </th> <th>&nbsp;</th> </tr>	
					<tr> <td>Number of passenger seats:</td> <td><INPUT TYPE="text" NAME="numSeats" SIZE="25"></td> </tr>

					<tr> <td>Other Comments (e.g. place of departure):</td> <td><INPUT TYPE="text" NAME="xtraInfo" SIZE="25"></td> </tr>
					<tr> <td><INPUT TYPE="submit" NAME="submit" VALUE="Confirm" SIZE="25"></td> <td>&nbsp;</td> </tr>
				</TABLE>

			</FORM>

		</DIV>
		
			<FORM name="showMap" id="map" method="post" target="_blank" action="displayRouteMap.jsp">
					<INPUT type="submit" value="View Map" onClick="getAddress()"/> 
					<INPUT type="hidden" name="mapFrom" >
				    <INPUT type="hidden" name="mapTo"   >
					<INPUT type="hidden" name="mapHouse" >
			</FORM>
	
	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>
	

	</BODY>
</HTML>
