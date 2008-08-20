<%@ page contentType="text/html; charset=US-ASCII" %>
<%@ page import="java.util.Enumeration;" %>
<html>
	<body>
		<p>
		<%Enumeration e = request.getParameterNames();
		  while(e.hasMoreElements()) {
			  String name = (String)e.nextElement();
			  %><%=name%> = <%=request.getParameter(name)%> <%=request.getParameter(name).length()%><br/><%
		  }
		%>
		</p>
		<p>
			<%java.io.File file2 = new java.io.File(".");
			//for( String name : file2.list()) {%>
				<%//name %>
			<%//} %>
			<%=file2.getAbsolutePath() %>
		</p>
	</body>
</html>