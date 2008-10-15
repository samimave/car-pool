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
		private String password = "n/a";
		
		protected UserImpl() {}
		
		@Override
		public Integer calcSocialScore() {
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
			return name;
		}

		@Override
		public String getOcupation() {
			return ocupation;
		}

		@Override
		public Set<String> getOpenIds() {
			return openids;
		}

		@Override
		public String getPhoneNumber() {
			return phoneNumber;
		}

		@Override
		public Integer getSocialScore() {
			return socialScore;
		}

		@Override
		public String getSuburb() {
			return suburb;
		}

		@Override
		public Integer getUserId() {
			return userId;
		}

		@Override
		public String getUserName() {
			return userName;
		}

		@Override
		public boolean loginFailed() {
			// TODO Auto-generated method stub
			return false;
		}

		@Override
		public Calendar getMemberSince() {
			return memberSince;
		}

		@Override
		public void addOpenId(String openid) {
			openids.add(openid);
		}

		@Override
		public void delOpenId(String openid) {
			openids.remove(openid);
		}

		@Override
		public String getPassword() {
			return password;
		}

		@Override
		public void setEmail(String email) {
			this.email = email;
		}

		@Override
		public void setMemberSince(Calendar date) {
			this.memberSince = date;
		}

		@Override
		public void setName(String name) {
			this.name = name;
		}

		@Override
		public void setOcupation(String ocupation) {
			this.ocupation = ocupation;
		}

		@Override
		public void setPassword(String password) {
			this.password = password;
		}

		@Override
		public void setPhoneNumber(String phone) {
			this.phoneNumber = phone;
		}

		@Override
		public void setSocialScore(Integer score) {
			this.socialScore = score;
		}

		@Override
		public void setSuburb(String suburb) {
			this.suburb = suburb;
		}

		@Override
		public void setUserId(Integer id) {
			this.userId = id;
		}

		@Override
		public void setUserName(String name) {
			this.userName = name;
		}
		
		@Override
		public boolean equals(Object obj) {
			return hashCode() == obj.hashCode();
		}
		
		
		private int getHash(Object obj) {
			if(obj != null) {
				return obj.hashCode();
			}
			
			return 0;
		}
		
		@Override
		public int hashCode() {
			int hash = 0 + getHash(email) + getHash(name) + getHash(ocupation) + getHash(phoneNumber) + getHash(suburb) + getHash(userName);
			hash += getHash(memberSince);
			for(String openid : this.openids) {
				hash += getHash(openid);
			}
			hash += getHash(socialScore);
			hash += getHash(suburb);
			hash += getHash(userId);
			
			return hash;
		}
	}
	
	
	User create(String openid) throws InvaildUserNamePassword, IOException, SQLException {
		UserImpl user = new UserImpl();
		CarPoolStore store = new CarPoolStoreImpl();
		user.userId = store.getUserIdByURL(openid);
		System.out.println("User Id: " + user.userId);
		Database db = new DatabaseImpl();
		//db.connect();
		String sql = "select userName, email, mobile_number, signUpDate from User where idUser = " + user.userId + ";";
		System.out.println(sql);
		Statement statement = db.getStatement();
		System.out.println("after statement");
		ResultSet rs = statement.executeQuery(sql);
		System.out.println("after execute query");
		System.out.println(rs);
		if(rs.first()) {
			user.userName = rs.getString(1);
			System.out.println("after get userName");
			user.email = rs.getString(2);
			user.phoneNumber = rs.getString(3);
			java.sql.Date date = rs.getDate(4);
			user.memberSince = Calendar.getInstance();
			user.memberSince.setTime(date);
		}
		for(String openids :store.getOpenIdsByUser(user.getUserId())) {
			System.out.println("OpenId: " + openids);
			user.addOpenId(openids);
		}

		rs.close();
		statement.close();

		return user;
	}
	
	private User create() {
		return new UserImpl();
	}
	
	public static User newInstance() {
		return new UserFactory().create();
	}
}
