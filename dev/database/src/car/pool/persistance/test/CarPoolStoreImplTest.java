package car.pool.persistance.test;

import java.sql.Date;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.Random;
import java.util.Vector;

import junit.framework.TestCase;

import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.RideDetail;
import car.pool.persistance.RideListing;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.RideException;
import car.pool.persistance.exception.StoreException;
import car.pool.persistance.util.Pair;

public class CarPoolStoreImplTest extends TestCase {

	
	CarPoolStoreImpl cps = null;
	
	LinkedList<Pair<String, String>> usedUsers = null;
	LinkedList<Integer> lodgedRides = null;
	
	protected void setUp() throws Exception {
		super.setUp();
		
		cps = new CarPoolStoreImpl();
		cps.removeAll("donotusethis");
		usedUsers = new LinkedList<Pair<String, String>>();
		lodgedRides = new LinkedList<Integer>();
	}
	
	/**
	 * remember a user from removal later
	 * @param username
	 * @param password
	 */
	private void trackUser(String username, String password){
		usedUsers.add(new Pair<String, String>(username, password));
	}
	
	private int getAUserID(){
		try {
			return cps.checkUser(usedUsers.get(0).first, usedUsers.get(0).second);
		} catch (InvaildUserNamePassword e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return -1;
	}
	
	/**
	 * remember a ride from removal later
	 * @param idRide
	 */
/*	private void trackRide(int idRide){
		lodgedRides.add(idRide);
	}
*/	
	/**
	 * Return a user and remove from memory
	 * @return
	 */
/*	private Pair<String,String> recallUser(){
		Pair<String, String> pair = usedUsers.removeLast();	
		return pair;
	}
*/	
	@SuppressWarnings("unchecked")
	private LinkedList<Pair<String, String>> allUsedUsers(){
		return (LinkedList<Pair<String, String>>) usedUsers.clone();
	}
	
	/**
	 * @return true if a user hasn't been recalled
	 */
/*	private boolean hasMoreUsedUsers(){
		return !usedUsers.isEmpty();
	}
*/	
	/**
	 * remove all test users from DB
	 */
	protected void tearDown() throws Exception {
		super.tearDown();
		
		cps.removeAll("donotusethis");
		
	}
	
	/**
	 * Test adding a user
	 * Assert failure after trying to insert duplicate username
	 * 50 random user inserts
	 */
	public void testAddUser() {
		try {
			cps.addUser("testUser", "testPassword");
			trackUser("testUser", "testPassword");
		}catch(StoreException e){
			fail("Failed to add user");
		}
		
		
		boolean failed = false;
		try {
			cps.addUser("testUser", "testPassword");
		}catch(StoreException e){
			failed = true;
		}
		assertEquals("Added a user with same name as another" ,true, failed);
		
		
		addLotsOfUsers();
		//TODO test concurrent access with multiple threads/multiple connections
		
	}
	
	private void addLotsOfUsers(){
		//test adding 50 users
		Random r = new Random();
		for(int i=50;i>0;i--){
			String username = Double.toString(r.nextDouble());
			String password = Double.toString(r.nextDouble());
			
			try {
				cps.addUser(username, password);
				trackUser(username, password);
			}catch(StoreException e){
				fail("Failed to add user");
			}
		}
	}
	
	public void testCheckUserExists(){
		/*addLotsOfUsers();
		
		LinkedList<Pair<String,String>> temp = allUsedUsers();
		
		while(!temp.isEmpty()){
			Pair<String, String> pair = temp.removeLast();
			assertEquals("Username should have been accepted", true, cps.checkUserExists(pair.first));
		}
		
		temp = allUsedUsers();
		
		while(!temp.isEmpty()){
			//Pair<String, String> pair = temp.removeLast();
			//boolean failed = false;
			assertEquals("A wrong username was accepted", false, cps.checkUserExists("im not the username"));
		}*/
	}
	
	public void testCheckUser(){
		
		addLotsOfUsers();
		
		LinkedList<Pair<String,String>> temp = allUsedUsers();
		
		while(!temp.isEmpty()){
			Pair<String, String> pair = temp.removeLast();
			try {
				cps.checkUser(pair.first, pair.second);
			} catch (InvaildUserNamePassword e) {
				fail("False negitive on username and password");
			}
		}
		
		temp = allUsedUsers();
		
		while(!temp.isEmpty()){
			Pair<String, String> pair = temp.removeLast();
			boolean failed = false;
			try {
				cps.checkUser(pair.first, "im not the password");
			} catch (InvaildUserNamePassword e) {
				failed = true;
			}
			assertEquals("A wrong password was accepted", true, failed);
		}
		
		temp = allUsedUsers();
		
		while(!temp.isEmpty()){
			Pair<String, String> pair = temp.removeLast();
			boolean failed = false;
			try {
				cps.checkUser("im not the username", pair.second);
			} catch (InvaildUserNamePassword e) {
				failed = true;
			}
			assertEquals("A unknown username was accepted", true, failed);
		}
		temp = null;
		
	}
	
	public void testAddRide(){
		//TODO
		
		addLotsOfUsers();
		
		LinkedList<Pair<String,String>> temp = allUsedUsers();
		
		Pair<String, String> user = temp.removeLast();
		
		int id = 0;
		try {
			id = cps.checkUser(user.first, user.second);
		} catch (InvaildUserNamePassword e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.exit(0);
		}
		
		int region = 0;
		int idLocation = 0;
		try {
			region = cps.addRegion("Palmy");
			idLocation = cps.addLocation(region,"Blair St");
		}
		catch (SQLException e) {
			// TODO: handle exception
		}
		
		int ride = 0;
		try {
			Date date = new Date(System.currentTimeMillis());
			ride = cps.addRide(id, 4, date.toString(), idLocation, idLocation, 0,1 , 0, "5:22 PM", "be on time");
		} catch (RideException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		user = temp.removeLast();
		
		int u = 0;
		try {
			u = cps.checkUser(user.first, user.second);
		} catch (InvaildUserNamePassword e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.exit(0);
		}
		
		try {
			cps.takeRide(u, ride, idLocation, 0,1);
		} catch (RideException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			cps.removeRide(u, ride);
		} catch (StoreException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		try {
			cps.removeRide(ride);
		} catch (StoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void testTakeRide(){
	}
	
	public void testRemoveUser(){
		//TODO
	}
	
	public void testAttachOpenID() throws SQLException{
		addLotsOfUsers();
		cps.attachOpenID("www.google.com", getAUserID());
	}
	
	public void testDetachOpenID() throws SQLException{
		addLotsOfUsers();
		cps.attachOpenID("www.google.com", getAUserID());
		
		cps.detachOpenID("www.google.com", getAUserID());
	}
	
	public void testDetachOpenIDbyUser() throws SQLException{
		addLotsOfUsers();
		cps.attachOpenID("www.google.com", getAUserID());
		
		cps.detachOpenIDsByUser(getAUserID());
	}
	public void testGetOpenIDbyUser() throws SQLException{
		addLotsOfUsers();
		cps.attachOpenID("www.google.com", getAUserID());
		
		try {
			System.out.println(cps.getOpenIdsByUser(getAUserID()).get(0));
			if(!cps.getOpenIdsByUser(getAUserID()).get(0).equals("www.google.com")){
				fail("did not return correct openid from userid");
			}
		} catch (InvaildUserNamePassword e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail("valid getopenid operation failed");
		}
	}
	public void testGetOpenIDbyURL() throws SQLException{
		addLotsOfUsers();
		cps.attachOpenID("www.google.com", getAUserID());
		
		try {
			if(getAUserID() != cps.getUserIdByURL("www.google.com")){
				fail("getUserIDbyURL returned wrong ID");
			}
		} catch (InvaildUserNamePassword e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			fail("getUserIDbyURL failed with valid operation");
		}
	}
	
	public void testAll(){
		Date date = new Date(System.currentTimeMillis());
		
		int region = 0;
		int idLocation = 0;
		try {
			region = cps.addRegion("Palmy");
			idLocation = cps.addLocation(region,"Blair St");
		}
		catch (SQLException e) {
			// TODO: handle exception
		}
		
		try {
			int idUser = cps.addUser("jordan", "jordan.d.carter@gmail.com", "0274681876", "thisismypassword");
			int idRide = cps.addRide(idUser, 4, date.toString(), idLocation, idLocation, 0,1 , 0, "5:22 PM", "be on time");
			cps.attachOpenID("www.google.com", idUser);
			cps.takeRide(idUser, idRide, idLocation, 0,1);
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void testRideListing(){
		new TestSetup();
		RideListing rl = cps.getRideListing();
		int rideCount = 0;
		try {
			while(rl.next()){
				rideCount++;
				System.out.println(rl.getRideID()+", "+rl.getUserID()+", "+rl.getUsername()+", "+rl.getAvailableSeats()+", "+rl.getRideDate().toString()+", "+rl.getStartLocation()+", "+rl.getEndLocation());
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		assertEquals(true, rideCount>0);
	}
	
	public void testSearchRideListing(){
		new TestSetup();
		Date date = new Date(System.currentTimeMillis());
		
		int region = 0;
		int idLocation = 0;
		int idLocation2 = 0;
		try {
			region = cps.addRegion("Palmy");
			idLocation = cps.addLocation(region,"Blair St");
			idLocation2 = cps.addLocation(region,"Massey Street");
		}
		catch (SQLException e) {
			e.printStackTrace();
			// TODO: handle exception
		}
		try {
			int idUser = cps.addUser("thisismypassword","jordan", "jordan.d.carter@gmail.com", "0274681876");
			int idRide = cps.addRide(idUser, 4, date.toString(), idLocation, idLocation2, 0,1 , 0, "noon", "this is a comment");
			cps.attachOpenID("www.google.com", idUser);
			cps.takeRide(idUser, idRide, idLocation2, 0,1);
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("search jordan");
		RideListing rl = cps.searchRideListing(RideListing.searchUser, "jordan");
		try {
			while(rl.next()){
				System.out.println(rl.getRideID()+", "+rl.getUserID()+", "+rl.getUsername()+", "+rl.getAvailableSeats()+", "+rl.getRideDate().toString()+", "+rl.getTime()+", "+rl.getStartLocation()+", "+rl.getEndLocation()+" geoLocation:" + rl.getGeoLocation());
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("searchDate");
		rl = cps.searchRideListing(RideListing.searchDate, date.toString());
		try {
			while(rl.next()){
				System.out.println(rl.getRideID()+", "+rl.getUserID()+", "+rl.getUsername()+", "+rl.getAvailableSeats()+", "+rl.getRideDate().toString()+", "+rl.getTime()+", "+rl.getStartLocation()+", "+rl.getEndLocation()+" geoLocation:" + rl.getGeoLocation());
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("search Blair St both");
		rl = cps.searchRideListing(RideListing.searchLocationBoth, "Blair St");
		try {
			while(rl.next()){
				System.out.println(rl.getRideID()+", "+rl.getUserID()+", "+rl.getUsername()+", "+rl.getAvailableSeats()+", "+rl.getRideDate().toString()+", "+rl.getTime()+", "+rl.getStartLocation()+", "+rl.getEndLocation()+" geoLocation:" + rl.getGeoLocation());
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("search Blair St start");
		rl = cps.searchRideListing(RideListing.searchLocationStart, "Blair St");
		try {
			while(rl.next()){
				System.out.println(rl.getRideID()+", "+rl.getUserID()+", "+rl.getUsername()+", "+rl.getAvailableSeats()+", "+rl.getRideDate().toString()+", "+rl.getTime()+", "+rl.getStartLocation()+", "+rl.getEndLocation()+" geoLocation:" + rl.getGeoLocation());
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("search Massey end");
		rl = cps.searchRideListing(RideListing.searchLocationEnd, "Massey");
		try {
			while(rl.next()){
				System.out.println(rl.getRideID()+", "+rl.getUserID()+", "+rl.getUsername()+", "+rl.getAvailableSeats()+", "+rl.getRideDate().toString()+", "+rl.getTime()+", "+rl.getStartLocation()+", "+rl.getEndLocation()+" geoLocation:" + rl.getGeoLocation());
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("getall");
		rl = cps.getRideListing();
		try {
			while(rl.next()){
				System.out.println(rl.getRideID()+", "+rl.getUserID()+", "+rl.getUsername()+", "+rl.getAvailableSeats()+", "+rl.getRideDate().toString()+", "+rl.getTime()+", "+rl.getStartLocation()+", "+rl.getEndLocation()+" geoLocation:" + rl.getGeoLocation());
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void testGetMax(){
		Date date = new Date(System.currentTimeMillis());
		
		
		int region = 0;
		int idLocation = 0;
		try {
			region = cps.addRegion("Palmy");
			idLocation = cps.addLocation(region,"Blair St");
		}
		catch (SQLException e) {
			// TODO: handle exception
		}
		
		try {
			int idUser = cps.addUser("jordan", "jordan.d.carter@gmail.com", "0274681876", "thisismypassword");
			int idUser2 = cps.addUser("jordanda", "jordan.d.caasdfrter@gmail.com", "027468187adsfasdf6", "thisismypassword");
			int idRide = cps.addRide(idUser, 4, date.toString(), idLocation, idLocation, 0,1 , 0, "5:22 PM", "be on time");
			cps.attachOpenID("www.google.com", idUser);
			assertEquals(4, cps.getAvailableSeats(idRide));
			assertEquals(4, cps.getMaxSeats(idRide));
			cps.takeRide(idUser2, idRide, idLocation, 0,1);
			assertEquals(3, cps.getAvailableSeats(idRide));
			assertEquals(4, cps.getMaxSeats(idRide));
			cps.acceptUser(idUser2, idRide, 0);
			assertEquals(3, cps.getAvailableSeats(idRide));
			
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void testAddGetDeleteComment() {
		
		int id1 = 0, id2 = 0, id3 = 0 ;
		int deleted = 0;
		String the_comment;
		Vector<String> all_comments;
		
		//add a comment (add user first to get a valid ID)
		try {
			int idUser = cps.addUser("testUserComments", "testPassword");
			id1 = cps.addComment(idUser, 1, "Test Comment 1 - Ride 1");
			id2 = cps.addComment(idUser, 1, "Test Comment 2 - Ride 1");
			id3 = cps.addComment(idUser, 2, "Test Comment 3 - Ride 2");
		}catch(SQLException e){
			fail("Couldn't add comment - SQL Error");
		}catch(Exception e){
			fail("User doesn't exist");
		}
		assertTrue("Couldn't add comment",id1>0);
		
		
		//try to get the comment added above
		try {
			the_comment = cps.getComment(id1);
			assertTrue("Couldn't get first comment", the_comment.contains("Test Comment"));
		}catch(SQLException e){
			fail("Couldn't get comment - SQL Error");
		}
		
		try {
			all_comments = cps.getRideComment(1);
			assertTrue("Couldn't get all comments for ride 1", all_comments.elementAt(0).contains("Test Comment"));
		}catch(SQLException e){
			fail("Couldn't get comment - SQL Error");
		}
		
		
		//try to delete the comment added above
		try {
			deleted = cps.delComment(id1);
			deleted = cps.delComment(id2);
			deleted = cps.delComment(id3);
		}catch(SQLException e){
			fail("Couldn't delete comment - SQL Error");
		}
		assertTrue("Couldn't delete comment"+ id3 + "" + deleted,deleted>0);
		
		
	}
	
	public void testGetRegionName(){
		int region = -1;
		int region2 = -1;
		int region3 = -1;
		int region4 = -1;
		int region5 = -1;
		try {
			region = cps.addRegion("TestRegion");
			region2 = cps.addRegion("TestRegion2");
			region3 = cps.addRegion("TestRegion3");
			region4 = cps.addRegion("TestRegion4");
			region5 = cps.addRegion("TestRegion5");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try {
			assertEquals(region, cps.getRegionIDbyName("TestRegion"));
			assertEquals(region2, cps.getRegionIDbyName("TestRegion2"));
			assertEquals(region3, cps.getRegionIDbyName("TestRegion3"));
			assertEquals(region4, cps.getRegionIDbyName("TestRegion4"));
			assertEquals(region5, cps.getRegionIDbyName("TestRegion5"));
		} catch (StoreException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void testGetRideDetail(){
		int region = 0;
		int idLocation = 0;
		try {
			region = cps.addRegion("Palmy");
			idLocation = cps.addLocation(region,"Blair St");
		}
		catch (SQLException e) {
			// TODO: handle exception
		}
		try {
			int a = cps.addUser("a", "a");
			int b = cps.addUser("b", "b");
			int c = cps.addUser("c", "c");
			int d = cps.addUser("d", "d");
			int e = cps.addUser("e", "a");
			int f = cps.addUser("f", "b");
			int g = cps.addUser("g", "c");
			int h = cps.addUser("h", "d");
			int i = cps.addUser("i", "a");
			int j = cps.addUser("j", "b");
			int k = cps.addUser("k", "c");
			int l = cps.addUser("l", "d");
/*			int m = cps.addUser("m", "a");
			int n = cps.addUser("n", "b");
			int o = cps.addUser("o", "c");
			int p = cps.addUser("p", "d");
			int q = cps.addUser("q", "a");
			int r = cps.addUser("r", "b");
			int s = cps.addUser("s", "c");
			int t = cps.addUser("t", "d");
*/			
			Date date = new Date(System.currentTimeMillis());
			//addRide(int user, int availableSeats, String startDate, int startLocation, int endLocation, int streetNumber, int reoccur, String time, String comment)			
			int ride1 = cps.addRide(a, 4, date.toString(), idLocation, idLocation, 0,1 , 0, "5:22 PM", "be on time");
			int ride2 = cps.addRide(b, 4, date.toString(), idLocation, idLocation,1,1 , 0, "6:22 AM", "no latecomers please");
			int ride3 = cps.addRide(c, 4, date.toString(), idLocation, idLocation,2,1 , 0, "3:22 PM", "I might be a few minutes late");
			int ride4 = cps.addRide(d, 4, date.toString(), idLocation, idLocation,3,1 , 0, "9:22 PM", "be on time");
//			int ride5 = cps.addRide(e, 4, date.toString(), "asgadfg", "adfgadfgafd home");
			
			cps.takeRide(e, ride1, idLocation,0,1);
			cps.takeRide(f, ride1, idLocation,0,1);
			cps.takeRide(g, ride1, idLocation,0,1);
			cps.takeRide(h, ride1, idLocation,0,1);
			
			cps.takeRide(i, ride2, idLocation,0,1);
			cps.takeRide(j, ride2, idLocation,0,1);
			
			cps.takeRide(g, ride3, idLocation,0,1);
			cps.takeRide(h, ride3, idLocation,0,1);
			
			cps.takeRide(k, ride3, idLocation,0,1);
			cps.takeRide(l, ride4, idLocation,0,1);
			
			
			RideDetail rd = cps.getRideDetail(ride1);
			
			while(rd.hasNext()){
				System.out.println("userid: " + rd.getUserID() + ", username: " + rd.getUsername() + ", street number: " + rd.getStreetNumber() + "," + rd.getStreetNumberEnd()+ ", geoLocation: " + rd.getGeoLocation());
			}
			
			rd = cps.getRideDetail(ride2);
			
			while(rd.hasNext()){
				System.out.println("userid: " + rd.getUserID() + ", username: " + rd.getUsername() + ", street number: " + rd.getStreetNumber() + "," + rd.getStreetNumberEnd()+ ", geoLocation: " + rd.getGeoLocation());
			}
			rd = cps.getRideDetail(ride3);
			
			while(rd.hasNext()){
				System.out.println("userid: " + rd.getUserID() + ", username: " + rd.getUsername() + ", street number: " + rd.getStreetNumber() + "," + rd.getStreetNumberEnd()+ ", geoLocation: " + rd.getGeoLocation());
			}
			rd = cps.getRideDetail(ride4);
			
			while(rd.hasNext()){
				System.out.println("userid: " + rd.getUserID() + ", username: " + rd.getUsername() + ", street number: " + rd.getStreetNumber() + "," + rd.getStreetNumberEnd()+ ", geoLocation: " + rd.getGeoLocation());
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	public void testScoring(){
		int region = 0;
		int idLocation = 0;
		try {
			region = cps.addRegion("Palmy");
			idLocation = cps.addLocation(region,"Blair St");
		}
		catch (SQLException e) {
			// TODO: handle exception
		}
		try {
			int a = cps.addUser("a", "a");
			int b = cps.addUser("b", "b");
			int c = cps.addUser("c", "c");
			int d = cps.addUser("d", "d");
			int e = cps.addUser("e", "a");
			int f = cps.addUser("f", "b");
			int g = cps.addUser("g", "c");
			int h = cps.addUser("h", "d");
			int i = cps.addUser("i", "a");
			int j = cps.addUser("j", "b");
			int k = cps.addUser("k", "c");
			int l = cps.addUser("l", "d");
/*			int m = cps.addUser("m", "a");
			int n = cps.addUser("n", "b");
			int o = cps.addUser("o", "c");
			int p = cps.addUser("p", "d");
			int q = cps.addUser("q", "a");
			int r = cps.addUser("r", "b");
			int s = cps.addUser("s", "c");
			int t = cps.addUser("t", "d");
*/			
			Date date = new Date(System.currentTimeMillis());
			//addRide(int user, int availableSeats, String startDate, int startLocation, int endLocation, int streetNumber, int reoccur, String time, String comment)			
			int ride1 = cps.addRide(a, 4, date.toString(), idLocation, idLocation, 0,1 , 0, "5:22 PM", "be on time");
			int ride2 = cps.addRide(b, 4, date.toString(), idLocation, idLocation,1,1 , 0, "6:22 AM", "no latecomers please");
			int ride3 = cps.addRide(c, 4, date.toString(), idLocation, idLocation,2,1 , 0, "3:22 PM", "I might be a few minutes late");
			int ride4 = cps.addRide(d, 4, date.toString(), idLocation, idLocation,3,1 , 0, "9:22 PM", "be on time");
//			int ride5 = cps.addRide(e, 4, date.toString(), "asgadfg", "adfgadfgafd home");
			
			cps.takeRide(e, ride1, idLocation,0,1);
			cps.takeRide(f, ride1, idLocation,0,1);
			cps.takeRide(g, ride1, idLocation,0,1);
			cps.takeRide(h, ride1, idLocation,0,1);
			
			cps.takeRide(i, ride2, idLocation,0,1);
			cps.takeRide(j, ride2, idLocation,0,1);
			
			cps.takeRide(g, ride3, idLocation,0,1);
			cps.takeRide(h, ride3, idLocation,0,1);
			
			cps.takeRide(k, ride3, idLocation,0,1);
			int trip1 = cps.takeRide(l, ride4, idLocation,0,1);
			
			
			cps.addScore(trip1, g, 3);
			cps.addScore(trip1, g, 7);
			cps.addScore(trip1, g, 4);
			cps.addScore(trip1, g, -2);
			assertEquals(cps.getScore(d), 12);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	@SuppressWarnings("unused")
	public void testGetTripID(){
		int region = 0;
		int idLocation = 0;
		try {
			region = cps.addRegion("Palmy");
			idLocation = cps.addLocation(region,"Blair St");
		}
		catch (SQLException e) {
			// TODO: handle exception
		}
		try {
			int a = cps.addUser("a", "a");
			int b = cps.addUser("b", "b");
			int c = cps.addUser("c", "c");
			int d = cps.addUser("d", "d");
			int e = cps.addUser("e", "a");
			int f = cps.addUser("f", "b");
			int g = cps.addUser("g", "c");
			int h = cps.addUser("h", "d");
			int i = cps.addUser("i", "a");
			int j = cps.addUser("j", "b");
			int k = cps.addUser("k", "c");
			int l = cps.addUser("l", "d");
	
			Date date = new Date(System.currentTimeMillis());
			//addRide(int user, int availableSeats, String startDate, int startLocation, int endLocation, int streetNumber, int reoccur, String time, String comment)			
			int ride1 = cps.addRide(a, 4, date.toString(), idLocation, idLocation, 0,1 , 0, "5:22 PM", "be on time");
			int ride2 = cps.addRide(b, 4, date.toString(), idLocation, idLocation,1,1 , 0, "6:22 AM", "no latecomers please");
			int ride3 = cps.addRide(c, 4, date.toString(), idLocation, idLocation,2,1 , 0, "3:22 PM", "I might be a few minutes late");
			int ride4 = cps.addRide(d, 4, date.toString(), idLocation, idLocation,3,1 , 0, "9:22 PM", "be on time");
//			int ride5 = cps.addRide(e, 4, date.toString(), "asgadfg", "adfgadfgafd home");
			
			assertEquals(cps.takeRide(e, ride1, idLocation,0,1),cps.getTripID(ride1, e));
			assertEquals(cps.takeRide(f, ride1, idLocation,0,1),cps.getTripID(ride1, f));
			assertEquals(cps.takeRide(g, ride1, idLocation,0,1),cps.getTripID(ride1, g));
			assertEquals(cps.takeRide(h, ride1, idLocation,0,1),cps.getTripID(ride1, h));
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public void testGetGeoLocation(){
		int region = 0;
		int idLocation = 0;
		try {
			region = cps.addRegion("Palmy");
			idLocation = cps.addLocation(region,"Blair St");
		}
		catch (SQLException e) {
			// TODO: handle exception
		}
		try {
			int a = cps.addUser("a", "a");
			int b = cps.addUser("b", "b");
			int c = cps.addUser("c", "c");
			int d = cps.addUser("d", "d");
			int e = cps.addUser("e", "a");
			int f = cps.addUser("f", "b");
			int g = cps.addUser("g", "c");
			int h = cps.addUser("h", "d");
			int i = cps.addUser("i", "a");
			int j = cps.addUser("j", "b");
			int k = cps.addUser("k", "c");
			int l = cps.addUser("l", "d");
	
			Date date = new Date(System.currentTimeMillis());
			//addRide(int user, int availableSeats, String startDate, int startLocation, int endLocation, int streetNumber, int reoccur, String time, String comment)			
			int ride1 = cps.addRide(a, 4, date.toString(), idLocation, idLocation, 0,1 , 0, "5:22 PM", "be on time", "this is as geolocation");
			int ride2 = cps.addRide(b, 4, date.toString(), idLocation, idLocation,1,1 , 0, "6:22 AM", "no latecomers please", "this is as geolocation");
			int ride3 = cps.addRide(c, 4, date.toString(), idLocation, idLocation,2,1 , 0, "3:22 PM", "I might be a few minutes late", "this is as geolocation");
			int ride4 = cps.addRide(d, 4, date.toString(), idLocation, idLocation,3,1 , 0, "9:22 PM", "be on time", "this is as geolocation");
//			int ride5 = cps.addRide(e, 4, date.toString(), "asgadfg", "adfgadfgafd home");
			int ride5 = cps.addRide(d, 4, date.toString(), idLocation, idLocation, 0, 1, 0, "5:34 PM", "blah comment", "this is as geolocation");
			
			assertEquals(cps.takeRide(e, ride1, idLocation,0,1),cps.getTripID(ride1, e));
			assertEquals(cps.takeRide(f, ride1, idLocation,0,1),cps.getTripID(ride1, f));
			assertEquals(cps.takeRide(g, ride1, idLocation,0,1),cps.getTripID(ride1, g));
			assertEquals(cps.takeRide(h, ride1, idLocation,0,1),cps.getTripID(ride1, h));
			
			RideDetail rd = cps.getRideDetail(ride5);
			assertEquals(true, rd.hasNext());
			assertEquals(rd.getGeoLocation(),"this is as geolocation");
			
			RideListing rl = cps.getRideListing();
			while(rl.next()){
				assertEquals("this is as geolocation", rl.getGeoLocation());
			}
			
			rl = cps.searchRideListing(RideListing.searchDate, date.toString());
			while(rl.next()){
				assertEquals("this is as geolocation", rl.getGeoLocation());
			}
			rl = cps.searchRideListing(RideListing.searchLocationBoth, "Blair St");
			while(rl.next()){
				assertEquals("this is as geolocation", rl.getGeoLocation());
			}
			rl = cps.searchRideListing(RideListing.searchLocationEnd, "Blair St");
			while(rl.next()){
				assertEquals("this is as geolocation", rl.getGeoLocation());
			}
			rl = cps.searchRideListing(RideListing.searchLocationStart, "Blair St");
			while(rl.next()){
				assertEquals("this is as geolocation", rl.getGeoLocation());
			}
			rl = cps.searchRideListing(RideListing.searchUser, Integer.toString(f));
			while(rl.next()){
				assertEquals("this is as geolocation", rl.getGeoLocation());
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
