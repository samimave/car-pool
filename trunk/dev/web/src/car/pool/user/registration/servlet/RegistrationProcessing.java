package car.pool.user.registration.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
 * Handles the registration of users using username and password and puts the data into the database and loggs them in redirecting them to the welcome page
 * 
 * @author James Hurford <terrasea@gmail.com>
 *
 */

public class RegistrationProcessing extends HttpServlet {
	private static final long serialVersionUID = -4410555702177133894L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		register(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("here");
		register(request, response);
	}
	
	private void register(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		HttpSession sessionVar = request.getSession(false);
		if (sessionVar == null) {
			System.out.println("Session is null");
		}
		//String loggedInAs = OpenIdFilter.getCurrentUser(request.getSession());
		String password1 = "";
		password1 = request.getParameter("password");
		String password2 = request.getParameter("password2");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		String userName = request.getParameter("userName");
		
		if(userName == null || email == null || userName.length() == 0 || email.length() == 0) {
			response.sendRedirect(response.encodeURL("register.jsp?error=Please%20input%20a%20username%20and%20a%20email%20address"));
			return;
		}else if((password1 != null && password2 != null) && (password1.length() > 0 || password2.length() > 0)) {
			if(!password1.equals(password2)) {
				response.sendRedirect(response.encodeURL("register.jsp?error=passwords%20must%20match"));
				return;
			}
		} else {
			response.sendRedirect(response.encodeURL("register.jsp?error=Please%20input%20a%20password"));
			return;
		}
		
		if(userName.toLowerCase().startsWith("admin")) {
			String param = HtmlUtils.createParameterString("error", "Username already in use, please use another");
			String s = String.format("register.jsp?%s", param);
			response.sendRedirect(response.encodeURL(s));
			return;
		}
		
		RandomTextGenerator generator = new RandomTextGenerator();
		String verifierText = generator.get(Integer.parseInt(sessionVar.getAttribute("quote_pos").toString()));
		String verifyText = request.getParameter("verifytext").toLowerCase();
		if(verifyText == null || verifyText.length() == 0) {
			String param = HtmlUtils.createParameterString("error", "Please input the verifiction text displayed in the image");
			response.sendRedirect(response.encodeURL(String.format("register.jsp?%s", param)));
			return;
		}
		
		if(!verifyText.equals(verifierText.toLowerCase())) {
			String param = HtmlUtils.createParameterString("error", "Please input the correct verifiction text displayed in the image");
			response.sendRedirect(response.encodeURL(String.format("register.jsp?%s", param)));
			return;
		}
		
		UserManager manager = new UserManager();
		User noidUser = UserFactory.newInstance();
		noidUser.setUserName(userName);
		noidUser.setEmail(email);
		noidUser.setPassword(password1);  // it is assumed since the method got this far that password1 and password2 match
		noidUser.setPhoneNumber(phone);
		try {
			User user = manager.registerUser(noidUser);
			sessionVar.setAttribute("user", user);
			sessionVar.setAttribute("signedin", Boolean.TRUE);
			// now to email the user with the success
			Email mail = new Email();
			mail.setToAddress(user.getEmail());
			mail.setSubject("Registration for the Car Pool Service");
			String message = String.format("Hello %s, thank you for registering with The Car Pool. We hope you find our site useful. To find out about the various things you can do with our site have a look at the FAQ page http://%s:%d%s/faq.jsp. And then log in and car pool away!", user.getUserName(), request.getLocalName(), request.getLocalPort(), request.getContextPath());
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
			String s = String.format("register.jsp?%s", param);
			response.sendRedirect(response.encodeURL(s));
			return;
		} catch (UserException e) {
			String param = HtmlUtils.createParameterString("error", e.getMessage());
			String s = String.format("register.jsp?%s", param);
			response.sendRedirect(response.encodeURL(s));
			return;
		} catch (SQLException e) {
			String param = HtmlUtils.createParameterString("error", "There is a problem with the database, Please inform the site administrator.");
			String s = String.format("register.jsp?%s", param);
			response.sendRedirect(response.encodeURL(s));
			return;
		}
	}
}