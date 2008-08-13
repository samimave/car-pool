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
	
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		UserManager manager = new UserManager();
		user = UserFactory.newInstance();
		user.setEmail("terrasea@gmail.com");
		user.setName("James");
		user.setPhoneNumber("3530079");
		user.setUserName("terrasea");
		user.addOpenId("http://terrasea.pip.verisignlabs.com");
		manager.registerUser(user);
		
		user = UserFactory.newInstance("http://terrasea.pip.verisignlabs.com/");
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
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
		fail("Not yet implemented");
	}

	@Test
	public void testGetOcupation() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetOpenIds() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetPhoneNumber() {
		fail("Not yet implemented");
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
		fail("Not yet implemented");
	}

	@Test
	public void testGetUserName() {
		fail("Not yet implemented");
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
