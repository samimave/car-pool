package car.pool.user.update.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.verisign.joid.consumer.OpenIdFilter;

import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.user.User;
import car.pool.user.UserManager;

/**
 * Updates the currently logged in users info in the database using info gathered from the parameters passed to it.
 * 
 * @author James Hurford <terrasea@gmail.com>
 *
 */
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
			CarPoolStore cps = new CarPoolStoreImpl();
			if(request.getParameter("changePassword") != null && request.getParameter("changePassword").equalsIgnoreCase("on")) {
				if(OpenIdFilter.getCurrentUser(session) == null) {
					String oldpass = request.getParameter("oldpassword");
					try {
						if(cps.checkUser(user.getUserName(), oldpass) == user.getUserId()) {
							String password1 = request.getParameter("newPassword1");
							String password2 = request.getParameter("newPassword2");
							if(password1.equals(password2)) {
								user.setPassword(password1);
							}
						}
					} catch (InvaildUserNamePassword e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				} else {
					String password1 = request.getParameter("newPassword1");
					String password2 = request.getParameter("newPassword2");
					if(password1.equals(password2)) {
						user.setPassword(password1);
					}
				}
			}
			String oldpass = request.getParameter("oldPassword");
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
			response.sendRedirect(response.encodeURL("myDetails.jsp"));
		} else {
			response.sendRedirect(response.encodeURL(request.getContextPath()));
		}
	}
}
