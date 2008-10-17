package car.pool.email.test;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import car.pool.email.Email;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;

import java.sql.ResultSet;

public class EmailTest {
	Email email = null;
	String address = "terrasea@gmail.com";
	
	@Before
	public void setUp() throws Exception {
		email = new Email();
	}

	@After
	public void tearDown() throws Exception {
		email = null;
	}

	@Test
	public void testGetSetToAddress() {
		email.setToAddress(address);
		Assert.assertEquals(address, email.getToAddress());
	}

	@Test
	public void testGetFromAddress() {
		String address = null;
		try {
			Database db = new DatabaseImpl();
			String sql = "select * from Email";
			ResultSet results = db.getStatement().executeQuery(sql);
			if(results != null && results.next()) {
				address = results.getString(2);
			}else{
				address = "anonymous@localhost";
			}
		} catch (Exception e) {
			fail(e.toString());
		}
		Assert.assertEquals(address, email.getFromAddress());
	}

	@Test
	public void testSetGetSubject() {
		String subject = "hello there";
		email.setSubject(subject);
		Assert.assertEquals(subject, email.getSubject());
	}

	@Test
	public void testSetGetMessage() {
		String message = "This is a test";
		email.setMessage(message);
		Assert.assertEquals(message, email.getMessage());
	}

}
