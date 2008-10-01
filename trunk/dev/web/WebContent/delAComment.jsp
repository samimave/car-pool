<%@ page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" import="java.util.*, java.text.*, car.pool.persistance.*, org.verisign.joid.consumer.OpenIdFilter"%>
<%
HttpSession s = request.getSession(false);

if (OpenIdFilter.getCurrentUser(s) == null && s.getAttribute("signedin") == null) {
	response.sendRedirect(request.getContextPath()+"/index.jsp");
}

CarPoolStore cps = new CarPoolStoreImpl();

int idRide = Integer.parseInt(request.getParameter("idComment"));

cps.delComment(idRide);

response.sendRedirect(request.getParameter("reDirURL"));
%>