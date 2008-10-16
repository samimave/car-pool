package car.pool.user.test;

import static org.junit.Assert.fail;

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
	public void testSetPassword() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetPhoneNumber() {
		String oldph = user.getPhoneNumber();
		user.setPhoneNumber("1234567");
		String newph = user.getPhoneNumber();
		user.setPhoneNumber(oldph);
		Assert.assertNotSame(oldph, newph);
		Assert.assertEquals(oldph, user.getPhoneNumber());
	}

	@Test
	public void testSetSocialScore() {
		Integer oldsoc = user.getSocialScore();
		user.setSocialScore(1);
		Integer nsoc = user.getSocialScore();
		user.setSocialScore(oldsoc);
		Assert.assertNotSame(oldsoc, nsoc);
		Assert.assertEquals(oldsoc, user.getSocialScore());
	}

	@Test
	public void testSetUserId() {
		Integer oldid = user.getUserId();
		user.setUserId(oldid.intValue() + 1);
		Integer newid = user.getUserId();
		user.setUserId(oldid);
		Assert.assertNotSame(oldid, newid);
		Assert.assertEquals(oldid, user.getUserId());
	}

	@Test
	public void testSetUserName() {
		String oldName = user.getUserName();
		user.setUserName("john");
		Assert.assertNotSame(oldName, user.getUserName());
	}
}
