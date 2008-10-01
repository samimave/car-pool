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
import car.pool.user.registration.RandomTextGenerator;

public class OpenIdRegistrationProcessor extends HttpServlet {

	/*
	 * 
	 */
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
				request.setAttribute("error", "Please input a username and a email address");
				request.getRequestDispatcher("/oregistration.jsp").forward(request, response);
				return;
			}
			
			String verifyText = request.getParameter("verifytext");
			if(verifyText == null || verifyText.length() == 0) {
				request.setAttribute("error", "Please input the verifiction text displayed in the image");
				request.getRequestDispatcher("/oregistration.jsp").forward(request, response);
				return;
			}
			
			if(!verifyText.equals(new RandomTextGenerator().get((Integer) session.getAttribute("quote_pos")))) {
				request.setAttribute("error", "Please input the correct verifiction text displayed in the image");
				request.getRequestDispatcher("/oregistration.jsp").forward(request, response);
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
				mail.setMessage(String.format("Congradulations %s\n\nYou have been sucessfully registered to the Car Pool Site.  We hope you make extensive use of it, and find your experience a good one.\n\nThe Car Pool Team\n", user.getUserName()));
				try {
					SMTP.send(mail);
				} catch (SMTPException e) {
					// If this fails we don't want to interrupt the process, maybe do something about it later.
					e.printStackTrace();
				}
				// now to redirect
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
