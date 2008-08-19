package car.pool.user.test;

import static org.junit.Assert.*;

import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

import car.pool.user.User;
import car.pool.user.UserFactory;
import car.pool.user.UserManager;

public class TestUser {

	static User user = null;
	static Integer id = null;
	
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		UserManager manager = new UserManager();
		user = UserFactory.newInstance();
		user.setEmail("terrasea@gmail.com");
		user.setName("James");
		user.setPhoneNumber("3530079");
		user.setUserName("david");
		user.addOpenId("http://sea.pip.verisignlabs.com");
		user = manager.registerUser(user);
		
		user = manager.getUserByOpenId("http://sea.pip.verisignlabs.com");
		id = user.getUserId();
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
		UserManager manager = new UserManager();
		manager.removeUser(user);
		user = null;
	}

	@Test
	public void testCalcSocialScore() {
		fail("Not yet implemented");
	}

	@Test
	public void testCheckPassword() {
		fail("Not yet implemented");
	}

	@Test
	public void testEditDetail() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetEmail() {
		String email = user.getEmail();
		Assert.assertEquals(email, "terrasea@gmail.com");
		//fail("Not yet implemented");
	}

	@Test
	public void testGetName() {
		Assert.assertEquals(user.getName(), "James" );
	}

	@Test
	public void testGetOcupation() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetOpenIds() {
		Assert.assertEquals(user.getOpenIds().size(), 1);
		Assert.assertEquals((String)user.getOpenIds().toArray()[0], "http://sea.pip.verisignlabs.com");
	}

	@Test
	public void testGetPhoneNumber() {
		Assert.assertEquals( user.getPhoneNumber(), "3530079" );
	}

	@Test
	public void testGetSocialScore() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetSuburb() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetUserId() {
		Assert.assertNotNull(user.getUserId());
		Assert.assertEquals(user.getUserId(), id);
	}

	@Test
	public void testGetUserName() {
		Assert.assertEquals(user.getUserName(), "david");
	}

	@Test
	public void testLoginFailed() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetMemberSince() {
		fail("Not yet implemented");
	}

	@Test
	public void testAddOpenId() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetPassword() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetEmail() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetMemberSince() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetName() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetOcupation() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetPassword() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetPhoneNumber() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetSocialScore() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetSuburb() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetUserId() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetUserName() {
		fail("Not yet implemented");
	}

}
