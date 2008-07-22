package car.pool.user.authentication;

import car.pool.user.User;

public class Authenticate {

	public Authenticate() {
		
	}
	
	boolean isValid(User user, String password) {
		if(user.getPassword().equals(password)) {
			return true;
		}
		return false;
	}
}
