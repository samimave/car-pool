package car.pool.user;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;

import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;
import car.pool.persistance.exception.InvaildUserNamePassword;

public class UserFactory {
	protected class UserImpl implements User {

		private String userName = null;
		private String email = null;
		private String name = null;
		private String ocupation = null;
		private List<String> openids = Collections.synchronizedList(new ArrayList<String>());
		private String phoneNumber = null;
		private Integer socialScore = new Integer(0);
		private String suburb = null;
		private Integer userId = null;
		private Calendar memberSince = null;
		
		protected UserImpl() {}
		
		@Override
		public Integer calcSocialScore() {
			// TODO Auto-generated method stub
			return new Integer(0);
		}

		@Override
		public boolean checkPassword() {
			// TODO Auto-generated method stub
			return false;
		}

		@Override
		public void editDetail() {
			// TODO Auto-generated method stub
			
		}

		@Override
		public String getEmail() {
			// TODO Auto-generated method stub
			return email;
		}

		@Override
		public String getName() {
			// TODO Auto-generated method stub
			return name;
		}

		@Override
		public String getOcupation() {
			// TODO Auto-generated method stub
			return ocupation;
		}

		@Override
		public List<String> getOpenIds() {
			// TODO Auto-generated method stub
			return openids;
		}

		@Override
		public String getPhoneNumber() {
			// TODO Auto-generated method stub
			return phoneNumber;
		}

		@Override
		public Integer getSocialScore() {
			// TODO Auto-generated method stub
			return socialScore;
		}

		@Override
		public String getSuburb() {
			// TODO Auto-generated method stub
			return suburb;
		}

		@Override
		public Integer getUserId() {
			// TODO Auto-generated method stub
			return userId;
		}

		@Override
		public String getUserName() {
			// TODO Auto-generated method stub
			return userName;
		}

		@Override
		public boolean loginFailed() {
			// TODO Auto-generated method stub
			return false;
		}

		@Override
		public Calendar memberSince() {
			// TODO Auto-generated method stub
			return memberSince;
		}		
	}
	
	
	private User create(String openid) throws InvaildUserNamePassword {
		UserImpl user = new UserImpl();
		CarPoolStore store = CarPoolStoreImpl.getStore();
		try {
			user.userId = store.getUserIdByURL(openid);
			Database db = new DatabaseImpl();
			String sql = "select userName, email, mobile_number, signUpDate from User where idUser = " + user.userId + ";";
			Statement statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			user.userName = rs.getString("userName");
			user.email = rs.getString("email");
			user.phoneNumber = rs.getString("mobile_number");
			java.sql.Date date = rs.getDate("signUpDate");
			user.memberSince = Calendar.getInstance();
			user.memberSince.setTime(date);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return user;
	}
	
	public static User getInstance(String openid) throws InvaildUserNamePassword {
		User user = new UserFactory().create(openid);
		
		return user;
	}
}
