package car.pool.persistance;

import java.util.Vector;

import java.sql.SQLException;

import car.pool.persistance.exception.DuplicateUserNameException;
import car.pool.persistance.exception.InvaildUserName;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.RideException;
import car.pool.persistance.exception.StoreException;
import car.pool.persistance.exception.UserException;

public interface CarPoolStore {

	public static final int FAILED = -1;
	
	int addUser(String username, String passwordHash) throws StoreException;
	int addUser(String openID,String userName,String  email,String  phone) throws DuplicateUserNameException, UserException;
	
	int checkUser(String username, String passwordHash) throws InvaildUserNamePassword;
	int checkUser(String username) throws InvaildUserNamePassword;
	
	int addRegion(String name) throws SQLException;
	int addLocation(int region, String name) throws SQLException;
	
	LocationList findLocation(String name);
	LocationList getLocations();
	
	boolean checkUserExists(String username);
	
	int addRide(int user, int availableSeats, String startDate, int startLocation, int endLocation, int streetNumber,  int reoccur, String time, String comment) throws RideException;
	int takeRide(int user, int ride, int idLocation, int streetNumber) throws RideException;
	
	boolean removeUser(String username, String passwordHash) throws StoreException;
	boolean removeRide(int user, int ride) throws StoreException;
	boolean removeRide(int ride) throws StoreException;
	
	public int getUserIdByURL(String openidurl) throws InvaildUserNamePassword;
	public Vector<String> getOpenIdsByUser(int idUser) throws InvaildUserNamePassword;
	public boolean attachOpenID(String openid_url,int idUser) throws SQLException;
	public boolean detachOpenID(String openid_url,int idUser);
	public boolean detachOpenIDsByUser(int idUser);
	
	public RideListing getRideListing();
	public RideListing searchRideListing(int searchType, String searchField);
	
	int addComment(int user, int ride, String comment) throws SQLException;
	int delComment(int idComment) throws SQLException;
	String getComment(int idComment) throws SQLException;
	public Vector<String> getRideComment(int idTrip) throws SQLException;
	
}
