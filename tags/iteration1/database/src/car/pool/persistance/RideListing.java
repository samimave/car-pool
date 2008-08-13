package car.pool.persistance;

import java.sql.Date;
import java.sql.SQLException;

public interface RideListing {
	
	public boolean next()throws SQLException;
	public int getRideID() throws SQLException;
	public int getUserID() throws SQLException;
	public String getUsername() throws SQLException;
	public int getAvailableSeats() throws SQLException;
	public Date getRideDate() throws SQLException;
	public String getStartLocation() throws SQLException;
	public String getEndLocation() throws SQLException;
}
