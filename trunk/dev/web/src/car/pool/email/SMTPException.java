package car.pool.email;

public class SMTPException extends Exception {
	private static final long serialVersionUID = 2355637793982227933L;

	public SMTPException(String reason) {
		super(reason);
	}
}
