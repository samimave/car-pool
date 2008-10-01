package car.pool.email;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.MimeMessage;

import com.sun.mail.smtp.SMTPMessage;

public class SMTP {
	protected SMTP() {
		
	}
	
	public static void send(Email email) throws IOException {
		String def =  "javamail.providers and javamail.default.providers";
		InputStream inStream = Class.class.getResourceAsStream(def);
		Properties props = new Properties();
		if(inStream != null) {
			props.load(inStream);
		}
		SMTPMessage message = new SMTPMessage(Session.getDefaultInstance(props));
	}
	
	public static void main(String[] argv) {
		try {
			SMTP.send(new Email());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
