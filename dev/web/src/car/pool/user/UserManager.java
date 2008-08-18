package car.pool.user;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;
import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.exception.DuplicateUserNameException;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.StoreException;
import car.pool.persistance.exception.UserException;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Calendar;

public class UserManager {

	public User getUserByOpenId(String openid) throws InvaildUserNamePassword, IOException, SQLException {
		return UserFactory.newInstance(openid);
	}
	

	public User getUserByUsername(String username, String password) throws IOException, InvaildUserNamePassword, SQLException {
		User user = UserFactory.newInstance();
		CarPoolStore store = new CarPoolStoreImpl();
		int id = store.checkUser(username, password);
		user.setUserId(id);
		String sql = "select userName, userPasswordHash, email, mobile_number, signUpDate from User where idUser = " + id + ";";
		Database db = new DatabaseImpl();
		Statement statement = db.getStatement();
		ResultSet rs = statement.executeQuery(sql);
		
		if(rs.first()) {
			user.setUserName(rs.getString(1));
			user.setPassword(rs.getString(2));
			user.setEmail(rs.getString(3));
			user.setPhoneNumber(rs.getString(4));
			java.sql.Date date = rs.getDate(5);
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			user.setMemberSince(cal);
		}
		
		return user;
	}
	
	public User registerUser(User user) throws DuplicateUserNameException, UserException, IOException, SQLException {
		CarPoolStoreImpl store = new CarPoolStoreImpl();
		Integer id = new Integer(store.addUserWithPassword(user.getUserName(), user.getEmail(), user.getPhoneNumber(), "n/a"));
		for(String openid : user.getOpenIds()) {
			store.attachOpenID(openid, id);
			break;
		}
		
		user.setUserId(id);

		System.out.println("User ID: " + user.getUserId());		

		return user;
	}
	
	public User attachOpenId(String openid, User user) throws IOException, SQLException {
		CarPoolStore store = new CarPoolStoreImpl();
		store.attachOpenID(openid, user.getUserId());
		user.addOpenId(openid);
		
		return user;
	}

	public User detachOpenId(String openid, User user) throws IOException, SQLException {
		CarPoolStore store = new CarPoolStoreImpl();
		store.detachOpenID(openid, user.getUserId());
		user.delOpenId(openid);

		return user;
	}

	public boolean removeUser( User user ) throws IOException, StoreException, SQLException {
		CarPoolStore store = new CarPoolStoreImpl();
		boolean result = true;
		for(String openid : user.getOpenIds()) {
			result &= store.detachOpenID(openid,user.getUserId());
		}
		StringBuffer sql = new StringBuffer();
		sql.append("delete from User where idUser = ");
		sql.append(user.getUserId());
		sql.append(";");
		int count = 0;
		Database db = new DatabaseImpl();
		Statement statement = db.getStatement();
		count = statement.executeUpdate(sql.toString());
		statement.close();
		
		//store.removeUser(user.getUserName(), user.getPassword())
		return count > 0 && result;
	}
}
