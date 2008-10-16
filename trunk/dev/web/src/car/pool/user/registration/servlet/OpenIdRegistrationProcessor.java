package car.pool.user.registration.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.verisign.joid.consumer.OpenIdFilter;

import car.pool.email.Email;
import car.pool.email.SMTP;
import car.pool.email.SMTPException;
import car.pool.persistance.exception.DuplicateUserNameException;
import car.pool.persistance.exception.UserException;
import car.pool.user.User;
import car.pool.user.UserFactory;
import car.pool.user.UserManager;
import car.pool.user.authentication.servlet.HtmlUtils;
import car.pool.user.registration.RandomTextGenerator;

/**
 * Handles the registration of users using OpenID and puts the data into the database and loggs them in redirecting them to the welcome page
 * 
 * @author James Hurford <terrasea@gmail.com>
 *
 */
public class OpenIdRegistrationProcessor extends HttpServlet {
	private static final long serialVersionUID = -8682803597729939605L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		HttpSession session = request.getSession();
		String loggedInAs = OpenIdFilter.getCurrentUser(session);
		if(loggedInAs != null) {
			UserManager manager = new UserManager();
			User noidUser = UserFactory.newInstance();
			String phone = request.getParameter("phone");
			String email = request.getParameter("email");
			String userName = request.getParameter("userName");
			
			if(email == null || userName == null || email.length() == 0 || userName.length() == 0) {
				String param = HtmlUtils.createParameterString("error", "Please input a username and a email address");
				response.sendRedirect(response.encodeURL(String.format("oregistration.jsp?%s", param)));
				return;
			}
			
			String verifyText = request.getParameter("verifytext").toLowerCase();
			if(verifyText == null || verifyText.length() == 0) {
				String param = HtmlUtils.createParameterString("error", "Please input the verifiction text displayed in the image");
				response.sendRedirect(response.encodeURL(String.format("oregistration.jsp?%s", param)));
				return;
			}
			
			if(!verifyText.equals((new RandomTextGenerator().get((Integer) session.getAttribute("quote_pos")).toLowerCase()))) {
				String param = HtmlUtils.createParameterString("error", "Please input the correct verifiction text displayed in the image");
				response.sendRedirect(response.encodeURL(String.format("oregistration.jsp?%s", param)));
				return;
			}
			
			if(userName.toLowerCase().startsWith("admin")) {
				String param = HtmlUtils.createParameterString("error", "Username already in use, please use another");
				response.sendRedirect(response.encodeURL(String.format("oregistration.jsp?%s", param)));
				return;
			}
			
			noidUser.setUserName(userName);
			noidUser.setEmail(email);
			noidUser.setPhoneNumber(phone);
			noidUser.addOpenId(loggedInAs);
			try {
				User user = manager.registerUser(noidUser);
				session.setAttribute("user", user);
				session.setAttribute("signedin", Boolean.TRUE);
				// now to email the user with the success
				Email mail = new Email();
				mail.setToAddress(user.getEmail());
				mail.setSubject("Registration for the Car Pool Service");
				String message = String.format("Hello %s, thank you for registering with The Car Pool. We hope you find our site useful. To find out about the various things you can	do with our site have a look at the FAQ page http://%s:%d%s/faq.jsp. And then log in and car pool away!", user.getUserName(), request.getLocalName(), request.getLocalPort(), request.getContextPath());
				mail.setMessage(message);
				try {
					SMTP.send(mail);
				} catch (SMTPException e) {
					// If this fails we don't want to interrupt the process, maybe do something about it later.
					e.printStackTrace();
				}
				// now to redirect
				String s = String.format("%s/welcome.jsp", request.getContextPath());
				response.sendRedirect(response.encodeURL(s));
				return;
			} catch (DuplicateUserNameException e) {
				String param = HtmlUtils.createParameterString("error", "Username already in use, please use another");
				response.sendRedirect(response.encodeURL(String.format("oregistration.jsp?%s", param)));
				return;
			} catch (UserException e) {
				String param = HtmlUtils.createParameterString("error", e.getMessage());
				response.sendRedirect(response.encodeURL(String.format("oregistration.jsp?%s", param)));
				return;
			} catch (SQLException e) {
				String param = HtmlUtils.createParameterString("error", "There is a problem with the database, Please inform the site administrator.");
				response.sendRedirect(response.encodeURL(String.format("oregistration.jsp?%s", param)));
				return;
			}
		}
	}
}
