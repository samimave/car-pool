package car.pool.persistance;

import java.io.IOException;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import java.util.zip.DataFormatException;

import com.sun.org.apache.xml.internal.utils.StopParseException;

import car.pool.persistance.exception.DuplicateUserNameException;
import car.pool.persistance.exception.InvaildUserName;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.RideException;
import car.pool.persistance.exception.StoreException;
import car.pool.persistance.exception.UserException;

public class CarPoolStoreImpl implements CarPoolStore {

	Database db = null;
	StringBuffer errors = new StringBuffer();
	
	private static CarPoolStore cps;

	public CarPoolStoreImpl() throws IOException {
		super();
		db = new DatabaseImpl();
	}

	public int addUser(String openID,String userName,String  email,String  phone) throws DuplicateUserNameException, UserException{
		int i = addUserWithPassword(userName, email, phone, "n/a");
		
		try {
			attachOpenID(openID, i);
		} catch( SQLException e ) { }
		
		return i;
	}
	
	public int addUser(String username, String passwordHash) throws DuplicateUserNameException, UserException{
		return addUserWithPassword(username,"n/a", "n/a", passwordHash);
	}
	
	public int addUserWithPassword(String username, String email, String mobile, String passwordHash) throws DuplicateUserNameException, UserException {
		int id = FAILED;
		Statement statement;
		if(checkUserExists(username)){
			throw new DuplicateUserNameException("Username in use "+username);
		}

		Date date = new Date(System.currentTimeMillis());

		statement = db.getStatement();
		String sql = "INSERT INTO User "
				+ "(userName,userPasswordHash,email,mobile_number,signUpDate) "
				+ "VALUES ('" + username + "','" + passwordHash + "','"
				+ email + "','"
				+ mobile + "','"
				+ date.toString() + "');";
		try {
			statement.executeUpdate(sql);
			statement.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		try {
			statement = db.getStatement();
			sql = "SELECT LAST_INSERT_ID();";
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		if (id == FAILED) {
			throw new UserException("User already exists or connection failed");
		} else {
			return id;
		}
	}

	/**
	 * Check username exists
	 * @param username
	 * @return
	 * @throws InvaildUserNamePassword 
	 */
	public boolean checkUserExists(String username){
		boolean userExists = false;

		Statement statement = db.getStatement();
		String sql = "SELECT idUser from User " + "Where userName='" + username+"';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			userExists = rs.next();
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
			System.exit(0);
		}

		if (!userExists) {
			return false;
		} else {
			return true;
		}
	}
	
	public int checkUser(String username, String passwordHash) throws InvaildUserNamePassword {
		int id = FAILED;

		Statement statement = db.getStatement();
		String sql = "SELECT idUser from User " + "Where userName='" + username
				+ "' " + "AND userPasswordHash='" + passwordHash + "';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		if (id == FAILED) {
			throw new InvaildUserNamePassword("Username or password failed");
		} else {
			return id;
		}
	}

	public int checkUser(String username) throws InvaildUserNamePassword {
		return checkUser(username, "n/a");
	}
	
	public int getMaxSeats(int ride) throws RideException{
		int seats = FAILED;

		Statement statement = db.getStatement();
		String sql = "SELECT r.availableSeats "+
					"FROM ride as r "+
					"WHERE r.idRide = "+ride+";";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				seats = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		if (seats == FAILED) {
			throw new RideException("RideID was not in DB");
		} else {
			return seats - 1;
		}
	}
	
	public int getAvailableSeats(int ride) throws RideException{
		int seats = FAILED;

		Statement statement = db.getStatement();
		String sql = "SELECT ra.availableSeats "+
		"FROM (Select r.idRide, (r.availableSeats - Count(*)) as availableSeats "+
		"FROM "+
		"(SELECT r.idRide, u.userName, r.availableSeats "+
		"FROM User as u, Ride as r, Matches as m "+
		"WHERE u.idUser = m.idUser "+
		"AND m.idRide = r.idRide) as r "+
		"GROUP BY r.idRide) as ra "+
		"WHERE ra.idRide="+ride+";";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				seats = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		if (seats == FAILED) {
			throw new RideException("RideID was not in DB:"+ride);
		} else {
			return seats;
		}
	}
	
	
	public int takeRide(int user, int ride) throws RideException{
		boolean success = false;
		int maxSeat = getMaxSeats(ride);
		int seatNum = 0;
		int idTrip = -1;
		while(!success && seatNum<=maxSeat){
			success = true;
			
			try {
				idTrip = takeRide(user, ride, seatNum);
			} catch (RideException e) {
				success = false;
			}
			seatNum++;
		}
		
		if(!success){
			throw new RideException("add ride failed");
		}else{
			return idTrip;
		}
	}
	
