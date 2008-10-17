package car.pool.user;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;
import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.exception.DuplicateUserNameException;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.StoreException;
import car.pool.persistance.exception.UserException;
import car.pool.security.AeSimpleSHA1;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Calendar;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * The Manager class used to manage to create instances of User and populate them with data from the database
 * 
 * @author James Hurford <terrasea@gmail.com>
 *
 */
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
		
		user.setSocialScore(new Integer(store.getScore(user.getUserId())));
		
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
		
		
		user.setSocialScore(new Integer(store.getScore(user.getUserId())));
		
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
		Integer id = new Integer(store.addUserWithPassword(user.getUserName(), user.getEmail(), user.getPhoneNumber(), user.getPassword() != null ? user.getPassword() : "n/a"));
		for(String openid : user.getOpenIds()) {
			store.attachOpenID(openid, id);
			break;
		}
		
		user.setUserId(id);		

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

	/**
	 * Removes the openid associated with this user
	 * @param openid - a string representing the openid that is to be removed.
	 * @param user - the user who is associated with the openid
	 * @return - the updated user
	 * @throws IOException
	 * @throws SQLException
	 */
	public User detachOpenId(String openid, User user) throws IOException, SQLException {
		CarPoolStore store = new CarPoolStoreImpl();
		store.detachOpenID(openid, user.getUserId());
		user.delOpenId(openid);

		return user;
	}

	/**
	 * Removes the user from the database
	 * @param user - the users details with which to id them with
	 * @return true on success false if something went wrong with the removal
	 * @throws IOException
	 * @throws StoreException
	 * @throws SQLException
	 */
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
	
	/**
	 * A conveniance method to allow for the retrieval of a user based on their userId
	 * @param id - the users id
	 * @return - the user associated with this id
	 * @throws IOException
	 * @throws SQLException
	 * @throws InvaildUserNamePassword
	 */
	public User getUserByUserId(Integer id) throws IOException, SQLException, InvaildUserNamePassword {
		User user = UserFactory.newInstance();
		user.setUserId(id);
		
		String selectSql = String.format("select userName, userPasswordHash, email, mobile_number, signUpDate from User where idUser = %d;", id);
		Database db = new DatabaseImpl();
		Statement statement = db.getStatement();
		ResultSet rs = statement.executeQuery(selectSql);
		
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
			throw new InvaildUserNamePassword("Id of User doesn't exist");
		}
		
		selectSql = String.format("select openid_url from user_openids where idUser = %d", user.getUserId());
		rs = statement.executeQuery(selectSql);
		
		while(rs.next()) {
			user.addOpenId(rs.getString(1));
		}
		
		user.setSocialScore(new Integer(new CarPoolStoreImpl().getScore(user.getUserId())));
		
		return user;
	}
	
	/**
	 * Updates the user in the database with the new values contained in the user parameter passed to this method.
	 * Currently the username will not be touched.
	 * @param user - the user with their updated details containes within
	 * @return the updated user.
	 * @throws InvaildUserNamePassword - if the user passed to this method is not in the database
	 * @throws IOException - communication problems with the database
	 * @throws SQLException - a error occured processing one of the sql statements used to update the user
	 */
 	public User updateUserDetails( User user ) throws InvaildUserNamePassword, IOException, SQLException {
 		User oldUser = getUserByUserId(user.getUserId());
 		String password = "";
		try {
			password = !oldUser.getPassword().equals(AeSimpleSHA1.SHA1(String.format("%s%s", user.getUserName(), user.getPassword()))) ? String.format("userPasswordHash = '%s'",AeSimpleSHA1.SHA1(String.format("%s%s", user.getUserName(), user.getPassword() ))) : "";
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
 		String email = !oldUser.getEmail().equals(user.getEmail()) && password.length() > 0 ? String.format(", email = '%s'", user.getEmail()) : !oldUser.getEmail().equals(user.getEmail()) ? String.format("email = '%s'", user.getEmail()) : "";
 		String phone = !oldUser.getPhoneNumber().equals(user.getPhoneNumber()) && (password.length() > 0 || email.length() > 0) ? String.format(", mobile_number = '%s'", user.getPhoneNumber()) : !oldUser.getPhoneNumber().equals(user.getPhoneNumber()) ? String.format("mobile_number = '%s'", user.getPhoneNumber()): "";
 		
 		if(password.length() > 0 || email.length() > 0 || phone.length() > 0 ) {
 			String updateSql = String.format("update User set %s%s%s where idUser = %d;", password, email, phone, user.getUserId());
 			Database db = new DatabaseImpl();
 			Statement statement = db.getStatement();
 			//shouldn't need to check if it affected more than one row as the user should exist and if they don't it shouldn't have got this far
 			statement.executeUpdate(updateSql);
 		}
		
		// now to update any openids
		if(!user.getOpenIds().equals(oldUser.getOpenIds())) {
			Set<String> newSet = Collections.synchronizedSet(new LinkedHashSet<String>());
			newSet.addAll(user.getOpenIds());
			Set<String> oldSet = Collections.synchronizedSet(new LinkedHashSet<String>());
			oldSet.addAll(oldUser.getOpenIds());
			if(newSet.size() > oldSet.size()) {
				newSet.removeAll(oldSet);
				for(String openid : newSet) {
					user = attachOpenId(openid, oldUser);
				}
			} else if(newSet.size() < oldSet.size()) {
				oldSet.removeAll(newSet);
				for(String openid : oldSet) {
					user = detachOpenId(openid, oldUser);
				}
			} else {
				for(String openid : newSet) {
					user = attachOpenId(openid, oldUser);
				}
				
				for(String openid : oldSet) {
					if(!newSet.contains(openid)) {
						user = detachOpenId(openid, oldUser);
					}
				}
			}
		}
		
		return user;
	}

}
