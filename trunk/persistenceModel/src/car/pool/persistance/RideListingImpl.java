package car.pool.persistance;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class RideListingImpl implements RideListing {
	
	ResultSet rs = null;
	
	public RideListingImpl(Statement statement){
		String sql = "Select *" +
		"FROM" +
		"(Select r.idRide, u.idUser, u.username,(r.availableSeats - Count(*)) as availableSeats, r.rideDate, r.rideStartLocation, r.rideStopLocation" +
		"FROM" +
		"(SELECT r.idRide, r.idUser, r.rideDate, r.rideStartLocation, r.rideStopLocation, r.availableSeats" +
		"FROM User as u, Ride as r, Matches as m" +
		"WHERE u.idUser = m.idUser" +
		"AND m.idRide = r.idRide) as r," +
		"User as u" +
		"WHERE u.idUser = r.idUser" +
		"GROUP BY r.idRide) as t" +
		"WHERE t.availableSeats > 0;";
		try {
			rs = statement.executeQuery(sql);
		} catch (SQLException e) {
			//throw new
		}
	}
	
	public String getNextLine() {
		return null;
	}
	
	public boolean hasNext(){
		return false;
	}

}