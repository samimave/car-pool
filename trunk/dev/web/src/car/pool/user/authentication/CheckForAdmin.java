package car.pool.user.authentication;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

import car.pool.persistance.DatabaseImpl;

/**
 * A class with a static method designed to check to see if a admin user exists in the database or not.
 * @author James Hurford <terrasea@gmail.com>
 *
 */
public class CheckForAdmin {

	/**
	 * Checks to see if a admin is already in the database
	 * @return true if admin already there, false if not
	 */
	public static boolean adminExists() {
		String sql = "select userName from User where userName like '%admin%'";
		try {
			ResultSet rs = new DatabaseImpl().getStatement().executeQuery(sql);
			if(rs != null && rs.next()) {
				// if it reaches this point, it doesn't have to check anything else as there is a admin user already
				return true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return false;
	}
}
