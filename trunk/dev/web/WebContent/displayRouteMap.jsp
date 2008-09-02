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
 	//massey key - ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRlE5ut_msTCy_drvRxhL-5WV5Z9RRgsjp91RhaFgOcfLwhiUE-yftYsA 
   
    //<![CDATA[
    
	window.onload = function() {
    showLocation(); 
    }
	window.unload = GUnload();

    if (GBrowserIsCompatible()) { 

      // Display the map, with some controls and set the initial location 
      var map = new GMap2(document.getElementById("map"));
      var geocoder = new GClientGeocoder();
      map.addControl(new GLargeMapControl());
      map.addControl(new GMapTypeControl());
	  map.setCenter(new GLatLng(-40.35814342293522, 175.6267547607422),13);
      var addressArray = ["marne street palmerston north new zealand",
                          "cook street palmerston north new zealand",
                          "churh street palmerston north new zealand",
                          "albert street palmerston north new zealand",
                          "main street palmerston north new zealand",
                          "college street palmerston north new zealand",
                          "milson line palmerston north new zealand"
                          ];
     
      // ===== Start with an empty GLatLngBounds object =====     
      var bounds = new GLatLngBounds();
      //iconStart=new GIcon(G_DEFAULT_ICON, "http://maps.google.com/mapfiles/dd-start.png");
      //iconDest=new GIcon(G_DEFAULT_ICON, "http://maps.google.com/mapfiles/dd-end.png");
                     
      // addAddressToMap() is called when the geocoder returns an
      // answer.  It adds a marker to the map with an open info window
      // showing the nicely formatted version of the address        	
      function addAddressToMap(response) {

          if (!response || response.Status.code != 200) {
            alert("Sorry, we were unable to geocode that address");
          } else {
            place = response.Placemark[0];
            point = new GLatLng(place.Point.coordinates[1],
                                place.Point.coordinates[0]);
            var marker = new GMarker(point);
            // ==== Each time a point is found, extent the bounds ato include it =====
            bounds.extend(point);
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
        		for (var i=0; i< addressArray.length; i++){
        		geocoder.getLocations(addressArray[i], addAddressToMap); 
        		}
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





  




