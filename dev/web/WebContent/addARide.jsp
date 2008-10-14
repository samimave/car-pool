<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="java.util.*,java.text.*,car.pool.persistance.*,org.verisign.joid.consumer.OpenIdFilter,car.pool.user.*"%>

<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	//user a container for the users information
	User user = null;								//current user
	Date now = null;								//current time
	String time = "";								//holds current time
	String date = "";								//holds current day 
	CarPoolStore cps = null;						//contains important information
	String options = "";							//holds the streets, used to populate the drop down boxes
	if (s.getAttribute("signedin") != null) {											//if the user is logged in
		user = (User) s.getAttribute("user");

		//simple date processing for display on page
		now = new Date();
		time = new SimpleDateFormat("HH:mm").format(now);								//format time string
		date = new SimpleDateFormat("dd/MM/yyyy").format(now);							//format date string
		cps = new CarPoolStoreImpl();

		//make the options for the street select box
		LocationList locations = cps.getLocations();									//get street information
		options = "";
		//if (locations != null) {
		while (locations.next()) {
			options += "<option value='" + locations.getID() + "'>"						//populate the dropdown box with streets information from db
					+ locations.getStreetName() + "</option>";
		}
		//}
	} else {
		response.sendRedirect(response.encodeURL(request.getContextPath()));			//if the user is not logged in redirect them to the login page
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE>Offer a Ride</TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<SCRIPT type="text/javascript" src="javascript/CalendarPopup.js"></SCRIPT>
		<script type="text/javascript" src="javascript/yav.js"></script>
		<script type="text/javascript" src="javascript/yav-config.js"></script>
		<script type="text/javascript" src="javascript/date.js"></script>
    	<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAwEEggV_Hd8onlfSgA_kgZBTz-RVM6WN_1Yrxj3B45o6dXx3SPxRBd9zQMOS18U6DzRdS0kg6JbFdlA" type="text/javascript"></script>
 
		<script type="text/javascript">
			var locations = new Array();
			
			<%LocationList loc = cps.getLocations();
			for (int i = 0; loc.next(); i++) {%>locations[<%=i%>] = <%=loc.getStreetName()%>;<%}%>
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
				document.getElementById("offerFrm").fromCoord.value=response.lat() + "," + response.lng();
				//getLength();
				}
			function codeTo(response) {
				document.getElementById("offerFrm").toCoord.value=response.lat() + "," + response.lng();
				//getLength();
				}
			function getLength(){
    			  fromCoord = document.getElementById("offerFrm").fromCoord.value;
    			  fromCoord = fromCoord.split(",");
      		   	  toCoord = document.getElementById("offerFrm").toCoord.value;
      		   	  toCoord = toCoord.split(",");

      		   	  fromPoint = new GLatLng(parseFloat(fromCoord[0]). parseFloat(fromCoord[1]));
      		   	  toPoint = new GLatLng(parseFloat(toCoord[0]). parseFloat(toCoord[1]));

      		   	  length = fromPoint.getDistance(toPoint);
      		   	  alert(length);
				
			}
			// a function to get the from and to streets from the combobox and pass them to the 
			// form call "showMap" which then post to the "displayRouteMap.jsp" to be display on google map
      		function getAddress(origin){
      			  startIdx = document.getElementById("offerFrm").streetFrom.selectedIndex;
      		   	  startLoc = document.getElementById("offerFrm").streetFrom.options[startIdx].text;
     			  endIdx   = document.getElementById("offerFrm").streetTo.selectedIndex;
     		   	  endLoc   = document.getElementById("offerFrm").streetTo.options[endIdx].text;
     		   	  houseNum  = document.getElementById("offerFrm").houseFrom.value;
				  destNum = document.getElementById("offerFrm").houseTo.value;
     		   	  document.getElementById("map").mapFrom.value=startLoc;
     		   	  document.getElementById("map").mapTo.value=endLoc;
     		   	  document.getElementById("map").mapHouse.value=houseNum;

     		   	  var geocoder = new GClientGeocoder();

     		   	  var from = houseNum + " " + startLoc + " PALMERSTON NORTH NEW ZEALAND";
     		   	  var to = destNum + " " + endLoc + " PALMERSTON NORTH NEW ZEALAND";
    		   	
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
		<script>

		//http://www.mattkruse.com/javascript/date/ for helpful examples
		//validates the time entered on the page with respect to the date		
		function checkTime() {
		    var msg;
		    var reg = new RegExp("^[0-2][0-9]:[0-5][0-9]$");
		    var curTime = formatDate(new Date(),"HH:mm");
		    var inpTime = document.forms['offerFrm'].depTime.value;
		    if ( reg.test(inpTime) ) {
				var curDate = formatDate(new Date(),"dd/MM/yyyy");
				var inpDate = document.forms['offerFrm'].depDate.value;
				var d_result1 = compareDates(curDate,"dd/MM/yyyy",inpDate,"dd/MM/yyyy");
				var d_result2 = compareDates(inpDate,"dd/MM/yyyy",curDate,"dd/MM/yyyy");
			    if ((d_result1 == 0) && (d_result2 == 0)) {
					var t_result = compareDates(curTime,"HH:mm",inpTime,"HH:mm");
					if ( t_result == 0 ) {
						msg = null;
					} else {
						msg = "Departure time must be in the future."
					}
			    } else if (d_result1 == 1) {
					msg = 'Departure date has already passed.';
			    } else {
					msg = null;
			    }
			} else {
			    msg = 'Enter 24 hour departure time.';
			}
			return msg;
		}

		//validates the date entered with respect to the time
		function checkDate() {
			var msg;
			var curDate = formatDate(new Date(),"dd/MM/yyyy");
			var inpDate = document.forms['offerFrm'].depDate.value;
			var result = compareDates(curDate,"dd/MM/yyyy",inpDate,"dd/MM/yyyy");
		    if ( result == 0 ) {
				msg = null;
			} else {
			    msg = 'Date has already passed.';
			}
			return msg;
		}
		
		//the input validation rules for the page
		var rules=new Array();
		rules[0]='houseFrom:origin house number|required';
		rules[1]='houseFrom:origin house number|numeric';
		rules[2]='streetFrom:origin street|required';
		rules[3]='houseTo:destination house number|required';
		rules[4]='houseTo:destination house number|numeric';
		rules[5]='streetTo:destination street|required';
		rules[6]='depDate:date|required';
		rules[7]='depDate:date|date';
		rules[8]='depDate|custom|checkDate()';
		rules[9]='depTime:departure time|required';
		rules[10]='depTime|custom|checkTime()';
		rules[11]='tripLength:ride length|required';
		rules[12]='tripLength:ride length|numeric';
		rules[13]='numSeats:number of seats|required';
		rules[14]='numSeats:number of seats|numeric';
		</script>

	</HEAD>
	<BODY onload="yav.init('offerFrm', rules);">

	<%@ include file="heading.html" %>	

		<DIV class="Content" id="Content" >
			<h2 class="title" id="title">Offer A Ride</h2>
			<br /><br />
			<h2>Ride Details:</h2>
			<div class="Box" id="Box">
			<p>Please enter the relevant details and click confirm. * indicates required field.</p>
			<FORM NAME="offerFrm" id="offerFrm" onsubmit="return yav.performCheck('offerFrm', rules, 'inline');" action="<%=response.encodeURL("newRideConfirmation.jsp")%>" method="post">
				<INPUT TYPE="hidden" NAME="user" VALUE="<%=OpenIdFilter.getCurrentUser(s)%>">
				<INPUT TYPE="hidden" NAME="fromCoord" SIZE="25">
				<INPUT TYPE="hidden" NAME="toCoord" SIZE="25">
					<%
						// Information on if ride is an offer or request. 
						//If Ride is a request then numSeats label should be no. of seats requested
						//else it should be no. of seats available.
						//<tr> <td>Ride Type:</td> <td>	
						//<SELECT name="rideType">
						//	<option value="Ride Offer">Ride Offer</option>
						//</SELECT></td> </tr>	
						//<tr><th>&nbsp;</th></tr>
					%>

					<%
						/* Location FROM, TO & VIA. 
											Streets is a combo box so user can type or use drop down to select
											a street. All streets boxes will need to be populated 
											from the database table streets*/
					%>
					<br />
					<h3>Departure:</h3>
					<div class="Box" id="Box">
					<TABLE class="rideDetails">
					<tr> <td>House number*:</td> 
					<td><INPUT TYPE="text" NAME="houseFrom" SIZE="25" onkeypress="getAddress('from')">&nbsp;&nbsp;<span id=errorsDiv_houseFrom></span></td> </tr>
					<tr> <td>Street*:</td> <td>
					<SELECT name="streetFrom"  onChange="getAddress('from')">
           		  		<option selected="selected" value=''>Select a Street</option>
	           		 	<%=options%>
       				</SELECT>&nbsp;&nbsp;<span id=errorsDiv_streetFrom></span></td> </tr>
        			<tr> <td>Region:</td> <td>Palmerston North</td> </tr>
					</table>
					</div>
					
					<br /><br />
					<h3>Arrival:</h3>
					<div class="Box" id="Box">
					<table class="rideDetails">
					<tr> <td>House number*:</td> 
					<td><INPUT TYPE="text" NAME="houseTo" SIZE="25" onkeypress="getAddress('to')">&nbsp;&nbsp;<span id=errorsDiv_houseTo></span></td> </tr>
					<tr> <td>Street*:</td> <td>
					<SELECT name="streetTo" onChange="getAddress('to')">
           		  		<option selected="selected" value=''>Select a Street</option>
	           		  	<%=options%>
       				 </SELECT>&nbsp;&nbsp;<span id=errorsDiv_streetTo></span></td> </tr>
					<tr> <td>Region:</td>  <td>Palmerston North</td> </tr>
					</table>
					</div>

					<%
						/* If one off option is chosen then user can choose date(s) of ride and if
						 regular is chosen user can choose startDate, days of ride and endDate*/
					%>
					<br /><br />
					<h3>Timing:</h3>
					<div class="Box" id="Box">
					<table class="rideDetails">
					<%
						/*<tr> <td>Recurrence:</td> <td>
						 <SELECT name="recurrence"  onchange="process_choice(this,document.offerFrm.depDate, document.offerFrm.depDays, document.offerFrm.calIcon, document.offerFrm.calIcon)">
						 <option value="sel">Choose One</option>
						 <option value="0">One-Off</option>
						 <option value="1">Regular</option>
						 </SELECT></td> </tr>
						 <tr><td>&nbsp;</td> <td><INPUT TYPE="text" NAME="depDate" style="display: none" VALUE="(dd/MM/yyyy)" SIZE="25"> <A HREF="#" onClick="cal.select(document.forms['offerFrm'].depDate,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img name="calIcon" style="display: none" border="0" src="calendar_icon.jpg" width="27" height="23"></A> </td> </tr> 
						 <tr> <td>&nbsp;</td><td><SELECT name="depDays" multiple="multiple" style="display: none">
						 <option value=1>Monday</option>
						 <option value =2>Tuesday</option>
						 <option value =3>Wednesday</option>
						 <option value=4>Thursday</option>
						 <option value=5>Friday</option>
						 <option value=6>Saturday</option>
						 <option value=7>Sunday</option>
						 </SELECT></td> </tr>*/
					%>
					<tr> <td>Departure Date (dd/MM/yyyy)*:</td> <td><INPUT TYPE="text" NAME="depDate" VALUE="<%=date%>" SIZE="25"> <A HREF="#" onClick="cal.select(document.forms['offerFrm'].depDate,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img name="calIcon" border="0" src="images/calendar_icon.jpg" width="27" height="23"></A>&nbsp;&nbsp;<span id=errorsDiv_depDate></span> </td> </tr>
					<tr> <td>Departure Time 24hr (hh:mm)*:</td> <td><INPUT TYPE="text" NAME="depTime" VALUE="<%=time%>" SIZE="25">&nbsp;&nbsp;<span id=errorsDiv_depTime></span></td> </tr>
					<tr> <td>Approx Trip Length (min)*:</td> <td><INPUT TYPE="text" NAME="tripLength" VALUE="15" SIZE="25">&nbsp;&nbsp;<span id=errorsDiv_tripLength></span></td> </tr>
					</table>
					</div>
					
					<br /><br />
					<h3>Additional Details:</h3>
					<div class="Box" id="Box">
					<table class="rideDetails">	
					<tr> <td>Number of passenger seats*:</td> <td><INPUT TYPE="text" NAME="numSeats" SIZE="25">&nbsp;&nbsp;<span id=errorsDiv_numSeats></span></td> </tr>

					<tr> <td>Other Comments:</td> <td><INPUT TYPE="text" NAME="xtraInfo" SIZE="25"></td> </tr>
					</table>					
					</div>
					<br />
					<p>Click here to <INPUT TYPE="submit" NAME="submit" VALUE="Confirm Ride Offer" SIZE="25"></p>
			</FORM>
			</div>

			<br /><br />
			<h2>Google Map:</h2>
			<div class="Box" id="Box">
			<FORM name="showMap" id="map" method="post" target="_blank" action="displayRouteMap.jsp">
					<p>Click here to <INPUT type="submit" value="View Map" onClick="getAddress()"/> </p>
					<INPUT type="hidden" name="mapFrom" >
				    <INPUT type="hidden" name="mapTo"   >
					<INPUT type="hidden" name="mapHouse" >
			</FORM>
			</div>
			<br /> <br /> <br />
			<p>-- <a href="<%=response.encodeURL("welcome.jsp")%>">Home</a> --</p>
		</DIV>
		
	<%@ include file="leftMenu.jsp" %>

	</BODY>
</HTML>
