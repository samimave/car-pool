package car.pool.persistance;

import java.util.Vector;

import java.sql.SQLException;

import car.pool.persistance.exception.DuplicateUserNameException;
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
	
	int getTripID(int idRide, int idPassenger) throws StoreException;
	
	int addRegion(String name) throws SQLException;
	int addLocation(int region, String name) throws SQLException;
	
	int getRegionIDbyName(String name) throws StoreException;
	LocationList findLocation(String name);
	LocationList getLocations();
	
	RideDetail getRideDetail(int rideID) throws StoreException;
	
	boolean checkUserExists(String username);
	
	int addRide(int user, int availableSeats, String startDate, int startLocation, int endLocation, int streetNumber, int streetNumberEnd,  int reoccur, String time, String comment) throws RideException;
	int addRide(int user, int availableSeats, String startDate, int startLocation, int endLocation, int streetNumber, int streetNumberEnd,  int reoccur, String time, String comment, String geoLocation) throws RideException;
	int takeRide(int user, int ride, int idLocation, int streetNumberStart, int streetNumberEnd, String geoLocation) throws RideException;
	int takeRide(int user, int ride, int idLocation, int streetNumberStart, int streetNumberEnd) throws RideException;
	
	boolean updateGeoLocationStart(int ride, String start) throws SQLException, StoreException;
	boolean updateGeoLocationEnd(int ride, String end) throws SQLException, StoreException;
	
	boolean updateSeats(int ride, int availableSeats) throws RideException;
	boolean updateStartDate(int ride, String startDate) throws RideException;
	boolean updateStartLoc(int ride, int houseNo, int startLoc, int idUser) throws RideException;
	boolean updateEndLoc(int ride, int houseNoEnd, int endLoc, int idUser) throws RideException;
	boolean updateStartTime(int ride, String startTime) throws RideException;
	
	public boolean acceptUser(int user, int ride, int conf) throws StoreException;
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
	
	public UserList getUserName();
	public UserList getUserEmail();
	public UserList getUserPhone();
	public UserList getUserSignUpDate();
	
	public boolean hasUserAddedScore(int tripID);
	public boolean hasUserAddedScore(int rideID, int userID) throws StoreException;
	
	public void addScore(int idTrip, int idUser, int score) throws SQLException;
	public int getScore(int idUser) throws SQLException;
	
	int addComment(int user, int ride, String comment) throws SQLException;
	int delComment(int idComment) throws SQLException;
	String getComment(int idComment) throws SQLException;
	public Vector<String> getRideComment(int idTrip) throws SQLException;
	
	
	TakenRides getTakenRides(int idUser);

	
	
}
