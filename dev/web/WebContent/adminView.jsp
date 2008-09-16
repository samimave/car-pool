<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page contentType="text/html; charset=ISO-8859-1" import="java.util.*, java.text.*, org.verisign.joid.consumer.OpenIdFilter, car.pool.persistance.*"%>

<%
//force the user to login to view the page
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}
CarPoolStore cps = new CarPoolStoreImpl();

%>


<%@page import="car.pool.persistance.test.AddLocations"%><HTML>
	<HEAD>
		<TITLE> Administration Tasks</TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
		</HEAD>
	<BODY>
		<DIV class="content">
			<h1>Administrative functions below</h1>
			<FORM NAME="admin" method="post" >	
				<table>
					<tr><td>Add locations in database?</td>
						<td><input type ="submit" VALUE="AddR" onselect=<%cps.addRegion("someRegion"); %>></td>
						<td><input type ="submit" VALUE="AddL" onselect=<%cps.addLocation(1, "someStreet"); %>></td>
						<td><input type ="submit" VALUE="AddLocMain" onselect=<%AddLocations.main(null);%>></td>
					</tr>
				</table>
			</FORM>
		</DIV>
	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>