package car.pool.email;

import java.io.IOException;
import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.URLName;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;

import com.sun.mail.smtp.SMTPMessage;
import com.sun.mail.smtp.SMTPTransport;

public class SMTP {
	protected static SMTPTransport transport = null;
	protected static Properties properties = null;
	protected static boolean usettls = false;
	
	protected SMTP() {
		
	}
	
	protected static void setup() throws SMTPException {
		String def =  "javamail.providers and javamail.default.providers";
		InputStream inStream = Class.class.getResourceAsStream(def);
		properties = new Properties();
		if(inStream != null) {
			try {
				properties.load(inStream);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				throw new SMTPException(e.toString());
			}
		}
		URLName urlname = null;
		try {
			String url = "";
			Integer port = new Integer(-1);
			//boolean ttls = false;
			String username = "";
			String password = "";
			Database db = new DatabaseImpl();
			String sql = "select * from SMTP";
			ResultSet result = db.getStatement().executeQuery(sql);
			if(result.next()) {
				url = result.getString(1);
				port = new Integer(result.getInt(2));
				usettls = result.getInt(3) > 0;
			}
			sql = "select * from Email";
			result = db.getStatement().executeQuery(sql);
			if(result.next()) {
				username = result.getString(1);
				password = result.getString(3);
			}
			urlname = new URLName("smtp", url, port, null, username, password);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new SMTPException(e.toString());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new SMTPException(e.toString());
		}
		
		transport = new SMTPTransport(Session.getDefaultInstance(properties), urlname);
	}
	
	public static void send(Email email) throws SMTPException {
		setup();
		SMTPMessage message = new SMTPMessage(Session.getDefaultInstance(properties));
		try {
			message.addFrom(InternetAddress.parse(email.getFromAddress()));
			message.addRecipients(Message.RecipientType.TO, email.getToAddress());
			message.setSubject(email.getSubject());
			message.setText(email.getMessage());
			message.setReplyTo(InternetAddress.parse(email.getFromAddress()));
			//SMTPTransport.send(message);
			transport.setStartTLS(usettls);
			transport.connect();
			transport.sendMessage(message, InternetAddress.parse(email.getToAddress()));
			transport.close();
		} catch (AddressException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new SMTPException(e.toString());
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new SMTPException(e.toString());
		}
	}
}
