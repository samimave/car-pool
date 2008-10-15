<%@page contentType="text/html; charset=ISO-8859-1" import="java.util.*, java.text.*, car.pool.persistance.*, org.verisign.joid.consumer.OpenIdFilter"%>
<%
if (OpenIdFilter.getCurrentUser(request.getSession()) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

CarPoolStore cps = new CarPoolStoreImpl();

int idRide = Integer.parseInt(request.getParameter("idRide"));
int idUser = Integer.parseInt(request.getParameter("idUser"));
String comment = request.getParameter("comment");

int success = cps.addComment(idUser, idRide, comment);

String html;

String form = "<FORM action=\"viewComments.jsp\" method=\"post\"><INPUT type=\"hidden\" name=\"idRide\" value=\"" + idRide + "\"><INPUT type=\"hidden\" name=\"idUser\" value=\"" + idUser + "\"><INPUT type=\"submit\" value=\"View Comments\" />";

if(success < 1){
	html = "Error adding comment<br>" + form;
}else{
	html = "Comment added!<br>" + form;
}

%>

<html>
<head>
<title>Adding Comment</title>
</head>
<body>
<%=html %>
</body>
</html>


