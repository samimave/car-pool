package car.pool.email;

public class Email {
	private String to = null;
	private String from = null;
	private String subject = null;
	private String message = null;
	
	public Email() {
		
	}
	
	public void setToAddress(String to) {
		this.to = to;
	}
	
	
	public String getToAddress() {
		return to;
	}
	
	public void setFromAddress(String from) {
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
