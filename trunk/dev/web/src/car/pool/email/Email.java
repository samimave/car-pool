package car.pool.email;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;

public class Email {
	//the email variables
	private String to = null;
	private String from = null;
	private String subject = null;
	private String message = null;
	
	/**
	 * Connects to database and fetches the from address from the Email table.  		 * This then becomes the from address used when sending emails
	 */
	public Email() {
		try {
			Database db = new DatabaseImpl();
			String sql = "select * from Email";
			ResultSet results = db.getStatement().executeQuery(sql);
			if(results != null && results.next()) {
				setFromAddress(results.getString(2));
			}else{
				setFromAddress("anonymous@localhost");
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	/**
	 * Sets the recipients address
	 * @param to - email address of the recipient
	 */
	public void setToAddress(String to) {
		this.to = to;
	}
	
	/**
	 * Gets the email address of the recipient of the email
	 * @return - the recipients email address
	 */
	public String getToAddress() {
		return to;
	}
	
	/**
	 * sets the senders address
	 * @param from - the senders email address
	 */
	private void setFromAddress(String from) {
		this.from = from;
	}
	
	/**
	 * Gets the senders email address
	 * @return - the senders email address
	 */
	public String getFromAddress() {
		return from;
	}
	
	
	/**
	 * Sets the subject line of the email
	 * @param subject - the subject of the email
	 */
	public void setSubject(String subject) {
		this.subject = subject;
	}
	
	/**
	 * Gets the subject of the email
	 * @return - the subject of the email
	 */
	public String getSubject() {
		return subject;
	}
	
	/**
	 * Sets the message or the main body of the email
	 * @param message - the message the sender wants to communicate with the receiver
	 */
	public void setMessage(String message) {
		this.message = message;
	}
	
	/**
	 * Gets the message to be sent
	 * @return - the message to be sent
	 */
	public String getMessage() {
		return message;
	}
}
