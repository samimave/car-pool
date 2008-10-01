package car.pool.email;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

import car.pool.persistance.Database;
import car.pool.persistance.DatabaseImpl;

public class Email {
	private String to = null;
	private String from = null;
	private String subject = null;
	private String message = null;
	
	public Email() {
		try {
			Database db = new DatabaseImpl();
			String sql = "select * from Email";
			ResultSet results = db.getStatement().executeQuery(sql);
			if(results.next()) {
				setFromAddress(results.getString(2));
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public void setToAddress(String to) {
		this.to = to;
	}
	
	
	public String getToAddress() {
		return to;
	}
	
	private void setFromAddress(String from) {
		this.from = from;
	}
	
	
	public String getFromAddress() {
		return from;
	}
	
	
	public void setSubject(String subject) {
		this.subject = subject;
	}
	
	
	public String getSubject() {
		return subject;
	}
	
	public void setMessage(String message) {
		this.message = message;
	}
	
	
	public String getMessage() {
		return message;
	}
}
