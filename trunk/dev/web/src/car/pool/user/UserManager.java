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

	/**
	 * Gets the users information from a database and fills the User class with this information and returns it. This method should only be used after the user has authenticated themselves with the openid provider.
	 * @param openid - the openid the user uses to authenticate themselves
	 * @return a User class instance encapsulating the information about the user
	 * @throws InvaildUserNamePassword - if the openid does not exists in the database
	 * @throws IOException - if connection errors happen
	 * @throws SQLException - if the sql statement is malformed or there is something wrong with the database definition
	 */
	public User getUserByOpenId(String openid) throws InvaildUserNamePassword, IOException, SQLException {
		User user = UserFactory.newInstance();
		CarPoolStore store = new CarPoolStoreImpl();
		user.setUserId(store.getUserIdByURL(openid));
		Database db = new DatabaseImpl();
		String sql = "select userName, email, mobile_number, signUpDate from User where idUser = " + user.getUserId() + ";";
		Statement statement = db.getStatement();
		ResultSet rs = statement.executeQuery(sql);
		if(rs.first()) {
			user.setUserName(rs.getString(1));
			user.setEmail(rs.getString(2));
			user.setPhoneNumber(rs.getString(3));
			java.sql.Date date = rs.getDate(4);
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			user.setMemberSince(cal);
		}
		for(String openids :store.getOpenIdsByUser(user.getUserId())) {
			user.addOpenId(openids);
		}

		rs.close();
		statement.close();
		
		return user;
	}
	

	/**
	 * Gets the users information from a database and fills the User class with this information and returns it.
	 * It does this using the users username and password. It can be used to authenticate the user.
	 * @param username - the users unique username
	 * @param password - their password
	 * @return a User class instance encapsulating the information about the user
	 * @throws IOException - if connection errors happen
	 * @throws InvaildUserNamePassword - if the username or password don't match what is in the database
	 * @throws SQLException - if the sql statement is malformed or there is something wrong with the database definition
	 */
	public User getUserByUsername(String username, String password) throws IOException, InvaildUserNamePassword, SQLException {
		User user = UserFactory.newInstance();
		CarPoolStore store = new CarPoolStoreImpl();
		
		int id = store.checkUser(username, password);
		
		user.setUserId(id);
		String sql = String.format("select userName, userPasswordHash, email, mobile_number, signUpDate from User where idUser = %d;", id);
		//Database db = new DatabaseImpl("jdbc:mysql://localhost:3306/carpool", "root", "thisistheroot");
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
		} else {
			throw new InvaildUserNamePassword("Invalid username or password");
		}
		
		return user;
	}
	
	/**
	 * Registers a user in the database based upon what is stored in the instance of the User class parameter
	 * @param user - the User class instance containing the users information.
	 * @return a User instance containing the users information plus the a new id for the user so now user.getUserId() will return something useful
	 * @throws DuplicateUserNameException - if name already exist in the database
	 * @throws UserException - User already exist or connection failed
	 * @throws IOException - connection with the database errors
	 * @throws SQLException - the sql statement encountered some problems
	 */
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
	
	/**
	 * Attach a openid to a already exiting user
	 * @param openid - the openid to attach to the user
	 * @param user - the user with all their details which to attach the openid to
	 * @return the user with the openid now attached to them
	 * @throws IOException - if connection errors occur
	 * @throws SQLException - if something goes wrong with the sql statement
	 */
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
	
	
/*	
 	public User updateUserDetails( User user ) {
		String sql = "update User set email='%s', mobile_number='%s', ";
		return user;
	}
*/
}
