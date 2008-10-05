<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="java.util.*, java.text.*, car.pool.persistance.*, org.verisign.joid.consumer.OpenIdFilter, car.pool.user.*"%>
<%
HttpSession s = request.getSession(false);

//a container for the users information
User user = null;
if(s.getAttribute("signedin") != null ) {
	user = (User)s.getAttribute("user");
} else {
	response.sendRedirect(request.getContextPath());
}

CarPoolStore cps = new CarPoolStoreImpl();

int idRide = Integer.parseInt(request.getParameter("idComment"));

cps.delComment(idRide);

response.sendRedirect(request.getParameter("reDirURL"));
%>