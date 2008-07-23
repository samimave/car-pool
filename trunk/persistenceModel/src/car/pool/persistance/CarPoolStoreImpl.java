package car.pool.persistance;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import java.util.zip.DataFormatException;

import car.pool.persistance.exception.DuplicateUserNameException;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.StoreException;
import car.pool.persistance.exception.UserException;

public class CarPoolStoreImpl implements CarPoolStore {

	Database db = new DatabaseImpl();
	StringBuffer errors = new StringBuffer();

	public CarPoolStoreImpl() {
		super();
	}

	@Override
	public int addUser(String username, String passwordHash)
			throws StoreException {

		int id = FAILED;
		boolean duplicate = false;//true if username is duplicate
		Statement statement;

		try {

			ResultSet rs = (statement = db.getStatement())
					.executeQuery("SELECT idUser from User WHERE userName='"
							+ username + "';");
			duplicate = rs.next();
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if(duplicate){
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

	@Override
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

	@Override
	public int takeRide(int user, int ride) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int addRide(int user, int availableSeats, long startDate,
			long endDate, String startLocation, String endLocation) {
		// TODO Auto-generated method stub
		return 0;
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
