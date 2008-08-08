package car.pool.persistance;

import java.io.IOException;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import car.pool.persistance.exception.ConnectionException;

public class RideListingImpl implements RideListing {
	
	ResultSet rs = null;
	Statement statement = null;

	protected RideListingImpl(Statement statement){
		super();
		
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
	
	public boolean next() throws SQLException{
		return rs.next();
	}

	@Override
	public int getAvailableSeats() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getEndLocation() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Date getRideDate() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int getRideID() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getStartLocation() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int getUserID() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getUsername() {
		// TODO Auto-generated method stub
		return null;
	}

}
