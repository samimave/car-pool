<%@ page contentType="text/html; charset=US-ASCII" %>
<%@ page import="java.util.Enumeration;" %>
<html>
	<body>
		<p>
		<%Enumeration e = request.getParameterNames();
		  while(e.hasMoreElements()) {
			  String name = (String)e.nextElement();
			  %><%=name%> = <%=request.getParameter(name)%><br/><%
		  }
		%>
		</p>
	</body>
</html>