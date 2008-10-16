<%@page errorPage="errorPage.jsp" %>
<%@page import="car.pool.persistance.*,org.verisign.joid.consumer.OpenIdFilter,car.pool.user.*" %>
<%
	HttpSession s = request.getSession(false);

	//force the user to log in to view the page
	//a container for the users information
	User user = null;
	String from = "";
	String to = "";
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");

		//get actual street names from index numbers by cycling through a list of all streets
		CarPoolStore cps = new CarPoolStoreImpl();
		LocationList allLocs = cps.getLocations();
		while (allLocs.next()) {
			if (allLocs.getID() == Integer.parseInt(request.getParameter("from"))){
				from = allLocs.getStreetName();
			}
			if (allLocs.getID() == Integer.parseInt(request.getParameter("to"))){
				to = allLocs.getStreetName();
			}
		}

	} else {
		response.sendRedirect(request.getContextPath());
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title>Add Car-Pool Ride Event</title>
	<style type="text/css" media="screen">@import "TwoColumnLayout.css";</style>
    <script type="text/javascript">
	function main()
	{
			//for more info about adding ride events via a link, go here: http://www.google.com/googlecalendar/event_publisher_guide_detail.html
						
			//construct the title from start and end locations
           	var text = "Ride from <%=from%> to <%=to%>";

			//get ISO start date-time / end date-time
   			var dates = getISODate(false) + "/" + getISODate(true);

   			//provide info about our site
   			var sprop = "name:Car-Pool";

   			//construct the link
   			var link = "http://www.google.com/calendar/event?action=TEMPLATE&text="+text+"&dates="+dates+"&sprop="+sprop;

   	   		//add the event	
   			window.location = link;
    }

    //get the date and time parameters from the POST data and correctly format them into a string accepted by google API
    function getISODate(end)
    {
    	var time = "";
    	var date = "<%=request.getParameter("date")%>";

    	//remove the '-' delimiting yr-mnth-day
    	date = date.replace(/-/g, "");
    	
    	//if this is for the start time/date then get the correct POST time, otherwise remove the ':' so google will accept the time
		if(end)
		{	
			time = getTime(true);
		}
		else
		{
			time = getTime(false);
		}

		return date + time;			
    }

    //add the length of the trip to the start time to get an end time
    function getTime(endTime)
    {
        var sTime = "<%=request.getParameter("time")%>";
        var length = "<%=request.getParameter("length")%>";

        var hhmm = sTime.split(":");

        //if user has enter a date with a leading 0 (ie 08:20) then remove it
        if(hhmm[0].substr(0,1) == "0"){hhmm[0] = hhmm[0].replace("0","");}

        var hh = parseInt(hhmm[0]);
        var mm = parseInt(hhmm[1]);

		//deal with invalid string inputs
        if(isNaN(mm)){mm = 0;}
        if(isNaN(hh)){hh = 0;}

        //if the minutes section of the date string contains 'pm' (NOT case sensitive) then turn into 24hr time
        if(hhmm[1].search(/pm/i) != -1)
        {
            hh += 12
            if(hh > 23){hh = 0;}
        }

        if(!endTime)
        {
            if(hh < 10){hh = "0" + hh;}
            if(mm < 10){mm = "0" + mm;}
            return "T" + hh + mm + "00"
        }
      
        mm += parseInt(length);

		//if minutes is larger than 59, add an hour.  If this will tick over to another day, then lock the time at 11:59pm
        while(mm>59)
        {
            mm -= 60;
            hh++;
            if(hh>23)
            {
                hh = "23";
                mm = "59";
            }
        }

        //add leading zeroes to hours or minutes if necessary
        if(mm<10)
        {
            mm = "0" + mm;
        }
        if(parseInt(hh)<10)
        {
            hh = "0" + hh;
        }

        return "T" + hh + mm +"00";
    }


    </script>
  </head>
 <body onload="main()">

	<%@ include file="heading.html" %>

    <div class="Content" id="Content">
		<p>Please wait while we transfer you to the <img src="images/googleCalendar.gif" width="50" height="20" /> Calendar site..</p>
		
	</div>

	<%@ include file="leftMenu.jsp" %>

  </body>
</html>
  




