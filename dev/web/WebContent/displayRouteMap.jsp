<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <title>Route Maps	-	Be Cool! Car Pool!</title>
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ" type="text/javascript"></script>
  </head>
  <body onunload="GUnload()">


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
 	//massey key - ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRlE5ut_msTCy_drvRxhL-5WV5Z9RRgsjp91RhaFgOcfLwhiUE-yftYsA 
   
    //<![CDATA[

    if (GBrowserIsCompatible()) { 

      // Display the map, with some controls and set the initial location 
      var map = new GMap2(document.getElementById("map"));
      var geocoder = new GClientGeocoder();
      var gmarkers = [];
      var i = 0;
      map.addControl(new GLargeMapControl());
      map.addControl(new GMapTypeControl());
      map.setCenter(new GLatLng(-40.35814342293522, 175.6267547607422),13);
  
      // addAddressToMap() is called when the geocoder returns an
      // answer.  It adds a marker to the map with an open info window
      // showing the nicely formatted version of the address
  		
      function addAddressToMap(response) {
          map.clearOverlays();
          if (!response || response.Status.code != 200) {
            alert("Sorry, we were unable to geocode that address");
          } else {
            place = response.Placemark[0];
            point = new GLatLng(place.Point.coordinates[1],
                                place.Point.coordinates[0]);
            marker = new GMarker(point);
            map.addOverlay(marker);
            marker.openInfoWindowHtml(place.address);
          }
        }

      // It geocodes the address in the database associate with the ride
      // and adds a marker to the map at that location.
      function showLocation() {
        var address = document.forms[0].q.value;
        geocoder.getLocations(address, addAddressToMap);
      }

     // findLocation() is used to enter the sample addresses into the form.
      function findLocation(address) {
		// here would be a for loop later to loop through the direction of that trip
       // for (var i=0; i<lines.length; i++ ){
        document.forms[0].q.value = address;
        showLocation();
      }

    }
    
    // display a warning if the browser was not compatible
    else {
      alert("Sorry, displaying route map is not compatible with this browser");
    }

    //]]>
    </script>
	
	<!-- Creates a simple input box where you can enter an address
         and a Search button that submits the form. //-->
    <form action="#" onsubmit="showLocation(); return false;">
      <p>
        <b>Search for an address:</b>
        <input type="text" name="q" value="Main Street,Palmerston North, New Zealand" class="address_input" size="40" />
        <input type="submit" name="find" value="Search" />

      </p>
    </form>

  </body>

</html>





  




