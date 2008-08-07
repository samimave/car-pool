package car.pool.user;


import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Calendar;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Set;

import java.io.IOException;

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
		private Set<String> openids = Collections.synchronizedSet(new LinkedHashSet<String>());
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
		public Set<String> getOpenIds() {
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
		public Calendar getMemberSince() {
			// TODO Auto-generated method stub
			return memberSince;
		}

		@Override
		public void addOpenId(String openid) {
			// TODO Auto-generated method stub
			openids.add(openid);
		}

		@Override
		public String getPassword() {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public void setEmail(String email) {
			// TODO Auto-generated method stub
			this.email = email;
		}

		@Override
		public void setMemberSince(Calendar date) {
			// TODO Auto-generated method stub
			this.memberSince = date;
		}

		@Override
		public void setName(String name) {
			// TODO Auto-generated method stub
			this.name = name;
		}

		@Override
		public void setOcupation(String ocupation) {
			// TODO Auto-generated method stub
			this.ocupation = ocupation;
		}

		@Override
		public void setPassword(String password) {
			// TODO Auto-generated method stub
		}

		@Override
		public void setPhoneNumber(String phone) {
			// TODO Auto-generated method stub
			this.phoneNumber = phone;
		}

		@Override
		public void setSocialScore(Integer score) {
			// TODO Auto-generated method stub
			this.socialScore = score;
		}

		@Override
		public void setSuburb(String suburb) {
			// TODO Auto-generated method stub
			this.suburb = suburb;
		}

		@Override
		public void setUserId(Integer id) {
			// TODO Auto-generated method stub
			this.userId = id;
		}

		@Override
		public void setUserName(String name) {
			// TODO Auto-generated method stub
			this.userName = name;
		}		
	}
	
	
	private User create(String openid) throws InvaildUserNamePassword, IOException {
		UserImpl user = new UserImpl();
		CarPoolStore store = new CarPoolStoreImpl();
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
	
	public static User getInstance(String openid) throws InvaildUserNamePassword, IOException {
		User user = new UserFactory().create(openid);
		
		return user;
	}
}
