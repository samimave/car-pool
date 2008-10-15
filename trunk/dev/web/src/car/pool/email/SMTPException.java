package car.pool.email;

public class SMTPException extends Exception {
	private static final long serialVersionUID = 2355637793982227933L;

	/**
	 * A unified Exception class used through the car.pool.email
	 * package as a unified Excetion to throw, so code only has to
	 * worry about this one and if the library used to send email's
	 * changes they still don't have to change the code as this will
	 * still be used
	 * @param reason - The reason the exception is thrown is stated here.
	 */
	public SMTPException(String reason) {
		super(reason);
	}
}
