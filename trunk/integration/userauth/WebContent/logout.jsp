<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@ page import="org.verisign.joid.consumer.OpenIdFilter"%>
<%
    OpenIdFilter.logout(session);
    session.removeAttribute("user");
    session.invalidate();
    response.sendRedirect(request.getContextPath() + "/index.jsp");
%>