	public int takeRide(int user, int ride, int seatNum) throws RideException {
		Statement statement = db.getStatement();
		int id = FAILED;
		String sql = "INSERT INTO Matches "
				+ "(idUser,idRide, seatNum) "
				+ "VALUES ('" + user + "','" + ride + "','" + seatNum + "');";
		
		try {
			statement.executeUpdate(sql);
			statement.close();
		} catch (SQLException e) {
			throw new RideException("add ride failed");
		}
		
		try {
			statement = db.getStatement();
			sql = "SELECT LAST_INSERT_ID();";
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if(id==FAILED){
			throw new RideException("add ride failed");
		}else{
			return id;
		}
	}

	public int addRide(int user, int availableSeats, String startDate, String startLocation, String endLocation) throws RideException {
		
		Statement statement = db.getStatement();
		int id = FAILED;
		
		availableSeats += 1;
		
		String sql = "INSERT INTO Ride "
				+ "(idUser,rideDate,rideStartLocation,rideStopLocation,availableSeats) "
				+ "VALUES ('" + user + "','" + startDate+"','"+ startLocation + "','" + endLocation+"','"+ availableSeats+"');";
		
		try {
			statement.executeUpdate(sql);
			statement.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			statement = db.getStatement();
			sql = "SELECT LAST_INSERT_ID();";
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if(id!= FAILED){
			takeRide(user,id);
		}else{
			try {
				removeRide(id);
			} catch (StoreException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		if(id==FAILED){
			throw new RideException("add ride failed");
		}else{
			return id;
		}
	}
	
	public boolean removeUser(String username, String passwordHash){
		Statement statement = null;
		int count = 0;

		try {
			statement = db.getStatement();
			count = statement.executeUpdate("DELETE FROM User WHERE userName='"+username+"' " +
									"AND userPasswordHash='"+passwordHash+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//TODO check user was removed
		return count > 0;
	}


	@Override
	public boolean removeRide(int user, int ride) throws StoreException {
		Statement statement = null;
		int count = 0;

		try {
			statement = db.getStatement();
			count = statement.executeUpdate("DELETE FROM Matches WHERE idUser='"+user+"' " +
													"AND idRide='"+ride+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//TODO check user,ride was removed
		return count > 0;
	}


	@Override
	public boolean removeRide(int ride) throws StoreException {
		Statement statement = null;
		int countm = 0;
		int countr = 0;

		try {
			statement = db.getStatement();
			countm = statement.executeUpdate("DELETE FROM matches WHERE idRide='"+ride+"';");
			countr = statement.executeUpdate("DELETE FROM ride WHERE idRide='"+ride+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//TODO check user was removed
		return true;
	}
	
	public int getUserIdByURL(String openidurl) throws InvaildUserNamePassword{
		//select user_id from user_openids where openid_url = openid_url
		int id = FAILED;

		Statement statement = db.getStatement();
		String sql = "SELECT idUser from user_openids " +
					"Where openid_url='" + openidurl + "';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		if (id == FAILED) {
			throw new InvaildUserNamePassword("OpenID failed");
		} else {
			return id;
		}
	}
	
	public Vector<String> getOpenIdsByUser(int idUser) throws InvaildUserNamePassword{
		//select openid_url from user_openids where user_id = user_id
		Vector<String> openID = new Vector<String>();
		Statement statement = db.getStatement();
		String sql = "SELECT openid_url from user_openids " +
					"Where idUser='" + idUser + "';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			while (rs.next()) {
				openID.add(rs.getString(1));
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if (openID.isEmpty()){
			throw new InvaildUserNamePassword("OpenID failed");
		} else {
			return openID;
		}
	}
	
	public boolean attachOpenID(String openid_url,int idUser) throws SQLException {
	    //insert into user_openids values (openid_url, user_id)
		Statement statement = null;
		
		//try {
			statement = db.getStatement();
			String sql = "INSERT INTO user_openids (openid_url, idUser) VALUES ('"
				+openid_url+"', '" +
				+idUser+"');";
			statement.executeUpdate(sql);
			statement.close();
		//} catch (SQLException e) {
		//	e.printStackTrace();
		//}
		
		//TODO check openID was Attached
		return true;
	}

	public boolean detachOpenID(String openid_url,int idUser){
		//delete from user_openids where openid_url = openid_url and
		//user_id = user_id
		Statement statement = null;
		int count = 0;

		try {
			statement = db.getStatement();
			count = statement.executeUpdate("DELETE FROM user_openids WHERE " +
									"openid_url='"+openid_url+"' AND " +
									"idUser='"+idUser+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//TODO check openID was Detached
		return count > 0;
	}
	
	public boolean detachOpenIDsByUser(int idUser){
		// delete from user_openids where user_id = user_id
		Statement statement = null;
		int count = 0;

		try {
			statement = db.getStatement();
			count = statement.executeUpdate("DELETE FROM user_openids WHERE " +
									"idUser='"+idUser+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//TODO check openID was Attached
		return count > 0;
	}
	
	public void removeAll(String password){
		if(password != "donotusethis"){
			return;
		}
		
		Statement statement = null;
		
		try {
			statement = db.getStatement();
			statement.executeUpdate("DELETE FROM user_openids;");
			statement.executeUpdate("DELETE FROM Matches;");
			statement.executeUpdate("DELETE FROM Ride;");
			statement.executeUpdate("DELETE FROM User;");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	public RideListing getRideListing(){		
		return RideListingFactory.getRideListing(db.getStatement());
	}

	
	
}
