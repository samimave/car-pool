package car_pool.user.authentication;

import javax.security.auth.login.LoginException;
import javax.servlet.http.HttpSession;

import org.verisign.joid.AuthenticationRequest;
import org.verisign.joid.server.User;

import car_pool.user.database.CarPoolUserManager;
import car_pool.user.database.NoSuchUserException;

public class Authenticate {

	/**
	 * The UserManager for the purposes of storing user names and passwords
	 */
	CarPoolUserManager userRecords = new CarPoolUserManager();
	
	/**
	 * The Authentication class for authenticating users and/or creating new users
	 */
	public Authenticate() {
		
	}
	
	/**
	 * Authenticates a user.  If they are new then creates a new user. If not then fetches the record of the user and checks their password.
	 * @param name - the name of the user
	 * @param password - the users password
	 * @param newUser - boolean variable, true if they are a new user, false if not new user
	 * @throws LoginException - will be thrown if either the username is wrong in the case of newUser being false or if the password supplied is wrong
	 */
	public void authenticate(String name, String password, boolean newUser) throws LoginException {
		User user = fetchUserRecord(name, password, newUser);
		if(newUser != true) {
			checkPassword(user, password);
		}
	}
	
	
	public boolean canClaim(User user, String claimedId) {
		return userRecords.canClaim(user.getUsername(), claimedId);
	}
	
	/**
	 * Fetches a user record creating one if one does not already exist
	 * @param name - the name of the user
	 * @param password - the users password
	 * @param newUser -  boolean variable, true if they are a new user, false if not new user
	 * @return a user record containing their name and password
	 * @throws LoginException - will be thrown if the username is wrong in the case of newUser being false.
	 */
	User fetchUserRecord(String name, String password, boolean newUser) throws LoginException {
		User user = null;
		try {
			user = userRecords.getUser(name);
		} catch (NoSuchUserException e) {
			if(newUser) {
				user = new User(name, password);
				userRecords.saveUser(user);
			} else {
				throw new LoginException();
			}
		}
		return user;
	}
	
	/**
	 * Checks if password is correct
	 * @param user - the user record
	 * @param password - the supplied password for checking
	 * @throws LoginException - thrown if supplied password is wrong
	 */
	void checkPassword(User user, String password) throws LoginException {
		if(user.getPassword().equals(password) != true) {
			throw new LoginException();
		}
	}
	
	
	public String getClaimID( HttpSession session ) {
		String claimedID = (String)session.getAttribute(AuthenticationRequest.OPENID_CLAIMED_ID);
		
		return claimedID;
	}
}
