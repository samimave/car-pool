package car.pool.email;

import java.io.IOException;
import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.URLName;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;

import com.sun.mail.smtp.SMTPMessage;
import com.sun.mail.smtp.SMTPTransport;

public class SMTP {
	/**
	 * The Transport object used to send emails with.
	 */
	protected static SMTPTransport transport = null;
	/**
	 * Does the SMTP server need to use TLS encryption
	 */
	protected static boolean usettls = false;
	
	/**
	 * All the methods used here are static so the SMTP constructor should not be used by anyone but itself.
	 * This also allows future coders to inherit from this class.
	 */
	protected SMTP() {
		
	}
	
	/**
	 * All the initial setup of the SMTPTransport is done here.
	 * What gets used depends on what is in the database.
	 * @throws SMTPException - if anything goes wrong.
	 */
	protected static void setup() throws SMTPException {
		Properties properties = new Properties();
		URLName urlname = null;
		try {
			String url = "localhost";
			Integer port = new Integer(25);  // default smtp port
			String username = "";
			String password = "";
			Database db = new DatabaseImpl();
			String sql = "select * from SMTP";
			ResultSet result = db.getStatement().executeQuery(sql);
			if(result != null && result.next()) {
				url = result.getString(1);
				port = new Integer(result.getInt(2));
				usettls = result.getInt(3) > 0;
			}
			sql = "select * from Email";
			result = db.getStatement().executeQuery(sql);
			if(result != null && result.next()) {
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
	
	/**
	 * Where the email is sent to the receiver. setup() is called from here.
	 * @param email - the email to send
	 * @throws SMTPException - if the data in the email is not complete or some error with the sending takes place
	 */
	public static void send(Email email) throws SMTPException {
		Properties properties = new Properties();
		setup();
		SMTPMessage message = new SMTPMessage(Session.getDefaultInstance(properties));
		try {
			if(email.getFromAddress() != null) {
				message.addFrom(InternetAddress.parse(email.getFromAddress()));
				message.addRecipients(Message.RecipientType.TO, email.getToAddress());
				message.setSubject(email.getSubject());
				message.setText(email.getMessage());
				message.setReplyTo(InternetAddress.parse(email.getFromAddress()));
				if(usettls) {
					transport.setStartTLS(usettls);
				}
				transport.connect();
				transport.sendMessage(message, InternetAddress.parse(email.getToAddress()));
				transport.close();
			}else {
				throw new SMTPException("No From Address found");
			}
		} catch (AddressException e) {
			throw new SMTPException(e.getMessage());
		} catch (MessagingException e) {
			throw new SMTPException(e.getMessage());
		}
	}
}
