<%@page contentType="text/html; charset=ISO-8859-1" import="java.util.*, java.text.*, car.pool.persistance.*, org.verisign.joid.consumer.OpenIdFilter"%>
<%
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}
%>
<html>
<head>
<title>Ride Comments - Ride # <%=request.getParameter("idRide") %></title>
<%
CarPoolStore cps = new CarPoolStoreImpl();
int idRide = Integer.parseInt(request.getParameter("idRide"));	
Vector<String> comments = cps.getRideComment(idRide);
String table;

if(comments.size() < 1){
	table = "<tr><td colspan=\"3\">Sorry, could not find any comments for this ride.  Please feel free to add one below</td></tr>";	
}else{
	table = "";
}
String[] the_comment;
//table builder
for(int i=0;i<comments.size();i++){
	the_comment = comments.elementAt(i).split("_delim_");
	if(i%2 != 0){
		table += "<tr bgcolor=\"#EEEEEE\">";
	}else{
		table += "<tr bgcolor=\"white\">";
	}
	table += "<td width=\"10%\">" + the_comment[0] + "</td><td width=\"10%\">" + the_comment[1] + "</td><td width=\"80%\">" + the_comment[3] + "</td></tr>";
}

%>
</head>
<body>
<table width = 100%>
<tr bgcolor="#EEEEEE"><td width="15%">Comment ID</td><td width="10%">User ID</td><td width="75%">Comment</td></tr>
<%=table %>
<tr><td colspan="3" align=center><b>Add a comment for this ride</b></td></tr>
<FORM action="addAComment.jsp" method="post">
	<tr><td colspan="3" align=center>
		<INPUT type="hidden" name="idRide" value="<%=request.getParameter("idRide") %>">
		<INPUT type="hidden" name="idUser" value="<%=request.getParameter("idUser") %>">
		<TEXTAREA cols="50" rows="4" name="comment"></TEXTAREA>
	</td></tr>
	<tr><td colspan="3" align=center>
		<INPUT type="submit" value="Add Comment" />
	</td></tr>
</FORM>
</table>
</body>
</html>