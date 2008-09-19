<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*, car.pool.user.*" %>

<%

User user = (User)session.getAttribute("user");

//simple date processing for display on page
Date now = new Date();
String date = DateFormat.getDateInstance().format(now);

CarPoolStore cps = new CarPoolStoreImpl();
//make the options for the street select box
LocationList locations = cps.getLocations();
String options = "";
while (locations.next()){
	options += "<option value='"+locations.getID()+"'>"+locations.getStreetName()+"</option>";
}

%>

<HTML>
	<HEAD>
		<TITLE>Ride Search</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css"; </STYLE>
		<SCRIPT type="text/javascript">
			var cal = new CalendarPopup();
      		function getAddress(){
    			  startIdx = document.getElementById("search").searchFrom.selectedIndex;
    		   	  startLoc = document.getElementById("search").searchFrom.options[startIdx].text;
   			  	  endIdx   = document.getElementById("search").searchTo.selectedIndex;
   		   	  	  endLoc   = document.getElementById("search").searchTo.options[endIdx].text;
   		   	 	  document.getElementById("search").sFrom.value=startLoc;
		   	  	  document.getElementById("search").sTo.value=endLoc;
      		}
      	</SCRIPT>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="content">
			<p>Please enter the search criteria in the boxes below and click search</p>
			<FORM NAME="searchFrm" id="search" method="post" action="result.jsp">	
					<INPUT type="hidden" name="sFrom" >
				    <INPUT type="hidden" name="sTo"   >
				<TABLE class="rideSearch">
					<tr> <th> <h2>Location:</h2> </th> <th>&nbsp;</th> </tr>	
					<tr> <td>DEPARTURE FROM -</td> </tr>
					<tr> <td>Street:</td> <td>
					<SELECT name="searchFrom" onChange="getAddress()" >
           		  		<option selected="selected">Select a Street</option>
	           		 	<%=options %>
       				</SELECT></td> </tr>
        			<tr> <td>Region: Palmerston North</td> </tr>
					<tr><td>ARRIVAL AT -</td></tr> 
					<tr> <td>Street:</td> <td>
					<SELECT name="searchTo"  onChange="getAddress()">
           		  		<option selected="selected">Select a Street</option>
	           		  	<%=options %>
       				 </SELECT></td> </tr>

					<tr> <td>Region: Palmerston North</td> </tr>					
					<tr> <td>Date (dd/MM/yyyy):</td> <td><INPUT TYPE="text" NAME="searchDate" VALUE="<%= date %>" SIZE="25"> <A HREF="#" onClick="cal.select(document.forms['searchFrm'].depDate,'anchor1','dd/MM/yyyy'); return false;" NAME="anchor1" ID="anchor1"><img name="calIcon" border="0" src="calendar_icon.jpg" width="27" height="23"></A> </td> </tr> 
					<tr> <td>User:</td> <td><INPUT TYPE="text" NAME="sUser" VALUE="15" SIZE="25"></td> </tr>
					<tr> <td>&nbsp;</td> <td><INPUT TYPE="submit" NAME="search" VALUE="Search" onclick="getAddress()" SIZE="25"></td> </tr>

				</TABLE>
			</FORM>
		</DIV>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>