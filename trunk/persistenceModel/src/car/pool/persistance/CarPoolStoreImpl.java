package car.pool.persistance;

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

	Database db = new DatabaseImpl();
	StringBuffer errors = new StringBuffer();

	public CarPoolStoreImpl() {
		super();
	}

	
	public int addUser(String username, String passwordHash) throws DuplicateUserNameException, UserException {

		int id = FAILED;
		Statement statement;

		if(checkUserExists(username)){
			throw new DuplicateUserNameException("Username in use");
		}

		Date date = new Date(System.currentTimeMillis());

		statement = db.getStatement();
		String sql = "INSERT INTO User "
				+ "(userName,userPasswordHash,signUpDate,ridesGiven,ridesTaken) "
				+ "VALUES ('" + username + "','" + passwordHash + "','"
				+ date.toString() + "','0','0');";
		
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

	public int takeRide(int user, int ride) throws RideException {
		Statement statement = db.getStatement();
		int id = FAILED;
		String sql = "INSERT INTO Matches "
				+ "(idUser,idRide) "
				+ "VALUES ('" + user + "','" + ride+"');";
		
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
		
		if(id==FAILED){
			throw new RideException("add ride failed");
		}else{
			return id;
		}
	}

	public int addRide(int user, int availableSeats, String startDate, String startLocation, String endLocation) throws RideException {
		
		Statement statement = db.getStatement();
		int id = FAILED;
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
		
		if(id==FAILED){
			throw new RideException("add ride failed");
		}else{
			return id;
		}
	}
	
	public boolean removeUser(String username, String passwordHash){
		Statement statement = null;
		
		try {
			statement = db.getStatement();
			statement.executeUpdate("DELETE FROM User WHERE userName='"+username+"' " +
													"AND userPasswordHash='"+passwordHash+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//TODO check user was removed
		return true;
	}

}
