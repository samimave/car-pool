<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>My Google Data API Application</title>
    <script src="http://www.google.com/jsapi?key=ABQIAAAA7rDxBnSa8ztdEea-bXHUqRTTZprX4YwS4GpqrFod4OfVHr1K6RQgRE9sL3F_96hh2QUZHuANtwF-KA" type="text/javascript"></script>
    <script type="text/javascript">
    //<![CDATA[

    google.load("gdata", "1");

    function OnLoad() {
    	google.load("gdata", "1");
    	  

          var scope = 'http://www.google.com/calendar/feeds/';
          if(!google.accounts.user.checkLogin(scope)){
              google.accounts.user.login();
          }else{
        	  /*
        	   * Create a single event
        	   */ 

        	  // Create the calendar service object
        	  var calendarService = new google.gdata.calendar.CalendarService('GoogleInc-jsguide-1.0');

        	  // The default "private/full" feed is used to insert event to the 
        	  // primary calendar of the authenticated user
        	  var feedUri = 'http://www.google.com/calendar/feeds/default/private/full';

        	  // Create an instance of CalendarEventEntry representing the new event
        	  var entry = new google.gdata.calendar.CalendarEventEntry();

        	  // Set the title of the event
        	  entry.setTitle(google.gdata.Text.create('JS-Client: insert event'));

        	  // Create a When object that will be attached to the event
        	  var when = new google.gdata.When();

        	  // Set the start and end time of the When object
        	  var startTime = google.gdata.DateTime.fromIso8601("2008-02-10T09:00:00.000-08:00");
        	  var endTime = google.gdata.DateTime.fromIso8601("2008-02-10T10:00:00.000-08:00");
        	  when.setStartTime(startTime);
        	  when.setEndTime(endTime);

        	  // Add the When object to the event 
        	  entry.addTime(when);

        	  // The callback method that will be called after a successful insertion from insertEntry()
        	  var callback = function(result) {
        	  }

        	  // Error handler will be invoked if there is an error from insertEntry()
        	  var handleError = function(error) {
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
    <div id="panel"/>
	<img src="google.jpg">
  </body>
</html>
  


