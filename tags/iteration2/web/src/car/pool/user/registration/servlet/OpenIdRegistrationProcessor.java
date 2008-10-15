package car.pool.user.registration.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.verisign.joid.consumer.OpenIdFilter;

import car.pool.persistance.exception.DuplicateUserNameException;
import car.pool.persistance.exception.UserException;
import car.pool.user.User;
import car.pool.user.UserFactory;
import car.pool.user.UserManager;

public class OpenIdRegistrationProcessor extends HttpServlet {

	/*
	 * 
	 */
	private static final long serialVersionUID = -8682803597729939605L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String loggedInAs = OpenIdFilter.getCurrentUser(request.getSession());
		if(loggedInAs != null) {
			UserManager manager = new UserManager();
			User noidUser = UserFactory.newInstance();
			String phone = request.getParameter("phone");
			String email = request.getParameter("email");
			String userName = request.getParameter("userName");
			noidUser.setUserName(userName);
			noidUser.setEmail(email);
			noidUser.setPhoneNumber(phone);
			noidUser.addOpenId(loggedInAs);
			try {
				HttpSession session = request.getSession();
				User user = manager.registerUser(noidUser);
				session.setAttribute("user", user);
				session.setAttribute("signedin", Boolean.TRUE);
				String s = String.format("%s/welcome.jsp", request.getContextPath());
				response.sendRedirect(s);
				return;
			} catch (DuplicateUserNameException e) {
				// TODO make sure a error message is shown for this user telling them why they couldn't be registered
				String s = String.format("%s/register.jsp", request.getContextPath());
				response.sendRedirect(s);
				return;
			} catch (UserException e) {
				// TODO make sure a error message is shown for this user telling them why they couldn't be registered
				response.sendRedirect(String.format("%s/register.jsp", request.getContextPath()));
				return;
			} catch (SQLException e) {
				// TODO make sure a error message is shown for this user telling them why they couldn't be registered
				response.sendRedirect(String.format("%s/register.jsp", request.getContextPath()));
				return;
			}
		}
	}
}
