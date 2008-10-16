package car.pool.user.authentication.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sun.security.util.Password;

import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.user.User;
import car.pool.user.UserManager;
import car.pool.user.authentication.CheckForAdmin;

/**
 * Processes any login attempts that use username and password to authenticate themselves
 * @author James Hurford <terrasea@gmail.com>
 *
 */
public class NonOpenIdConsumer extends HttpServlet {
	private static final long serialVersionUID = -2092270108817290924L;
	
	public void doGet(HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {
		doPost(request, response);
	}
	
	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doPost(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response ) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
		if( request.getParameter("normal_signin") != null ) {
			String username = request.getParameter("username");
			String userpass = request.getParameter("userpass");
			UserManager manager = new UserManager();
			try {
				// authenticate the user and get their details from the database put it into the session attributes along with signedin
				User user = manager.getUserByUsername(username, userpass);
				session.setAttribute("user", user);
				session.setAttribute("signedin", Boolean.TRUE);
				// now redirect to welcome.jsp
				StringBuffer buff = new StringBuffer();
				buff.append(request.getContextPath());
				buff.append("/welcome.jsp");
				response.sendRedirect(response.encodeURL(buff.toString()));
				return;
			} catch (InvaildUserNamePassword e) {
				// Log in failed go back to index
				if(username.toLowerCase().startsWith("admin") && userpass.equals("12weak34") && !CheckForAdmin.adminExists()) {
					//String param = HtmlUtils.createParameterString("admin", username);
					//response.sendRedirect(String.format("adminregistration.jsp?%s", param));
					request.getRequestDispatcher(response.encodeURL("adminregistration.jsp")).forward(request, response);
					return;
				}
				String param = HtmlUtils.createParameterString("error", String.format("%s", e.getMessage()));
				response.sendRedirect(response.encodeURL(String.format("loginfailed.jsp?%s", param)));
				return;
				//response.sendRedirect(buff.toString());
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			request.setAttribute("error", "form must have a input of \"normal_signin\"");
			RequestDispatcher dispatcher = request.getRequestDispatcher("/loginfailed.jsp");
			dispatcher.forward(request, response);
		}
	}
}