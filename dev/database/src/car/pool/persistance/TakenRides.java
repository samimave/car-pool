package car.pool.persistance;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class TakenRides {
private ResultSet rs;
	
	public TakenRides(int idUser, Statement statement){
		rs = null;
		String sql = 	"SELECT*, l.street as start, ll.street as end, lll.street as pickUp "+
						"FROM Matches, User, Ride, locations as l, locations as ll, locations as lll "+
						"WHERE User.idUser=" +idUser+
						" AND User.idUser = Matches.idUser "+
						" AND Matches.idRide = Ride.idRide "+
						" AND Matches.idUser <> Ride.idUser "+
						" AND Matches.idLocation = lll.idLocations "+
						" AND Ride.rideStartLocation = l.idLocations"+
						" AND Ride.rideStopLocation = ll.idLocations;";
		try {
			rs = statement.executeQuery(sql);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public boolean hasNext() throws SQLException{
		return rs != null && rs.next();
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
	
	public String getStartID() throws SQLException{
		return rs.getString("rideStartLocation");
	}
	
	public String getStopID() throws SQLException{
		return rs.getString("rideStopLocation");
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
	
	public String getPickUp() throws SQLException{
		return rs.getString("pickUp");
	}
}
