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
		this.statement = statement;
	}
	
	public RideListing getAll(){
		
		String sql = "Select * " +
		"FROM " +
		"(Select r.idRide, u.idUser, u.username,(r.availableSeats - Count(*)) as availableSeats, r.rideDate, r.rideTime, r.rideStartLocation, r.rideStopLocation, r.rideReoccur, r.rideComment " +
		"FROM " +
		"(SELECT r.idRide, r.idUser, r.rideDate, r.rideTime, l.street as rideStartLocation, ll.street as rideStopLocation, r.availableSeats, r.rideReoccur, r.rideComment  "+
		"FROM User as u, Ride as r, Matches as m, locations as l, locations as ll "+
		"WHERE u.idUser = m.idUser "+
		"AND l.idLocations = r.rideStartLocation "+
		"AND ll.idLocations = r.rideStopLocation "+
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
		
		return this;
	}
	
	public RideListing search(int searchType, String searchField){
		
		if(searchType == searchUser){
			String username = "%" + searchField.replace(' ', '%') + "%";
			String sql = "SELECT * "+
			"FROM ("	+	
			"Select * " +
			"FROM " +
			"(Select r.idRide, u.idUser, u.username,(r.availableSeats - Count(*)) as availableSeats, r.rideDate, r.rideTime, r.rideStartLocation, r.rideStopLocation " +
			"FROM " +
			"(SELECT r.idRide, r.idUser, r.rideDate, r.rideTime, l.street as rideStartLocation, ll.street as rideStopLocation, r.availableSeats "+
			"FROM User as u, Ride as r, Matches as m, locations as l, locations as ll "+
			"WHERE u.idUser = m.idUser "+
			"AND l.idLocations = r.rideStartLocation "+
			"AND ll.idLocations = r.rideStopLocation "+
			"AND m.idRide = r.idRide) as r, " +
			"User as u " +
			"WHERE u.idUser = r.idUser " +
			"GROUP BY r.idRide) as t " +
			"WHERE t.availableSeats > 0 "+
			") as a "+
			"WHERE a.username LIKE '"+username+"';";
			try {
				rs = statement.executeQuery(sql);
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}else if(searchType == searchDate){
			String date = searchField;
			String sql = "SELECT * "+
			"FROM ("	+	
			"Select * " +
			"FROM " +
			"(Select r.idRide, u.idUser, u.username,(r.availableSeats - Count(*)) as availableSeats, r.rideDate, r.rideTime, r.rideStartLocation, r.rideStopLocation " +
			"FROM " +
			"(SELECT r.idRide, r.idUser, r.rideDate, r.rideTime, l.street as rideStartLocation, ll.street as rideStopLocation, r.availableSeats "+
			"FROM User as u, Ride as r, Matches as m, locations as l, locations as ll "+
			"WHERE u.idUser = m.idUser "+
			"AND l.idLocations = r.rideStartLocation "+
			"AND ll.idLocations = r.rideStopLocation "+
			"AND m.idRide = r.idRide) as r, " +
			"User as u " +
			"WHERE u.idUser = r.idUser " +
			"GROUP BY r.idRide) as t " +
			"WHERE t.availableSeats > 0 "+
			") as a "+
			"WHERE a.rideDate = '"+date+"';";
			try {
				rs = statement.executeQuery(sql);
			} catch (SQLException e) {
				//throw new
			}
		}else if(searchType == searchLocationBoth){
			String location = "%" + searchField.replace(' ', '%') + "%";
			String sql = "SELECT * "+
			"FROM ("	+	
			"Select * " +
			"FROM " +
			"(Select r.idRide, u.idUser, u.username,(r.availableSeats - Count(*)) as availableSeats, r.rideDate, r.rideTime, r.rideStartLocation, r.rideStopLocation " +
			"FROM " +
			"(SELECT r.idRide, r.idUser, r.rideDate, r.rideTime, l.street as rideStartLocation, ll.street as rideStopLocation, r.availableSeats "+
			"FROM User as u, Ride as r, Matches as m, locations as l, locations as ll "+
			"WHERE u.idUser = m.idUser "+
			"AND l.idLocations = r.rideStartLocation "+
			"AND ll.idLocations = r.rideStopLocation "+
			"AND m.idRide = r.idRide) as r, " +
			"User as u " +
			"WHERE u.idUser = r.idUser " +
			"GROUP BY r.idRide) as t " +
			"WHERE t.availableSeats > 0 "+
			") as a "+
			"WHERE a.rideStartLocation LIKE '"+location+"' "+
			"OR a.rideStopLocation LIKE '"+location+"';";
			try {
				rs = statement.executeQuery(sql);
			} catch (SQLException e) {
				//throw new
			}
		}else if(searchType == searchLocationEnd){
			String location = "%" + searchField.replace(' ', '%') + "%";
			String sql = "SELECT * "+
			"FROM ("	+	
			"Select * " +
			"FROM " +
			"(Select r.idRide, u.idUser, u.username,(r.availableSeats - Count(*)) as availableSeats, r.rideDate, r.rideTime, r.rideStartLocation, r.rideStopLocation " +
			"FROM " +
			"(SELECT r.idRide, r.idUser, r.rideDate, r.rideTime, l.street as rideStartLocation, ll.street as rideStopLocation, r.availableSeats "+
			"FROM User as u, Ride as r, Matches as m, locations as l, locations as ll "+
			"WHERE u.idUser = m.idUser "+
			"AND l.idLocations = r.rideStartLocation "+
			"AND ll.idLocations = r.rideStopLocation "+
			"AND m.idRide = r.idRide) as r, " +
			"User as u " +
			"WHERE u.idUser = r.idUser " +
			"GROUP BY r.idRide) as t " +
			"WHERE t.availableSeats > 0 "+
			") as a "+
			"WHERE a.rideStopLocation LIKE '"+location+"';";
			try {
				rs = statement.executeQuery(sql);
			} catch (SQLException e) {
				//throw new
			}
		}else if(searchType == searchLocationStart){
			String location = "%" + searchField.replace(' ', '%') + "%";
			String sql = "SELECT * "+
			"FROM ("	+	
			"Select * " +
			"FROM " +
			"(Select r.idRide, u.idUser, u.username,(r.availableSeats - Count(*)) as availableSeats, r.rideDate, r.rideTime, r.rideStartLocation, r.rideStopLocation " +
			"FROM " +
			"(SELECT r.idRide, r.idUser, r.rideDate, r.rideTime, l.street as rideStartLocation, ll.street as rideStopLocation, r.availableSeats "+
			"FROM User as u, Ride as r, Matches as m, locations as l, locations as ll "+
			"WHERE u.idUser = m.idUser "+
			"AND l.idLocations = r.rideStartLocation "+
			"AND ll.idLocations = r.rideStopLocation "+
			"AND m.idRide = r.idRide) as r, " +
			"User as u " +
			"WHERE u.idUser = r.idUser " +
			"GROUP BY r.idRide) as t " +
			"WHERE t.availableSeats > 0 "+
			") as a "+
			"WHERE a.rideStartLocation LIKE '"+location+"';";
			try {
				rs = statement.executeQuery(sql);
			} catch (SQLException e) {
				//throw new
			}
		}else{
			getAll();
		}
		
		return this;
	}
	
	public boolean next() throws SQLException{
		if(rs != null) {
			return rs.next();
		} else {
			System.out.println("rs equals null");
			return false;
		}
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

	//@Override
	public String getTime() throws SQLException {
		return rs.getString("rideTime");
	}
	
	//@Override
	public String getOccur() throws SQLException{
		return rs.getString("rideReoccur");
	}
	
	//@Override
	public String getComment() throws SQLException{
		return rs.getString("rideComment");
	}
}
