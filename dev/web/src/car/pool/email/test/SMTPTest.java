package car.pool.email.test;

import static org.junit.Assert.fail;

import org.junit.Test;

import car.pool.email.Email;
import car.pool.email.SMTP;
import car.pool.email.SMTPException;

public class SMTPTest {

	String toAddress = "terrasea@gmail.com";
	@Test
	public void testSend() {
		Email email = new Email();
		email.setToAddress(toAddress);
		email.setSubject("test");
		email.setMessage("This is a test");
		try {
			SMTP.send(email);
		} catch (SMTPException e) {
			// TODO Auto-generated catch block
			fail(String.format("SMTP.send fails: %s", e.toString()));
		}
	}

}
