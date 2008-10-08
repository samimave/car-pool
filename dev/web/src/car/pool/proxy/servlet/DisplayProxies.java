package car.pool.proxy.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;

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
			ResultSet results = db.getStatement().executeQuery("select * from proxyaddress;");
			out.print("<table class=\"proxy\" id=\"proxy\">");
			while(results.next()) {
				displayRow(out, results);
			}
			out.println("</table>");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}


	private void displayRow(PrintWriter out, ResultSet results) {
		out.format("<tr><td></td></tr>");
	}
}
