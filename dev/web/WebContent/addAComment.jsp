<%@ page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" import="java.util.*, java.text.*, car.pool.persistance.*, org.verisign.joid.consumer.OpenIdFilter"%>
<%
HttpSession s = request.getSession(false);

if (OpenIdFilter.getCurrentUser(s) == null && session.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

CarPoolStore cps = new CarPoolStoreImpl();

int idRide = Integer.parseInt(request.getParameter("idRide"));
int idUser = Integer.parseInt(request.getParameter("idUser"));
String comment = request.getParameter("comment");

if(comment != ""){cps.addComment(idUser, idRide, comment);}

String html = "Comment added!";

response.sendRedirect(request.getParameter("reDirURL"));

%>

<html>
<head>
<title>Adding Comment</title>
</head>
<body>
<%=html %>
</body>
</html>


