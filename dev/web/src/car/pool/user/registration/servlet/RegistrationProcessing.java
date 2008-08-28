package car.pool.user.registration.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.servlet.ServletException;
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


public class RegistrationProcessing extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4410555702177133894L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		register(request, response);
	}
	
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//System.out.println(String.format("%s/welcome.jsp", request.getContextPath()));
		register(request, response);
		
	}
	
	private void register(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String password1 = null;
		String password2 = null;
		String use_openid = null;
		String confirmReg = null;
		String openid_url = null;
		String phone = null;
		String email = null;
		String userName = null;
		String signin = null;
		String newUser = null;
		HttpSession session = request.getSession();
		String loggedInAs = OpenIdFilter.getCurrentUser(request.getSession());
		if(session.getAttribute("registration") == null) {
			System.out.println("not registration");
			password1 = request.getParameter("password1");
			System.out.println(password1);
			password2 = request.getParameter("password2");
			use_openid = request.getParameter("use_openid");
			confirmReg = request.getParameter("confirmReg");
			openid_url = request.getParameter("openid_url");
			phone = request.getParameter("phone");
			email = request.getParameter("email");
			userName = request.getParameter("userName");
			signin = request.getParameter("signin");
			newUser = request.getParameter("newUser");
		} else {
			System.out.print("registration");
			//Map<String,String> map = (Map<String,String>)session.getAttribute("user_details");
			try {
				password1 = (String)session.getAttribute("password1");
				password2 = (String)session.getAttribute("password2");
			} catch(NullPointerException e) {
				password1 = "";
				password2 = "";
			}
			use_openid = (String)session.getAttribute("use_openid");
			confirmReg = (String)session.getAttribute("confirmReg");
			openid_url = (String)session.getAttribute("openid_url");
			phone = (String)session.getAttribute("phone");
			email = (String)session.getAttribute("email");
			userName = (String)session.getAttribute("userName");
			signin = (String)session.getAttribute("signin");
			newUser = (String)session.getAttribute("newUser");
		}
		
		
		System.out.println(openid_url);
		if(loggedInAs == null && openid_url.length() > 0) {
			// pain I will have to store this data above and authenticate the openid first
			//Map<String, String> map = Collections.synchronizedMap(new LinkedHashMap<String, String>());
			session.setAttribute("password1", password1);
			session.setAttribute("password2", password2);
			session.setAttribute("use_openid", use_openid);
			session.setAttribute("confirmReg", confirmReg);
			session.setAttribute("openid_url", openid_url);
			session.setAttribute("phone", phone);
			session.setAttribute("email", email);
			session.setAttribute("userName", userName);
			session.setAttribute("signin", signin);
			session.setAttribute("newUser", newUser);
			//session.setAttribute("user_datails", map);
			session.setAttribute("registration", Boolean.TRUE);
			response.sendRedirect(String.format("%s/openidlogin", request.getContextPath()));
			return;
		} else if(loggedInAs != null && openid_url.length() > 0) {
			//normalize the openid_url if it needs it
			if(!openid_url.startsWith("http:")) {
				openid_url = "http://" + openid_url;
			}
			// check to make sure they are equal
			if(!loggedInAs.equals(openid_url)) {
				// TODO what happens if a users entered openid_url does not match the openid they logged in with?
			}
		}
		
		UserManager manager = new UserManager();
		User noidUser = UserFactory.newInstance();
		if(password1.length() > 0 || password2.length() > 0) {
			if(!password1.equals(password2)) {
				// TODO make sure they get a error message and the form is prefilled with the previous values they entered 
				response.sendRedirect(String.format("%s/register.jsp", request.getContextPath()));
				return;
			}
			System.out.println(password1);
		}
		noidUser.setUserName(userName);
		noidUser.setEmail(email);
		noidUser.setPassword(password1);  // it is assumed since the method got this far that password1 and password2 match
		System.out.println(noidUser.getPassword());
		noidUser.setPhoneNumber(phone);
		if(loggedInAs != null) {
			// assuming they are only using one openid and the loggedInAs matches openid_url
			noidUser.addOpenId(loggedInAs);
		}
		try {
			User user = manager.registerUser(noidUser);
			session.setAttribute("user", user);
			session.setAttribute("signedin", Boolean.TRUE);
			if(session.getAttribute("registration") != null) {
				//session.removeAttribute("user_details");
				session.removeAttribute("password1");
				session.removeAttribute("password2");
				session.removeAttribute("use_openid");
				session.removeAttribute("confirmReg");
				session.removeAttribute("openid_url");
				session.removeAttribute("phone");
				session.removeAttribute("email");
				session.removeAttribute("userName");
				session.removeAttribute("signin");
				session.removeAttribute("newUser");
				session.removeAttribute("registration");
			}
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