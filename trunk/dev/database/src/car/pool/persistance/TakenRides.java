package car.pool.persistance;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class TakenRides {
private ResultSet rs;
	
	public TakenRides(int idUser, Statement statement){
		rs = null;
		String sql = 	"SELECT*, l.street as start, ll.street as end "+
						"FROM Matches, User, Ride, Locations as l, Locations as ll "+
						"WHERE User.idUser=" +idUser+
						" AND User.idUser = Matches.idUser "+
						" AND Matches.idRide = Ride.idRide "+
						" AND Matches.idUser <> Ride.idUser "+
						" AND Ride.rideStartLocation = l.idLocations"+
						" AND Ride.rideStopLocation = ll.idLocations;";
		try {
			rs = statement.executeQuery(sql);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public boolean hasNext() throws SQLException{
		return rs.next();
	}
	
	public String getUsername() throws SQLException{
		return rs.getString("userName");
	}
	
	public boolean getConfirmed() throws SQLException{
		return rs.getBoolean("confirmed");
	}
	
	public String getStartLocation() throws SQLException{
		return rs.getString("start");
	}
	
	public String getStopLocation() throws SQLException{
		return rs.getString("end");
	}

	public int getStreetNumber() throws SQLException{
		return rs.getInt("streetNumber");
	}
	
	public Date getRideDate() throws SQLException{
		return rs.getDate("rideDate");
	}
	
	public int getAvailableSeats() throws SQLException{
		return rs.getInt("availableSeats");
	}
	
	public String getTime() throws SQLException {
		return rs.getString("rideTime");
	}
	
	public int getRideID() throws SQLException {
		return rs.getInt("idRide");
	}
}
