package car.pool.persistance;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class RideListingImpl implements RideListing {
	
	ResultSet rs = null;
	Statement statement = null;

	protected RideListingImpl(Statement statement){
		super();
		
		String sql = "Select * " +
		"FROM " +
		"(Select r.idRide, u.idUser, u.username,(r.availableSeats - Count(*)) as availableSeats, r.rideDate, r.rideStartLocation, r.rideStopLocation " +
		"FROM " +
		"(SELECT r.idRide, r.idUser, r.rideDate, r.rideStartLocation, r.rideStopLocation, r.availableSeats " +
		"FROM User as u, Ride as r, Matches as m " +
		"WHERE u.idUser = m.idUser " +
		"AND m.idRide = r.idRide) as r, " +
		"User as u " +
		"WHERE u.idUser = r.idUser " +
		"GROUP BY r.idRide) as t " +
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
	public int getAvailableSeats() throws SQLException {
		return rs.getInt("availableSeats");
	}

	@Override
	public String getEndLocation() throws SQLException {
		return rs.getString("rideStopLocation");
	}

	@Override
	public Date getRideDate() throws SQLException {
		return rs.getDate("rideDate");
	}

	@Override
	public int getRideID() throws SQLException {
		return rs.getInt("idRide");
	}

	@Override
	public String getStartLocation() throws SQLException {
		return rs.getString("rideStartLocation");
	}

	@Override
	public int getUserID() throws SQLException {
		return rs.getInt("idUser");
	}

	@Override
	public String getUsername() throws SQLException {
		return rs.getString("username");
	}

}
