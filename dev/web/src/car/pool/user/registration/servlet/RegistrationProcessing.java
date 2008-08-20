package car.pool.user.registration.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.verisign.joid.consumer.OpenIdFilter;


public class RegistrationProcessing extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4410555702177133894L;
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		String loggedInAs = OpenIdFilter.getCurrentUser(request.getSession());
		String password1 = request.getParameter("password1");
		String password2 = request.getParameter("password2");
		String use_openid = request.getParameter("use_openid");
		String confirmReg = request.getParameter("confirmReg");
		String openid_url = request.getParameter("openid_url");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		String userName = request.getParameter("userName");
		String signin = request.getParameter("signin");
		String newUser = request.getParameter("newUser");
		
		if(loggedInAs == null && openid_url.length() > 0) {
			// pain I will have to store this data above and authenticate the openid first
			
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
	}
}