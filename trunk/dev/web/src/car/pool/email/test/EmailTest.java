package car.pool.email.test;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import car.pool.email.Email;

public class EmailTest {
	Email email = null;
	
	@Before
	public void setUp() throws Exception {
		email = new Email();
	}

	@After
	public void tearDown() throws Exception {
		email = null;
	}

	@Test
	public void testEmail() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetToAddress() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetToAddress() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetFromAddress() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetSubject() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetSubject() {
		fail("Not yet implemented");
	}

	@Test
	public void testSetMessage() {
		fail("Not yet implemented");
	}

	@Test
	public void testGetMessage() {
		fail("Not yet implemented");
	}

}
