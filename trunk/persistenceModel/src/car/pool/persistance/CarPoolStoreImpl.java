package car.pool.persistance;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.zip.DataFormatException;

public class CarPoolStoreImpl implements CarPoolStore {
		
	Database db = new DatabaseImpl();
	
	public CarPoolStoreImpl(){
		super();
	}
	@Override
	public int addUser(String username, String passwordHash) {
		
		int id = -1;
		
		Date date = new Date(System.currentTimeMillis());
		
		
		Statement statement = db.getStatement();
		String sql = 	"INSERT INTO User "+
						"(userName,userPasswordHash,signUpDate,ridesGiven,ridesTaken) "+
						"VALUES ('"+username+"','"+passwordHash+"','"+date.toString()+"','0','0');";
						
		System.out.println(sql);
		try {
			statement.executeUpdate(sql);
			statement.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
		statement = db.getStatement();
		sql = "SELECT LAST_INSERT_ID();";
		ResultSet rs = statement.executeQuery(sql);
		if ( rs.next() )
			{
			id = rs.getInt(1);
			}
		rs.close();
		statement.close();
		} catch (SQLException e){
			e.printStackTrace();
		}

		return id;
	}

	@Override
	public int checkUser(String username, String passwordHash) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getErrorMessage() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int takeRide(int user, int ride) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public int addRide(int user, int availableSeats, long startDate,
			long endDate, String startLocation, String endLocation) {
		// TODO Auto-generated method stub
		return 0;
	}

}
