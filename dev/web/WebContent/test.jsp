<%@ page contentType="text/html; charset=US-ASCII" %>
<%@ page import="java.util.Enumeration, car.pool.persistance.*,java.util.Formatter" %>
<%
CarPoolStore cps = new CarPoolStoreImpl(); 
LocationList loc = cps.getLocations();
StringBuffer locations = new StringBuffer();
Formatter format = new Formatter(locations);
while(loc.next()) {
	format.format("locations[%d] = \"%s\";\n",loc.getID(),loc.getStreetName());
}
%>
<html>
	<head>
		<script type="text/javascript">
			var locations = new Array();
			<%=locations.toString()%>
			 function getAddress1(addrs){
                 var from = "";
                 //LocationList loc = cps.getLocations();
                 //addrs = document.getElementById('streetFrom').value;
                         // from = locations.getStreetName(addrs);
                 //for(i = 0; i < locations.length; i++ ) {
                     if(addrs >= 0 && addrs <=locations.length) {
                         return locations[addrs];
                     }
                 //}

                 return false;
                         
         }
		</script>
	</head>
	<body>
		<p>
		<%Enumeration e = request.getParameterNames();
		  while(e.hasMoreElements()) {
			  String name = (String)e.nextElement();
			  %><%=name%> = <%=request.getParameter(name)%> <%=request.getParameter(name).length()%><br/><%
		  }
		%>
		</p>
		<p>
			<%java.io.File file2 = new java.io.File(".");
			//for( String name : file2.list()) {%>
				<%//name %>
			<%//} %>
			<%=file2.getAbsolutePath() %>
		</p>
		<p><script type="text/javascript">document.writeln(getAddress1(10));</script></p>
	</body>
</html>