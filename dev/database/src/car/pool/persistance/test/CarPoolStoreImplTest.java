package car.pool.persistance.test;

import java.sql.Date;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.Random;

import junit.framework.TestCase;
import car.pool.persistance.CarPoolStoreImpl;
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
			ride = cps.addRide(id, 4, date.toString(), idLocation, idLocation, 0);
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
			cps.takeRide(u, ride,idLocation, idLocation, 0);
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
			int idRide = cps.addRide(idUser, 4, date.toString(), idLocation, idLocation, 0);
			cps.attachOpenID("www.google.com", idUser);
			cps.takeRide(idUser, idRide, idLocation, idLocation, 0);
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void testRideListing(){
		new TestSetup();
		RideListing rl = cps.getRideListing();
		try {
			while(rl.next()){
				System.out.println(rl.getRideID()+", "+rl.getUserID()+", "+rl.getUsername()+", "+rl.getAvailableSeats()+", "+rl.getRideDate().toString()+", "+rl.getStartLocation()+", "+rl.getEndLocation());
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
			int idRide = cps.addRide(idUser, 4, date.toString(), idLocation, idLocation, 0);
			cps.attachOpenID("www.google.com", idUser);
			assertEquals(4, cps.getAvailableSeats(idRide));
			assertEquals(4, cps.getMaxSeats(idRide));
			cps.takeRide(idUser2, idRide, idLocation, idLocation, 0);
			assertEquals(3, cps.getAvailableSeats(idRide));
			assertEquals(4, cps.getMaxSeats(idRide));
			
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
