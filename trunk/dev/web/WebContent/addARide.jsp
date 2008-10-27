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

<!DOCTYPE html PUBLIC "-//W3C//DTD html 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>Offer a Ride</title>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<script type="text/javascript" src="javascript/CalendarPopup.js"></script>
		<script type="text/javascript" src="javascript/yav.js"></script>
		<script type="text/javascript" src="javascript/yav-config.js"></script>
		<script type="text/javascript" src="javascript/date.js"></script>
    	<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ" type="text/javascript"></script>
 		<%//massey key: ABQIAAAAwEEggV_Hd8onlfSgA_kgZBTz-RVM6WN_1Yrxj3B45o6dXx3SPxRBd9zQMOS18U6DzRdS0kg6JbFdlA
 	    //localhost key - ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ %>
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
		<script type="text/javascript">
			var cal = new CalendarPopup();

			//PLEASE LEAVE THESE TWO FUNCTIONS HERE
			//for some reason they have to be ABOVE getAddress for geocoder to work
			function codeFrom(response) {
				document.getElementById("offerFrm").fromCoord.value=response.lat() + "," + response.lng();
				}
			function codeTo(response) {
				document.getElementById("offerFrm").toCoord.value=response.lat() + "," + response.lng();
				}
			// a function to get the from and to streets from the combobox and pass them to the 
			// form call "showMap" which then post to the "displayRouteMap.jsp" to be display on google map


			//NOTE: two functions above are callback functions used for out-putting these co-ordinates to 
			//appropriate html FORM text boxes (hidden)
			//these co-ordinates are used in the searchRides calculations
			function getAddress(origin){
          		//get values of html FORM fields
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

     		   	  //build address strings
     		   	  var from = houseNum + " " + startLoc + " PALMERSTON NORTH NEW ZEALAND";
     		   	  var to = destNum + " " + endLoc + " PALMERSTON NORTH NEW ZEALAND";

				//depending on whether the event was sent from the 'from' or 'to' locations
				//set callback function codeFrom or codeTo to be used when getLatLong (google function) is successful
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

		</script>
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

	</head>
	<body onload="yav.init('offerFrm', rules);">

	<%@ include file="heading.html" %>	

		<div class="Content" id="Content" >
			<h2 class="title" id="title">Offer A Ride</h2>
			<br /><br />
			<h2>Ride Details:</h2>
			<div class="Box" id="Box">
			<p>Please enter the relevant details and click confirm. * indicates required field.</p>
			<form name="offerFrm" id="offerFrm" onsubmit="return yav.performCheck('offerFrm', rules, 'inline');" action="<%=response.encodeURL("newRideConfirmation.jsp")%>" method="post">
				<input type="hidden" name="user" value="<%=OpenIdFilter.getCurrentUser(s)%>">
				<input type="hidden" name="fromCoord" size="25">
				<input type="hidden" name="toCoord" size="25">
					<%
						// Information on if ride is an offer or request. 
						//If Ride is a request then numSeats label should be no. of seats requested
						//else it should be no. of seats available.
						//<tr> <td>Ride Type:</td> <td>	
						//<select name="rideType">
						//	<option value="Ride Offer">Ride Offer</option>
						//</select></td> </tr>	
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
					<table class="rideDetails">
					<tr> <td>House number*:</td> 
					<td><input type="text" name="houseFrom" size="25" onkeypress="getAddress('from')">&nbsp;&nbsp;<span id=errorsDiv_houseFrom></span></td> </tr>
					<tr> <td>Street*:</td> <td>
					<select name="streetFrom"  onChange="getAddress('from')">
           		  		<option selected="selected" value=''>Select a Street</option>
	           		 	<%=options%>
       				</select>&nbsp;&nbsp;<span id=errorsDiv_streetFrom></span></td> </tr>
        			<tr> <td>Region:</td> <td>Palmerston North</td> </tr>
					</table>
					</div>
					
					<br /><br />
					<h3>Arrival:</h3>
					<div class="Box" id="Box">
					<table class="rideDetails">
					<tr> <td>House number*:</td> 
					<td><input type="text" name="houseTo" size="25" onkeypress="getAddress('to')">&nbsp;&nbsp;<span id=errorsDiv_houseTo></span></td> </tr>
					<tr> <td>Street*:</td> <td>
					<select name="streetTo" onChange="getAddress('to')">
           		  		<option selected="selected" value=''>Select a Street</option>
	           		  	<%=options%>
       				 </select>&nbsp;&nbsp;<span id=errorsDiv_streetTo></span></td> </tr>
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
						 <select name="recurrence"  onchange="process_choice(this,document.offerFrm.depDate, document.offerFrm.depDays, document.offerFrm.calIcon, document.offerFrm.calIcon)">
						 <option value="sel">Choose One</option>
						 <option value="0">One-Off</option>
						 <option value="1">Regular</option>
						 </select></td> </tr>
						 <tr><td>&nbsp;</td> <td><input type="text" name="depDate" style="display: none" value="(dd/MM/yyyy)" size="25"> <A href="#" onClick="cal.select(document.forms['offerFrm'].depDate,'anchor1','dd/MM/yyyy'); return false;" name="anchor1" ID="anchor1"><img name="calIcon" style="display: none" border="0" src="calendar_icon.jpg" width="27" height="23"></A> </td> </tr> 
						 <tr> <td>&nbsp;</td><td><select name="depDays" multiple="multiple" style="display: none">
						 <option value=1>Monday</option>
						 <option value =2>Tuesday</option>
						 <option value =3>Wednesday</option>
						 <option value=4>Thursday</option>
						 <option value=5>Friday</option>
						 <option value=6>Saturday</option>
						 <option value=7>Sunday</option>
						 </select></td> </tr>*/
					%>
					<tr> <td>Departure Date (dd/MM/yyyy)*:</td> <td><input type="text" name="depDate" value="<%=date%>" size="25"> <A href="#" onClick="cal.select(document.forms['offerFrm'].depDate,'anchor1','dd/MM/yyyy'); return false;" name="anchor1" ID="anchor1"><img name="calIcon" border="0" src="images/calendar_icon.jpg" width="27" height="23"></A>&nbsp;&nbsp;<span id=errorsDiv_depDate></span> </td> </tr>
					<tr> <td>Departure Time 24hr (hh:mm)*:</td> <td><input type="text" name="depTime" value="<%=time%>" size="25">&nbsp;&nbsp;<span id=errorsDiv_depTime></span></td> </tr>
					<tr> <td>Approx Trip Length (min)*:</td> <td><input type="text" name="tripLength" value="15" size="25">&nbsp;&nbsp;<span id=errorsDiv_tripLength></span></td> </tr>
					</table>
					</div>
					
					<br /><br />
					<h3>Additional Details:</h3>
					<div class="Box" id="Box">
					<table class="rideDetails">	
					<tr> <td>Number of passenger seats*:</td> <td><input type="text" name="numSeats" size="25">&nbsp;&nbsp;<span id=errorsDiv_numSeats></span></td> </tr>

					<tr> <td>Other Comments:</td> <td><input type="text" name="xtraInfo" size="25"></td> </tr>
					</table>					
					</div>
					<br />
					<p>Click here to <input type="submit" name="submit" value="Confirm Ride Offer" size="25"></p>
			</form>
			</div>

			<br /><br />
			<h2>Google Map:</h2>
			<div class="Box" id="Box">
			<form name="showMap" id="map" method="post" target="_blank" action="displayRouteMap.jsp">
					<p>Click here to <input type="submit" value="View Map" onClick="getAddress()"/> </p>
					<input type="hidden" name="mapFrom" >
				    <input type="hidden" name="mapTo"   >
					<input type="hidden" name="mapHouse" >
			</form>
			</div>
			<br /> <br /> <br />
			<p>-- <a href="<%=response.encodeURL("welcome.jsp")%>">Home</a> --</p>
		</div>
		
	<%@ include file="leftMenu.jsp" %>

	</body>
</html>
