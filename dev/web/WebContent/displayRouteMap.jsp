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
    	drawRoute(); 
    
    }
	window.unload = GUnload();

    if (GBrowserIsCompatible()) { 

      
      var map = new GMap2(document.getElementById("map"));
      var geocoder = new GClientGeocoder();
      //route mapping code
	  var directionsPanel = document.getElementById("my_textual_div");
	  var directions = new GDirections(map, directionsPanel);
	  // Display the map, with some controls and set the initial location   
      map.addControl(new GLargeMapControl());
      map.addControl(new GMapTypeControl());
      // set the map center to palmerston north new zealand
	  map.setCenter(new GLatLng(-40.35814342293522, 175.6267547607422),13);

	  // get the street from and street to from the combobox from the offer a ride page	
	  var tempFrom  = "<%=request.getParameter("mapFrom") %>";
	  var tempTo    = "<%=request.getParameter("mapTo") %>";
	  var tempHouse = "<%=request.getParameter("mapHouse") %>";

	  //address formating, tempHouse is the house number, because two jsp page is using the same variable
	  //one is the "offer ride" page which can provide house number, so tempHouse value is either null or not null
	  //the other one is the "temp2" page which doesn't provide the house number, so the value is "null" as a string.
	  if (tempHouse == null){	   
		  // if tempHouse (house number) is null ignore it 
		     var addressNoHouse =tempFrom.toString() + "  PALMERSTON NORTH NEW ZEALAND";
		   		 toAddress   =tempTo.toString() + "  PALMERSTON NORTH NEW ZEALAND";
		         fromAddress = addressNoHouse;
		  }
	  // if tempHouse (house number) is not null added to the address to be display on  the map	
	  if (tempHouse != null){
		  var addressHouse =tempHouse.toString() + " " + tempFrom.toString() + "  PALMERSTON NORTH NEW ZEALAND";				   
		   	  toAddress   =tempTo.toString() + "  PALMERSTON NORTH NEW ZEALAND";
		      fromAddress = addressHouse;
	  }
	// if tempHouse (house number) is null ignore it 
	  if (tempHouse == "null"){
		  var detailAddress =tempFrom.toString() + "  PALMERSTON NORTH NEW ZEALAND";				   
		   	  toAddress   =tempTo.toString() + "  PALMERSTON NORTH NEW ZEALAND";
		      fromAddress = detailAddress;
	  }
      var addressArray = [
                          fromAddress,
                          toAddress,                        
                          ];
	               

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





  




