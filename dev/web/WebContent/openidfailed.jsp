<%@ page import="java.util.Enumeration" %>

<html>
	<head><title>OpenId failed</title></head>
	<body>
		<%Enumeration e = session.getAttributeNames();
			while(e.hasMoreElements()) {
				String name = e.nextElement().toString();
				%><%=name %> = <%=session.getAttribute(name) %>
			<%} %>
	</body>
</html>