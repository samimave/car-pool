<%@ page errorPage="errorPage.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Route Maps	-	Be Cool! Car Pool!</title>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ" type="text/javascript"></script>
  </head>
  <body>

    <!-- you can use tables or divs for the overall layout -->
    <table border=1>
      <tr>
        <td>
           <div id="map" style="width: 550px; height: 450px"></div>
        </td>

      </tr>
    </table>

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
      //route mapping code
	  var directionsPanel = document.getElementById("my_textual_div");
	  var directions = new GDirections(map, directionsPanel);	
	  // add map control  
      map.addControl(new GLargeMapControl());
      map.addControl(new GMapTypeControl());
      // set the map center to be palmerston north new zealand
	  map.setCenter(new GLatLng(-40.35814342293522, 175.6267547607422),13);

	  // get the street from and street to from the combobox	
	  var tempFrom  = "<%=request.getParameter("mapFrom") %>";
	  var tempTo    = "<%=request.getParameter("mapTo") %>";
	  var tempVia = "<%=request.getParameter("mapVia") %>";

	  // assign the right format to the variables
	  var fromAddress =tempFrom.toString() + "  PALMERSTON NORTH NEW ZEALAND";
	  var toAddress   =tempTo.toString() + "  PALMERSTON NORTH NEW ZEALAND";
      var addressArray = [fromAddress,toAddress];
      var viaAddress = tempVia.toString();

	  //address formating, received the "via addresses" as a single string with sign like "[", "]" ","
	  //need to use the split function to store each "via address" to an array		
      viaAddress = viaAddress.replace("[","");
      viaAddress = viaAddress.replace("]","");
      viaAddress = viaAddress.replace(", ",",");      
	  var viaArray=[];
	  var viaLoc = viaAddress.split(",");  	
	  var i = 0;	
		while(i < (viaLoc.length)){
			viaArray[i] = viaLoc[i]+ " PALMERSTON NORTH NEW ZEALAND";
			i++;		
		}	    
                  
      // addAddressToMap() is called when the geocoder returns an
      // answer.  It adds a marker("via address") to the map with an open info window
      // showing the nicely formatted version of the address        	
      function addAddressToMap(response) {

          if (!response || response.Status.code != 200) {
        	  alert("Sorry, the address is unable to display. Some map function is not campatible with IE 7. ");
          } 
          else {
            place = response.Placemark[0];
            point = new GLatLng(place.Point.coordinates[1],
                                place.Point.coordinates[0]);
            var marker = new GMarker(point);
            var html = place.address;
            GEvent.addListener(marker, "click", function() {
                marker.openInfoWindowHtml(html);
              });
            map.addOverlay(marker); 
            return marker;   
                  
          }
          
        }     
                
      // It geocodes the address in the database associate with the ride
      // and adds a marker to the map at that location.
      function showLocation() {
        		for (var j=1; j< viaArray.length; j++){
        		geocoder.getLocations(viaArray[j], addAddressToMap); 
        		}
        		drawRoute();
      }

      //draw route on map
      function drawRoute(){
    	  directions.loadFromWaypoints(addressArray);
      }
     
    }

    // display a warning if the browser was not compatible
    else {
      alert("Sorry, displaying route map is not compatible with this browser");
    }
    
    //]]>
    </script>
  </body>
</html>





  




