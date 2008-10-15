package car.pool.user.authentication.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.user.User;
import car.pool.user.UserManager;

public class NonOpenIdConsumer extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2092270108817290924L;
	
	public void doGet(HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {
		doPost(request, response);
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		out.println("<html><body><p>is normal_login?</p>");
		if( request.getParameter("normal_signin") != null ) {
			out.println("<p>yes</p>;");
			String username = request.getParameter("username");
			String userpass = request.getParameter("userpass");
			UserManager manager = new UserManager();
			try {
				// authenticate the user and get their details from the database put it into the session attributes along with signedin
				User user = manager.getUserByUsername(username, userpass);
				HttpSession session = request.getSession();
				session.setAttribute("user", user);
				session.setAttribute("signedin", Boolean.TRUE);
				// now redirect to welcome.jsp
				StringBuffer buff = new StringBuffer();
				buff.append(request.getContextPath());
				buff.append("/welcome.jsp");
				response.sendRedirect(buff.toString());
			} catch (InvaildUserNamePassword e) {
				// Log in failed go back to index
				StringBuffer buff = new StringBuffer();
				buff.append(request.getContextPath());
				buff.append("/loginfailed.jsp");
				response.sendRedirect(buff.toString());
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			out.println("<p>NO</p></body></html>");
		}
	}
}