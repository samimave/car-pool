package car.pool.persistance;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class RideDetail {
	
	private ResultSet rs;
	
	public RideDetail(int idRide, Statement statement){
		rs = null;
		String sql = 	"SELECT * "+
						"FROM matches, user, locations "+
						"WHERE idRide=" +idRide+
						" AND user.idUser = matches.idUser "+
						"AND matches.idLocation = locations.idLocations;";
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
}
