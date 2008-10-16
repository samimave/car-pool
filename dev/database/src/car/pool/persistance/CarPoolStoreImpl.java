package car.pool.persistance;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import car.pool.persistance.exception.DuplicateUserNameException;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.RideException;
import car.pool.persistance.exception.StoreException;
import car.pool.persistance.exception.UserException;
import car.pool.security.AeSimpleSHA1;

public class CarPoolStoreImpl implements CarPoolStore {

	/**
	 * a connection generator for the database
	 */
	Database db = null;
	
	StringBuffer errors = new StringBuffer();
	
	@SuppressWarnings("unused")
	
	/**
	 * Singleton
	 */
	private static CarPoolStore cps;

	public CarPoolStoreImpl() throws IOException {
		super();
		db = new DatabaseImpl();
	}

	/**
	 * add a user using openid, userName, email, phone number
	 * returns unique userid
	 */
	public int addUser(String openID,String userName,String  email,String  phone) throws DuplicateUserNameException, UserException{
		int i = addUserWithPassword(userName, email, phone, "n/a");
		
		try {
			attachOpenID(openID, i);
		} catch( SQLException e ) { }
		
		return i;
	}
	
	
	/**
	 * add a user without openid, only password and username
	 * returns unique userid
	 */
	public int addUser(String username, String passwordHash) throws DuplicateUserNameException, UserException{
		return addUserWithPassword(username,"n/a", "n/a", passwordHash);
	}
	
