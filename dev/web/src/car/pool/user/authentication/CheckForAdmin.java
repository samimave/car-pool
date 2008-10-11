package car.pool.user.authentication;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

import car.pool.persistance.DatabaseImpl;

public class CheckForAdmin {

	public static boolean adminExists() {
		String sql = "select userName from User where userName like '%admin%'";
		try {
			ResultSet rs = new DatabaseImpl().getStatement().executeQuery(sql);
			if(rs != null && rs.next()) {
				// if it reaches this point, it doesn't have to check anything else as there is a admin user already
				return true;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return false;
	}
}
