package car.pool.persistance;

import java.sql.Date;

public interface RideListing {
	
	public boolean hasNextLine();
	public int getRideID();
	public int getUserID();
	public String getUsername();
	public int getAvailableSeats();
	public Date getRideDate();
	public String getStartLocation();
	public String getEndLocation();
}
