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
import javax.servlet.http.HttpSession;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;
import car.pool.user.User;
/**
 * Technologies used here are HttpServlet, javascript with ajax.  The output is intended to be inserted into another page using the <object> tag.
 * The parameers need fo thi are <objet data="[url for this servlet]" type="text/html" width="500" height="300"> or you could just display this as a stand alone page.
 * This is intended to be a dynamically updated page where you can add or remove proxies and the output will be updated for you as you do this.  Hence the use of javascript and ajax 
 * @author James hurford <terrasea@gmail.com>
 *
 */
public class DisplayProxies extends HttpServlet {
	private static final long serialVersionUID = -3663186030520570646L; // servlets are seializable
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		// only allow those who are logged in and are a admin view this output.
		if(session.getAttribute("signedin") != null) {
			User user = (User)session.getAttribute("user");
			if(user.getUserName().toLowerCase().startsWith("admin")) {
				Database db = new DatabaseImpl();
				PrintWriter out = response.getWriter();
				// for the moment it seems that firefox doesn't like the javascript if you include these xml and doctype declarations
				//out.println("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
				//out.println("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">");
				out.println("<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\">");
				out.println("<head>\n<title>Proxy List</title>");
				// setup the javascript global variables and functions used by the form and buttons displayed in the page
				out.format("<script type=\"text/javascript\">\n<!--//\n%s\n", createAjax());
				out.format("%s\n", createDeleteFunction());
				// the add to table proxy javascript function.
				out.print("    function setupproxy(form) {\n");
				out.print("        var url = \"setupproxy?proxysetup=yes&ipaddress=\"+form.ipaddr.value+\"&port=\"+form.port.value+\"&ptypes=\"+form.ptypes.value;\n");
				out.print("        request.open(\"GET\", url, false);\n");
				out.print("        request.send( null );\n");
				out.print("        var response = request.responseText;\n");
				out.print("        if(response == \"false\") {\n");
				out.println("            alert(\"Failed to add proxy to list\");");
				out.println("        }");
				out.print("        window.location.reload();\n");
				out.print(         "return false;\n");
				out.print("     }\n");
				out.println("//-->");
				out.print("</script>\n");
				out.print("</head><body>\n");
				try {
					ResultSet results = db.getStatement().executeQuery("select * from proxyaddress;");
					out.print("<table class=\"proxy\" id=\"proxy\">");
					out.print("<tr><th>IP Address</th><th>Port</th><th>Proxy Types</th></tr>");
					while(results.next()) {
						displayRow(out, results);
					}
					//out.println("</table>");
					out.println("<div><form action=\"javascript:void(0)\" onsubmit=\"return setupproxy(this)\"><tr><td><input type=\"text\" name=\"ipaddr\" size=\"10\"/></td><td><input type=\"text\" name=\"port\" size=\"10\"/></td><td><input type=\"text\" name=\"ptypes\" size=\"10\"/></td><td><input value=\"Add\" type=\"submit\"/></td></tr></table></form></div>");
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				out.print("</body></html>\n");
			} else {
				response.sendRedirect(response.encodeURL("welcome.jsp"));
				return;
			}
		} else {
			response.sendRedirect(response.encodeURL(""));
			return;
		}
	}


	/**
	 * I wasn't consistent with this but eah javascript function is created in the output of a sepate method and outputed in the response, making it easier to work on them in the future if changes are needed.
	 * @return the string containing the javascript ajax variable needed by the other javascript functions 
	 */
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


	/**
	 * prins ou table row wih the data contained in the current table row in the database
	 * @param out - the Printwriter to output the results to A stand alone button is added to the end of the row which has a javascrpt function associayed with its's onclick event to delete this row from the database table
	 * @param results thw resultset which is at the row you wish to be outputed.
	 */
	private void displayRow(PrintWriter out, ResultSet results) {
		try {
			out.format("<tr><td>%s</td><td>%s</td><td>%s</td><td><button value=\"Delete\" type=\"button\" onclick=\"delproxy('%s','%s','%s')\">Delete</button></td></tr>", results.getString(1),results.getString(2),results.getString(3),results.getString(1),results.getString(2), results.getString(3));
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}


	/**
	 * Creates a string definition of the javascript function used to delete a row of data from the proxyaddress table
	 * @return - a javascript funtion definition for deleting a table row
	 */
	private String createDeleteFunction() {
		Formatter builder = new Formatter();
		builder.format("function delproxy(ip, port, ptypes) {\n");
		builder.format("var url = \"setupproxy?proxydelete=yes&ipaddress=\"+ip+\"&port=\"+port+\"&ptypes=\"+ptypes;\n");
		builder.format("request.open(\"GET\", url, false);\n");
		builder.format("request.send( null );\n");
		builder.format("var response = request.responseText;\n");
		//builder.format("if(response == \"true\") {\n");
		builder.format("window.location.reload();\n");
		builder.format("}\n");
		
		return builder.toString();
	}
	
	
}
