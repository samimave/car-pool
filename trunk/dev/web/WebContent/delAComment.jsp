<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="java.util.*,java.text.*,car.pool.persistance.*,org.verisign.joid.consumer.OpenIdFilter,car.pool.user.*"%>
<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	//a container for the users information
	User user = null;
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");

		CarPoolStore cps = new CarPoolStoreImpl();
		int idRide = Integer
				.parseInt(request.getParameter("idComment"));
		
		//delete the comment
		cps.delComment(idRide);
		
		//redirect page back to original one specfied by POST data
		response.sendRedirect(response.encodeURL(request.getParameter("reDirURL")));
	} else {
		response.sendRedirect(request.getContextPath());
	}
%>