package car.pool.user.test;

import static org.junit.Assert.*;

import java.io.IOException;
import java.sql.SQLException;

import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.Assert;

import car.pool.persistance.CarPoolStoreImpl;
import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.user.UserManager;
import car.pool.user.User;
import car.pool.user.UserFactory;

public class UserManagerTest {

	UserManager manager = null;
	String testOpenId = "http://terrasea.myopenid.com/";
	
	@BeforeClass
	public static void cleanDatabase() throws Exception{
		CarPoolStoreImpl store = new CarPoolStoreImpl();
		store.removeAll("donotusethis");
	}
	
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
		user.addOpenId(testOpenId);

		try {
			user = manager.registerUser( user );
			Assert.assertNotNull(user.getUserId());
		} catch(Exception e ) {
			System.out.println(e);
			fail("testRegisterUser: " + e);
		}
	}

	@Test
	public void testLogin() {
		try {
			User user = manager.getUserByOpenId(testOpenId);
			Assert.assertNotNull(user.getUserId());
		} catch(Exception e ) {
			fail("testLogin" + e);
		}
	}

	@Test
	public void testAttachOpenId() {
		try {
			User user = manager.getUserByOpenId(testOpenId);
			if(user.getUserId() != null ) {
				Assert.assertEquals(manager.attachOpenId("http://terra.pip.verisignlabs.com", user).getOpenIds().size(), 2);
			}
		} catch( Exception e ) {
			fail("testAttachOpenId: " + e );
		}
	}
	
	@Test
	public void testDetachOpenId() {
		try {
			User user = manager.getUserByOpenId(testOpenId);
			if(user.getUserId() != null ) {
				Assert.assertEquals(manager.detachOpenId("http://terra.pip.verisignlabs.com", user).getOpenIds().size(), 1);
			}
		} catch(Exception e) {
			fail("testDetachOpenId: " + e );
		}
	}
	
	@Test
	public void testRemoveUser() {
		try {
			User user = manager.getUserByOpenId(testOpenId);
			if(user.getUserId() != null ) {
				Assert.assertTrue(manager.removeUser(user));
			}
		} catch( Exception e ) {
			fail("testRemoveUser: " + e);
		}
	}
}
