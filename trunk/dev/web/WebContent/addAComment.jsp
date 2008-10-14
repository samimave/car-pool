<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="java.util.*,java.text.*,car.pool.persistance.*,org.verisign.joid.consumer.OpenIdFilter,car.pool.user.*,car.pool.escapeSpecialChars.*"%>
<%@page import="car.pool.escapeSpecialChars.EscapeSpecialChars"%>
<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	//a container for the users information
	User user = null;
	String html = "";
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");

		CarPoolStore cps = new CarPoolStoreImpl();
		int idRide = Integer.parseInt(request.getParameter("idRide"));
		int idUser = Integer.parseInt(request.getParameter("idUser"));
		String comment = EscapeSpecialChars.forHTML(request.getParameter("comment"));

		if (comment != "") {
			cps.addComment(idUser, idRide, comment);
		}
		html = "Comment added!";
		response.sendRedirect(response.encodeURL(request.getParameter("reDirURL")));

	} else {
		response.sendRedirect(response.encodeURL(request.getContextPath()));
	}
%>

<html>
<head>
<title>Adding Comment</title>
</head>
<body>
<%=html%>
</body>
</html>


