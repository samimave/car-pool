<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>My Google Data API Application</title>
	<style type="text/css" media="screen">@import "3ColumnLayout.css";</style>
    <script src="http://www.google.com/jsapi?key=ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ" type="text/javascript"></script>
    <script type="text/javascript">
  //<![CDATA[

    //load google api libraries
    google.load("gdata", "1");

    //wait for gdata to load properly, then execute 'createEvent'
    google.setOnLoadCallback(createEvent);
    	
    function createEvent() 
    {
        //check to see if user already logged in to a google account, if not then re-direct them
    	var scope = 'http://www.google.com/calendar/feeds/';
        if(!google.accounts.user.checkLogin(scope))
        {
            		google.accounts.user.login(scope);
        }
    	else
        {
 		

        	var title = "Ride from <%=request.getParameter("from") %> to <%=request.getParameter("to") %>";

			//create a calendar service object
			var calendarService = new google.gdata.calendar.CalendarService('Car-Pool');
   			
   			// The default "private/full" feed is used to insert event into the primary calendar of the authenticated user
   			var feedUri = 'http://www.google.com/calendar/feeds/default/private/full';

   			// Create an instance of CalendarEventEntry representing the new event
   			var entry = new google.gdata.calendar.CalendarEventEntry();

   			// Set the title of the event
   			entry.setTitle(google.gdata.Text.create(title));

   			// Create a When object that will be attached to the event
   			var when = new google.gdata.When();

   			// Set the start and end time of the When object
   			var startTime = google.gdata.DateTime.fromIso8601(getISODate(true));
   			var endTime = google.gdata.DateTime.fromIso8601(getISODate(false));
   			when.setStartTime(startTime);
   			when.setEndTime(endTime);

   			//Sample date/time string for future reference - "2008-02-10T10:00:00.000-08:00"

   			// Add the When object to the event 
   			entry.addTime(when);

   			// The callback method that will be called after a successful insertion from insertEntry()
   			var callback = function(result) 
   			{
   				window.location="welcome.jsp";
   			}

   			// Error handler will be invoked if there is an error from insertEntry()
    		var handleError = function(error) 
    		{
				document.write("Error ");
    			document.write(error);
    		}

   			// Submit the request using the calendar service object
   			calendarService.insertEntry(feedUri, entry, callback, 
   			    handleError, google.gdata.calendar.CalendarEventEntry);
		}
    }

    //get the date and time parameters from the POST data and correctly format them into a string accepted by google API
    function getISODate(start)
    {
    	var time = null;
    	var date = "<%=request.getParameter("date") %>";
    	
    	//split date string so it can be re-ordered and re-delmited correctly
    	var arrDate = date.split("/");

    	//need a leading '0' if day is <10 and doesn't already have this
    	if(arrDate[0].length == 1)
    	{
        	arrDate[0] = "0" + arrDate[0]
    	}

    	//re-order and re-delimit (using '-') date string
    	date = arrDate[2] + "-" + arrDate[1] + "-" + arrDate[0];
    	
    	//if this is for the start time/date then get the correct POST time
		if(start)
		{
			time = "T<%=request.getParameter("stime") %>:00.000"	
		}
		else
		{
			time = "T<%=request.getParameter("etime") %>:00.000"
		}

		return date + time;			
    }

	//]]>
    </script>
  </head>
  <body>

	<%@ include file="heading.html" %>

    <div class="content">
		Please wait, adding event data....
		<img src="carpool.png">
	</div>

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

  </body>
</html>
  




