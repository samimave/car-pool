<HTML>
<HEAD>
<TITLE>Ride Search Results</TITLE>
<script
	src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAwEEggV_Hd8onlfSgA_kgZBTz-RVM6WN_1Yrxj3B45o6dXx3SPxRBd9zQMOS18U6DzRdS0kg6JbFdlA"
	type="text/javascript"></script>
</HEAD>
<BODY>
	<FORM NAME="resultFrm" id="result">
	<TABLE border=1>
		<tr>
			<td>
			<div id="map" style="width: 550px; height: 450px"></div>
			</td>
	
		</tr>
	</TABLE>
	</FORM>
	</DIV>

<script type="text/javascript">

    //localhost key - ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ
 	//massey key - ABQIAAAAwEEggV_Hd8onlfSgA_kgZBTz-RVM6WN_1Yrxj3B45o6dXx3SPxRBd9zQMOS18U6DzRdS0kg6JbFdlA 
   
    //<![CDATA[
    
	window.onload = function() {
    	showLocation(); 
    
    }
	window.unload = GUnload();

   
	if (GBrowserIsCompatible()) {

		// Display the map, with some controls and set the initial location 
		var map = new GMap2(document.getElementById("map"));
		var geocoder = new GClientGeocoder();

		//get all the rides to map
		var rides = "<%=request.getParameter("mapCoords")%>".split(":");
		
		//route mapping code
		var directionsPanel = document.getElementById("my_textual_div");
		var routes = new Array();

		//create array of route objects
		for(var i=0; i<rides.length;i++){
			routes[i] = new GDirections(map, directionsPanel);
		}

		///	  
		map.addControl(new GLargeMapControl());
		map.addControl(new GMapTypeControl());
		map.setCenter(new GLatLng(-40.35814342293522, 175.6267547607422), 13);

		// It geocodes the address in the database associate with the ride
		// and adds a marker to the map at that location.
		function showLocation() {

			for(var i=0; i<rides.length;i++){
				routes[i].loadFromWaypoints(rides[i].split("/"));
			}

		}
	}

	// display a warning if the browser was not compatible
	else {
		alert("Sorry, displaying route map is not compatible with this browser");
	}

	//]]>
</script>