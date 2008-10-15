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
		response.setContentType("text/plain"); // this is called by ajax and is only looking for true and false as the output.
		PrintWriter out = response.getWriter();
		// make sure the right parameters in form are used, This makes sure they at least think about it before they create a form for using this servlet
		if(request.getParameter("emailconfig") != null) {
			// now the values from the parameters are extracted and stored 
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
				// only one line in each of the table used is used so delete any previous dats
				String sql = "delete from SMTP;";
				db.getStatement().executeUpdate(sql);
				sql = "delete from Email;";
				db.getStatement().executeUpdate(sql);
				// now for the obvious insert of data into the tables
				sql = String.format("insert into Email values('%s','%s','%s')", username, replyTo, password);
				db.getStatement().executeUpdate(sql);
				sql = String.format("insert into SMTP values('%s', %d, %d)", smtp, port, useTLS ? 1 : 0);
				db.getStatement().executeUpdate(sql);
				out.print("true"); // nothing went wrong so output true
			} catch (SQLException e) {
				out.print("false"); // it failed for some SQL reason so output false
				e.printStackTrace();
			}
		} else {
			// TODO maybe should print something else but for the moment this will do
			out.print("false"); // wrong table used so output false
		}
		
		out.close();
	}
}
