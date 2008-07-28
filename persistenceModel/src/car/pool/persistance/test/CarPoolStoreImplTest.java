package car.pool.persistance.test;

import java.sql.Date;
import java.util.LinkedList;
import java.util.Map;
import java.util.Random;
import java.util.Vector;

import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.exception.InvaildUserName;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.RideException;
import car.pool.persistance.exception.StoreException;
import car.pool.persistance.util.Pair;
import junit.framework.TestCase;

public class CarPoolStoreImplTest extends TestCase {

	
	CarPoolStore cps = null;
	
	LinkedList<Pair<String, String>> usedUsers = null;
	LinkedList<Integer> lodgedRides = null;
	
	protected void setUp() throws Exception {
		super.setUp();
		
		cps = new CarPoolStoreImpl();
		usedUsers = new LinkedList<Pair<String, String>>();
		lodgedRides = new LinkedList<Integer>();
	}
	
	/**
	 * remember a user from removal later
	 * @param username
	 * @param password
	 */
	private void trackUser(String username, String password){
		usedUsers.add(new Pair(username, password));
	}
	
	/**
	 * remember a ride from removal later
	 * @param idRide
	 */
	private void trackRide(int idRide){
		lodgedRides.add(idRide);
	}
	
	/**
	 * Return a user and remove from memory
	 * @return
	 */
	private Pair recallUser(){
		Pair pair = usedUsers.pollLast();	
		return pair;
	}
	
	@SuppressWarnings("unchecked")
	private LinkedList<Pair<String, String>> allUsedUsers(){
		return (LinkedList<Pair<String, String>>) usedUsers.clone();
	}
	
	/**
	 * @return true if a user hasn't been recalled
	 */
	private boolean hasMoreUsedUsers(){
		return !usedUsers.isEmpty();
	}
	
	/**
	 * remove all test users from DB
	 */
	protected void tearDown() throws Exception {
		super.tearDown();
		
		while(hasMoreUsedUsers()){
			Pair<String, String> user = recallUser();
			cps.removeUser(user.first, user.second);
		}
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
		addLotsOfUsers();
		
		LinkedList<Pair<String,String>> temp = allUsedUsers();
		
		while(!temp.isEmpty()){
			Pair<String, String> pair = temp.pollLast();
			assertEquals("Username should have been accepted", true, cps.checkUserExists(pair.first));
		}
		
		temp = allUsedUsers();
		
		while(!temp.isEmpty()){
			Pair<String, String> pair = temp.pollLast();
			boolean failed = false;
			assertEquals("A wrong username was accepted", false, cps.checkUserExists("im not the username"));
		}
	}
	
	public void testCheckUser(){
		
		addLotsOfUsers();
		
		LinkedList<Pair<String,String>> temp = allUsedUsers();
		
		while(!temp.isEmpty()){
			Pair<String, String> pair = temp.pollLast();
			try {
				cps.checkUser(pair.first, pair.second);
			} catch (InvaildUserNamePassword e) {
				fail("False negitive on username and password");
			}
		}
		
		temp = allUsedUsers();
		
		while(!temp.isEmpty()){
			Pair<String, String> pair = temp.pollLast();
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
			Pair<String, String> pair = temp.pollLast();
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
		
		Pair<String, String> user = temp.pollLast();
		
		int id = 0;
		try {
			id = cps.checkUser(user.first, user.second);
		} catch (InvaildUserNamePassword e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.exit(0);
		}
		
		int ride = 0;
		try {
			Date date = new Date(System.currentTimeMillis());
			ride = cps.addRide(id, 4, date.toString(), "Massey", "Home");
		} catch (RideException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		user = temp.pollLast();
		
		int u = 0;
		try {
			u = cps.checkUser(user.first, user.second);
		} catch (InvaildUserNamePassword e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.exit(0);
		}
		
		try {
			cps.takeRide(u, ride);
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
		//TODO
	}
	
	public void testRemoveUser(){
		//TODO
	}

}
