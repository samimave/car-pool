package car.pool.user.registration.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import car.pool.persistance.exception.DuplicateUserNameException;
import car.pool.persistance.exception.UserException;
import car.pool.user.User;
import car.pool.user.UserFactory;
import car.pool.user.UserManager;
import car.pool.user.authentication.servlet.HtmlUtils;

/**
 * Processes registration of the administrator
 * 
 * @author James Hurford <terrasea@gmail.com>
 *
 */
public class AdminRegistration extends HttpServlet {
	private static final long serialVersionUID = 8740358060048284751L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		doPost(request, response);
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		HttpSession sessionVar = request.getSession(false);
		String username = request.getParameter("username");
		String userpass = request.getParameter("userpass");
		String password2 = request.getParameter("password2");
		String password1 = request.getParameter("password");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		
		if(username == null || username.length() == 0 || email == null || email.length() == 0) {
			String str = HtmlUtils.createParameterString("error", String.format("Please input a username and a email address&username=%s&userpass=%s", username, userpass));
			response.sendRedirect(response.encodeURL(String.format("adminregistration.jsp?%s", str)));
			return;
		}
		
		if(password1 == null || password2 == null || password1.length() == 0 || password2.length() == 0) {
			String str = HtmlUtils.createParameterString("error", String.format("Please input a password&username=%s&userpass=%s", username, userpass));
			response.sendRedirect(response.encodeURL(String.format("adminregistration.jsp?%s", str)));
			return;
		} else {
			if(!password1.equals(password2)) {
				String str = HtmlUtils.createParameterString("error", String.format("passwords must match&username=%s&userpass=%s", username, userpass));
				response.sendRedirect(response.encodeURL(String.format("adminregistration.jsp?%s", str)));
				return;
			}
		}
		
		UserManager manager = new UserManager();
		User noidUser = UserFactory.newInstance();
		noidUser.setUserName(username);
		noidUser.setEmail(email);
		noidUser.setPassword(password1);  // it is assumed since the method got this far that password1 and password2 match
		noidUser.setPhoneNumber(phone);
		try {
			User user = manager.registerUser(noidUser);
			sessionVar.setAttribute("user", user);
			sessionVar.setAttribute("signedin", Boolean.TRUE);
			
			String s = String.format("%s/welcome.jsp", request.getContextPath());
			response.sendRedirect(response.encodeURL(s));
			return;
		} catch (DuplicateUserNameException e) {
			// not going to bother sending them back to reg page, as a admin already exists so back to index you go
			response.sendRedirect(response.encodeURL(""));
			return;
		} catch (UserException e) {
			String param = HtmlUtils.createParameterString("error", e.getMessage());
			String s = String.format("adminregistration.jsp?%s", param);
			response.sendRedirect(response.encodeURL(s));
			return;
		} catch (SQLException e) {
			String param = HtmlUtils.createParameterString("error", "There is a problem with the database, Please inform the site administrator.");
			String s = String.format("adminregistration.jsp?%s", param);
			response.sendRedirect(response.encodeURL(s));
			return;
		}
	}
}
