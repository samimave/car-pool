package car.pool.user;


import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.Calendar;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Set;

import car.pool.persistance.CarPoolStoreImpl;
import car.pool.security.AeSimpleSHA1;

/**
 * A factory used to create instances of User.
 * In future I think I might remove the inner class of UserImpl and put it in a separate class.  I'm not sure if the current implementation is the best one, but I had to make a decision and this was it.
 * @author James Hurford <terrasea@gmail.com>
 *
 */
public class UserFactory {
	/**
	 * The inner class definition of the User interface.  Hidden from the rest of the world, and only able to get out through the factory newInstace method.
	 * @author James Hurford <terrasea@gmail.com>
	 *
	 */
	protected class UserImpl implements User {

		private String userName = null;
		private String email = null;
		private String name = null;
		private Set<String> openids = Collections.synchronizedSet(new LinkedHashSet<String>());
		private String phoneNumber = null;
		//private Integer socialScore = new Integer(0);
		private Integer userId = null;
		private Calendar memberSince = null;
		private String password = "n/a";
		
		protected UserImpl() {}
		
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
		public Set<String> getOpenIds() {
			return openids;
		}

		@Override
		public String getPhoneNumber() {
			return phoneNumber;
		}

		@Override
		public Integer getSocialScore() {
			try {
				return new CarPoolStoreImpl().getScore(userId);
			} catch (IOException e) {
				e.printStackTrace();
			}
			return new Integer(-1);
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
		public void setPassword(String password) {
			this.password = password;
		}

		@Override
		public void setPhoneNumber(String phone) {
			this.phoneNumber = phone;
		}

		@Override
		public void setSocialScore(Integer score) {
			//the way the score is created doesn't allow for this method
			//this.socialScore = score;
		}


		@Override
		public void setUserId(Integer id) {
			this.userId = id;
		}

		@Override
		public void setUserName(String name) {
			this.userName = name;
		}		
	}
	
/* not needed anymore	
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
	*/
	
	/**
	 * @return a new instance of a User object
	 */
	private User create() {
		return new UserImpl();
	}
	
	/**
	 * A static method used to create a new instance of User
	 * @return a new instance of User
	 */
	public static User newInstance() {
		return new UserFactory().create();
	}
}
