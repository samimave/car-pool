package car.pool.persistance;

import java.sql.Statement;

public class RideListingFactory {

	public static RideListing getRideListing(Statement statement){
		return new RideListingImpl(statement).getAll();
	}

	public static RideListing searchRideListing(Statement statement, int searchType, String searchField) {
		return new RideListingImpl(statement).search(searchType, searchField);
	}
	
}
