<%@page contentType="text/html; charset=ISO-8859-1" import="java.util.*, java.text.*, org.verisign.joid.consumer.OpenIdFilter"%>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

//simple date processing for display on page
Date now = new Date();
String time = DateFormat.getTimeInstance(DateFormat.SHORT).format(now);
String date = DateFormat.getDateInstance().format(now);
%>

<HTML>
	<HEAD>
		<TITLE> Offer or Request a Ride </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
		<SCRIPT type="text/javascript" src="CalendarPopup.js"></SCRIPT>
		<SCRIPT type="text/javascript">
			var cal = new CalendarPopup();
			function activate(field) {
				field.disabled=false;
				if(document.styleSheets)field.style.display  = 'inline';
				  	field.focus(); 
			}
			function process_choice(selection,textfield, selectfield) {
				if (selection.value == 'sel'){
					textfield.style.display = 'none';
					selectfield.style.display = 'none';
				}
				if(selection.value == 'oneoff') {
				    activate(textfield); 
				    selectfield.style.display = 'none';
				    selectfield.disabled = true; 
				    if(document.styleSheets)selectfield.style.display  = 'none';
				    	selectfield.value = ''; 
				 }
				if(selection.value == 'regular') {
					activate(selectfield)
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
			<FORM NAME="offerFrm" method="post" action="newRideConfirmation.jsp">
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
					
					<tr> <td>FROM -</td> <td>
					<tr> <td>Region:</td> <td>
					<SELECT name="regionFrom">
						<option>Palmerston North</option>
					</SELECT></td> </tr>
					<tr> <td>Street:</td> <td>
					<SELECT name="streetFrom">
						<option>Select a Street</option>
					</SELECT></td> </tr>
					
					<tr> <td>TO -</td> <td>
					<tr> <td>Region:</td> <td>
					<SELECT name="regionTo">
						<option>Palmerston North</option>
					</SELECT></td> </tr>
					<tr> <td>Street:</td> <td>
					<SELECT name="streetTo">
						<option>Select a Street</option>
					</SELECT></td> </tr>

					<%/* If one off option is chosen then user can choose date(s) of ride and if
					regular is chosen user can choose startDate, days of ride and endDate*/%>
					<tr> <th> <h2>Timing:</h2> </th> <th>&nbsp;</th> </tr>
					<tr> <td>Reccurence:</td> <td>
					<SELECT name="reccurence"  onchange="process_choice(this,document.offerFrm.depDate, document.offerFrm.depDays)">
						<option value="sel">Select an Option</option>
						<option value="oneoff">One-Off</option>
						<option value="regular">Regular</option>
					</SELECT></td> </tr>
					<tr> <td>Date (dd/MM/yyyy):</td> <td><INPUT TYPE="text" NAME="depDate" style="display: none" VALUE="<%= date %>" SIZE="25"> <A HREF="#" onClick="cal.select(document.forms['offerFrm'].depDate,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img border="0" src="calendar_icon.jpg" width="27" height="23"></A> </td> </tr> 
					<tr> <td>Days:</td> <td>
					<SELECT name="depDays" multiple="true" style="display: none">
						<option>Monday</option>
						<option>Tuesday</option>
						<option>Wednesday</option>
						<option>Thursday</option>
						<option>Friday</option>
						<option>Saturday</option>
						<option>Sunday</option>
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

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>