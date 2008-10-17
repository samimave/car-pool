<html>
  <head>
    <title>Add Car-Pool Ride Event</title>
    <script type="text/javascript">


	function main()
	{
			//for more info about adding ride events via a link, go here: http://www.google.com/googlecalendar/event_publisher_guide_detail.html
						
			//construct the title from start and end locations
           	var text = "Ride from <%=request.getParameter("from") %> to <%=request.getParameter("to") %>";

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
    	var time = "T<%=request.getParameter("time") %>00";
    	var date = "<%=request.getParameter("date") %>";
    	
    	//split date string so it can be re-ordered and re-delmited correctly
    	var arrDate = date.split("/");

    	//need a leading '0' if day is <10 and doesn't already have this
    	if(arrDate[0].length == 1)
    	{
        	arrDate[0] = "0" + arrDate[0]
    	}

    	//re-order and re-delimit (using '-') date string
    	date = arrDate[2] + arrDate[1] + arrDate[0];
    	
    	//if this is for the start time/date then get the correct POST time, otherwise remove the ':' so google will accept the time
		if(end)
		{	
			time = getEndTime();
		}
		else
		{
			time = time.replace(":", "");
		}

		return date + time;			
    }

    //add the length of the trip to the start time to get an end time
    function getEndTime()
    {
        var sTime = "<%=request.getParameter("time") %>";
        var length = "<%=request.getParameter("length") %>";

        var hhmm = sTime.split(":");

        var hh = parseInt(hhmm[0]);
        var mm = parseInt(hhmm[1]);

        mm += parseInt(length);

		//if minutes is larger than 59, add an hour.  If this will tick over to another day, then lock the time at 11:59pm
        if(mm>59)
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

    <div class="content">
		Please wait while we transfer you to the Google Calendar site..
		<img src="google.jpg">
	</div>

  </body>

  </body>
</html>
  




