<%@ page contentType="text/html; charset=US-ASCII" %>
<%@ page import="java.util.Enumeration, car.pool.persistance.*,java.util.Formatter" %>
<%

%>
<html>
	<head>
		<title>test<title>
	</head>
	<body>
		<p>
		<%Enumeration e = request.getParameterNames();%>
		<%
		  while(e.hasMoreElements()) {
			  String name = (String)e.nextElement();
			  %><%=name%> = <%=request.getParameter(name) %><br/><%
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
		<p><script type="text/javascript">document.writeln(getAddress1(10));</script></p>
	</body>
</html>