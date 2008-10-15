package car.pool.persistance.exception;

public class DuplicateUserNameException extends StoreException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7637829911989766902L;

	public DuplicateUserNameException(String message) {
		super(message);
	}

}
