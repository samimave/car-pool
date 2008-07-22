package car.pool.user.database;

import java.util.Hashtable;
import java.util.Map;
import car.pool.user.User;

public class UserRecordFetcher {

	Map<String, User> users = new Hashtable<String, User>();
	
	private class UserRecord implements User {

		private String name = null;
		private String password = null;
		
		@Override
		public String getName() {
			return name;
		}

		@Override
		public String getPassword() {
			return password;
		}
		
	}
	
	public UserRecordFetcher() {
		addUser("James", "password");
		addUser("Arlo", "password");
		addUser("Ben", "password");
		addUser("Jordan", "password");
		addUser("Parul", "password");
		addUser("Sam/Yong", "password");
	}
	
	protected void addUser(String name, String password) {
		UserRecord record = new UserRecord();
		record.name = name;
		record.password = password;
		users.put(name, record);
	}
	
	public User getUserRecord( String name ) throws NoSuchUserException {
		User user = null;
		try {
			user = users.get(name);
		} catch(NullPointerException e) {
			throw new NoSuchUserException();
		}
//		if( user == null ) {
//			throw new NoSuchUserException();
//		}
		return user;
	}
}
