package car.pool.user.update.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.user.User;
import car.pool.user.UserManager;

public class UpdateUserDetails extends HttpServlet {
	private static final long serialVersionUID = 8039935676680953454L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession();
		if(request.getParameter("updateDetails") != null && session.getAttribute("signedin") != null) {
			User user = (User)session.getAttribute("user");
			user.setEmail(request.getParameter("email"));
			user.setPhoneNumber(request.getParameter("phone"));
			UserManager manager = new UserManager();
			try {
				user = manager.updateUserDetails(user);
				session.removeAttribute("user");
				session.setAttribute("user", user);
			} catch (InvaildUserNamePassword e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			response.sendRedirect("updatesuccess.jsp");
		} else {
			response.sendRedirect("");
		}
	}
}
