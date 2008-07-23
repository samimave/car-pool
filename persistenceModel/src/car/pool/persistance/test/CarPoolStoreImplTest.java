package car.pool.persistance.test;

import java.util.LinkedList;
import java.util.Map;
import java.util.Random;
import java.util.Vector;

import car.pool.persistance.CarPoolStore;
import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.persistance.exception.StoreException;
import car.pool.persistance.util.Pair;
import junit.framework.TestCase;

public class CarPoolStoreImplTest extends TestCase {

	
	CarPoolStore cps = null;
	
	LinkedList<Pair<String, String>> usedUsers = null;
	
	protected void setUp() throws Exception {
		super.setUp();
		
		cps = new CarPoolStoreImpl();
		usedUsers = new LinkedList<Pair<String, String>>();
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
		//TODO check unknown user returns negitive
		
	}

}
