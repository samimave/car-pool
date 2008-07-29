<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<%
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
  PRINT('event created!');
}

// Error handler will be invoked if there is an error from insertEntry()
var handleError = function(error) {
  PRINT(error);
}

// Submit the request using the calendar service object
calendarService.insertEntry(feedUri, entry, callback, 
    handleError, google.gdata.calendar.CalendarEventEntry);
%>
</head>
<body>

</body>
</html>

