package car.pool.user.test;

import static org.junit.Assert.*;


import org.junit.After;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import car.pool.persistance.CarPoolStoreImpl;
import car.pool.user.User;
import car.pool.user.UserFactory;
import car.pool.user.UserManager;

public class TestUpdateUser {

	UserManager manager = null;
	User user = null;
	static String testOpenId = "http://terrasea.myopenid.com";
	
	@BeforeClass
	public static void initialSetup() throws Exception {
		CarPoolStoreImpl store = new CarPoolStoreImpl();
		store.removeAll("donotusethis");
		User user = UserFactory.newInstance();
		user.setEmail("terrasea@gmail.com");
		user.setName("James");
		user.setPhoneNumber("3530079");
		user.setUserName("james");
		user.addOpenId(testOpenId);
		new UserManager().registerUser(user);
	}
	
	
	@AfterClass
	public static void cleanup() throws Exception {
		CarPoolStoreImpl store = new CarPoolStoreImpl();
		store.removeAll("donotusethis");
	}
	
	@Before
	public void setUp() throws Exception {
		manager = new UserManager();
		user = manager.getUserByOpenId(testOpenId);
		
	}

	@After
	public void tearDown() throws Exception {
		manager = null;
	}

	@Test
	public void testUpdateUserEmail() {
		try {
			String oldEmail = user.getEmail();
			user.setEmail("terrasea@localhost");
			User updated = manager.updateUserDetails(user);
			Assert.assertEquals(updated.getEmail(), user.getEmail());
			Assert.assertNotSame(oldEmail, updated.getEmail());
			
		} catch (Exception e ) {
			fail("testUpdateUserEmail: " + e);
		}
	}
	
	@Test
	public void testUpdateUserPhone() {
		try {
			String oldPhone = user.getPhoneNumber();
			user.setPhoneNumber("1234567");
			User updated = manager.updateUserDetails(user);
			Assert.assertEquals(updated.getPhoneNumber(), user.getPhoneNumber());
			Assert.assertNotSame(oldPhone, updated.getPhoneNumber());
		} catch(Exception e) {
			fail("testUpdateUserPhone: " + e);
		}
	}
	
	@Test
	public void testUpdateUserOpenId() {
		try {
			String openid = "http://terrasea.provider.com";
			user.addOpenId(openid);
			User updated = manager.updateUserDetails(user);
			//user = manager.getUserByOpenId(openid);
			Assert.assertEquals(updated.getOpenIds().size(), user.getOpenIds().size());
			Object[] oldArray = user.getOpenIds().toArray();
			Object[] newArray = updated.getOpenIds().toArray();
			for(int i = 0; i < newArray.length; i++) {
				Assert.assertEquals(oldArray[i], newArray[i]);
			}
		} catch(Exception e) {
			fail("testUpdateUserOpenId: " + e);
		}
	}
	
	@Test
	public void testUpdateUserReplaceOpenId() {
		try {
			String openid1 = "http://test.provider.com";
			String openid2 = "http://test2.provider.com";
			user.getOpenIds().clear();
			//for(String openid : user.getOpenIds()) {
			//	user.delOpenId(openid);
			//}
			user.addOpenId(openid1);
			user.addOpenId(openid2);
			User updated = manager.updateUserDetails(user);
			updated = manager.getUserByOpenId(openid1);
			//user = manager.getUserByOpenId(openid);
			Assert.assertEquals(updated.getOpenIds().size(), user.getOpenIds().size());
			Object[] oldArray = user.getOpenIds().toArray();
			Object[] newArray = updated.getOpenIds().toArray();
			for(int i = 0; i < newArray.length; i++) {
				Assert.assertEquals(oldArray[i], newArray[i]);
			}
		} catch(Exception e) {
			e.printStackTrace();
			fail("testUpdateUserReplaceOpenId: " + e);
		}
	}

}