	/**
	 * add user with a password, username, email, phone number
	 * @param username
	 * @param email
	 * @param mobile
	 * @param passwordHash
	 * @return unique userid
	 * @throws DuplicateUserNameException
	 * @throws UserException
	 */
	public int addUserWithPassword(String username, String email, String mobile, String passwordHash) throws DuplicateUserNameException, UserException {
		int id = FAILED;
		Statement statement;
		if(checkUserExists(username)){
			throw new DuplicateUserNameException("Username in use "+username);
		}

		Date date = new Date(System.currentTimeMillis());
		
		try {
			passwordHash = AeSimpleSHA1.SHA1(username+passwordHash);
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (UnsupportedEncodingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		statement = db.getStatement();
		String sql = "INSERT INTO User "
				+ "(userName,userPasswordHash,email,mobile_number,signUpDate) "
				+ "VALUES ('" + username + "','" + passwordHash + "','"
				+ email + "','"
				+ mobile + "','"
				+ date.toString() + "');";
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
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		if (id == FAILED) {
			throw new UserException("User already exists or connection failed");
		} else {
			return id;
		}
	}

	/**
	 * Check username exists in database
	 * @param username
	 * @return
	 * @throws InvaildUserNamePassword 
	 */
	public boolean checkUserExists(String username){
		boolean userExists = false;

		Statement statement = db.getStatement();
		String sql = "SELECT idUser from User " + "Where userName='" + username+"';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			userExists = rs.next();
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
			System.exit(0);
		}

		if (!userExists) {
			return false;
		} else {
			return true;
		}
	}
	
	/**
	 * check username exists and password correct
	 */
	public int checkUser(String username, String passwordHash) throws InvaildUserNamePassword {
		int id = FAILED;

		try {
			passwordHash = AeSimpleSHA1.SHA1(username+passwordHash);
		} catch (NoSuchAlgorithmException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (UnsupportedEncodingException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		Statement statement = db.getStatement();
		String sql = "SELECT idUser from User " + "Where userName='" + username
				+ "' " + "AND userPasswordHash='" + passwordHash + "';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		if (id == FAILED) {
			throw new InvaildUserNamePassword("Username or password failed");
		} else {
			return id;
		}
	}

	/**
	 * Check a username exists without a password (openid user)
	 */
	public int checkUser(String username) throws InvaildUserNamePassword {
		return checkUser(username, "n/a");
	}
	
	/**
	 * get max number of seats for a ride
	 * @param ride
	 * @return
	 * @throws RideException
	 */
	public int getMaxSeats(int ride) throws RideException{
		int seats = FAILED;

		Statement statement = db.getStatement();
		String sql = "SELECT r.availableSeats "+
					"FROM Ride as r "+
					"WHERE r.idRide = "+ride+";";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				seats = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		if (seats == FAILED) {
			throw new RideException("RideID was not in DB");
		} else {
			return seats - 1;
		}
	}
	
	/**
	 * get available seats for a ride
	 * @param ride
	 * @return
	 * @throws RideException
	 */
	public int getAvailableSeats(int ride) throws RideException{
		int seats = FAILED;

		Statement statement = db.getStatement();
		String sql = "SELECT ra.availableSeats "+
		"FROM (Select r.idRide, (r.availableSeats - Count(*)) as availableSeats "+
		"FROM "+
		"(SELECT r.idRide, u.userName, r.availableSeats "+
		"FROM User as u, Ride as r, Matches as m "+
		"WHERE u.idUser = m.idUser "+
		"AND m.idRide = r.idRide) as r "+
		"GROUP BY r.idRide) as ra "+
		"WHERE ra.idRide="+ride+";";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				seats = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		if (seats == FAILED) {
			throw new RideException("RideID was not in DB:"+ride);
		} else {
			return seats;
		}
	}
	
	/**
	 * add a user to a ride
	 */
	public int takeRide(int user, int ride, int idLocation, int streetNumber, int streetNumberEnd, String geoLocation) throws RideException{
		boolean success = false;
		int maxSeat = getMaxSeats(ride);
		int seatNum = 0;
		int idTrip = -1;
		while(!success && seatNum<=maxSeat){
			success = true;
			
			
			idTrip = takeRide(user, ride, seatNum, idLocation, streetNumber, streetNumberEnd, geoLocation);
			
			seatNum++;
		}
		
		if(!success){
			throw new RideException("add ride failed");
		}else{
			return idTrip;
		}
	}
	
	/**
	 * add a user to a ride
	 */
	public int takeRide(int user, int ride, int idLocation, int streetNumber, int streetNumberEnd) throws RideException{
		return takeRide(user, ride, idLocation, streetNumber, streetNumberEnd, "noLocation");
	}
	
	/**
	 * add a user to a ride
	 * @param user
	 * @param ride
	 * @param seatNum
	 * @param idLocation
	 * @param streetNumber
	 * @param streetNumberEnd
	 * @param geoLocation
	 * @return
	 * @throws RideException
	 */
	public int takeRide(int user, int ride, int seatNum, int idLocation, int streetNumber, int streetNumberEnd, String geoLocation) throws RideException {
		Statement statement = db.getStatement();
		int id = FAILED;
		String sql = "INSERT INTO Matches "
				+ "(idUser,idRide, seatNum, idLocation, streetNumber, streetNumberEnd, geoLocation) "
				+ "VALUES ('" + user + "','" + ride + "','" + seatNum + "','" + idLocation + "','" + streetNumber + "','" + streetNumberEnd + "','" + geoLocation + "');";
		
		try {	
			statement.executeUpdate(sql);
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RideException("add ride failed");
		}
		
		try {
			statement = db.getStatement();
			sql = "SELECT LAST_INSERT_ID();";
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if(id==FAILED){
			throw new RideException("add ride failed");
		}else{
			return id;
		}
	}

	/**
	 * add a ride into the database
	 */
	public int addRide(int user, int availableSeats, String startDate, int startLocation, int endLocation, int streetNumber,int streetNumberEnd, int reoccur, String time, String comment) throws RideException {
		return addRide(user, availableSeats, startDate, startLocation, endLocation, streetNumber, streetNumberEnd, reoccur, time, comment, "noLocation");
	}
	
	/**
	 * add a ride into the database
	 */
	public int addRide(int user, int availableSeats, String startDate, int startLocation, int endLocation, int streetNumber, int streetNumberEnd, int reoccur, String time, String comment, String geoLocation) throws RideException {
		
		Statement statement = db.getStatement();
		int id = FAILED;
		
		availableSeats += 1;
		
		String sql = "INSERT INTO Ride "
				+ "(idUser,rideDate,rideStartLocation,rideStopLocation,availableSeats, rideReoccur, rideTime, rideComment, geoLocation) "
				+ "VALUES ('" + user + "','" + startDate+"','"+ startLocation + "','" + endLocation+"','"+ availableSeats+"','"+ reoccur+"','"+time+"','"+comment+"','"+geoLocation+"');";
		
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
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if(id!= FAILED){
			takeRide(user,id, endLocation, streetNumber, streetNumberEnd, geoLocation);
		}else{
			try {
				removeRide(id);
			} catch (StoreException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		if(id==FAILED){
			throw new RideException("add ride failed");
		}else{
			return id;
		}
	}
	
	/**
	 * remove a user from the database
	 * 
	 * this method would probably fail
	 */
	@Deprecated
	public boolean removeUser(String username, String passwordHash){
		Statement statement = null;
		int count = 0;

		try {
			statement = db.getStatement();
			count = statement.executeUpdate("DELETE FROM User WHERE userName='"+username+"' " +
									"AND userPasswordHash='"+passwordHash+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//TODO check user was removed
		return count > 0;
	}

	/**
	 * update the number of seats available in a ride
	 */
	public boolean updateSeats(int ride, int availableSeats) throws RideException{
		Statement statement = null;
		int countr = 0;
		
		try {
			statement = db.getStatement();
			countr = statement.executeUpdate("UPDATE Ride SET Ride.availableSeats='"+availableSeats+"' "+"WHERE idRide='"+ride+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return countr > 0;
	}

	
	/**
	 * update the start date of a ride
	 */
	public boolean updateStartDate(int ride, String startDate) throws RideException{
		Statement statement = null;
		int countr = 0;
		
		try {
			statement = db.getStatement();
			countr = statement.executeUpdate("UPDATE Ride SET Ride.rideDate='"+startDate+"' "+"WHERE idRide='"+ride+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return countr > 0;
	}
	
	/**
	 * update the starting location of a ride
	 */
	public boolean updateStartLoc(int ride, int houseNo, int startLoc, int idUser) throws RideException{
		Statement statement = null;
		int countr = 0;
		int countm = 0;
		try {
			statement = db.getStatement();
			countr = statement.executeUpdate("UPDATE Ride SET Ride.rideStartLocation='"+startLoc+"' "+"WHERE idRide='"+ride+"';");
			countm = statement.executeUpdate("UPDATE Matches SET Matches.streetNumber='"+houseNo+"' "+"WHERE idUser='"+idUser+"' " +"AND idRide='"+ride+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return countr > 0 && countm > 0;
	}
	
	
	/**
	 * update the end location of a ride
	 */
	public boolean updateEndLoc(int ride, int houseNoEnd, int endLoc, int idUser) throws RideException{
		Statement statement = null;
		int countr = 0;
		int countm = 0;
		try {
			statement = db.getStatement();
			countr = statement.executeUpdate("UPDATE Ride SET Ride.rideStopLocation='"+endLoc+"' "+"WHERE idRide='"+ride+"';");
			countm = statement.executeUpdate("UPDATE Matches SET Matches.streetNumberEnd='"+houseNoEnd+"' "+"WHERE idUser='"+idUser+"' " +"AND idRide='"+ride+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return countr > 0 && countm > 0;
	}

	/**
	 * update the start time of a ride
	 */
	public boolean updateStartTime(int ride, String startTime) throws RideException{
		Statement statement = null;
		int countr = 0;
		
		try {
			statement = db.getStatement();
			countr = statement.executeUpdate("UPDATE Ride SET Ride.rideTime='"+startTime+"' "+"WHERE idRide='"+ride+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return countr > 0;
	}
	
	/**
	 * the owner of a ride accepting a user into that ride
	 */
	public boolean acceptUser(int user, int ride, int conf) throws StoreException{
		Statement statement = null;
		int countr = 0;
		
		try {
			statement = db.getStatement();
			countr = statement.executeUpdate("UPDATE Matches SET Matches.confirmed='"+conf+"' "+"WHERE idUser='"+user+"' " +"AND idRide='"+ride+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return true;
	}
	
	/**
	 * remove a ride from the database
	 */
	@Override
	public boolean removeRide(int user, int ride) throws StoreException {
		Statement statement = null;
		int count = 0;
		int counts = 0;
		try {
			statement = db.getStatement();
			counts = statement.executeUpdate("DELETE FROM social WHERE idTrip in (SELECT idTrip FROM Matches WHERE idRide='"+ride+"' AND idUser='"+user+"');");
			count = statement.executeUpdate("DELETE FROM Matches WHERE idUser='"+user+"' " +
													"AND idRide='"+ride+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//TODO check user,ride was removed
		return count > 0;
	}


	/**
	 * remove a ride from the database
	 */
	@Override
	public boolean removeRide(int ride) throws StoreException {
		Statement statement = null;
		int countm = 0;
		int countr = 0;
		int counts = 0;
		try {
			statement = db.getStatement();
			counts = statement.executeUpdate("DELETE FROM social WHERE idTrip in (SELECT idTrip FROM Matches WHERE idRide='"+ride+"');");
			countm = statement.executeUpdate("DELETE FROM Matches WHERE idRide='"+ride+"';");
			countr = statement.executeUpdate("DELETE FROM Ride WHERE idRide='"+ride+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//TODO check user was removed
		return countr > 0 && countm > 0;
	}
	
	/**
	 * return userID by openid
	 */
	public int getUserIdByURL(String openidurl) throws InvaildUserNamePassword{
		//select user_id from user_openids where openid_url = openid_url
		int id = FAILED;

		Statement statement = db.getStatement();
		String sql = "SELECT idUser from user_openids " +
					"Where openid_url='" + openidurl + "';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		if (id == FAILED) {
			throw new InvaildUserNamePassword("OpenID failed");
		} else {
			return id;
		}
	}
	
	/**
	 * get all openids from a userID
	 */
	public Vector<String> getOpenIdsByUser(int idUser) throws InvaildUserNamePassword{
		//select openid_url from user_openids where user_id = user_id
		Vector<String> openID = new Vector<String>();
		Statement statement = db.getStatement();
		String sql = "SELECT openid_url from user_openids " +
					"Where idUser='" + idUser + "';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			while (rs.next()) {
				openID.add(rs.getString(1));
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if (openID.isEmpty()){
			throw new InvaildUserNamePassword("OpenID failed");
		} else {
			return openID;
		}
	}
	
	/**
	 * add another openid to a userID
	 */
	public boolean attachOpenID(String openid_url,int idUser) throws SQLException {
	    //insert into user_openids values (openid_url, user_id)
		Statement statement = null;
		
		//try {
			statement = db.getStatement();
			String sql = "INSERT INTO user_openids (openid_url, idUser) VALUES ('"
				+openid_url+"', '" +
				+idUser+"');";
			statement.executeUpdate(sql);
			statement.close();
		//} catch (SQLException e) {
		//	e.printStackTrace();
		//}
		
		//TODO check openID was Attached
		return true;
	}

	/**
	 * remove an openid from a user
	 */
	public boolean detachOpenID(String openid_url,int idUser){
		//delete from user_openids where openid_url = openid_url and
		//user_id = user_id
		Statement statement = null;
		int count = 0;

		try {
			statement = db.getStatement();
			count = statement.executeUpdate("DELETE FROM user_openids WHERE " +
									"openid_url='"+openid_url+"' AND " +
									"idUser='"+idUser+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//TODO check openID was Detached
		return count > 0;
	}
	
	/**
	 * remove all openids
	 */
	public boolean detachOpenIDsByUser(int idUser){
		// delete from user_openids where user_id = user_id
		Statement statement = null;
		int count = 0;

		try {
			statement = db.getStatement();
			count = statement.executeUpdate("DELETE FROM user_openids WHERE " +
									"idUser='"+idUser+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		//TODO check openID was Attached
		return count > 0;
	}
	
	/**
	 * THIS DELETES ALL DATABASE CONTENTS!
	 * USED FOR DEBUGGING AND TESTING ONLY!
	 * @param password
	 */
	public void removeAll(String password){
		if(password != "donotusethis"){
			return;
		}
		
		Statement statement = null;
		
		try {
			statement = db.getStatement();
			statement.executeUpdate("DELETE FROM user_openids;");
			statement.executeUpdate("DELETE FROM social;");
			statement.executeUpdate("DELETE FROM Matches;");
			statement.executeUpdate("DELETE FROM Ride;");
			statement.executeUpdate("DELETE FROM RideComment;");
			statement.executeUpdate("DELETE FROM Comments;");
			statement.executeUpdate("DELETE FROM User;");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	/**
	 * Produce a listing of all rides
	 */
	public RideListing getRideListing(){		
		return RideListingFactory.getRideListing(db.getStatement());
	}

	/**
	 * add a regions to the database of streets
	 * returns unique region id
	 */
	@Override
	public int addRegion(String name) throws SQLException {
		Statement statement = null;
		int id = FAILED;

		statement = db.getStatement();
		String sql = "INSERT INTO regions (name) VALUES ('"
			+name+"');";
		statement.executeUpdate(sql);
		statement.close();

		try {
			statement = db.getStatement();
			sql = "SELECT LAST_INSERT_ID();";
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		//TODO check region was added
		return id;
	}

	/**
	 * adds a street to the database, requires unique regionid from database
	 */
	@Override
	public int addLocation(int region, String street) throws SQLException {
		Statement statement = null;
		int id = FAILED;

		statement = db.getStatement();
		String sql = "INSERT INTO locations (idRegion, street) VALUES ('"
			+region+"','"
			+street+"');";
		statement.executeUpdate(sql);
		statement.close();

		try {
			statement = db.getStatement();
			sql = "SELECT LAST_INSERT_ID();";
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		//TODO check region was added
		return id;
	}

	/**
	 * returns a list of streets matching name given
	 */
	@Override
	public LocationList findLocation(String name) {
		LocationList locList = new LocationList(name, db.getStatement(), false);
		return locList;
	}
	
	/**
	 * returns a listing of all streets
	 */
	@Override
	public LocationList getLocations() {
		LocationList locList = new LocationList("", db.getStatement(), true);
		return locList;
	}
	
	/**
	 * fetches a regionid by name
	 */
	public int getRegionIDbyName(String name) throws StoreException{
		int id = FAILED;
		Statement statement = db.getStatement();
		String sql = "SELECT idRegions from regions " +
					"Where name='" + name + "';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			while (rs.next()) {
				id = rs.getInt("idRegions");
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if (id == FAILED){
			throw new StoreException("invalid region name");
		} else {
			return id;
		}
	}

	@Override
	/**
	 * Returns a rideListing with the search results
	 * @param searchType should be a RideListing.searchType
	 */
	public RideListing searchRideListing(int searchType, String searchField) {
		return RideListingFactory.searchRideListing(db.getStatement(), searchType, searchField);
	}
	
	/**
	 * adds a comment to a ride from a user
	 */
	public int addComment(int user, int ride, String comment) throws SQLException{
		//add a comment
		Statement statement = null;
		int id = FAILED;

		statement = db.getStatement();
		String sql = "INSERT INTO Comments (idUser, idTrip, comment) VALUES ('"
			+user+"','"
			+ride+"','"
			+comment+"');";
		statement.executeUpdate(sql);
		statement.close();

		try {
			statement = db.getStatement();
			sql = "SELECT LAST_INSERT_ID();";
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next()) {
				id = rs.getInt(1);
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return id;
	}
	
	//NOT WORKING
	public int delComment(int idComment) throws SQLException{
		//delete a comment
		Statement statement = null;
		int count = 0;

		try {
			statement = db.getStatement();
			count = statement.executeUpdate("DELETE FROM Comments WHERE " +
									"idComment='"+idComment+"';");
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return count;
	}	
	
	//NOT WORKING
	public String getComment(int idComment) throws SQLException{
		//return a single comment
		String comment = "";
		//int i=0;
		
		Statement statement = db.getStatement();
		String sql = "SELECT * FROM Comments WHERE idComment='"+idComment+"';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			while(rs.next()){
			for(int j=1;j<5;j++){
				comment += rs.getString(j) + "|";
				}
			}
		
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return comment;

	}
	
	/**
	 * returns all ride comments for a trip (a ride associated to one passenger)
	 */
	public Vector<String> getRideComment(int idTrip) throws SQLException{
		//return a single comment
		Vector<String> comment = new Vector<String>();
		String temp = "";
		
		Statement statement = db.getStatement();
		String sql = "SELECT * FROM Comments WHERE idTrip='"+idTrip+"';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			while(rs.next()){
			for(int i=1;i<5;i++){
				temp += rs.getString(i) + "_delim_";
				}
			comment.add(temp);
			temp = "";
			}
			
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return comment;

	}

	/**
	 * return list of users
	 */
	@Override
	public UserList getUserName() {
		UserList UList = new UserList(db.getStatement(),true);		
		return UList;
	}

	/**
	 * 
	 */
	@Override
	public UserList getUserEmail() {
		UserList UList = new UserList(db.getStatement(),true);		
		return UList;
	}

	@Override
	public UserList getUserPhone() {
		UserList UList = new UserList(db.getStatement(),true);		
		return UList;
	}

	@Override
	public UserList getUserSignUpDate() {
		UserList UList = new UserList(db.getStatement(),true);		
		return UList;
	}

	/**
	 * returns all details to one ride
	 */
	@Override
	public RideDetail getRideDetail(int rideId) {
		return new RideDetail(rideId, db.getStatement());
	}
	
	/**
	 * adds social score to a ride
	 */
	@SuppressWarnings("unused")
	public void addScore(int idTrip, int idUser, int score) throws SQLException{
		//add a comment
		Statement statement = null;
		int id = FAILED;

		statement = db.getStatement();
		String sql = "INSERT INTO social (idTrip, idUser, score) VALUES ('"
			+idTrip+"','"
			+idUser+"','"
			+score+"');";
		statement.executeUpdate(sql);
		statement.close();
	}
	
	/**
	 * returns the social score of a user
	 */
	public int getScore(int idUser){
		int score = 0;
		Statement statement = db.getStatement();
		String sql = 	"SELECT SUM(score) as total " +
						"FROM Matches,Ride,social " +
						"WHERE Ride.idUser ='"+idUser+"' "+
						"AND Matches.idRide = Ride.idRide " +
						"AND Matches.idTrip = social.idTrip;";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			while (rs.next()) {
				score = rs.getInt("total");
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return score;
		
	}
	
	/**
	 * returns unique tripID (one passenger in a ride = tripID)
	 */
	public int getTripID(int idRide, int idPassenger) throws StoreException{
		int id = FAILED;
		Statement statement = db.getStatement();
		String sql = 	"SELECT Matches.idTrip as tripID " +
						"FROM Matches,Ride " +
						"WHERE Matches.idUser ='"+idPassenger+"' "+
						"AND Matches.idRide ='"+idRide+"';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			while (rs.next()) {
				id = rs.getInt("tripID");
			}
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		if (id == FAILED){
			throw new StoreException("invalid idRide and idPassenger");
		} else {
			return id;
		}
	}

	/**
	 * return list of rides taken by userid
	 */
	@Override
	public TakenRides getTakenRides(int idUser) {	 
		return new TakenRides(idUser,db.getStatement());
	}
	
	/**
	 * returns true if a user has left a social score for this ride
	 */
	public boolean hasUserAddedScore(int rideID, int userID) throws StoreException{
		return hasUserAddedScore(getTripID(rideID, userID));
	}

	/**
	 * returns true if a user has left a social score for this ride
	 */
	public boolean hasUserAddedScore(int tripID) {
		boolean has = false;
		Statement statement = db.getStatement();
		String sql = 	"SELECT * " +
						"FROM social " +
						"WHERE social.idTrip ='"+tripID+"';";
		try {
			statement = db.getStatement();
			ResultSet rs = statement.executeQuery(sql);
			has = rs.next();
			rs.close();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return has;
	}
	
	/**
	 * update the geoLocation end for a ride
	 */
	@Override
	public boolean updateGeoLocationEnd(int ride, String end) throws SQLException, StoreException {
		int[] rows = null;
		Statement statement = db.getStatement();
		RideDetail rd = getRideDetail(ride);
		rd.hasNext();
		String sql1 = 	"UPDATE ride " +
						"SET ride.geoLocation ='" +
						rd.getGeoLocation().split("/")[1] + "/" + end + "' " +
						"WHERE ride.idRide ='"+ride+"';";
		
		String sql2 = 	"UPDATE matches " +
		"SET matches.geoLocation ='" +
		rd.getGeoLocation().split("/")[0] + "/" + end + "' " +
		"WHERE matches.idRide ='"+ride+"';";
		try {
			statement = db.getStatement();
			statement.addBatch(sql1);
			statement.addBatch(sql2);
			//rows = statement.executeUpdate(sql);
			rows = statement.executeBatch();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return rows[0]>0 && rows[1]>0;
	}

	/**
	 * update the geoLocation start
	 */
	@Override
	public boolean updateGeoLocationStart(int ride, String start) throws SQLException, StoreException {
		int[] rows = null;
		Statement statement = db.getStatement();
		RideDetail rd = getRideDetail(ride);
		rd.hasNext();
		String sql1 = 	"UPDATE ride " +
						"SET ride.geoLocation ='" +
						start + "/" + rd.getGeoLocation().split("/")[1] + "' " +
						"WHERE ride.idRide ='"+ride+"';";
		
		String sql2 = 	"UPDATE matches " +
		"SET matches.geoLocation ='" +
		start + "/" + rd.getGeoLocation().split("/")[1] + "' " +
		"WHERE matches.idRide ='"+ride+"';";
		try {
			statement = db.getStatement();
			statement.addBatch(sql1);
			statement.addBatch(sql2);
			//rows = statement.executeUpdate(sql);
			rows = statement.executeBatch();
			statement.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return rows[0]>0 && rows[1]>0;
	}
	
	
	
	
}
