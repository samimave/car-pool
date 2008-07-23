package car.pool.persistance;

import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.RideException;
import car.pool.persistance.exception.StoreException;
import car.pool.persistance.exception.UserException;

public interface CarPoolStore {

	public static final int FAILED = -1;
	
	
	int addUser(String username, String passwordHash) throws StoreException;
	int checkUser(String username, String passwordHash) throws InvaildUserNamePassword;
	int addRide(int user, int availableSeats, long startDate,long endDate, String startLocation, String endLocation) throws RideException;
	int takeRide(int user, int ride) throws RideException;
	boolean removeUser(String username, String passwordHash) throws StoreException;
}
