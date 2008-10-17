package car.pool.user;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayDeque;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;
import car.pool.persistance.exception.InvaildUserNamePassword;
/**
 * A stack of all those who are part of a ride except for the one offering the ride.
 * @author James Hurford <terrasea@gmail.com>
 *
 */
public class RideUserStack extends ArrayDeque<User> {
	private static final long serialVersionUID = -6261710740194226421L;

	/**
	 * 
	 * @param rideId - the id of the ride in the database
	 * @throws IOException -- on connection errors
	 * @throws SQLException -- if the sql is incorrect or something to do with sql
	 * @throws InvaildUserNamePassword -- if the id of one of the users reported using the ride is not valid.
	 */
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
