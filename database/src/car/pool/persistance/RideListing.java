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
	
	public RideListing getAll();
	public RideListing search(int searchType, String searchField);
	
	public static final int searchUser = 0;
	//public static final int searchStartLocation = 1;
	//public static final int searchEndLocation = 2;
	public static final int searchDate = 3;
	//public static final int searchAll = 4;
	public static final int searchLocationBoth = 5;
	public static final int searchLocationStart = 6;
	public static final int searchLocationEnd = 7;

	public String getOccur() throws SQLException;
	public String getTime() throws SQLException;
	public String getComment() throws SQLException;

}
