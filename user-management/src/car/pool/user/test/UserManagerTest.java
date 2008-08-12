package car.pool.user.test;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.Assert;

import car.pool.user.UserManager;
import car.pool.user.User;
import car.pool.user.UserFactory;

public class UserManagerTest {

	UserManager manager = null;

	@Before
	public void setUp() throws Exception {
		manager = new UserManager();
	}

	@After
	public void tearDown() throws Exception {
		manager = null;
	}

	@Test
	public void testRegisterUser() {
		User user = UserFactory.newInstance();
		user.setEmail("terrasea@gmail.com");
		user.setName("James");
		user.setPhoneNumber("3530079");
		user.setUserName("james");
		user.addOpenId("http://terrasea.pip.verisignlabs.com");

		try {
			user = manager.registerUser( user );
			Assert.assertNotNull(user.getUserId());
		} catch(Exception e ) {
			System.out.println(e);
			fail("testRegisterUser: " + e);
		}
	}

	/*@Test
	public void testLogin() {
		try {
			User user = manager.login("http://terrasea.pip.verisignlabs.com");
			System.out.println(user.getUserId());
			Assert.assertNotNull(user.getUserId());
		} catch(Exception e ) {
			fail("testLogin" + e);
		}
	}

	@Test
	public void testAttachOpenId() {
		fail("Not yet implemented");
	}*/
	
	@Test
	public void testRemoveUser() {
		try {
			User user = manager.login("http://terrasea.pip.verisignlabs.com");
			if(user.getUserId() != null ) {
				Assert.assertTrue(manager.removeUser(user));
			}
		} catch( Exception e ) {
			fail("testRemoveUser: " + e);
		}
	}

}
