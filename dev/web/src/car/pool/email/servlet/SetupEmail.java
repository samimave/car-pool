package car.pool.email.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;

public class SetupEmail extends HttpServlet {
	private static final long serialVersionUID = 5193075482923805039L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/plain");
		PrintWriter out = response.getWriter();
		if(request.getParameter("emailconfig") != null) {
			boolean authenticate = request.getParameter("authenticate") != null && request.getParameter("authenticate").equals("on");
			String username = "";
			String password = "";
			if(authenticate) {
				username = (String)request.getParameter("username");
				password = (String)request.getParameter("password");
			}
			String replyTo = (String)request.getParameter("replyTo");
			String smtp = (String)request.getParameter("smtpURL");
			Integer port = new Integer((String)request.getParameter("port"));
			boolean useTLS = request.getParameter("useTLS") != null && request.getParameter("useTLS").equals("on");
			Database db = new DatabaseImpl();
			try {
				String sql = "delete from SMTP;";
				db.getStatement().executeUpdate(sql);
				sql = "delete from Email;";
				db.getStatement().executeUpdate(sql);
				sql = String.format("insert into Email values('%s','%s','%s')", username, replyTo, password);
				db.getStatement().executeUpdate(sql);
				sql = String.format("insert into SMTP values('%s', %d, %d)", smtp, port, useTLS ? 1 : 0);
				db.getStatement().executeUpdate(sql);
				out.print("true");
			} catch (SQLException e) {
				out.print("false");
				e.printStackTrace();
			}
		} else {
			out.print("false");
		}
		
		out.close();
	}
}
