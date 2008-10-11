package car.pool.proxy.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Formatter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;

public class DisplayProxies extends HttpServlet {
	private static final long serialVersionUID = -3663186030520570646L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Database db = new DatabaseImpl();
		PrintWriter out = response.getWriter();
		try {
			out.format("<script type=\"text/javascript\">\n<!--\n%s\n-->\n</script>", createAjax());
			ResultSet results = db.getStatement().executeQuery("select * from proxyaddress;");
			out.print("<table class=\"proxy\" id=\"proxy\">");
			out.print("<tr><th>IP Address</th><th>Port</th><th>Proxy Types</th></tr>");
			while(results.next()) {
				displayRow(out, results);
			}
			out.println("</table>");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}


	private String createAjax() {
		StringBuilder builder = new StringBuilder();
		builder.append("var request = false;\n");
		builder.append("try {\n");
		builder.append("        request = new XMLHttpRequest();\n");
		builder.append("} catch (trymicrosoft) {\n");
		builder.append("        try {\n");
		builder.append("        request = new ActiveXObject(\"Msxml2.XMLHTTP\");\n");
		builder.append("        } catch (othermicrosoft) {\n");
		builder.append("            try {\n");
		builder.append("                request = new ActiveXObject(\"Microsoft.XMLHTTP\");\n");
		builder.append("            } catch (failed) {\n");
		builder.append("                request = false;\n");
		builder.append("            }\n");
		builder.append("        }\n");
		builder.append("}\n");
		builder.append("if(!request)\n");
		builder.append("		alert(\"Error initializing XMLHttpRequest!\");\n");
		return builder.toString();
	}


	private void displayRow(PrintWriter out, ResultSet results) {
		try {
			out.format("<script type=\"text/javascript\">\n<!--\n%s\n//--></script>", createDeleteFunction(results.getString(1),results.getString(2), results.getString(3)));
			out.format("<tr><td>%s</td><td>%s</td><td>%s</td><td><button value=\"Delete\" type=\button\" onclick=\"del%s%s()\">Delete</button></td></tr>", results.getString(1),results.getString(2),results.getString(3),results.getString(1),results.getString(2));
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}


	private String createDeleteFunction(String ip, String port, String types) {
		Formatter builder = new Formatter();
		builder.format("function del%s%s() {\n", ip,port);
		builder.format("var url = \"setupproxy?proxydelete=yes&ipaddress=%s&port=%s&ptypes=%s\";\n", ip, port, types);
		builder.format("request.open(\"GET\", url, false);\n");
		builder.format("request.send( null );\n");
		builder.format("var response = request.responseText;\n");
		//builder.format("if(response == \"true\") {\n");
		builder.format("window.location.reload();\n");
		builder.format("}\n");
		
		return builder.toString();
	}
}
