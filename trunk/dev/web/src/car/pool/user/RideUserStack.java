package car.pool.user;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayDeque;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;
import car.pool.persistance.exception.InvaildUserNamePassword;

public class RideUserStack extends ArrayDeque<User> {
	private static final long serialVersionUID = -6261710740194226421L;

	public RideUserStack(Integer rideId) throws IOException, SQLException, InvaildUserNamePassword {
		Database db = new DatabaseImpl();
		String sql = String.format("select Matches.idUser from Matches, Ride where Ride.idRide = %d and Matches.idRide = Ride.idRide and Matches.idUser != Ride.idUser and Matches.confirmed = 1;", rideId.intValue());
		ResultSet rs = db.getStatement().executeQuery(sql);
		if(rs != null) {
			UserManager manager = new UserManager();
			while(rs.next()) {
				Integer id = rs.getInt(1);
				User user = manager.getUserByUserId(id);
				push(user);
			}
		}
	}
}
