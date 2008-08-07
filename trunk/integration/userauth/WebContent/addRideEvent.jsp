<%@page contentType="text/html; charset=ISO-8859-1" import="org.verisign.joid.consumer.OpenIdFilter"%>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(session) == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>My Google Data API Application</title>
	<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>
    <script src="http://www.google.com/jsapi?key=ABQIAAAA25n2LirGgUauwcTzm80V-RT2yXp_ZAY8_ufC3CFXhHIE1NvwkxS6WEYVuO3pdgxYPfQ30eV4B7q0zw" type="text/javascript"></script>
    <script type="text/javascript">
    //<![CDATA[
	//local-host ABQIAAAA25n2LirGgUauwcTzm80V-RT2yXp_ZAY8_ufC3CFXhHIE1NvwkxS6WEYVuO3pdgxYPfQ30eV4B7q0zw
	//ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ
    google.load("gdata", "1");

    function OnLoad() {
    	google.load("gdata", "1");

  	  	<% 
  	  		String title = "Ride from " + request.getParameter("from") + " to " + request.getParameter("to"); 
  	  	
  	  	 	String times[] = new String[2];
  	  	 	times[0] = request.getParameter("stime");
			times[1] = request.getParameter("etime");
  	  	 	String date = request.getParameter("date");
  	  	 	 	  	 	
  	  	 	String[] dmy = date.split("/");
  	  	 	date = dmy[2] + "-" + dmy[1] + "-" + dmy[0];
 	  	 	  	  	 	
  	  	 	String gSdate = date + "T" + times[0] + ":00.000";
  	  	 	String gEdate = date + "T" + times[1] + ":00.000";
		%>

          var scope = 'http://www.google.com/calendar/feeds/';
          if(!google.accounts.user.checkLogin(scope)){
              google.accounts.user.login();
          }else{
        	  // Create the calendar service object
        	  var calendarService = new google.gdata.calendar.CalendarService('GoogleInc-jsguide-1.0');

        	  // The default "private/full" feed is used to insert event to the 
        	  // primary calendar of the authenticated user
        	  var feedUri = 'http://www.google.com/calendar/feeds/default/private/full';

        	  // Create an instance of CalendarEventEntry representing the new event
        	  var entry = new google.gdata.calendar.CalendarEventEntry();

        	  // Set the title of the event
        	  entry.setTitle(google.gdata.Text.create("<%=title %>"));

        	  // Create a When object that will be attached to the event
        	  var when = new google.gdata.When();

        	  // Set the start and end time of the When object
        	  var startTime = google.gdata.DateTime.fromIso8601("<%=gSdate %>");
        	  var endTime = google.gdata.DateTime.fromIso8601("<%=gEdate %>");
        	  when.setStartTime(startTime);
        	  when.setEndTime(endTime);

        	  // Add the When object to the event 
        	  entry.addTime(when);

        	  // The callback method that will be called after a successful insertion from insertEntry()
        	  var callback = function(result) {
        		  location.href="welcome.jsp";
        	  }

        	  // Error handler will be invoked if there is an error from insertEntry()
        	  var handleError = function(error) {
            	  document.write("Error: " + handleError.text);
            }

        	  // Submit the request using the calendar service object
        	  calendarService.insertEntry(feedUri, entry, callback, 
        	      handleError, google.gdata.calendar.CalendarEventEntry);
        	}
    }

    //]]>
    </script>
  </head>
  <body onload="OnLoad()">

	<%@ include file="heading.html" %>

    <div class="content">
		Please wait, adding event data....
		<img src="carpool.png" />
	</div>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

  </body>
</html>
  




