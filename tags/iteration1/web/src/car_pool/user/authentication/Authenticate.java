package car.pool.user.authentication;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.verisign.joid.OpenIdException;
import org.verisign.joid.consumer.OpenIdFilter;

public class Authenticate {
	private String returnTo = null;
	private String trustRoot = null;
	
	public Authenticate(String returnTo, String trustRoot) {
		this.returnTo = returnTo;
		this.trustRoot = trustRoot;
	}
	
	private boolean userExists(String openid) {
		return false;
	}
	
	public void askProvider(String openid, HttpServletResponse response) throws IOException {
		try {
			if(userExists(openid)) {
				response.sendRedirect(OpenIdFilter.joid().getAuthUrl(openid, returnTo, trustRoot));
			} else {
				// TODO deal with getting extra data to put in the DB
			}
		} catch (OpenIdException e) {
			
		}	
	}
	
	public boolean checkResponse(HttpSession session) {
		if(OpenIdFilter.getCurrentUser(session) != null ) {
			return true;
		}
		
		return false;
	}
	
	public void logout(HttpSession session) {
		OpenIdFilter.logout(session);
	    session.removeAttribute("user");
	    session.invalidate();
	}
}
