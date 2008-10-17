package car.pool.user.update.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import car.pool.user.User;
import car.pool.user.UserManager;

/**
 * Detaches a OpenID to the currently logged in user removing it from the database
 * 
 * @author James Hurford <terrasea@gmail.com>
 *
 */
public class RemoveOpenId extends HttpServlet {
	private static final long serialVersionUID = -5249343738435970805L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession();
		if(request.getParameter("removeopenid") != null && session.getAttribute("signedin") != null) {
			String openid = request.getParameter("openid");
			User user = (User) session.getAttribute("user");
			try {
				UserManager manager = new UserManager();
				User nuser = manager.detachOpenId(openid, user);
				session.removeAttribute("user");
				session.setAttribute("user", nuser);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			response.sendRedirect(response.encodeURL("myDetails.jsp"));
		} else {
			response.sendRedirect(response.encodeURL(request.getContextPath()));
		}
	}
}
