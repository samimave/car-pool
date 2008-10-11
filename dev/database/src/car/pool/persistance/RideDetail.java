package car.pool.persistance;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;

import car.pool.persistance.exception.StoreException;

public class RideDetail {
	
	private ResultSet rs;
	
	public RideDetail(int idRide, Statement statement){
		rs = null;
		String sql = 	"SELECT * "+
						"FROM Matches, User, locations "+
						"WHERE idRide=" +idRide+
						" AND User.idUser = Matches.idUser "+
						"AND Matches.idLocation = locations.idLocations;";
		try {
			rs = statement.executeQuery(sql);
			rs.next();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	public String getUsername() throws SQLException{
		return rs.getString("userName");
	}
	
	public boolean getConfirmed() throws SQLException{
		return rs.getBoolean("confirmed");
	}
	
	public String getLocationName() throws SQLException{
		return rs.getString("street");
	}
	public String getLocationID() throws SQLException{
		return rs.getString("idLocations");
	}
	public int getUserID() throws SQLException{
		return rs.getInt("idUser");
	}
	public int getStreetNumber() throws SQLException{
		return rs.getInt("streetNumber");
	}
	public int getStreetNumberEnd() throws SQLException{
		return rs.getInt("streetNumberEnd");
	}
	public String getGeoLocation() throws SQLException{
		return rs.getString("geoLocation");
	}
}
