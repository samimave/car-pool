package car.pool.persistance;

import java.sql.Date;
import java.sql.SQLException;

public interface RideListing {
	
	public boolean next()throws SQLException;
	public int getRideID();
	public int getUserID();
	public String getUsername();
	public int getAvailableSeats();
	public Date getRideDate();
	public String getStartLocation();
	public String getEndLocation();
}
