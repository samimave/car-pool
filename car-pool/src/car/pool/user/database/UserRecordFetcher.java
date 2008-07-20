package car.pool.user.database;

import car.pool.user.User;

public class UserRecordFetcher {

	private class UserRecord implements User {

		private String name = null;
		private String password = null;
		
		@Override
		public String getName() {
			// TODO Auto-generated method stub
			return name;
		}

		@Override
		public String getPassword() {
			// TODO Auto-generated method stub
			return password;
		}
		
	}
	
	public User getUserRecord( String name ) {
		UserRecord record = new UserRecord();
		record.name = "James";
		record.password = "password";
		
		return record;
	}
}
