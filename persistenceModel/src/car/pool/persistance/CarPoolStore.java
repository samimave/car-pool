package car.pool.persistance;

public interface CarPoolStore {

	public static final int FAILED = -1;
	
	
	int addUser(String username, String passwordHash);
	int checkUser(String username, String passwordHash);
	int addRide(int user, int availableSeats, long startDate,long endDate, String startLocation, String endLocation);
	int takeRide(int user, int ride);
	
	String getErrorMessage();
}
