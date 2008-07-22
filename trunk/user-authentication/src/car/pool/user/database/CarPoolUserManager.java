package car.pool.user.database;

import java.util.Hashtable;
import java.util.Map;

import org.verisign.joid.Store;
import org.verisign.joid.db.DbStore;
import org.verisign.joid.server.MemoryUserManager;
import org.verisign.joid.server.OpenIdServlet;
import org.verisign.joid.server.User;
import org.verisign.joid.server.UserManager;

public class CarPoolUserManager implements UserManager {

	Map<String, User> users = new Hashtable<String, User>();
	Store store = new DbStore();
	
	private MemoryUserManager userManager()
    {
		
        return (MemoryUserManager) OpenIdServlet.getUserManager();
    }
	
	public CarPoolUserManager() {
		addUser("James", "password");
		addUser("Arlo", "password");
		addUser("Ben", "password");
		addUser("Jordan", "password");
		addUser("Parul", "password");
		addUser("Sam/Yong", "password");
	}
	
	protected void addUser(String name, String password) {
		User record = new User();
		record.setUsername(name);
		record.setPassword(password);
		users.put(name, record);
	}
	
	public void saveUser(User user) {
		userManager().save(user);
	}
	
	public User getUser( String name ) throws NoSuchUserException {
		User user = null;
		try {
			//user = users.get(name);
			user = userManager().getUser(name);
		} catch(NullPointerException e) {
			throw new NoSuchUserException();
		}
//		if( user == null ) {
//			throw new NoSuchUserException();
//		}
		return user;
	}

	@Override
	public boolean canClaim(String username, String claimedId) {
		String usernameFromClaimedId = claimedId.substring(claimedId.lastIndexOf("/") + 1);
        if (username.equals(usernameFromClaimedId)) {
            return true;
        }
		return false;
	}

	@Override
	public String getRememberedUser(String username, String authKey) {
		if (username == null || authKey == null) return null;
		return userManager().getRememberedUser(username, authKey);
		//return null;
	}

	@Override
	public void remember(String username, String authKey) {
		// TODO Auto-generated method stub
		userManager().remember(username, authKey);
	}
}
