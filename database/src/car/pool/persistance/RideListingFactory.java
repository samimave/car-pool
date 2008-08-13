package car.pool.persistance;

import java.sql.Statement;

public class RideListingFactory {

	public static RideListing getRideListing(Statement statement){
		return new RideListingImpl(statement);
	}
	
}
